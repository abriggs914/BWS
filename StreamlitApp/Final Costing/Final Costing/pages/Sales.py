# import PyPDF2
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


s_h = streamlit_js_eval(js_expressions='parent.innerHeight', key='SCR_H')
s_w = streamlit_js_eval(js_expressions='parent.innerWidth', key='SCR_W')


pages_per_render = 10
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
pdf_render_pages = st.session_state.setdefault("pdf_render_pages", list(range(pages_per_render)))
iss_log = []
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


if any(pdf_render_pages):
	with container_pdf_ctls:
		cols_ctls = st.columns(5)

		with cols_ctls[0]:
			a, b = 0, pages_per_render
			st.write(f"0 {a=}, {b=}")
			if st.button(
				label=f"1 - {pages_per_render - 1}",
				key="btn_pdf_ctl_first",
				disabled=pdf_render_pages[0] == 0
			):
				st.session_state.update({
					"pdf_render_pages": list(range(a, b))
				})
				st.rerun()
		with cols_ctls[1]:
			a, b = max(0, pdf_render_pages[0] - pages_per_render), max(pdf_render_pages[0], pages_per_render - 1)
			st.write(f"1 {a=}, {b=}")
			if st.button(
				label=f"{a + 1} - {b}",
				key="btn_pdf_ctl_prev",
				disabled=pdf_render_pages[0] == 0
			):
				st.session_state.update({
					"pdf_render_pages": list(range(a, b))
				})
				st.rerun()
		with cols_ctls[2]:
			st.write(f"2 {pdf_render_pages=}")
			st.write(f"2 {max_pages=}")
			st.write(f"Page ({pdf_render_pages[0] + 1} - {pdf_render_pages[-1] + 1}) of {max_pages} pages(s)")
		with cols_ctls[3]:
			a, b = min(max_pages - pages_per_render, pdf_render_pages[-1] + 1), min(pdf_render_pages[-1] + pages_per_render, max_pages)
			st.write(f"3 {a=}, {b=}")
			if st.button(
				label=f"{a + 1} - {b + 1}",
				key="btn_pdf_ctl_next",
				disabled=pdf_render_pages[-1] == (max_pages - 1)
			):
				st.session_state.update({
					"pdf_render_pages": list(range(a, b))
				})
				st.rerun()
		with cols_ctls[4]:
			a, b = max_pages - pages_per_render, max_pages
			st.write(f"4 {a=}, {b=}")
			if st.button(
				label=f"{a + 1} - {b + 1}",
				key="btn_pdf_ctl_last",
				disabled=pdf_render_pages[-1] == (max_pages - 1)
			):
				st.session_state.update({
					"pdf_render_pages": list(range(a, b))
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
		nodes = [
			{
				"label": q,
				"value": f"{ch}{q}",
				"children": [
					{
						"label": "problem",
						"value": f"{pb}{q}",
						"children": [
							{
								"label": "code",
								"value": f"{pb}code_{lf}{q}"
							},
							{
								"label": "option-wording",
								"value": f"{pb}wording_{lf}{q}"
							},
							{
								"label": "typo",
								"value": f"{pb}typo_{lf}{q}"
							}
						]
					},
					{
						"label": "question",
						"value": f"{qn}{q}",
						"children": [
							{
								"label": "Beams",
								"value": f"{qn}beams_{lf}{q}"
							},
							{
								"label": "Load Securement",
								"value": f"{qn}load_securement_{lf}{q}"
							}
						]
					}
				]
			}
			for q in quotes_list
		]

		with st.container(border=True):
			return_select = tree_select(nodes)
		with st.container(border=True):
			st.write(return_select)

		chk_quotes = set()
		for i, check_key in enumerate(return_select["checked"]):
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
					print(f"Quote: '{quote}', ISS: '{key}'")
					if key == ch.removeprefix("_").removesuffix("_"):
						# checked Tag
						valid_log.append(quote)
					else:
						if quote not in valid_log:
							iss_log.append(quote)

with st.expander("RESULTS"):
	st.write("Checked")
	st.write(valid_log)
	st.write("---")
	st.write("Issues")
	st.write(iss_log)

