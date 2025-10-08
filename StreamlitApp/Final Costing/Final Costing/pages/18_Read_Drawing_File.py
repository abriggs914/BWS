import pandas as pd
import pytesseract
import pdfplumber
from streamlit_utility import *
from PIL import Image
import re

# pytesseract.pytesseract.tesseract_cmd = r"C:\Users\abriggs\AppData\Local\Programs\Tesseract-OCR\tesseract.exe"

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
st.set_page_config(layout="wide")
st.title("🧾 PDF Parts List Extractor")

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

