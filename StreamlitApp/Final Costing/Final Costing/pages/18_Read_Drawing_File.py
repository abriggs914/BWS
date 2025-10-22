import io
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

from streamlit_pills import pills
from streamlit_pdf_viewer import pdf_viewer

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
	def detect_table_cells(bw, min_line_len_frac=0.25, line_thickness=1):
		"""
		Detects table grid by morphological operations.
		Returns a list of cell boxes [(x, y, w, h), ...] sorted by rows then cols.
		"""
		h, w = bw.shape
		min_len = int(min(h, w) * min_line_len_frac)

		# Kernels for morphology
		horiz_kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (max(10, w // 40), line_thickness))
		vert_kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (line_thickness, max(10, h // 40)))

		# Extract horizontal and vertical lines
		horiz = cv2.morphologyEx(bw, cv2.MORPH_OPEN, horiz_kernel, iterations=2)
		vert = cv2.morphologyEx(bw, cv2.MORPH_OPEN, vert_kernel, iterations=2)

		# Keep only long lines
		def filter_long_lines(img, axis=0):
			cnts, _ = cv2.findContours(img, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
			keep = np.zeros_like(img)
			for c in cnts:
				x, y, cw, ch = cv2.boundingRect(c)
				ln = ch if axis == 0 else cw
				if ln >= min_len:
					cv2.drawContours(keep, [c], -1, 255, -1)
			return keep

		horiz = filter_long_lines(horiz, axis=1)
		vert = filter_long_lines(vert, axis=0)

		# st.write(f"horiz")
		# st.write(horiz)
		# st.write(f"vert")
		# st.write(vert)

		grid = cv2.bitwise_or(horiz, vert)
		# st.write(f"grid")
		# st.write(grid)

		# Intersections can help ensure real grid (optional)
		intersections = cv2.bitwise_and(horiz, vert)
		if intersections.sum() < 255 * 10:
			# Not enough grid structure
			return []

		# Find boxes by looking at closed contours in the grid's inverted mask
		# Create a mask where table cells (white areas bounded by lines) are blobs
		table_mask = cv2.bitwise_not(grid)
		# Slight closing to merge tiny gaps
		table_mask = cv2.morphologyEx(table_mask, cv2.MORPH_CLOSE,
									  cv2.getStructuringElement(cv2.MORPH_RECT, (3, 3)), 1)

		cnts, _ = cv2.findContours(table_mask, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

		# st.write(f"cnts")
		# st.write(cnts)
		boxes = []
		for c in cnts:
			x, y, cw, ch = cv2.boundingRect(c)
			# # Filter out non-cell areas (too big/too small/outer background)
			# if cw < 25 or ch < 14:  # tiny
			# 	continue
			# if cw > int(w * 0.999) and ch > int(h * 0.999):  # full page
			# 	continue
			# # Require there to be surrounding grid lines near borders
			# # (loose check: look for some black pixels along borders in grid)
			# pad = 2
			# left_line = grid[y:y + ch, max(0, x - pad):x + 1].sum() > 0
			# right_line = grid[y:y + ch, x + cw - 1:min(w, x + cw + pad)].sum() > 0
			# top_line = grid[max(0, y - pad):y + 1, x:x + cw].sum() > 0
			# bot_line = grid[y + ch - 1:min(h, y + ch + pad), x:x + cw].sum() > 0
			# # if sum([left_line, right_line, top_line, bot_line]) >= 2:
			boxes.append((x, y, cw, ch))

		if not boxes:
			return []

		st.write(f"boxes")
		st.write(boxes)

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
			st.write(f"A ROW")
			st.write(row)
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
		st.write("A Grouped")
		st.write(grouped)
		grouped = [sorted(r, key=lambda b: b[0]) for r in grouped if len(r) == cols]
		st.write("B Grouped")
		st.write(grouped)

		data = []
		for r in grouped:
			row_vals = []
			for (x, y, w, h) in r:
				roi = cv_bgr[max(0, y + 2):y + h - 2, max(0, x + 2):x + w - 2]
				st.write(f"{r=}, {x=}, {y=}, {w=}, {h=}, {roi=}")
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


	# PO Invoices
	st.title("PO Invoice Extractor")
	uploaded_file = st.file_uploader("Upload a PO Invoice PDF", type=["pdf"])

	dpi = st.slider("Render DPI", 200, 400, value=300, step=50, disabled=True)
	rot = st.slider("Rotate", 0, 270, value=0, step=90, disabled=True)
	digits_only = st.checkbox("Digits-only OCR for cells", value=False)
	show_debug = st.checkbox("Show debug masks", value=False)

	if uploaded_file:
		pdf_bytes = uploaded_file.getvalue()
		with pdfplumber.open(io.BytesIO(pdf_bytes)) as pdf:
			for pidx, page in enumerate(pdf.pages, start=1):
				st.subheader(f"Page {pidx}")
				# Render page to image
				# pil = page.to_image(resolution=dpi).original
				# cv = pil_to_cv(pil)
				#
				# # Preprocess
				# gray, bw = preprocess_for_ocr(cv, adaptive=True)
				# gray = gray.transpose()[::-1]
				# bw = bw.transpose()[::-1]
				#
				# # Detect table grid
				# detected = detect_table_cells(bw)

				pil = page.to_image(resolution=dpi).original
				cv = pil_to_cv(pil)

				# Apply the SAME rotation to cv first
				cv = rotate_cv(cv, rot)

				# Now preprocess (deskew, threshold) on the rotated image
				gray, bw = preprocess_for_ocr(cv, adaptive=True)

				# Make sure arrays are contiguous before any PIL/Tesseract calls or cv2 color ops
				gray = np.ascontiguousarray(gray)
				bw = np.ascontiguousarray(bw)
				cv = np.ascontiguousarray(cv)

				# Detect grid on bw
				detected = detect_table_cells(bw)

				if detected:
					(cells, cols) = detected
					# st.write(f"cells")
					# st.write(cells)
					# st.write(f"cols")
					# st.write(cols)
					df = assemble_table_from_cells(cv, rows=None, cols=2, cells=cells)
					st.write(df)
					df.columns = [f"col_{i+1}" for i in range(len(df.columns))]
					st.write(df)
					col_0: str = df.columns.tolist()[0]
					df = df[[col_0]]
					df = df[~pd.isna(df[col_0])]
					df = df[df[col_0] != ""]

					known_cols: list[str] = [
						"Qty Ord.",
						"Qty Ship.",
						"Qty B.O.",
						"Piece No.",
						"Unit Price",
						"Total Price"
					]
					n_known_cols: int = len(known_cols)
					table_vals: str = df.loc[1, col_0]

					table_data = {kc: [] for kc in known_cols}
					splt_vals: list[str] = table_vals.split("\n")
					# st.write(len(splt_vals))
					# st.write(splt_vals)
					for i in range(len(splt_vals)):
						sub_splt = splt_vals[i].split(" ")
						for j in range(len(sub_splt)):
							# st.write(f"{i=}, {j=}, {sub_splt=}")
							col = known_cols[j]
							table_data[col].append(sub_splt[j])

					st.write(table_data)
					table_data = {k: v for k, v in table_data.items() if v}
					df_table_data: pd.DataFrame = pd.DataFrame(table_data)
					st.write(df_table_data)

					if df is not None and not df.empty:
						st.dataframe(df, use_container_width=True)
						st.download_button(
							f"Download Page {pidx} as CSV",
							df.to_csv(index=False).encode("utf-8"),
							file_name=f"page_{pidx}.csv",
							mime="text/csv",
						)
					else:
						st.info("Grid found but OCR returned no cells; trying fallback…")
						df2 = words_to_naive_table(cv)
						st.dataframe(df2 if df2 is not None else pd.DataFrame(["No result"]))
				else:
					st.info("No clear grid detected; trying fallback (word clustering)…")
					df2 = words_to_naive_table(cv)
					st.dataframe(df2 if df2 is not None else pd.DataFrame(["No result"]))

				if show_debug:
					cols = st.columns(3)
					with cols[0]:
						st.image(pil, caption="Original")

					with cols[1]:
						st.image(cv2.cvtColor(gray, cv2.COLOR_GRAY2BGR), caption="Gray/Deskew")

					with cols[2]:
						st.image(bw, caption="Binary (inverted)")
