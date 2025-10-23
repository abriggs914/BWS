import io
import gc
import cv2
import numpy as np
import pandas as pd
import pytesseract
import streamlit
from pytesseract import Output
import pdfplumber
from streamlit_utility import *
from itertools import groupby
from collections import defaultdict
from operator import itemgetter
from PIL import Image
import re

import altair as alt
from streamlit_pills import pills
from streamlit_pdf_viewer import pdf_viewer

from utility import money, isnumber

pytesseract.pytesseract.tesseract_cmd = r"C:\Users\abriggs\AppData\Local\Programs\Tesseract-OCR\tesseract.exe"


@st.cache_data(ttl=None, show_spinner=True)
def load_pdf_binary(pdf_file):
	with open(pdf_file, "rb") as f:
		return f.read()


st.set_page_config(layout="wide")

k_pills_mode: str = "pills_mode"
options_pills_mode: list[str] = ["Drawings", "PO Invoices"]
pills_mode = pills(
	"Mode",
	key=k_pills_mode,
	index=1,
	options=options_pills_mode
)

if pills_mode == options_pills_mode[0]:

	# Drawings

	path_pdf = r"\\server4\Design\VaultWorkspace_BWS\PDFS\WF-MVL-003.PDF"
	parts_data = []

	# with pdfplumber.open(path_pdf) as pdf:
	# 	for i, page in enumerate(pdf.pages):
	# 		table = page.extract_table()
	# 		df = pd.DataFrame(data=table)
	# 		print(df)
	# # 		print(f"🔍 Processing page {i + 1}...")
	# #
	# # 		pil_img = page.to_image(resolution=300).original
	# #
	# # 		# Convert to grayscale
	# # 		gray = pil_img.convert("L")
	# #
	# # 		# Apply threshold (simple binarization)
	# # 		bw = gray.point(lambda x: 0 if x < 180 else 255, '1')  # tune threshold as needed
	# #
	# # 		ocr_text = pytesseract.image_to_string(bw)
	# #
	# # 		lines = ocr_text.splitlines()
	# #
	# # 		# --- Find header row ---
	# # 		start_idx = None
	# # 		for idx, line in enumerate(lines):
	# # 			if "ITEM NO" in line.upper() and "PART NO" in line.upper():
	# # 				start_idx = idx + 1
	# # 				break
	# #
	# # 		if start_idx is None:
	# # 			print("⚠️ Parts table header not found.")
	# # 			continue
	# #
	# # 		# --- Parse lines after header ---
	# # 		for i, line in enumerate(lines[start_idx:]):
	# # 			line = line.strip()
	# # 			print(f"PH i={i}, line={line!r}")
	# # 			if not line:
	# # 				continue
	# #
	# # 			# Split line on whitespace and remove empty tokens
	# # 			tokens = [t for t in re.split(r"[\s|]+", line) if t]
	# #
	# # 			if not tokens or len(tokens) < 2:
	# # 				print(f"🔸 Skipping short line: {line}")
	# # 				continue
	# #
	# # 			part_no = tokens[0]
	# # 			qty = None
	# # 			weight = None
	# # 			material = ""
	# # 			description = ""
	# #
	# # 			# If last token is numeric, treat as qty
	# # 			if re.match(r"^\d+$", tokens[-1]):
	# # 				qty = int(tokens[-1])
	# # 				tokens = tokens[:-1]
	# #
	# # 			# Try to find float near end for weight
	# # 			for j in range(len(tokens) - 1, 0, -1):
	# # 				if re.match(r"^\d+\.\d+$", tokens[j]):
	# # 					weight = float(tokens[j])
	# # 					tokens.pop(j)
	# # 					break
	# #
	# # 			# Try to find material (like "304 SS", "6061 Alloy", "AISI 304")
	# # 			material_candidates = ["AISI", "ALLOY", "304", "6061", "SS"]
	# # 			for j in range(len(tokens) - 1, 0, -1):
	# # 				if any(mat in tokens[j].upper() for mat in material_candidates):
	# # 					material = " ".join(tokens[j:])
	# # 					tokens = tokens[:j]
	# # 					break
	# #
	# # 			description = " ".join(tokens[1:])  # skip part number
	# #
	# # 			parts_data.append({
	# # 				"Part No": part_no,
	# # 				"Description": description,
	# # 				"Material": material,
	# # 				"Weight": weight,
	# # 				"Qty": qty
	# # 			})
	# #
	# # # --- Final Output ---
	# # if parts_data:
	# # 	df_parts = pd.DataFrame(parts_data)
	# # 	print(df_parts)
	# # else:
	# # 	print("❌ No parts found.")
	# #
	# #
	# #
	# # # # from streamlit_utility import *
	# # # import pytesseract
	# # # import pdfplumber
	# # #
	# # # import pandas as pd
	# # # from PIL import Image
	# # # import io
	# # # import re
	# # #
	# # # # Force pytesseract to use specific path to tesseract.exe
	# # # pytesseract.pytesseract.tesseract_cmd = r"C:\Users\abriggs\AppData\Local\Programs\Tesseract-OCR\tesseract.exe"
	# # #
	# # # path_pff = r"\\server4\Design\VaultWorkspace_BWS\PDFS\WF-MVL-003.PDF"
	# # # parts_data = []
	# # #
	# # # with pdfplumber.open(path_pff) as pdf:
	# # # 	for i, page in enumerate(pdf.pages):
	# # # 		print(f"🔍 Processing page {i + 1}...")
	# # #
	# # # 		# Convert PDF page to image
	# # # 		img = page.to_image(resolution=300)
	# # # 		pil_img = img.original
	# # #
	# # # 		# Use pytesseract to extract text
	# # # 		ocr_text = pytesseract.image_to_string(pil_img)
	# # # 		lines = ocr_text.splitlines()
	# # #
	# # # 		# --- Find header start ---
	# # # 		start_idx = None
	# # # 		for idx, line in enumerate(lines):
	# # # 			print(f"PH {idx=}, {line=}")
	# # # 			if "ITEM NO." in line.upper() and "PART NO." in line.upper():
	# # # 				start_idx = idx + 1
	# # # 				break
	# # #
	# # # 		if start_idx is None:
	# # # 			print("⚠️ Parts table header not found.")
	# # # 			continue
	# # #
	# # # 		# --- Parse lines after header ---
	# # # 		for i, line in enumerate(lines[start_idx:]):
	# # # 			line = line.strip()
	# # # 			print(f"PH {i=}, {line=}")
	# # # 			if not line:
	# # # 				continue
	# # #
	# # # 			# Match: starts with int (item no), ends with int (qty)
	# # # 			match = re.match(r"^(\d+)\s+(.+?)\s+(\d+)$", line)
	# # # 			if match:
	# # # 				item_no = int(match.group(1))
	# # # 				remainder = match.group(2)
	# # # 				qty = int(match.group(3))
	# # #
	# # # 				# Split remainder: part_no is first token
	# # # 				parts = remainder.split()
	# # # 				part_no = parts[0]
	# # # 				description = " ".join(parts[1:])
	# # #
	# # # 				parts_data.append({
	# # # 					"Item": item_no,
	# # # 					"Part No": part_no,
	# # # 					"Description & Extras": description,
	# # # 					"Qty": qty
	# # # 				})
	# # # 			else:
	# # # 				print(f"🔸 Skipping non-matching line: {line}")
	# # #
	# # # 	# --- Final Output ---
	# # # 	if parts_data:
	# # # 		df_parts = pd.DataFrame(parts_data).sort_values("Item")
	# # # 		print(df_parts)
	# # # 	else:
	# # # 		print("❌ No parts found.")
	# # #
	# # #
	# # #

	# --- File uploader ---
	uploaded_file = st.file_uploader("Upload a drawing PDF", type=["pdf"])

	if uploaded_file:
		st.success("✅ PDF uploaded. Click below to extract parts.")
		if st.button("Yes, Extract Parts"):
			parts_data = []

			with pdfplumber.open(uploaded_file) as pdf:
				for i, page in enumerate(pdf.pages):
					st.write(f"🔍 Processing page {i+1}...")
					e_table = page.extract_table()
					st.write(e_table)
					table = pd.DataFrame(e_table).reset_index()
					col = 1
					# if col not in table.columns:
					# 	col = 1
					st.write(f"{table.columns.tolist()=}")
					table = table.loc[
						(~pd.isna(table[col]))
						& (table[col].str.upper() != "ITEM NO.")
						& (table[col].str.upper() != "ITEM")
					]
					parts_data.append(table)

			if parts_data:
				for i, df_parts in enumerate(parts_data):
					display_df(
						df_parts,
						f"DF #{i}"
					)
					st.success(f"✅ Extracted {df_parts.shape[0]} unique parts.")
			else:
				st.warning("⚠️ No parts list could be detected. Try another file or check formatting.")

else:

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

	# ---- Optional on Windows: point pytesseract to tesseract.exe ----
	# pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"
	# or wherever yours is installed

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
		cfg = f"--oem 3 --psm {psm}"
		if digits_only:
			cfg += " -c tessedit_char_whitelist=0123456789.,-/"
		txt = pytesseract.image_to_string(image_bgr, config=cfg)
		return txt.strip()


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


	def rotate_cv(img, deg):
		deg = deg % 360
		if deg == 0:
			return img
		if deg == 90:
			return cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
		if deg == 180:
			return cv2.rotate(img, cv2.ROTATE_180)
		if deg == 270:
			return cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
		# arbitrary angle (rarely needed for invoices)
		h, w = img.shape[:2]
		M = cv2.getRotationMatrix2D((w // 2, h // 2), deg, 1.0)
		return cv2.warpAffine(img, M, (w, h), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)


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
	st.title("PO Invoice Extractor")
	uploaded_files = st.file_uploader(
		"Upload a PO Invoice PDF",
		type="pdf"
		# ,
		# accept_multiple_files=True
	)

	# dpi = st.slider("Render DPI", 200, 400, value=300, step=50, disabled=True)
	# rot = st.slider("Rotate", 0, 270, value=0, step=90, disabled=True)
	# digits_only = st.checkbox("Digits-only OCR for cells", value=False)
	show_debug = st.checkbox("Show debug masks", value=False)

	if uploaded_files:
		if not isinstance(uploaded_files, (list, tuple)):
			uploaded_files = [uploaded_files]
		if st.button(
			f"Process {len(uploaded_files)} pdf(s)?"
		):
			pdf_tables: list[pd.DataFrame] = []
			for file in uploaded_files:
				# st.write(file)
				pdf_bytes = file.getvalue()
				with pdfplumber.open(io.BytesIO(pdf_bytes)) as pdf:
					for pidx, page in enumerate(pdf.pages, start=1):
						with st.expander(f"{file.name}  -  Page {pidx}"):

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

							cont_0 = st.container()
							cont_1 = st.container(border=True)
							cont_1.subheader("debugging info:")
							cols_results_0 = cont_1.columns(2)

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
								expand_bottom = 0.625  # 18 % of page width — adjust until green boxes cover prices
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
									with cols_results_0[1]:
										display_df(
											df,
											"Interpreted values:"
										)

								n_known_cols: int = len(known_cols)
								header_vals: str = df.loc[0, col_0].split("\n")[1]
								header_cols = ["P.O. Number", "Memo No.", "Date"]

								cols_results_0[1].write("header_vals")
								cols_results_0[1].write(header_vals)
								po, memo_no, *rest = header_vals.split(" ", 2)
								l_memo = ""
								cols_results_0[1].write(f"A {po=}, {memo_no=}, {rest=}")
								j_rest = " ".join(rest)
								if j_rest.count(" ") == 0:
									date = j_rest
								else:
									*rest, l_memo, date = j_rest.rsplit(" ", 2)

								cols_results_0[1].write(f"B {po=}, {date=}, {l_memo=}, {memo_no=}, {rest=}")
								memo_no = memo_no + l_memo
								table_vals: str = df.loc[1, col_0]

								table_data = {kc: [] for kc in known_cols}
								splt_vals: list[str] = table_vals.split("\n")
								for i in range(len(splt_vals)):
									if splt_vals[i].strip():
										sub_splt = splt_vals[i].split(" ", len(known_cols) - 1)
										# st.write(f"{i=}")
										# st.write(sub_splt)
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
								df_table_data["File"] = file.name
								df_table_data["Page"] = pidx

								for i, col_data in enumerate([
									int_cols,
									str_cols,
									dbl_cols
								]):
									lst = col_data["lst"]
									func = col_data["func"]
									for j, col in enumerate(lst):
										df_table_data[col] = df_table_data[col].apply(func)

								with cont_0:
									display_df(
										df_table_data,
										"Parsed Data:"
									)
								pdf_tables.append(df_table_data)

								if df is not None and not df.empty:
									# st.dataframe(df, use_container_width=True)
									cont_0.download_button(
										f"Download Page {pidx} as CSV",
										df_table_data.to_csv(index=False).encode("utf-8"),
										file_name=f"page_{pidx}.csv",
										mime="text/csv",
										key=f"btn_download_df_table_{pidx}_{file.name}"
									)
								else:
									cont_0.info("Grid found but OCR returned no cells; trying fallback…")
									df2 = words_to_naive_table(cv)
									df2 = df2 if df2 is not None else pd.DataFrame(["No result"])
									cont_0.dataframe(df2)
							else:
								cont_0.info("No clear grid detected; trying fallback (word clustering)…")
								df2 = words_to_naive_table(cv)
								df2 = df2 if df2 is not None else pd.DataFrame(["No result"])
								cont_0.dataframe(df2)

							if show_debug:

								# with cols[0]:
								# 	st.image(pil, caption="Original")
								#
								# with cols[1]:
								# 	st.image(cv2.cvtColor(gray, cv2.COLOR_GRAY2BGR), caption="Gray/Deskew")
								#
								# with cols[2]:
								# 	st.image(bw, caption="Binary (inverted)")

								with cols_results_0[0]:
									debug = cv.copy()
									for (x, y, w, h) in cells:
										cv2.rectangle(debug, (x, y), (x + w, y + h), (0, 255, 0), 1)
									st.image(cv2.cvtColor(debug, cv2.COLOR_BGR2RGB), caption="Detected cells (expanded)")
				cols_results = st.columns([0.64, 0.18, 0.18], border=True)

				if pdf_tables:
					df_all = pd.concat(pdf_tables, ignore_index=True)
				else:
					st.warning("No tables extracted from any uploaded files.")
					st.stop()

				sub_total = df_all["Total Price"].sum()
				if isnumber(sub_total):
					sales_tax = sub_total * 0.15
					total = sub_total + sales_tax
				else:
					sales_tax = "?"
					total = "?"
				po = df_all["PO"].mode().iat[0]
				memo = df_all["Memo"].mode().iat[0]
				date = df_all["Date"].mode().iat[0]

				with cols_results[0]:
					display_df(
						df_all,
						"Results",
						width=1000
					)
					st.download_button(
						f"Download results as CSV",
						df_all.to_csv(index=False).encode("utf-8"),
						file_name=f"parsed_results_{datetime.datetime.now():%Y%m%d%H%M%S}.csv",
						mime="text/csv",
						key=f"btn_download_df_all_{file.name}"
					)
					df_score = score_df_accuracy(df_all)
					cols_results_scores = st.columns(2)
					with cols_results_scores[0]:
						display_df(
							df_score,
							f"Accuracy score:"
						)
					with cols_results_scores[1]:
						df_plot = df_score.copy()
						df_plot = df_plot[df_plot["Column"].notna()].copy()
						df_plot["Score %"] = pd.to_numeric(df_plot["Score %"], errors="coerce")
						order = [c for c in df_plot["Column"].tolist() if c != "—"] + ["—"]
						df_plot = df_plot.set_index("Column").loc[order].reset_index()
						chart = (
							alt.Chart(df_plot)
							.mark_bar()
							.encode(
								x=alt.X("Score %:Q", title="Accuracy (%)", scale=alt.Scale(domain=[0, 100])),
								y=alt.Y("Column:N", sort="-x", title=None),
								color=alt.Color(
									# use an expression to choose color based on value
									"Score %:Q",
									scale=alt.Scale(
										domain=[0, 60, 85, 100],
										range=["firebrick", "gold", "seagreen", "seagreen"]
									),
									legend=None
								),
								tooltip=["Column", "Expected", "Score %"]
							)
							.properties(width=500, height=325, title="Column Accuracy Scores")
						)
						text = (
							alt.Chart(df_plot)
							.mark_text(align="left", dx=5, color="white")
							.encode(
								x="Score %:Q",
								y=alt.Y("Column:N", sort=order),
								text=alt.Text("Score %:Q", format=".0f")
							)
						)
						st.altair_chart(chart + text)

				with cols_results[1]:
					st.metric(
						label="PO",
						value=po
					)
					st.metric(
						label="Memo",
						value=memo
					)
					st.metric(
						label="Date",
						value=date
					)

				with cols_results[2]:
					st.metric(
						label="Sub-Total",
						value=money(sub_total) if isnumber(sub_total) else sub_total
					)
					st.metric(
						label="Sales-Tax",
						value="+ " + f"{money(sales_tax) if (isnumber(sales_tax) and sales_tax != "?") else sales_tax}"
					)
					st.divider()
					st.metric(
						label="Total",
						value=money(total) if (isnumber(total) and sales_tax != "?") else total
					)
				gc.collect()

			###################
			## Combined Results
			###################

			if len(uploaded_files) > 1:
				cols_results = st.columns([0.64, 0.18, 0.18], border=True)
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

				with cols_results[0]:
					display_df(
						df_all_master,
						"Combined Results",
						width=1000
					)
					st.download_button(
						f"Download results as CSV",
						df_all_master.to_csv(index=False).encode("utf-8"),
						file_name=f"parsed_results_{datetime.datetime.now():%Y%m%d%H%M%S}.csv",
						mime="text/csv",
						key=f"btn_download_df_all_master"
					)
					df_score = score_df_accuracy(df_all_master)
					cols_results_scores = st.columns(2)
					with cols_results_scores[0]:
						display_df(
							df_score,
							f"Accuracy score:"
						)
					with cols_results_scores[1]:
						df_plot = df_score.copy()
						df_plot = df_plot[df_plot["Column"].notna()].copy()
						df_plot["Score %"] = pd.to_numeric(df_plot["Score %"], errors="coerce")
						order = [c for c in df_plot["Column"].tolist() if c != "—"] + ["—"]
						df_plot = df_plot.set_index("Column").loc[order].reset_index()
						chart = (
							alt.Chart(df_plot)
							.mark_bar()
							.encode(
								x=alt.X("Score %:Q", title="Accuracy (%)", scale=alt.Scale(domain=[0, 100])),
								y=alt.Y("Column:N", sort="-x", title=None),
								color=alt.Color(
									# use an expression to choose color based on value
									"Score %:Q",
									scale=alt.Scale(
										domain=[0, 60, 85, 100],
										range=["firebrick", "gold", "seagreen", "seagreen"]
									),
									legend=None
								),
								tooltip=["Column", "Expected", "Score %"]
							)
							.properties(width=500, height=250, title="Column Accuracy Scores")
						)
						text = (
							alt.Chart(df_plot)
							.mark_text(align="left", dx=5, color="white")
							.encode(
								x="Score %:Q",
								y=alt.Y("Column:N", sort=order),
								text=alt.Text("Score %:Q", format=".0f")
							)
						)
						st.altair_chart(chart+text)

				with cols_results[1]:
					st.metric(
						label="PO",
						value=po
					)
					st.metric(
						label="Memo",
						value=memo
					)
					st.metric(
						label="Date",
						value=date
					)

				with cols_results[2]:
					st.metric(
						label="Sub-Total",
						value=money(sub_total) if isnumber(sub_total) else sub_total
					)
					st.metric(
						label="Sales-Tax",
						value="+ " + f"{(money(sales_tax) if (isnumber(sales_tax) and sales_tax != "?") else sales_tax)}"
					)
					st.divider()
					st.metric(
						label="Total",
						value=money(total) if (isnumber(total) and sales_tax != "?") else total
					)
