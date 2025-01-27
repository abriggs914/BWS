
# Version 2025-01-27 1800
# import PyPDF2
import datetime
from copy import deepcopy

import pdfplumber

import streamlit as st

from streamlit_pdf_viewer import pdf_viewer
from streamlit_js_eval import streamlit_js_eval
from streamlit_tree_select import tree_select
from streamlit_float import float_init
from streamlit_scroll_navigation import scroll_navbar

st.set_page_config(
	layout="wide",
	page_title="Weekly WO Meeting"
)


# # Create a dummy streamlit page
# import streamlit as st
# from streamlit_scroll_navigation import scroll_navbar
#
# # Anchor IDs and icons
# anchor_ids = ["About", "Features", "Settings", "Pricing", "Contact"]
# anchor_icons = ["info-circle", "lightbulb", "gear", "tag", "envelope"]
#
# # 1. as sidebar menu
# with st.sidebar:
#     st.subheader("Example 1")
#     scroll_navbar(
#         anchor_ids,
#         anchor_labels=None, # Use anchor_ids as labels
#         anchor_icons=anchor_icons)
#
# # 2. horizontal menu
# st.subheader("Example 2")
# scroll_navbar(
#         anchor_ids,
#         key = "navbar2",
#         anchor_icons=anchor_icons,
#         orientation="horizontal")
#
# # Dummy page setup
# for anchor_id in anchor_ids:
#     st.subheader(anchor_id,anchor=anchor_id)
#     st.write("content " * 100)


float_init()


@st.cache_data(ttl=None, show_spinner=True)
def parse_quotes_list(pdf_obj, column_name="Quote #") -> tuple[int, list[str]]:
	quotes = []

	with pdfplumber.open(pdf_file) as pdf_obj:

		max_pages = len(pdf_obj.pages) + 1

		for page in pdf_obj.pages[:2]:
			tables = page.extract_tables()
			for table in tables:
				# Check if the column name exists in the table header
				if column_name in table[0]:  # table[0] is assumed to be the header row
					# Get the index of the desired column
					col_index = table[0].index(column_name)

					# Extract data from the column
					quotes += [row[col_index] for row in table[1:] if len(row) > col_index]

		return max_pages, quotes


def refresh():
	print(f"REFRESH")
	sel = st.session_state.get("tree_select_selected_nodes", [])
	print(f"AA 'problem_option_wording_leaf_31080' in sel => '{'problem_option_wording_leaf_31080' in sel}'")
	st.rerun()


@st.dialog(title="Issue Details", width="large")
def ask_details(key: str):
	*key, quote = key.rsplit("_", 1)
	key = "".join(key).removeprefix("_").removesuffix("_")
	st.header(f"Please describe your '{key}' issue with quote '{quote}':")
	st.write(f"issue_details_{key}")
	t_key: str = f"issue_details_{key}"
	# IMPORTANT!
	# widget keys in dialog functions are popped from session_state before they can share their values.
	inp = st.text_area(
		label="Details",
		key=f"text_area_{t_key}",
		placeholder=f"Contact sales for further details",
		label_visibility="hidden"
		# ,
		# on_change=lambda: st.session_state.update({t_key: ""})
	)
	cols = st.columns(2)
	with cols[0]:
		if st.button(
			label="cancel",
			key=f"cancel_details_input"
		):
			st.rerun()
	with cols[1]:
		if st.button(
			label="submit",
			key=f"submit_details_input"
		):
			st.session_state.update({t_key: inp})
			print(t_key)
			print(f"SS=> '{st.session_state.get(t_key, 'N/A').strip()}'")
			st.rerun()


s_h = streamlit_js_eval(js_expressions='parent.innerHeight', key='SCR_H')
s_w = streamlit_js_eval(js_expressions='parent.innerWidth', key='SCR_W')

if s_h is None or not s_h:
	s_h = 900
if s_w is None or not s_w:
	s_w = 1600


pages_per_render = 5
checklist_float_pos = 50, 60


# column_pdf, column = st.columns([50, 50])
cols_main = st.columns([0.75, 0.25])
container_pdf = cols_main[0].container(border=1)
container_pdf_ctls = st.container(border=1, height=25)
# container_pdf_ctls.float()
container_pdf_ctls.float("bottom: 0;background-color: grey;")

cols_main[1].float(f"right: {checklist_float_pos[0]}px; top: {checklist_float_pos[1]}px;")

st.write(f"Screen width is '{s_w}'")
st.write(f"Screen height is '{s_h}'")
pdf_render_pages = st.session_state.setdefault("pdf_render_pages", list(range(1, pages_per_render + 1)))
iss_log = {}
valid_log = []

with container_pdf:
	pdf_file = st.file_uploader(
		"Upload PDF file",
		type=('pdf',),
		key="file_uploader_pdf_file",
		accept_multiple_files=False
	)

	if pdf_file:
		st.write(pdf_file.name)
		binary_data = pdf_file.getvalue()

		max_pages, quotes_list = parse_quotes_list(pdf_file)
		# pdf_obj = PyPDF2.PdfReader(pdf_file)

		pdf_viewer(
			input=binary_data,
			width=s_w,
			pages_to_render=pdf_render_pages
		)
	else:
		pdf_render_pages = None, None
		max_pages, quotes_list = None, []
		st.session_state.pop("pdf_render_pages")


st.write(f"Max_pages: '{max_pages}'")
st.write(f"pdf_render_pages: '{pdf_render_pages}'")


if any(pdf_render_pages):
	with container_pdf_ctls:
		cols_ctls = st.columns(5)

		with cols_ctls[0]:
			a, b = 0, pages_per_render
			st.write(f"0 {a=}, {b=}")
			if st.button(
				label=f"1 - {pages_per_render}",
				key="btn_pdf_ctl_first",
				disabled=pdf_render_pages[0] == 1
			):
				st.session_state.update({
					"pdf_render_pages": list(range(a+1, b+1))
				})
				st.rerun()
		with cols_ctls[1]:
			a, b = (
				max(1, pdf_render_pages[0] - pages_per_render - 1),
				max(pages_per_render, pdf_render_pages[0] - 1)
			)
			st.write(f"1 {a=}, {b=}")
			if st.button(
				label=f"{a} - {b}",
				key="btn_pdf_ctl_prev",
				disabled=pdf_render_pages[0] == 1
			):
				st.session_state.update({
					"pdf_render_pages": list(range(a, b+1))
				})
				st.rerun()
		with cols_ctls[2]:
			st.write(f"2 {pdf_render_pages=}")
			st.write(f"2 {max_pages=}")
			st.write(f"Page ({pdf_render_pages[0]} - {pdf_render_pages[-1]}) of {max_pages} pages(s)")
		with cols_ctls[3]:
			a, b = (
				min(max_pages - (1 + (max_pages % pages_per_render)), pdf_render_pages[0] + pages_per_render),
				min(max_pages, pdf_render_pages[-1] + pages_per_render)
			)
			st.write(f"3 {a=}, {b=}")
			if st.button(
				label=f"{a} - {b}",
				key="btn_pdf_ctl_next",
				disabled=pdf_render_pages[-1] == max_pages
			):
				st.session_state.update({
					"pdf_render_pages": list(range(a, b+1))
				})
				st.rerun()
		with cols_ctls[4]:
			a, b = max_pages - (1 + (max_pages % pages_per_render)), max_pages
			st.write(f"4 {a=}, {b=}")
			if st.button(
				label=f"{a} - {b}",
				key="btn_pdf_ctl_last",
				disabled=pdf_render_pages[-1] == max_pages
			):
				st.session_state.update({
					"pdf_render_pages": list(range(a, b+1))
				})
				st.rerun()

with cols_main[1]:

	with st.container(
		border=1,
		height=int(s_h * 0.75)
	):
		st.subheader("Checklist:")

		# Create nodes to display
		# nodes = [
		# 	{"label": "Folder A", "value": "folder_a"},
		# 	{
		# 		"label": "Folder B",
		# 		"value": "folder_b",
		# 		"children": [
		# 			{"label": "Sub-folder A", "value": "sub_a"},
		# 			{"label": "Sub-folder B", "value": "sub_b"},
		# 			{"label": "Sub-folder C", "value": "sub_c"},
		# 		],
		# 	},
		# 	{
		# 		"label": "Folder C",
		# 		"value": "folder_c",
		# 		"children": [
		# 			{"label": "Sub-folder D", "value": "sub_d"},
		# 			{
		# 				"label": "Sub-folder E",
		# 				"value": "sub_e",
		# 				"children": [
		# 					{"label": "Sub-sub-folder A", "value": "sub_sub_a"},
		# 					{"label": "Sub-sub-folder B", "value": "sub_sub_b"},
		# 				],
		# 			},
		# 			{"label": "Sub-folder F", "value": "sub_f"},
		# 		],
		# 	},
		# ]
		lf = "leaf_"
		ch = "check_"
		pb = "problem_"
		qn = "question_"
		aa = "all_of_the_above_"
		node_structure = {
			"problem": (["Code", "Option-Wording", "Typo"], pb),
			"question": (["Beams", "Load-Securement"], qn),
			"all of the above": ([], aa)
		}
		nodes = [{
			"label": q,
			"value": f"{ch}{q}",
			# "showCheckbox": False,
			"children": [{
				"label": lbl.title(),
				"value": f"{node_structure[lbl][1]}{q}",
				# "showCheckbox": False,
				"children": [{
					# "label": child.title(),
					"label": f"{node_structure[lbl][1]}{child.lower().replace(' ', '_').replace('-', '_')}_{lf}{q}",
					"value": f"{node_structure[lbl][1]}{child.lower().replace(' ', '_').replace('-', '_')}_{lf}{q}"
					}
					for child in node_structure[lbl][0]
				]}
				for lbl in node_structure
			]}
			for i, q in enumerate(quotes_list)
		]
		possible_keys = []
		for i, q in enumerate(quotes_list):
			possible_keys.append(nodes[i]["value"])
			for j, lbl in enumerate(node_structure):
				possible_keys.append(nodes[i]["children"][j]["value"])
				if not nodes[i]["children"][j].get("children", []):
					del nodes[i]["children"][j]["children"]
				else:
					for child in nodes[i]["children"][j].get("children", []):
						possible_keys.append(child["value"])
		st.write(possible_keys)
		st.write(nodes)
		# nodes = [
		# 	{
		# 		"label": q,
		# 		"value": f"{ch}{q}",
		# 		"children": [
		# 			{
		# 				"label": "problem",
		# 				"value": f"{pb}{q}",
		# 				"children": [
		# 					{
		# 						"label": "code",
		# 						"value": f"{pb}code_{lf}{q}"
		# 					},
		# 					{
		# 						"label": "option-wording",
		# 						"value": f"{pb}wording_{lf}{q}"
		# 					},
		# 					{
		# 						"label": "typo",
		# 						"value": f"{pb}typo_{lf}{q}"
		# 					}
		# 				]
		# 			},
		# 			{
		# 				"label": "question",
		# 				"value": f"{qn}{q}",
		# 				"children": [
		# 					{
		# 						"label": "Beams",
		# 						"value": f"{qn}beams_{lf}{q}"
		# 					},
		# 					{
		# 						"label": "Load Securement",
		# 						"value": f"{qn}load_securement_{lf}{q}"
		# 					}
		# 				]
		# 			},
		# 			{
		# 				"label": "all of the above",
		# 				"value": f"{lf}{aa}{q}"
		# 			}
		# 		]
		# 	}
		# 	for q in quotes_list
		# ]

		with st.container(border=True):
			pre_select = st.session_state.get("tree_select_selected_nodes", [])
			print(f"BB 'problem_option_wording_leaf_31080' in pre_select => '{'problem_option_wording_leaf_31080' in pre_select}'")

			return_select = tree_select(
				nodes,
				checked=pre_select,
				# key="tree_select",
				direction="ltr"
			)

			if st.button(
				label="select all",
				key="btn_select_all_checklist"
			):
				children = deepcopy(nodes)
				checked = []
				while children:
					node = children.pop(0)
					val = node.get("value")
					children.extend(node.get("children", []))
					checked.append(val)
					# st.session_state.update({val: True})
				st.session_state.update({"tree_select_selected_nodes": checked})
				# if val not in return_select["checked"]:
				# 	return_select["checked"].append(val)

				st.rerun()

			st.write("pre_select")
			st.write(pre_select)

		with st.container(border=True):
			st.write(return_select)

		checked = return_select["checked"]

		old_checked = st.session_state.get("tree_select_selected_nodes", [])
		new_checked = set(checked).difference(set(old_checked))
		new_removed = set(old_checked).difference(set(checked))

		added: bool = False
		for i, key in enumerate(new_checked):
			if key.startswith(aa):
				for j, k in enumerate(node_structure):
					ok = f"{k}_{q}".lower().replace(' ', '_').replace('-', '_')
					if ok not in checked:
						checked.append(ok)
						added = True
						print(f"ADD '{ok}'")
						if ok not in possible_keys:
							raise ValueError(f"NO '{ok}'")
					for lbl in node_structure[k][0]:
						ok = f"{k}_{lbl}_{lf}{q}".lower().replace(' ', '_').replace('-', '_')
						if ok not in checked:
							checked.append(ok)
							added = True
							print(f"ADD '{ok}'")
							if ok not in possible_keys:
								raise ValueError(f"NO '{ok}'")
			ask_details(key)
			print("XX '" + st.session_state.get(f"issue_details{key}", "n/a") + "'")

		removed: bool = False
		for i, key in enumerate(new_removed):
			if key.startswith(aa):
				for j, k in enumerate(node_structure):
					ok = f"{k}_{q}".lower().replace(' ', '_').replace('-', '_')
					if ok in checked:
						checked.remove(ok)
						removed = True
						print(f"ADD '{ok}'")
						if ok not in possible_keys:
							raise ValueError(f"NO '{ok}'")
					for lbl in node_structure[k][0]:
						ok = f"{k}_{lbl}_{lf}{q}".lower().replace(' ', '_').replace('-', '_')
						if ok in checked:
							checked.remove(ok)
							removed = True
							print(f"ADD '{ok}'")
							if ok not in possible_keys:
								raise ValueError(f"NO '{ok}'")

		st.session_state.update({"tree_select_selected_nodes": checked})
		st.write("old_checked")
		st.write(old_checked)
		st.write("new_checked")
		st.write(new_checked)
		st.write("new_removed")
		st.write(new_removed)
		st.write("checked")
		st.write(checked)
		#
		#
		# st.session_state.update({"tree_select_selected_nodes": return_select["checked"]})
		if added or removed:
			# print(f"{st.session_state.get('tree_select_selected_nodes')=}")
			print(f"RERUN {datetime.datetime.now():%Y-%m-%d %H:%M:%S}")
			# st.rerun()
			refresh()

		chk_quotes = set()
		for i, check_key in enumerate(checked):
			*key, quote = check_key.rsplit("_", 1)
			key = "".join(key)
			# print(f"Quote: '{quote}', ISS: '{key}'")
			chk_quotes.add(quote)
		quotes_left = list(set(quotes_list).difference(chk_quotes))

		with st.container(border=True):
			if st.button(
				label="End Meeting",
				key=f"btn_end_meeting",
				disabled=bool(quotes_left)
			):
				for i, check_key in enumerate(return_select["checked"]):
					*key, quote = check_key.rsplit("_", 1)
					key = "".join(key).removeprefix("_").removesuffix("_")
					# iss = key.removeprefix(pb).removeprefix(qn).removesuffix(lf)
					print(f"Quote: '{quote}', ISS: '{key}'")
					if key == ch.removeprefix("_").removesuffix("_"):
						# checked Tag
						valid_log.append(quote)
					else:
						if quote not in valid_log:
							# if key == aa.removesuffix("_").removeprefix("_"):
							if quote not in iss_log:
								iss_log[quote] = []
							# if key.removeprefix(lf).removeprefix(ch) == aa:
							# 	for j
							# else:
								iss_log[quote].append({
									"iss": key,
									"comm": st.session_state.get(f"issue_details_{key}", "N/A")
								})

with st.expander("RESULTS"):
	st.write("Checked")
	st.write(valid_log)
	st.write("---")
	st.write("Issues")
	st.write(iss_log)

# Version 2025-01-27 1900

# import os
# import datetime
# from copy import deepcopy
#
# import pdfplumber
# from PyPDF2 import PdfMerger
#
# import streamlit as st
#
# from streamlit_pdf_viewer import pdf_viewer
# from streamlit_js_eval import streamlit_js_eval
# from streamlit_tree_select import tree_select
# from streamlit_float import float_init
# from streamlit_scroll_navigation import scroll_navbar
#
# from utility import next_available_file_name
#
# st.set_page_config(
# 	layout="wide",
# 	page_title="Weekly WO Meeting"
# )
#
#
# # # Create a dummy streamlit page
# # import streamlit as st
# # from streamlit_scroll_navigation import scroll_navbar
# #
# # # Anchor IDs and icons
# # anchor_ids = ["About", "Features", "Settings", "Pricing", "Contact"]
# # anchor_icons = ["info-circle", "lightbulb", "gear", "tag", "envelope"]
# #
# # # 1. as sidebar menu
# # with st.sidebar:
# #     st.subheader("Example 1")
# #     scroll_navbar(
# #         anchor_ids,
# #         anchor_labels=None, # Use anchor_ids as labels
# #         anchor_icons=anchor_icons)
# #
# # # 2. horizontal menu
# # st.subheader("Example 2")
# # scroll_navbar(
# #         anchor_ids,
# #         key = "navbar2",
# #         anchor_icons=anchor_icons,
# #         orientation="horizontal")
# #
# # # Dummy page setup
# # for anchor_id in anchor_ids:
# #     st.subheader(anchor_id,anchor=anchor_id)
# #     st.write("content " * 100)
#
#
# float_init()
#
#
# @st.cache_data(ttl=None, show_spinner=True)
# def parse_quotes_list(pdf_obj, column_name="Quote #") -> tuple[int, list[str]]:
# 	quotes = []
#
# 	with pdfplumber.open(pdf_file) as pdf_obj:
#
# 		max_pages = len(pdf_obj.pages) + 1
#
# 		for page in pdf_obj.pages[:2]:
# 			tables = page.extract_tables()
# 			for table in tables:
# 				# Check if the column name exists in the table header
# 				if column_name in table[0]:  # table[0] is assumed to be the header row
# 					# Get the index of the desired column
# 					col_index = table[0].index(column_name)
#
# 					# Extract data from the column
# 					quotes += [row[col_index] for row in table[1:] if len(row) > col_index]
#
# 		return max_pages, quotes
#
#
# def refresh():
# 	print(f"REFRESH")
# 	sel = st.session_state.get("tree_select_selected_nodes", [])
# 	print(f"AA 'problem_option_wording_leaf_31080' in sel => '{'problem_option_wording_leaf_31080' in sel}'")
# 	st.rerun()
#
#
# @st.dialog(title="Issue Details", width="large")
# def ask_details(key: str):
# 	*key, quote = key.rsplit("_", 1)
# 	key = "".join(key).removeprefix("_").removesuffix("_")
# 	st.header(f"Please describe your '{key}' issue with quote '{quote}':")
# 	st.write(f"issue_details_{key}")
# 	t_key: str = f"issue_details_{key}"
# 	# IMPORTANT!
# 	# widget keys in dialog functions are popped from session_state before they can share their values.
# 	inp = st.text_area(
# 		label="Details",
# 		key=f"text_area_{t_key}",
# 		placeholder=f"Contact sales for further details",
# 		label_visibility="hidden"
# 		# ,
# 		# on_change=lambda: st.session_state.update({t_key: ""})
# 	)
# 	cols = st.columns(2)
# 	with cols[0]:
# 		if st.button(
# 			label="cancel",
# 			key=f"cancel_details_input"
# 		):
# 			st.rerun()
# 	with cols[1]:
# 		if st.button(
# 			label="submit",
# 			key=f"submit_details_input"
# 		):
# 			st.session_state.update({t_key: inp})
# 			print(t_key)
# 			print(f"SS=> '{st.session_state.get(t_key, 'N/A').strip()}'")
# 			st.rerun()
#
#
# def merge_pdfs_from_folder(
# 		folder_path: str,
# 		quote_order: list[str],
# 		output_file: str = "merged_output.pdf"
# ) -> str:
# 	"""
# 	Merges all PDF files in a specified folder into a single PDF file.
#
# 	Args:
# 		folder_path (str): The path to the folder containing PDF files.
# 		quote_order (list[str)): The order of quotes to reference when ordering the PDFs. Read from itinerary_file.
# 		output_file (str): The name of the output merged PDF file (default: "merged_output.pdf").
#
# 	Returns:
# 		str: The path to the merged output file.
# 	"""
#
# 	print(f"Starting...")
# 	start_time = datetime.datetime.now()
#
# 	# Check if the folder exists
# 	if not os.path.exists(folder_path):
# 		raise FileNotFoundError(f"The folder '{folder_path}' does not exist.")
#
# 	if not os.path.exists(os.path.join(folder_path, itinerary_file)):
# 		raise FileNotFoundError(f"The Itinerary file '{itinerary_file}' does not exist.")
#
# 	files = []
#
# 	print(f"Searching...")
#
# 	# Iterate through files in the folder
# 	for filename in sorted(os.listdir(folder_path)):
# 		# Check if the file is a PDF
# 		if filename.lower().endswith(".pdf"):
# 			if filename != itinerary_file:
# 				file_path = os.path.join(folder_path, filename)
# 				# print(f"Adding: {file_path}")
# 				files.append(file_path)
#
# 	print(f"Combining...")
#
# 	# Create a PdfMerger object
# 	merger = PdfMerger()
# 	merger.append(os.path.join(folder_path, itinerary_file))
#
# 	for i, quote_number in enumerate(quote_order):
# 		if not isinstance(quote_number, str):
# 			quote_number = str(quote_number)
# 		for j, file_name in enumerate(files):
# 			if f"q{quote_number}.pdf".lower() in file_name.lower():
# 				merger.append(file_name)
#
# 	print(f"Saving...")
#
# 	# Save the merged PDF to the specified output file
# 	output_path = os.path.join(folder_path, output_file)
# 	merger.write(output_path)
# 	merger.close()
#
# 	end_time = datetime.datetime.now()
# 	print(f"Finished...")
# 	print(f"Merged PDF saved as: {output_path}")
# 	print(f"Results in {(end_time - start_time).total_seconds()} second(s)")
# 	return output_path
#
#
# def extract_quote_column(pdf_file_path, column_name="Quote #"):
# 	"""
# 	Extract data from a specific column in a table within a PDF.
#
# 	Args:
# 		pdf_file_path (str): Path to the PDF file.
# 		column_name (str): Name of the column to extract (default: "Quote").
#
# 	Returns:
# 		list: A list of values from the specified column.
# 	"""
# 	quotes = []
#
# 	# Open the PDF file using pdfplumber
# 	with pdfplumber.open(pdf_file_path) as pdf:
# 		for page in pdf.pages:
# 			# Extract tables from the page
# 			tables = page.extract_tables()
# 			for table in tables:
# 				# Check if the column name exists in the table header
# 				if column_name in table[0]:  # table[0] is assumed to be the header row
# 					# Get the index of the desired column
# 					col_index = table[0].index(column_name)
#
# 					# Extract data from the column
# 					quotes += [row[col_index] for row in table[1:] if len(row) > col_index]
# 	return quotes
#
#
# s_h = streamlit_js_eval(js_expressions='parent.innerHeight', key='SCR_H')
# s_w = streamlit_js_eval(js_expressions='parent.innerWidth', key='SCR_W')
#
# if s_h is None or not s_h:
# 	s_h = 900
# if s_w is None or not s_w:
# 	s_w = 1600
#
#
# pages_per_render = 5
# checklist_float_pos = 50, 60
#
#
# # column_pdf, column = st.columns([50, 50])
# cols_main = st.columns([0.75, 0.25])
# container_pdf = cols_main[0].container(border=1)
# container_pdf_ctls = st.container(border=1, height=25)
# # container_pdf_ctls.float()
# container_pdf_ctls.float("bottom: 0;background-color: grey;")
#
# cols_main[1].float(f"right: {checklist_float_pos[0]}px; top: {checklist_float_pos[1]}px;")
#
# st.write(f"Screen width is '{s_w}'")
# st.write(f"Screen height is '{s_h}'")
# pdf_render_pages = st.session_state.setdefault("pdf_render_pages", list(range(1, pages_per_render + 1)))
# iss_log = {}
# valid_log = []
#
# with container_pdf:
# 	pdf_file = st.file_uploader(
# 		"Upload PDF file",
# 		type=('pdf',),
# 		key="file_uploader_pdf_file",
# 		accept_multiple_files=False
# 	)
#
# 	# prep_date = datetime.datetime(2025, 1, 14)
# 	prep_date = datetime.datetime.today()
#
# 	output_file = r"merged_output.pdf"
# 	folder_path = fr"\\bwsfp01\Public\SALES OFFICE\Weekly WO Meetings\{prep_date:%Y-%m-%d}"
#
# 	output_file = next_available_file_name(os.path.join(folder_path, output_file))
# 	output_file = os.path.basename(output_file)
#
# 	itinerary_file = fr"WO_Meeting_{prep_date:%Y-%m-%d}.pdf"
# 	if os.path.exists(os.path.join(folder_path, itinerary_file)):
# 		quote_order = extract_quote_column(
# 			os.path.join(folder_path, itinerary_file)
# 		)
# 		# print(f"{quote_order=}")
#
# 		merge_pdfs_from_folder(
# 			folder_path,
# 			quote_order,
# 			os.path.join(folder_path, output_file)
# 		)
# 	else:
# 		print(f"Please follow the steps to create an Itinerary file first.")
#
# 	if pdf_file:
# 		st.write(pdf_file.name)
# 		binary_data = pdf_file.getvalue()
#
# 		max_pages, quotes_list = parse_quotes_list(pdf_file)
# 		# pdf_obj = PyPDF2.PdfReader(pdf_file)
#
# 		pdf_viewer(
# 			input=binary_data,
# 			width=s_w,
# 			pages_to_render=pdf_render_pages
# 		)
# 	else:
# 		pdf_render_pages = None, None
# 		max_pages, quotes_list = None, []
# 		st.session_state.pop("pdf_render_pages")
#
#
# st.write(f"Max_pages: '{max_pages}'")
# st.write(f"pdf_render_pages: '{pdf_render_pages}'")
#
#
# if any(pdf_render_pages):
# 	with container_pdf_ctls:
# 		cols_ctls = st.columns(5)
#
# 		with cols_ctls[0]:
# 			a, b = 0, pages_per_render
# 			st.write(f"0 {a=}, {b=}")
# 			if st.button(
# 				label=f"1 - {pages_per_render}",
# 				key="btn_pdf_ctl_first",
# 				disabled=pdf_render_pages[0] == 1
# 			):
# 				st.session_state.update({
# 					"pdf_render_pages": list(range(a+1, b+1))
# 				})
# 				st.rerun()
# 		with cols_ctls[1]:
# 			a, b = (
# 				max(1, pdf_render_pages[0] - pages_per_render - 1),
# 				max(pages_per_render, pdf_render_pages[0] - 1)
# 			)
# 			st.write(f"1 {a=}, {b=}")
# 			if st.button(
# 				label=f"{a} - {b}",
# 				key="btn_pdf_ctl_prev",
# 				disabled=pdf_render_pages[0] == 1
# 			):
# 				st.session_state.update({
# 					"pdf_render_pages": list(range(a, b+1))
# 				})
# 				st.rerun()
# 		with cols_ctls[2]:
# 			st.write(f"2 {pdf_render_pages=}")
# 			st.write(f"2 {max_pages=}")
# 			st.write(f"Page ({pdf_render_pages[0]} - {pdf_render_pages[-1]}) of {max_pages} pages(s)")
# 		with cols_ctls[3]:
# 			a, b = (
# 				min(max_pages - (1 + (max_pages % pages_per_render)), pdf_render_pages[0] + pages_per_render),
# 				min(max_pages, pdf_render_pages[-1] + pages_per_render)
# 			)
# 			st.write(f"3 {a=}, {b=}")
# 			if st.button(
# 				label=f"{a} - {b}",
# 				key="btn_pdf_ctl_next",
# 				disabled=pdf_render_pages[-1] == max_pages
# 			):
# 				st.session_state.update({
# 					"pdf_render_pages": list(range(a, b+1))
# 				})
# 				st.rerun()
# 		with cols_ctls[4]:
# 			a, b = max_pages - (1 + (max_pages % pages_per_render)), max_pages
# 			st.write(f"4 {a=}, {b=}")
# 			if st.button(
# 				label=f"{a} - {b}",
# 				key="btn_pdf_ctl_last",
# 				disabled=pdf_render_pages[-1] == max_pages
# 			):
# 				st.session_state.update({
# 					"pdf_render_pages": list(range(a, b+1))
# 				})
# 				st.rerun()
#
# with cols_main[1]:
#
# 	with st.container(
# 		border=1,
# 		height=int(s_h * 0.75)
# 	):
# 		st.subheader("Checklist:")
#
# 		# Create nodes to display
# 		# nodes = [
# 		# 	{"label": "Folder A", "value": "folder_a"},
# 		# 	{
# 		# 		"label": "Folder B",
# 		# 		"value": "folder_b",
# 		# 		"children": [
# 		# 			{"label": "Sub-folder A", "value": "sub_a"},
# 		# 			{"label": "Sub-folder B", "value": "sub_b"},
# 		# 			{"label": "Sub-folder C", "value": "sub_c"},
# 		# 		],
# 		# 	},
# 		# 	{
# 		# 		"label": "Folder C",
# 		# 		"value": "folder_c",
# 		# 		"children": [
# 		# 			{"label": "Sub-folder D", "value": "sub_d"},
# 		# 			{
# 		# 				"label": "Sub-folder E",
# 		# 				"value": "sub_e",
# 		# 				"children": [
# 		# 					{"label": "Sub-sub-folder A", "value": "sub_sub_a"},
# 		# 					{"label": "Sub-sub-folder B", "value": "sub_sub_b"},
# 		# 				],
# 		# 			},
# 		# 			{"label": "Sub-folder F", "value": "sub_f"},
# 		# 		],
# 		# 	},
# 		# ]
# 		lf = "leaf_"
# 		ch = "check_"
# 		pb = "problem_"
# 		qn = "question_"
# 		aa = "all_of_the_above_"
# 		node_structure = {
# 			"problem": (["Code", "Option-Wording", "Typo"], pb),
# 			"question": (["Beams", "Load-Securement"], qn),
# 			"all of the above": ([], aa)
# 		}
# 		nodes = [{
# 			"label": q,
# 			"value": f"{ch}{q}",
# 			# "showCheckbox": False,
# 			"children": [{
# 				"label": lbl.title(),
# 				"value": f"{node_structure[lbl][1]}{q}",
# 				# "showCheckbox": False,
# 				"children": [{
# 					# "label": child.title(),
# 					"label": f"{node_structure[lbl][1]}{child.lower().replace(' ', '_').replace('-', '_')}_{lf}{q}",
# 					"value": f"{node_structure[lbl][1]}{child.lower().replace(' ', '_').replace('-', '_')}_{lf}{q}"
# 					}
# 					for child in node_structure[lbl][0]
# 				]}
# 				for lbl in node_structure
# 			]}
# 			for i, q in enumerate(quotes_list)
# 		]
# 		possible_keys = []
# 		for i, q in enumerate(quotes_list):
# 			possible_keys.append(nodes[i]["value"])
# 			for j, lbl in enumerate(node_structure):
# 				possible_keys.append(nodes[i]["children"][j]["value"])
# 				if not nodes[i]["children"][j].get("children", []):
# 					del nodes[i]["children"][j]["children"]
# 				else:
# 					for child in nodes[i]["children"][j].get("children", []):
# 						possible_keys.append(child["value"])
# 		st.write(possible_keys)
# 		st.write(nodes)
# 		# nodes = [
# 		# 	{
# 		# 		"label": q,
# 		# 		"value": f"{ch}{q}",
# 		# 		"children": [
# 		# 			{
# 		# 				"label": "problem",
# 		# 				"value": f"{pb}{q}",
# 		# 				"children": [
# 		# 					{
# 		# 						"label": "code",
# 		# 						"value": f"{pb}code_{lf}{q}"
# 		# 					},
# 		# 					{
# 		# 						"label": "option-wording",
# 		# 						"value": f"{pb}wording_{lf}{q}"
# 		# 					},
# 		# 					{
# 		# 						"label": "typo",
# 		# 						"value": f"{pb}typo_{lf}{q}"
# 		# 					}
# 		# 				]
# 		# 			},
# 		# 			{
# 		# 				"label": "question",
# 		# 				"value": f"{qn}{q}",
# 		# 				"children": [
# 		# 					{
# 		# 						"label": "Beams",
# 		# 						"value": f"{qn}beams_{lf}{q}"
# 		# 					},
# 		# 					{
# 		# 						"label": "Load Securement",
# 		# 						"value": f"{qn}load_securement_{lf}{q}"
# 		# 					}
# 		# 				]
# 		# 			},
# 		# 			{
# 		# 				"label": "all of the above",
# 		# 				"value": f"{lf}{aa}{q}"
# 		# 			}
# 		# 		]
# 		# 	}
# 		# 	for q in quotes_list
# 		# ]
#
# 		with st.container(border=True):
# 			pre_select = st.session_state.get("tree_select_selected_nodes", [])
# 			print(f"BB 'problem_option_wording_leaf_31080' in pre_select => '{'problem_option_wording_leaf_31080' in pre_select}'")
#
# 			return_select = tree_select(
# 				nodes,
# 				checked=pre_select,
# 				# key="tree_select",
# 				direction="ltr"
# 			)
#
# 			if st.button(
# 				label="select all",
# 				key="btn_select_all_checklist"
# 			):
# 				children = deepcopy(nodes)
# 				checked = []
# 				while children:
# 					node = children.pop(0)
# 					val = node.get("value")
# 					children.extend(node.get("children", []))
# 					checked.append(val)
# 					# st.session_state.update({val: True})
# 				st.session_state.update({"tree_select_selected_nodes": checked})
# 				# if val not in return_select["checked"]:
# 				# 	return_select["checked"].append(val)
#
# 				st.rerun()
#
# 			st.write("pre_select")
# 			st.write(pre_select)
#
# 		with st.container(border=True):
# 			st.write(return_select)
#
# 		checked = return_select["checked"]
#
# 		old_checked = st.session_state.get("tree_select_selected_nodes", [])
# 		new_checked = set(checked).difference(set(old_checked))
# 		new_removed = set(old_checked).difference(set(checked))
#
# 		added: bool = False
# 		for i, key in enumerate(new_checked):
# 			if key.startswith(aa):
# 				for j, k in enumerate(node_structure):
# 					ok = f"{k}_{q}".lower().replace(' ', '_').replace('-', '_')
# 					if ok not in checked:
# 						checked.append(ok)
# 						added = True
# 						print(f"ADD '{ok}'")
# 						if ok not in possible_keys:
# 							raise ValueError(f"NO '{ok}'")
# 					for lbl in node_structure[k][0]:
# 						ok = f"{k}_{lbl}_{lf}{q}".lower().replace(' ', '_').replace('-', '_')
# 						if ok not in checked:
# 							checked.append(ok)
# 							added = True
# 							print(f"ADD '{ok}'")
# 							if ok not in possible_keys:
# 								raise ValueError(f"NO '{ok}'")
# 			ask_details(key)
# 			print("XX '" + st.session_state.get(f"issue_details{key}", "n/a") + "'")
#
# 		removed: bool = False
# 		for i, key in enumerate(new_removed):
# 			if key.startswith(aa):
# 				for j, k in enumerate(node_structure):
# 					ok = f"{k}_{q}".lower().replace(' ', '_').replace('-', '_')
# 					if ok in checked:
# 						checked.remove(ok)
# 						removed = True
# 						print(f"ADD '{ok}'")
# 						if ok not in possible_keys:
# 							raise ValueError(f"NO '{ok}'")
# 					for lbl in node_structure[k][0]:
# 						ok = f"{k}_{lbl}_{lf}{q}".lower().replace(' ', '_').replace('-', '_')
# 						if ok in checked:
# 							checked.remove(ok)
# 							removed = True
# 							print(f"ADD '{ok}'")
# 							if ok not in possible_keys:
# 								raise ValueError(f"NO '{ok}'")
#
# 		st.session_state.update({"tree_select_selected_nodes": checked})
# 		st.write("old_checked")
# 		st.write(old_checked)
# 		st.write("new_checked")
# 		st.write(new_checked)
# 		st.write("new_removed")
# 		st.write(new_removed)
# 		st.write("checked")
# 		st.write(checked)
# 		#
# 		#
# 		# st.session_state.update({"tree_select_selected_nodes": return_select["checked"]})
# 		if added or removed:
# 			# print(f"{st.session_state.get('tree_select_selected_nodes')=}")
# 			print(f"RERUN {datetime.datetime.now():%Y-%m-%d %H:%M:%S}")
# 			# st.rerun()
# 			refresh()
#
# 		chk_quotes = set()
# 		for i, check_key in enumerate(checked):
# 			*key, quote = check_key.rsplit("_", 1)
# 			key = "".join(key)
# 			# print(f"Quote: '{quote}', ISS: '{key}'")
# 			chk_quotes.add(quote)
# 		quotes_left = list(set(quotes_list).difference(chk_quotes))
#
# 		with st.container(border=True):
# 			if st.button(
# 				label="End Meeting",
# 				key=f"btn_end_meeting",
# 				disabled=bool(quotes_left)
# 			):
# 				for i, check_key in enumerate(return_select["checked"]):
# 					*key, quote = check_key.rsplit("_", 1)
# 					key = "".join(key).removeprefix("_").removesuffix("_")
# 					# iss = key.removeprefix(pb).removeprefix(qn).removesuffix(lf)
# 					print(f"Quote: '{quote}', ISS: '{key}'")
# 					if key == ch.removeprefix("_").removesuffix("_"):
# 						# checked Tag
# 						valid_log.append(quote)
# 					else:
# 						if quote not in valid_log:
# 							# if key == aa.removesuffix("_").removeprefix("_"):
# 							if quote not in iss_log:
# 								iss_log[quote] = []
# 							# if key.removeprefix(lf).removeprefix(ch) == aa:
# 							# 	for j
# 							# else:
# 								iss_log[quote].append({
# 									"iss": key,
# 									"comm": st.session_state.get(f"issue_details_{key}", "N/A")
# 								})
#
# with st.expander("RESULTS"):
# 	st.write("Checked")
# 	st.write(valid_log)
# 	st.write("---")
# 	st.write("Issues")
# 	st.write(iss_log)
#
