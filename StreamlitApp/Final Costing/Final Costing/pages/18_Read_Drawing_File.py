import io
import gc
import json

import cv2
import numpy as np
import pandas as pd
import streamlit
import pdfplumber
from streamlit_utility import *
from collections import defaultdict
from operator import itemgetter
from PIL import Image
import re

import altair as alt
from streamlit_pills import pills
from streamlit_pdf_viewer import pdf_viewer

from utility import money, isnumber, percent
import ocr_utility as ocr

import streamlit_auth_sql as auth
########################################################################
# Begin Auth Boilerplate

APP_NAME: str = st.secrets["app"]['app_name']
PAGE_NAME: str = f"{APP_NAME}_read_drawing_file"

if not auth.st_auth(APP_NAME):
	st.info(f"Please contact Avery for further help with registering for this program.")
	# Go no further
	st.stop()

admin_end_users = ["abriggs"]
admin_test_users = ["rec"] + admin_end_users
user = st.session_state.get("user", "??")

if user in admin_test_users:
	with st.sidebar:
		if st.button(
			label="Clear Cache & Rerun",
			key=f"k_clear_cache_rerun"
		):
			st.cache_data.clear()
			st.cache_resource.clear()
			st.rerun()
		with st.popover("session_state"):
			info_dict = auth.load_session_state_info()
			st.write(info_dict)

# if st.button("change password"):
with st.popover("change password"):
	if auth.show_change_password(APP_NAME):
		st.rerun()

# End Auth Boilerplate
########################################################################


SAVE_FILE: str = r"\\bwsfp01\Public\Accounts Payable\AP - BWS Manufacturing\Processed Invoices\processed_invoices.json"
EXAMPLE_PDF: str = r"\\bwsfp01\Public\Accounts Payable\AP - BWS Manufacturing\Posted\C.B.R. Laser\2025\CBR FactureInvoice #IN0001214365.PDF"


@st.cache_data(ttl=None, show_spinner=True)
def load_pdf_binary(pdf_file):
	with open(pdf_file, "rb") as f:
		return f.read()


def read_saved_data() -> list[dict]:
	with open(SAVE_FILE, "r") as f:
		return json.load(f)


st.set_page_config(layout="wide")

k_pills_mode: str = "pills_mode"
options_pills_mode: list[str] = ["Drawings", "PO Invoices"]
pills_mode = pills(
	"Mode",
	key=k_pills_mode,
	index=1,
	options=options_pills_mode
)

read_data: list[dict] = read_saved_data()


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

	int_cols = {"lst": known_cols[:3], "func": lambda v: ocr.try_cast(v, "int")}
	str_cols = {"lst": known_cols[3:4], "func": lambda v: ocr.try_cast(v, "str")}
	dbl_cols = {"lst": known_cols[-2:], "func": lambda v: ocr.try_cast(v, "float")}


	def frame(txt):
		pat_1_digit = r"\d+\s"
		prefixed_digits = {}
		count_start_digits = 0
		count_tries = 0
		txt_w = txt
		m_start_digit = re.match(pat_1_digit, txt_w)
		while m_start_digit:
			txt_match = m_start_digit.group().strip()
			if txt_match:
				count_start_digits += 1
				prefixed_digits[count_tries] = txt_match
			count_tries += 1
			txt_w = txt_w[m_start_digit.end():]
			m_start_digit = re.match(pat_1_digit, txt_w)
			if count_tries > 10:
				break

		txt = txt_w
		# print(f"{txt=}")
		t_price, u_price = "", ""
		pat_currencies = r"(\d+(?:[.,\s]\d+)+)\s"
		m_trailing_currencies = re.match(pat_currencies, txt[::-1])
		if m_trailing_currencies:
			trailing_currencies = m_trailing_currencies.group()[::-1].strip()
			trailing_currencies_ns = trailing_currencies.replace(" ", "").strip()
			trailing_currencies_0 = ocr.combine_num_parts(trailing_currencies)
			trailing_currencies_0_ns = trailing_currencies_0.replace(" ", "").strip()
			t_price = trailing_currencies_0
			if len(trailing_currencies_ns) != len(trailing_currencies_0_ns):
				space_idxs = [i for i, c in enumerate(txt) if c == " "]
				trailing_currencies_1_ns = txt.replace(" ", "").strip().removesuffix(trailing_currencies_0_ns)
				trailing_currencies_1 = ""
				for i, c in enumerate(trailing_currencies_1_ns):
					if space_idxs and (i == space_idxs[0]):
						trailing_currencies_1 += " "
					trailing_currencies_1 += c

				u_price = ocr.combine_num_parts(trailing_currencies_1)

		txt_w = txt_w.replace(" ", "").strip().removesuffix(f"{u_price}{t_price}".replace(" ", "").strip())
		# txt_ns = txt.replace(" ", "").strip()
		# rest = txt_ns[:m_trailing_currencies.start() if m_trailing_currencies else len(txt_ns)]
		idx = m_trailing_currencies.end() if m_trailing_currencies else len(txt_w)
		part = txt_w[:idx].strip()
		# print(f"{idx=}, {txt_w=}")

		prefixed_digits.setdefault(2, 0)
		prefixed_digits.setdefault(1, 0)
		prefixed_digits.setdefault(0, 0)

		row_vals = list(map(str, prefixed_digits.values())) + [part, u_price, t_price]
		row_vals = " ".join(row_vals)

		return row_vals


	def score_row_accuracy(row, tol=0.02):
		try:
			tp, tp_calc = float(row["Total Price"]), float(row["Total Price_C"])
			if tp == 0 and tp_calc == 0:
				return 1.0
			diff_ratio = abs(tp - tp_calc) / max(tp, tp_calc)
			return 1.0 if diff_ratio <= tol else 0.5 if diff_ratio <= 0.1 else 0.0
		except Exception:
			return 0.0


	def auto_correct_total(row):
		try:
			tp, tp_calc = float(row["Total Price"]), float(row["Total Price_C"])
			if abs(tp_calc - (tp * 10)) < 1.0:  # likely lost decimal
				return tp * 10
			if abs(tp_calc - (tp / 10)) < 1.0:  # extra decimal
				return tp / 10
			return tp
		except:
			return row["Total Price"]


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
				casted = ocr.try_cast(v, target_type)
				if casted is not None and not (isinstance(casted, str) and target_type != "str"):
					ok += 1
				elif target_type == "str" and isinstance(casted, str) and len(casted.strip()):
					ok += 1

			return ok / total

		# Evaluate integer, string, and float groups
		for col in int_cols["lst"]:
			results.append({"Column": col, "Expected": "int", "Score": score_type(col, "int")})
		for col in str_cols["lst"]:
			results.append({"Column": col, "Expected": "str", "Score": score_type(col, "str")})
		for col in dbl_cols["lst"]:
			results.append({"Column": col, "Expected": "float", "Score": score_type(col, "float")})

		results.append({
			"Column": "Total Price Score",
			"Expected": "float",
			"Score": (df["TotalScore"].mean() + score_type("Total Price", "float")) / 2
		})

		# Build summary DataFrame
		df_score = pd.DataFrame(results)
		df_score["Score %"] = (df_score["Score"] * 100).round(1)
		df_score.loc["Overall"] = ["—", "—", df_score["Score"].mean(), df_score["Score %"].mean()]
		return df_score


	# PO Invoices
	st.title("C.B.R. Invoice Extractor", help="C.B.R. Invoices only. See 'Example PDF' tab for the expected PDF format for this program.\nIt specializes in reading only invoices of this format from this supplier.\nPlease contact IT for further help, questions, or issues.")

	options_pills_invoice_extractor_mode = [
		"New Invoice",
		"Previously Processed",
		"Example PDF"
	]
	k_pills_invoice_extractor_mode: str = "key_pills_invoice_extractor_mode"
	pills_invoice_extractor_mode = pills(
		label="Mode",
		key=k_pills_invoice_extractor_mode,
		options=options_pills_invoice_extractor_mode,
		index=0,
		label_visibility="hidden"
	)

	if pills_invoice_extractor_mode == options_pills_invoice_extractor_mode[2]:
		# Example

		data = {
			"Table Formatting:": ["The PDF must follow explicit table structure. The program searches for borders to define where tables begin and end."],
			"Expected Headers:": [f"Two tables in particular have headers that this program will target and attempt to extract and bin data accordingly. The columns are ['{"', '".join(known_cols + ['P.O. Number', 'Memo No.', 'Date'])}']."],
			"Authenticity:": ["This program has best accuracy when reading original documents. Photos or scanned images of invoices drastically degrades the performance and accuracy for reading text."],
			"Persistence:": ["If this program can run without errors, all outputs are saved to an external save file, allowing for quick recall of previously processed invoices."],
			"Output:": ["The results of this program are available for download via the 'Download results as CSV' button below the results table."]
		}
		df_notes = pd.DataFrame(data).transpose().rename(columns={0: "Notes"})

		# display_df(
		# 	df_notes,
		# 	"Notes",
		# 	width=1600,
		# 	show_shape=False
		# )
		st.markdown(
			df_notes.to_html(header=False, index=True),
			unsafe_allow_html=True
		)

		k_pdf_viewer_example = "key_pdf_viewer_example"
		pdf_viewer_example = pdf_viewer(
			load_pdf_binary(EXAMPLE_PDF),
			key=k_pdf_viewer_example
		)
	elif pills_invoice_extractor_mode == options_pills_invoice_extractor_mode[1]:
		# Previously Processed

		k_slider_show_n: str = "key_slider_show_n"
		st.session_state.setdefault(k_slider_show_n, min(5, len(read_data)))
		slider_show_n = st.slider(
			label="Show last N:",
			key=k_slider_show_n,
			min_value=1,
			max_value=max(1, len(read_data)),
			step=max(1, len(read_data) // 20)
		)

		if not slider_show_n:
			st.write("Select something")

		for i, data in enumerate(read_data[:-(slider_show_n + 1):-1]):
			cols_r = st.columns(2)
			d_ = data.copy()
			del d_["data"]
			cols_r[0].write(
				d_
			)
			with cols_r[1]:
				display_df(
					pd.read_json(io.StringIO(data["data"]))
				)
			st.divider()

		if not read_data:
			st.write("No Data")
	else:
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
								cv = ocr.pil_to_cv(pil)

								# # Apply the SAME rotation to cv first
								# cv = rotate_cv(cv, rot)

								# Now preprocess (deskew, threshold) on the rotated image
								gray, bw = ocr.preprocess_for_ocr(cv, adaptive=True)

								# Make sure arrays are contiguous before any PIL/Tesseract calls or cv2 color ops
								gray = np.ascontiguousarray(gray)
								bw = np.ascontiguousarray(bw)
								cv = np.ascontiguousarray(cv)

								# Detect grid on bw
								detected = ocr.detect_table_cells(bw)

								cont_0 = st.container()
								if show_debug:
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
									# expand_bottom = 0.625  # 18 % of page width — adjust until green boxes cover prices
									# expand_bottom = 0.63  # 18 % of page width — adjust until green boxes cover prices
									expand_bottom = 0.65  # 18 % of page width — adjust until green boxes cover prices
									for i, (x, y, w, h) in enumerate(cells):
										new_h = int(h * (1 + expand_bottom))
										cells[i] = (x, y, w, new_h)

									df = ocr.assemble_table_from_cells(cv, rows=None, cols=2, cells=cells)
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

									if show_debug:
										cols_results_0[1].write("header_vals")
										cols_results_0[1].write(header_vals)
									po, memo_no, *rest = header_vals.split(" ", 2)
									l_memo = ""
									if show_debug:
										cols_results_0[1].write(f"A {po=}, {memo_no=}, {rest=}")
									j_rest = " ".join(rest)
									if j_rest.count(" ") == 0:
										date = j_rest
									else:
										*rest, l_memo, date = j_rest.rsplit(" ", 2)

									if show_debug:
										cols_results_0[1].write(f"B {po=}, {date=}, {l_memo=}, {memo_no=}, {rest=}")
									memo_no = memo_no + l_memo
									table_vals: str = df.loc[1, col_0]

									with cols_results_0[1]:
										st.write("TABLE VALS:")
										st.write(table_vals)

									table_data = {kc: [] for kc in known_cols}
									splt_vals: list[str] = table_vals.split("\n")
									for i in range(len(splt_vals)):
										splt_vals_i = ocr.clean_numeric(splt_vals[i]).strip()
										splt_vals_io = splt_vals_i
										if len(splt_vals_io.split(" ")) != n_known_cols:
											splt_vals_i = frame(splt_vals_io)
										else:
											splt_vals_i = splt_vals_io
										st.write(f"==== {i=}, {splt_vals_io=}, {splt_vals_i=}")
										if splt_vals_i:
											sub_splt = splt_vals_i.split(" ", len(known_cols) - 1)
											st.write(sub_splt)
											for j in range(len(sub_splt)):
												col = known_cols[j]
												# st.write(f"{j=}, {col=}")
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

									try:
										df_table_data["Total Price"] = df_table_data["Total Price"].apply(lambda tp: float(str(tp).replace(" ", "").strip()))
										if show_debug:
											cols_results_0[1].write(f"Sum Total Price: {df_table_data['Total Price'].sum()}")
											cols_results_0[1].write(f"Max Total Price: {df_table_data['Total Price'].max()}")
											cols_results_0[1].write(f"Min Total Price: {df_table_data['Total Price'].min()}")
									except:
										st.warning("Unable to find 'Total Price' code: E011")

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

									df_table_data["Total Price_C"] = df_table_data["Qty Ship."] * df_table_data["Unit Price"]

									# display_df(
									# 	df_table_data,
									# 	"df_table_data CHECK A"
									# )

									df_table_data["TotalScore"] = df_table_data.apply(score_row_accuracy, axis=1)
									df_table_data["Total Price_Fixed"] = df_table_data.apply(auto_correct_total, axis=1)

									# display_df(
									# 	df_table_data,
									# 	"df_table_data CHECK B"
									# )

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
										df2 = ocr.words_to_naive_table(cv)
										df2 = df2 if df2 is not None else pd.DataFrame(["No result"])
										cont_0.dataframe(df2)
								else:
									cont_0.info("No clear grid detected; trying fallback (word clustering)…")
									df2 = ocr.words_to_naive_table(cv)
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
					cols_results = st.columns([0.78, 0.22], border=True)

					if pdf_tables:
						df_all = pd.concat(pdf_tables, ignore_index=True)
					else:
						st.warning("No tables extracted from any uploaded files.")
						st.stop()

					try:
						df_all["Total Price"] = df_all["Total Price_Fixed"]
						sub_total = df_all["Total Price"].sum()
					except:
						sub_total = None
						st.warning("Unable to find 'Total Price' code: E012")

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
						suspect = df_all[df_all["TotalScore"] < 1.0]
						if not suspect.empty:
							with st.expander("Possible errors:"):
								st.warning(
									f"There are rows that may have been mis-read, please double-check the following:")
								display_df(
									# suspect[["Qty Ship.", "Unit Price", "Total Price", "Total Price_C"]],
									suspect,
									"⚠️ Suspect OCR rows:"
								)

						st.download_button(
							f"Download results as CSV",
							df_all.to_csv(index=False).encode("utf-8"),
							file_name=f"parsed_results_{datetime.datetime.now():%Y%m%d%H%M%S}.csv",
							mime="text/csv",
							key=f"btn_download_df_all_{file.name}"
						)
						df_score = score_df_accuracy(df_all)
						cols_results_scores = st.columns([0.25, 0.6, 0.15])
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

						with cols_results_scores[2]:
							overall_score = df_score.loc["Overall", "Score %"]

							if overall_score >= 90:
								st.metric(
									"Overall Accuracy",
									f"{overall_score:.1f}%",
									delta="✅ Excellent",
									# delta_color="#21AA21",
									delta_color="normal",
									border=True
								)
							elif overall_score >= 70:
								st.metric(
									"Overall Accuracy",
									f"{overall_score:.1f}%",
									delta="⚠️ Good",
									# delta_color="#FFCF4F"
									delta_color="off",
									border=True
								)
							else:
								st.metric(
									"Overall Accuracy",
									f"{overall_score:.1f}%",
									delta="❌ Poor",
									# delta_color="#AA2121"
									delta_color="inverse",
									border=True
								)

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

						with st.container(border=True):
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