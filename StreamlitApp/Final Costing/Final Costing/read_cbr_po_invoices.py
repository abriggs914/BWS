import gc
import json
import os

import cv2
import datetime
import numpy as np
import pandas as pd
import pytesseract
from pytesseract import Output
import pdfplumber
from itertools import groupby

from json_utility import jsonify
from utility import money, isnumber

pytesseract.pytesseract.tesseract_cmd = r"C:\Users\abriggs\AppData\Local\Programs\Tesseract-OCR\tesseract.exe"
SAVE_FILE: str = r"\\bwsfp01\Public\Accounts Payable\AP - BWS Manufacturing\Processed Invoices\processed_invoices.json"
RUNNING_FILE: str = fr"\\bwsfp01\Public\Accounts Payable\AP - BWS Manufacturing\Processed Invoices\output_{datetime.datetime.now():%Y%m%d%H%M%S}.txt"
CBR_FOLDER_2025: str = r"\\bwsfp01\Public\Accounts Payable\AP - BWS Manufacturing\Posted\C.B.R. Laser\2025"


def read_saved_data() -> list[dict]:
	if not os.path.exists(SAVE_FILE):
		with open(SAVE_FILE, "w") as f:
			f.write("[]")
		return []
	with open(SAVE_FILE, "r") as f:
		return json.load(f)


read_data: list[dict] = read_saved_data()


dpi, row = 300, 90
known_cols: list[str] = [
	"Qty Ord.",
	"Qty Ship.",
	"Qty B.O.",
	"Piece No.",
	"Unit Price",
	"Total Price"
]

int_cols = {"lst": known_cols[:3], "func": lambda v: try_cast(v, "int")}
str_cols = {"lst": known_cols[3:4], "func": lambda v: try_cast(v, "str")}
dbl_cols = {"lst": known_cols[-2:], "func": lambda v: try_cast(v, "float")}


# ----------------- Image utilities -----------------
def pil_to_cv(pil_img):
	arr = np.array(pil_img)
	if arr.ndim == 2:
		return arr
	return cv2.cvtColor(arr, cv2.COLOR_RGB2BGR)


def deskew(gray):
	# Compute rotation angle via minAreaRect on edges and rotate back
	edges = cv2.Canny(gray, 50, 150)
	coords = np.column_stack(np.where(edges > 0))
	if coords.size < 10:
		return gray  # nothing to skew-correct
	rect = cv2.minAreaRect(coords.astype(np.float32))
	angle = rect[-1]
	if angle < -45:
		angle = -(90 + angle)
	else:
		angle = -angle
	(h, w) = gray.shape[:2]
	M = cv2.getRotationMatrix2D((w // 2, h // 2), angle, 1.0)
	return cv2.warpAffine(gray, M, (w, h), flags=cv2.INTER_CUBIC, borderMode=cv2.BORDER_REPLICATE)


def preprocess_for_ocr(cv_bgr, adaptive=True):
	gray = cv2.cvtColor(cv_bgr, cv2.COLOR_BGR2GRAY)
	gray = deskew(gray)
	# Light denoise
	gray = cv2.bilateralFilter(gray, 5, 40, 40)
	if adaptive:
		# bw = cv2.adaptiveThreshold(gray, 255, cv2.ADAPTIVE_THRESH_MEAN_C, cv2.THRESH_BINARY_INV, 31, 12)
		bw = cv2.adaptiveThreshold(gray, 255, cv2.ADAPTIVE_THRESH_MEAN_C, cv2.THRESH_BINARY_INV, 25,10)
	else:
		_, bw = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)
	return gray, bw


# ----------------- Table grid detection -----------------
def detect_table_cells(bw, min_line_len_frac=0.12, line_thickness=1):
	"""
	Detects table grid by morphological operations.
	Returns a list of cell boxes [(x, y, w, h), ...] sorted by rows then cols.
	"""
	h, w = bw.shape
	min_len = int(min(h, w) * min_line_len_frac)

	# Kernels for morphology
	horiz_kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (max(10, w // 50), 2))
	vert_kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (1, max(5, h // 20)))

	# Extract horizontal and vertical lines
	horiz = cv2.morphologyEx(bw, cv2.MORPH_OPEN, horiz_kernel, iterations=2)
	vert = cv2.morphologyEx(bw, cv2.MORPH_OPEN, vert_kernel, iterations=2)

	# # Keep only long lines
	# def filter_long_lines(img, axis=0):
	# 	cnts, _ = cv2.findContours(img, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
	# 	keep = np.zeros_like(img)
	# 	for c in cnts:
	# 		x, y, cw, ch = cv2.boundingRect(c)
	# 		ln = ch if axis == 0 else cw
	# 		if ln >= min_len:
	# 			cv2.drawContours(keep, [c], -1, 255, -1)
	# 	return keep
	#
	# horiz = filter_long_lines(horiz, axis=1)
	# vert = filter_long_lines(vert, axis=0)

	grid = cv2.bitwise_or(horiz, vert)

	# Intersections can help ensure real grid (optional)
	intersections = cv2.bitwise_and(horiz, vert)
	if intersections.sum() < 255 * 10:
		# Not enough grid structure
		return []

	# # Find boxes by looking at closed contours in the grid's inverted mask
	# # Create a mask where table cells (white areas bounded by lines) are blobs
	# table_mask = cv2.bitwise_not(grid)
	# # Slight closing to merge tiny gaps
	# table_mask = cv2.morphologyEx(table_mask, cv2.MORPH_CLOSE,
	# 							  cv2.getStructuringElement(cv2.MORPH_RECT, (3, 3)), 1)


	footer_cutoff = int(h * 0.90)  # keep upper 90% of the page only
	bw_no_footer = bw[:footer_cutoff, :]  # crop binary image
	h, w = bw_no_footer.shape
	# recompute kernels and grid using bw_no_footer instead of bw
	horiz = cv2.morphologyEx(bw_no_footer, cv2.MORPH_OPEN, horiz_kernel, iterations=2)
	vert = cv2.morphologyEx(bw_no_footer, cv2.MORPH_OPEN, vert_kernel, iterations=2)
	grid = cv2.bitwise_or(horiz, vert)
	table_mask = cv2.bitwise_not(grid)

	cnts, _ = cv2.findContours(table_mask, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

	boxes = []
	for c in cnts:
		x, y, cw, ch = cv2.boundingRect(c)
		if cw > int(w * 0.999) and ch > int(h * 0.999):
			continue  # keep skipping full page only
		elif cw > int(w * 0.90):  # previously cropped wide cells
			boxes.append((x, y, cw, ch))
			continue
		boxes.append((x, y, cw, ch))

	if not boxes:
		return []

	# Cluster into rows (by y) then sort each row by x
	boxes = sorted(boxes, key=lambda b: (b[1], b[0]))
	rows = []
	y_tol = 12
	for k, group in groupby(boxes, key=lambda b: b[1]):
		row = list(group)
		if not rows:
			rows.append(row)
		else:
			# close to previous row? append; else new row
			if abs(rows[-1][0][1] - row[0][1]) <= y_tol:
				rows[-1].extend(row)
			else:
				rows.append(row)

	# Normalize each row order and reduce duplicates/overlaps
	cleaned = []
	for row in rows:
		row = sorted(row, key=lambda b: b[0])
		# remove overlapping duplicates
		keep = []
		for b in row:
			if not keep or b[0] >= keep[-1][0] + keep[-1][2] * 0.6:
				keep.append(b)
		if len(keep) >= 2:  # need at least 2 cells to be a row
			cleaned.append(keep)

	# Ensure rows have similar column counts; choose the modal count
	if not cleaned:
		return []
	counts = pd.Series([len(r) for r in cleaned])
	target_cols = counts.mode().iat[0]
	grid_cells = [r for r in cleaned if len(r) == target_cols]
	# Flatten back to list
	cells = [b for r in grid_cells for b in r]
	return cells, target_cols


# ----------------- OCR helpers -----------------
def ocr_cell(image_bgr, psm=6, digits_only=False):
	# cfg = f"--oem 3 --psm {psm}"
	# if digits_only:
	# 	cfg += " -c tessedit_char_whitelist=0123456789.,-/"
	# txt = pytesseract.image_to_string(image_bgr, config=cfg)
	# return txt.strip()
	cfg_base = "--oem 3 --dpi 300"
	psms = [7, 6, 8]  # try single line, block, sparse text
	whitelist = "0123456789.,-/"
	if digits_only:
		cfg_base += f" -c tessedit_char_whitelist={whitelist}"

	for psm in psms:
		cfg = f"{cfg_base} --psm {psm}"
		txt = pytesseract.image_to_string(image_bgr, config=cfg).strip()
		if txt:
			return txt
	return ""


def assemble_table_from_cells(cv_bgr, rows, cols, cells):
	"""Convert cell boxes to a DataFrame by OCRing each cell."""
	# Sort by row (top->down) and column (left->right)
	cells = sorted(cells, key=lambda b: (b[1], b[0]))
	# cluster into rows
	y_tol = 12
	grouped = []
	for b in cells:
		if not grouped:
			grouped.append([b])
		else:
			if abs(grouped[-1][0][1] - b[1]) <= y_tol:
				grouped[-1].append(b)
			else:
				grouped.append([b])
	# keep only rows with target count
	grouped = [sorted(r, key=lambda b: b[0]) for r in grouped if len(r) == cols]

	data = []
	for r in grouped:
		row_vals = []
		for (x, y, w, h) in r:
			roi = cv_bgr[max(0, y + 2):y + h - 2, max(0, x + 2):x + w - 2]
			# st.write(f"{r=}, {x=}, {y=}, {w=}, {h=}, {roi=}")
			row_vals.append(ocr_cell(roi))
		data.append(row_vals)
	if not data:
		return None
	df = pd.DataFrame(data)
	# Heuristic: first row often header
	if df.shape[0] >= 2:
		df.columns = [c if c else f"col{j}" for j, c in enumerate(df.iloc[0].tolist())]
		df = df.iloc[1:].reset_index(drop=True)
	return df


# ----------------- Fallback: word clustering table -----------------
def words_to_naive_table(cv_bgr, y_gap=14, x_gap=28):
	gray = cv2.cvtColor(cv_bgr, cv2.COLOR_BGR2GRAY)
	data = pytesseract.image_to_data(gray, output_type=Output.DATAFRAME, config="--oem 3 --psm 6")
	data = data.dropna(subset=["text"])
	if data.empty:
		return None
	# Build lines by y proximity
	lines = []
	for _, w in data.sort_values(["block_num", "par_num", "line_num", "left"]).iterrows():
		y = int(w["top"])
		placed = False
		for line in lines:
			if abs(line["y"] - y) <= y_gap:
				line["items"].append(w)
				placed = True
				break
		if not placed:
			lines.append({"y": y, "items": [w]})
	# Split each line into cells by x-gap
	table = []
	for line in sorted(lines, key=lambda d: d["y"]):
		items = sorted(line["items"], key=lambda r: int(r["left"]))
		if not items:
			continue
		cells, cur = [], [items[0]["text"]]
		for a, b in zip(items, items[1:]):
			gap = int(b["left"]) - (int(a["left"]) + int(a["width"]))
			if gap > x_gap:
				cells.append(" ".join(cur))
				cur = [b["text"]]
			else:
				cur.append(b["text"])
		cells.append(" ".join(cur))
		table.append(cells)
	if not table:
		return None
	n = max(map(len, table))
	table = [r + [""] * (n - len(r)) for r in table]
	return pd.DataFrame(table)


def try_cast(v, type_: str = "str"):
	vs = str(v).replace(" ", "").strip()
	try:
		if type_.lower().strip() == "int":
			return int(vs)
		elif type_.lower().strip() == "float":
			return float(vs)
		else:
			return v
	except:
		return None


def score_df_accuracy(df: pd.DataFrame) -> pd.DataFrame:
	"""
	Scores each known column by how many values successfully cast
	to the expected type (int, float, str).
	Returns a summary DataFrame with per-column and overall accuracy.
	"""
	results = []

	def score_type(col_name, target_type):
		if col_name not in df:
			return 0

		series = df[col_name].dropna().astype(str)
		total = len(series)
		if total == 0:
			return 0.0

		ok = 0
		for v in series:
			casted = try_cast(v, target_type)
			if casted is not None and not (isinstance(casted, str) and target_type != "str"):
				ok += 1
			elif target_type == "str" and isinstance(casted, str):
				ok += 1

		return ok / total

	# Evaluate integer, string, and float groups
	for col in int_cols["lst"]:
		results.append({"Column": col, "Expected": "int", "Score": score_type(col, "int")})
	for col in str_cols["lst"]:
		results.append({"Column": col, "Expected": "str", "Score": score_type(col, "str")})
	for col in dbl_cols["lst"]:
		results.append({"Column": col, "Expected": "float", "Score": score_type(col, "float")})

	# Build summary DataFrame
	df_score = pd.DataFrame(results)
	df_score["Score %"] = (df_score["Score"] * 100).round(1)
	df_score.loc["Overall"] = ["—", "—", df_score["Score"].mean(), df_score["Score %"].mean()]
	return df_score


# PO Invoices
print("PO Invoice Extractor")
uploaded_files = os.listdir(CBR_FOLDER_2025)


show_debug: bool = False
show_running: bool = False

if uploaded_files:

	with open(RUNNING_FILE, "w") as f_run:
		pdf_tables: list[pd.DataFrame] = []
		df_multiple_pdfs = []
		for file in uploaded_files:
			f_run.write(f"{""*120}\n")
			# st.write(file)
			# pdf_bytes = file.getvalue()
			with pdfplumber.open(os.path.join(CBR_FOLDER_2025, file)) as pdf:
				for pidx, page in enumerate(pdf.pages, start=1):
					f_run.write(f"{os.path.join(CBR_FOLDER_2025, file)}  -  Page {pidx}\n")

					pil = page.to_image(resolution=dpi).original
					cv = pil_to_cv(pil)

					# # Apply the SAME rotation to cv first
					# cv = rotate_cv(cv, rot)

					# Now preprocess (deskew, threshold) on the rotated image
					gray, bw = preprocess_for_ocr(cv, adaptive=True)

					# Make sure arrays are contiguous before any PIL/Tesseract calls or cv2 color ops
					gray = np.ascontiguousarray(gray)
					bw = np.ascontiguousarray(bw)
					cv = np.ascontiguousarray(cv)

					# Detect grid on bw
					detected = detect_table_cells(bw)

					if show_debug:
						f_run.write("debugging info:\n")

					if detected:
						(cells, cols) = detected

						expand_right = 0.4009  # 18 % of page width — adjust until green boxes cover prices
						for i, (x, y, w, h) in enumerate(cells):
							new_w = int(w * (1 + expand_right))
							cells[i] = (x, y, new_w, h)

						page_height = bw.shape[0]
						max_y1 = max(y + h for (x, y, w, h) in cells)
						gap_below = page_height - max_y1

						# If there’s significant white space below, extend the last row boxes
						# expand_bottom = 0.625  # 18 % of page width — adjust until green boxes cover prices
						expand_bottom = 0.63  # 18 % of page width — adjust until green boxes cover prices
						for i, (x, y, w, h) in enumerate(cells):
							new_h = int(h * (1 + expand_bottom))
							cells[i] = (x, y, w, new_h)

						df = assemble_table_from_cells(cv, rows=None, cols=2, cells=cells)
						df.columns = [f"col_{i+1}" for i in range(len(df.columns))]
						col_0: str = df.columns.tolist()[0]
						df = df[[col_0]]
						df = df[~pd.isna(df[col_0])]
						df = df[df[col_0] != ""]

						if show_debug:
							f_run.write("Interpreted values:\n")
							f_run.write(jsonify(df))
							f_run.write("\n")

						n_known_cols: int = len(known_cols)
						header_vals: str = df.loc[0, col_0].split("\n")[1]
						header_cols = ["P.O. Number", "Memo No.", "Date"]

						if show_debug:
							f_run.write("header_vals\n")
							f_run.write(jsonify(header_vals))
							f_run.write("\n")
						po, memo_no, *rest = header_vals.split(" ", 2)
						l_memo = ""
						if show_debug:
							f_run.write(f"A {po=}, {memo_no=}, {rest=}\n")
						j_rest = " ".join(rest)
						if j_rest.count(" ") == 0:
							date = j_rest
						else:
							*rest, l_memo, date = j_rest.rsplit(" ", 2)

						if show_debug:
							f_run.write(f"B {po=}, {date=}, {l_memo=}, {memo_no=}, {rest=}\n")
						memo_no = memo_no + l_memo
						table_vals: str = df.loc[1, col_0]

						table_data = {kc: [] for kc in known_cols}
						splt_vals: list[str] = table_vals.split("\n")
						for i in range(len(splt_vals)):
							if splt_vals[i].strip():
								sub_splt = splt_vals[i].split(" ", len(known_cols) - 1)
								for j in range(len(sub_splt)):
									col = known_cols[j]
									table_data[col].append(sub_splt[j])

						# st.write(table_data)
						table_data = {k: v for k, v in table_data.items() if v}
						# st.write(table_data)
						df_table_data: pd.DataFrame = pd.DataFrame(table_data)
						df_table_data["PO"] = po
						df_table_data["Memo"] = memo_no
						df_table_data["Date"] = date
						df_table_data["File"] = os.path.join(CBR_FOLDER_2025, file)
						df_table_data["Page"] = pidx

						try:
							df_table_data["Total Price"] = df_table_data["Total Price"].apply(lambda tp: float(str(tp).replace(" ", "").strip()))
							if show_debug:
								f_run.write(f"Sum Total Price: {df_table_data['Total Price'].sum()}\n")
								f_run.write(f"Max Total Price: {df_table_data['Total Price'].max()}\n")
								f_run.write(f"Min Total Price: {df_table_data['Total Price'].min()}\n")
						except:
							f_run.write("Unable to find 'Total Price'\n")

						for i, col_data in enumerate([
							int_cols,
							str_cols,
							dbl_cols
						]):
							lst = col_data["lst"]
							func = col_data["func"]
							for j, col in enumerate(lst):
								try:
									df_table_data[col] = df_table_data[col].apply(func)
								except:
									pass

						f_run.write("Parsed Data:\n")
						f_run.write(jsonify(df_table_data))
						f_run.write("\n")
						pdf_tables.append(df_table_data)

						if df is not None and not df.empty:
							# st.dataframe(df, use_container_width=True)
							pass
						else:
							f_run.write("Grid found but OCR returned no cells; trying fallback…\n")
							df2 = words_to_naive_table(cv)
							df2 = df2 if df2 is not None else pd.DataFrame(["No result"])
							f_run.write(jsonify(df2))
							f_run.write("\n")
					else:
						f_run.write("No clear grid detected; trying fallback (word clustering)…\n")
						df2 = words_to_naive_table(cv)
						df2 = df2 if df2 is not None else pd.DataFrame(["No result"])
						f_run.write(jsonify(df2))
						f_run.write("\n")

			go_to_next: bool = not bool(pdf_tables)
			if not go_to_next:
				df_all = pd.concat(pdf_tables, ignore_index=True)
				try:
					sub_total = df_all["Total Price"].sum()
				except:
					sub_total = None
					f_run.write("Unable to find 'Total Price'\n")

				if isnumber(sub_total):
					sales_tax = sub_total * 0.15
					total = sub_total + sales_tax
				else:
					sales_tax = "?"
					total = "?"
				po = df_all["PO"].mode().iat[0]
				memo = df_all["Memo"].mode().iat[0]
				date = df_all["Date"].mode().iat[0]

				f_run.write("Results\n")
				f_run.write(jsonify(df_all))
				f_run.write("\n")
				df_score = score_df_accuracy(df_all)

				f_run.write(f"Accuracy score:\n")
				f_run.write(jsonify(df_score))
				f_run.write("\n")

				overall_score = df_score.loc["Overall", "Score %"]

				f_run.write("Overall Accuracy\n")
				f_run.write("Overall " + f"{overall_score:.1f}% Excellent\n")
				if overall_score >= 90:
					pass
				elif overall_score >= 70:
					f_run.write("Overall " + f"{overall_score:.1f}% Good\n")
				else:
					f_run.write("Overall " + f"{overall_score:.1f}% Poor\n")

				f_run.write(f"PO {po}\n")
				f_run.write(f"Memo {memo}\n")
				f_run.write(f"Date {date}\n")

				f_run.write(f"Sub-Total {money(sub_total) if isnumber(sub_total) else sub_total}\n")
				f_run.write("Sales-Tax + " + f"{money(sales_tax) if (isnumber(sales_tax) and sales_tax != "?") else sales_tax}\n")
				f_run.write(f"Total {money(total) if (isnumber(total) and sales_tax != "?") else total}\n")

				# Save the results
				df_all_grps: pd.DataFrame = df_all.groupby(
					by=[
						"PO",
						"Memo",
						"Date",
						"File",
						"Page"
					]
				).agg({
					"Piece No.": "count"
				}).reset_index()

				save_data = []
				for i, row in df_all_grps.iterrows():
					file = row["File"]
					memo = row["Memo"]
					po = row["PO"]
					po_date = row["Date"]
					page = row["Page"]
					score = overall_score

					df_all_grp_po: pd.DataFrame = df_all.loc[
						(df_all["File"] == file)
						& (df_all["Memo"] == memo)
						& (df_all["PO"] == po)
						& (df_all["Date"] == po_date)
						& (df_all["Page"] == page)
					]

					df_all_grp_po = df_all_grp_po.drop(columns=["File", "Memo", "PO", "Date", "Page"])
					try:
						total = df_all_grp_po["Total Price"].sum().round(2)
					except:
						total = "?"

					save_data.append({
						"date": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
						"file": file,
						"memo": memo,
						"po": po,
						"po_date": po_date,
						"page": page,
						"total": total,
						"score": score,
						"data": df_all_grp_po.to_json()
					})

				read_data.extend(save_data)

				with open(SAVE_FILE, "w") as f:
					json.dump(read_data, f)

				df_multiple_pdfs.append(
					df_all
				)

				gc.collect()

				###################
				## Combined Results
				###################

				if len(uploaded_files) > 1:
					df_all_master: pd.DataFrame = pd.concat(pdf_tables, ignore_index=True)
					sub_total = df_all_master["Total Price"].sum()
					if isnumber(sub_total):
						sales_tax = sub_total * 0.15
						total = sub_total + sales_tax
					else:
						sales_tax = "?"
						total = "?"
					po = df_all_master["PO"].mode().iat[0]
					memo = df_all_master["Memo"].mode().iat[0]
					date = df_all_master["Date"].mode().iat[0]

					f_run.write("Combined Results\n")
					f_run.write(jsonify(df_all_master))
					f_run.write("\n")
					df_score = score_df_accuracy(df_all_master)
					f_run.write(f"Accuracy score:\n")
					f_run.write(jsonify(df_score))
					f_run.write("\n")

					f_run.write(f"PO {po}\n")
					f_run.write(f"Memo {memo}\n")
					f_run.write(f"Date {date}\n")

					f_run.write(f"Sub-Total {money(sub_total) if isnumber(sub_total) else sub_total}\n")
					f_run.write("Sales-Tax + " + f"{(money(sales_tax) if (isnumber(sales_tax) and sales_tax != "?") else sales_tax)}\n")
					f_run.write(f"Total {money(total) if (isnumber(total) and sales_tax != '?') else total}\n")
			else:
				f_run.write("No tables extracted from any uploaded files.\n")

		excel_file = os.path.join(os.path.dirname(RUNNING_FILE), f"Processed_Invoices_{datetime.datetime.now():%Y%m%d%H%M%S}.xlsx")
		with pd.ExcelWriter(excel_file, "openpyxl") as writer:
			for i, df in enumerate(pdf_tables):
				sheet_name = df.loc[0, "File"] if "File" in df.columns else f"Sheet{i + 1}"
				sheet_name = os.path.basename(str(sheet_name)).upper().removesuffix(".PDF")
				sheet_name = sheet_name[:31].replace(":", "_").replace("/", "_")
				df.to_excel(writer, sheet_name=sheet_name, index=False)

if not read_data:
	f_run.write("No Data\n")
