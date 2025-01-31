import json
# Version 2025-01-27 1800
# import PyPDF2
import os
import datetime
from copy import deepcopy

import pandas as pd
import pdfplumber

import streamlit as st

from streamlit_pdf_viewer import pdf_viewer
from streamlit_js_eval import streamlit_js_eval
from streamlit_tree_select import tree_select
from streamlit_float import float_init
from streamlit_scroll_navigation import scroll_navbar
from streamlit_pills import pills

from colour_utility import random_colour, gradient, RED, GREEN, Colour
from json_utility import jsonify
from pyodbc_connection import connect

st.set_page_config(
	layout="wide",
	page_title="Weekly WO Meeting"
)


@st.cache_data(ttl=None, show_spinner=True)
def parse_quotes_list(pdf_file, column_name="Quote #") -> list[str]:
	quotes = []

	with pdfplumber.open(pdf_file) as pdf_obj:

		# max_pages = len(pdf_obj.pages) + 1

		for page in pdf_obj.pages[:2]:
			tables = page.extract_tables()
			for table in tables:
				# Check if the column name exists in the table header
				if column_name in table[0]:  # table[0] is assumed to be the header row
					# Get the index of the desired column
					col_index = table[0].index(column_name)

					# Extract data from the column
					quotes += [row[col_index] for row in table[1:] if len(row) > col_index]

		return quotes


@st.cache_data(ttl=None, show_spinner=True)
def load_meetings():
	return connect("WSOM_Meetings")


@st.cache_data(ttl=None, show_spinner=True)
def load_meeting_notes():
	return connect("WSOM_MeetingNotes")


@st.cache_data(ttl=None, show_spinner=True)
def load_products():
	return connect("Products")


@st.cache_data(ttl=None, show_spinner=True)
def load_orders():
	return connect("Orders")


@st.cache_data(ttl=None, show_spinner=True)
def check_similar_quotes():
	sql = """
SET NOCOUNT ON;
DECLARE @sd DATETIME = '{SD}';
DECLARE @ed DATETIME = '{ED}';

DECLARE @t TABLE (
        [ID] INT IDENTITY(0, 1),
        [Q] INT
);
DECLARE @r TABLE (
        [ID] INT IDENTITY(0, 1),
        [Q] INT,
        [SimQ] INT
);
INSERT INTO @t ([Q])
SELECT
        [Orders].[Quote#]
FROM (
        [BWSdb].[dbo].[Sales Staff] WITH (NOLOCK)
INNER JOIN
        [BWSdb].[dbo].[Orders] WITH (NOLOCK)
ON
        [Sales Staff].[ID-SaleStaff] = [Orders].[Sale PersonID]
)
INNER JOIN
        [BWSdb].[dbo].[Production] WITH (NOLOCK)
ON
        [Orders].[Quote#]=[Production].[Quote#]
WHERE (
        (
                ([Production].[Prod Date]) Between @sd And @ed
        )
        And (
                ([Orders].[WO Reviewed])=0 Or ([Orders].[WO Reviewed]) Is Null
        )
)
/*
ORDER BY
        [Orders].[Model No]
        ,[Production].[Prod Date]
        ,[Orders].[Quote#]
*/
;

DECLARE @i INT;
DECLARE @c INT;
declare @modelno NVARCHAR(255);
declare @quote INT;

SELECT
        @i = 0,
        @c = COUNT(*)
FROM
        @t
;

WHILE @i < @c BEGIN

        SELECT
                @quote = [Q]
        FROM
                @t
        WHERE
                [ID] = @i
        ;

    -- Insert statements for procedure here
        --Grab Model No for future referencing
        SELECT 
			@modelno = (select [Model No]
		from
			[BWSdb].[dbo].Orders with (nolock) 
		where
			Quote# = @quote);

        --Drop and create temp table in tmpdb SQL database for faster processing
        IF OBJECT_ID('tempdb..#QuoteOptions') IS NOT NULL BEGIN
			DROP TABLE #QuoteOptions
		END

        create table #QuoteOptions
        (
                #Options int,
                [Option No] nvarchar(255),
        [Price] money,
        [Qty] int,
        [Sections] nvarchar(255),
        [Description] nvarchar(max)
        );

        --Grab Quotes with same Model No and Options as @quote parameter
        insert into #QuoteOptions ([Option No], Price, Qty, Sections, Description)
        select [Option No], Price, Qty, Sections, Description
        from [BWSdb].[dbo].[Order Options] with (nolock)
        where Quote# = @quote
		;

        update #QuoteOptions
        set #Options = NoOptions
        from (select count(*) as NoOptions
                  from [BWSdb].[dbo].[Order Options] with (nolock)
                  where Quote# = @quote) as subCountOptions
		;

        --Drop and create temp table in tmpdb SQL database for faster processing
        IF OBJECT_ID('tempdb..#QuoteswithsameOptions') IS NOT NULL BEGIN
			DROP TABLE #QuoteswithsameOptions
		END

        create table #QuoteswithsameOptions
        (
                [Quote#] int,
                [WO#] int,
                [Quote Date] datetime,
                [Prod Date] datetime
        );

        insert into #QuoteswithsameOptions
        select Orders.Quote#, Orders.WO#, Orders.[Quote Date], [Prod Date]
        from [BWSdb].[dbo].[Order Options] as main with (nolock)
        inner join [BWSdb].[dbo].Orders with (nolock) on main.Quote# = Orders.Quote#
        left outer join [BWSdb].[dbo].Production with (nolock) on Orders.Quote# = Production.Quote#
        inner join #QuoteOptions as QuoteOptions on main.[Option No] = QuoteOptions.[Option No]
                                                                                                and (case when main.Sections is null then '' else main.Sections end) = (case when QuoteOptions.Sections is null then '' else QuoteOptions.Sections end)       
                                                                                                and main.Description = QuoteOptions.Description
                                                                                                AND main.[Qty] = [QuoteOptions].[Qty]
        where main.Quote# in (select Quote#
                                                  from [BWSdb].[dbo].[Order Options] with (nolock)
                                                  group by Quote#
                                                  having count(*) in (select #Options from #QuoteOptions))
        and Orders.[Model No] = @modelno
        and [Date Declined] is null
        group by Orders.Quote#, Orders.WO#, Orders.[Quote Date], [Prod Date]
        having count(*) = (select distinct #Options from #QuoteOptions)
		;

        --Drop and create temp table in tmpdb SQL database for faster processing
        IF OBJECT_ID('tempdb..#QuoteNPOs') IS NOT NULL BEGIN
			DROP TABLE #QuoteNPOs
		END

        create table #QuoteNPOs
        (
                #NPOs int,
        [Description] nvarchar(max)
        );

        --Grab Quotes with same NPOs
        insert into #QuoteNPOs (Description)
        select Description
        from [BWSdb].[dbo].[Custom Work] with (nolock)
        where Quote# = @quote
		;

        update #QuoteNPOs
        set #NPOs = NoNPOs
        from (select count(*) as NoNPOs
                  from [BWSdb].[dbo].[Custom Work] with (nolock)
                  where Quote# = @quote) as subCountNPOs
		;

        --Drop and create temp table in tmpdb SQL database for faster processing
        IF OBJECT_ID('tempdb..#QuoteswithsameNPOs') IS NOT NULL BEGIN
			DROP TABLE #QuoteswithsameNPOs
		END

        create table #QuoteswithsameNPOs
        (
                [Quote#] int,
                [WO#] int,
                [Quote Date] datetime,
                [Prod Date] datetime
        );

        insert into #QuoteswithsameNPOs
        select Orders.Quote#, Orders.WO#, Orders.[Quote Date], [Prod Date]
        from [BWSdb].[dbo].[Custom Work] as main with (nolock)
        inner join [BWSdb].[dbo].Orders with (nolock) on main.Quote# = Orders.Quote#
        left outer join [BWSdb].[dbo].Production with (nolock) on Orders.Quote# = Production.Quote#
        inner join #QuoteNPOs as QuoteNPOs on main.Description = QuoteNPOs.Description
        where main.Quote# in (select Quote#
                                                  from [BWSdb].[dbo].[Custom Work] with (nolock)
                                                  group by Quote#
                                                  having count(*) in (select #NPOs from #QuoteNPOs))
        and Orders.[Model No] = @modelno
        and [Date Declined] is null
        group by Orders.Quote#, Orders.WO#, Orders.[Quote Date], [Prod Date]
        having count(*) = (select distinct #NPOs from #QuoteNPOs)
		;

        --Final select statement
        INSERT INTO @r ([Q], [SimQ])
        select @quote, Options.Quote#
        from #QuoteswithsameOptions as Options
        inner join #QuoteswithsameNPOs as NPOs on Options.Quote# = NPOs.Quote#
        LEFT JOIN @t ON [Options].[Quote#] = [@t].[Q]
        where Options.Quote# <> @quote
		;


        SELECT @i = @i + 1;

END
/*
SELECT
        *
FROM
        @t
*/

SELECT
        *
FROM
        @r
;
	""".format(SD=f"{datetime.datetime.now():%Y-%m-%d}", ED=f"{(datetime.datetime.now() + datetime.timedelta(days=185)):%Y-%m-%d}")
	# print(sql)
	return connect(sql, returns_records=True)


@st.cache_data(ttl=None, show_spinner=True)
def load_pdf_binary(pdf_file):
	with open(pdf_file, "rb") as f:
		return f.read()


@st.cache_data(ttl=None, show_spinner=True)
def load_pdf_annotations(pdf_file):
	highlighted_texts = []
	# print(f"{pdf_file=}")
	# highlighted_texts = {
	# 	"annots": [],
	# 	"texts": []
	# }
	max_width = 0
	# unique = set()
	with pdfplumber.open(pdf_file) as f:
		for page_num, page in enumerate(f.pages, start=1):
			# st.write("page.annots")
			# st.write(page.annots)
			# st.write("page.lines")
			# st.write(page.lines)
			# st.write("page.extract_text_lines()")
			# st.write(page.extract_text_lines()[:8])
			for i, rect in enumerate(page.rects):
				# X and Y points are calculated from the bottom left of the page????
				x_r = rect.get("x0")
				# y_r = rect.get("y0")
				# x_r = rect.get("x1")
				y_r = rect.get("y1")
				# x_r = rect.get("top")
				# y_r = rect.get("bottom")
				w_r = rect.get("width")
				h_r = rect.get("height")
				# w_r = rect.get("x1") - rect.get("x0")
				# h_r = rect.get("y1") - rect.get("y0")
				x_r_c, y_r_c = page.point2coord((x_r, y_r))
				# x_r_c, y_r_c = x_r, y_r
				# h_r /= 3

				# bbox = (x_r, y_r, x_r + w_r, y_r + h_r)
				# unique.add(jsonify(rect))
				if w_r >= max_width:
					if rect["non_stroking_color"] != (1,):
						max_width = w_r
						# bbox = (rect.get("x0"), rect.get("y0"), rect.get("x1"), rect.get("y1"))
						bbox = (
							x_r_c,
							y_r_c,
							*page.point2coord((
								rect.get("x1"),
								rect.get("y0")
							))
						)
						# texts = page.within_bbox(bbox).extract_text_lines()
						texts = page.within_bbox(bbox).extract_text()
						highlighted_texts.append({
							"page": page_num,
							"x": x_r_c,
							"y": y_r_c,
							"height": h_r,
							"width": w_r,
							"color": "#AA1111",
							"text": texts
						})
						# print(f"\n{page_num=}, {i=}, {rect=}")
						# print(f"WW => {page.within_bbox(bbox).extract_text()}")
			# for i, char in enumerate(page.chars):
			# 	# if i < 750:
			# 	if (page_num == 1) and (250 <= i <= 300):
			# 		print(f"{page_num=}, {i=}, C='{char['text']}', NCS='{char['ncs']}', {char=}")
			# 		# print(f"{page_num=}, {i=}, C='{char['text']}', NCS='{char['ncs']}'")
			# 	# if "non_stroking_color" in char and char["non_stroking_color"]:
			# 	# 	color = char["non_stroking_color"]
			# 	# 	print(f"{color=}")
			# 	# 	# Check for highlight-like colors (e.g., yellow shades)
			# 	# 	if isinstance(color, (list, tuple)) and 0.8 <= color[1] <= 1 and color[0] < 0.5 and color[2] < 0.5:
			# 	# 		highlighted_texts.append({
			# 	# 			"page": page_num + 1,
			# 	# 			"text": char["text"],
			# 	# 			"bbox": char["bbox"],
			# 	# 			"color": color
			# 	# 		})
		highlighted_texts = [annot for annot in highlighted_texts if (annot["width"] == max_width)]
		# highlighted_texts.sort(key=lambda annot: (annot["page"], annot["y"]))
		# # grads = [gradient(i, len(highlighted_texts) - 1, GREEN, RED, rgb=False) for i in range(len(highlighted_texts))]
		# print(f"\n\nPARSED OPTIONS:")
		# for i, data in enumerate(highlighted_texts):
		# 	print(f"\n{i=}, {data=}")
		# 	bbox = (data["x"], data["y"], data["x"] + data["width"], data["y"] + data["height"])
		# 	print(f"WW => {page.within_bbox(bbox).extract_text()}")
		# # 	highlighted_texts[i]["color"] = grads[i]
		# # 	highlighted_texts[i]["color_n"] = str(Colour(grads[i]))
		#
		# # print("unique")
		# # print(unique)
		# # st.write(list(map(lambda v: json.loads(v), unique)))

		return highlighted_texts

	# highlighted_regions = []
	# print(f"{pdf_file=}")
	# with pdfplumber.open(pdf_file) as f:
	# 	for page_num, page in enumerate(f.pages):
	# 		# print(f"{dir(page)=}")
	# 		print(f"{page_num}, {dir(page.annots)=}")
	# 		print(f"{page_num}, {page.annots=}")
	# 		if page.annots:
	# 			for annot in page.annots:
	# 				if annot["subtype"] == "Highlight":
	# 					# Extract the bounding box (bbox) of the highlighted text
	# 					bbox = annot["rect"]
	# 					highlighted_regions.append({"page": page_num + 1, "bbox": bbox})
	#
	# 	return highlighted_regions


@st.dialog(title="WO Meeting Review Details")
def ask_details(key, selected_quote, annotation):
	st.subheader(f"Describe the issue with quote {selected_quote}")
	st.subheader(f"{annotation['text']}")
	issues = st.session_state.setdefault(key, [])
	st.text_area(
		label="Known Issues:",
		value="\n".join(issues),
		disabled=True
	)
	if st.button(
		label="save"
	):
		issues.append(f"{datetime.datetime.now():%Y-%m-%d %H:%M:%S}")
		st.session_state.update({
			key: issues
		})
		# st.session_state
		if "clicked_annotation" in pdf_viewer:
			print("POP")
			pdf_viewer_data = st.session_state.get(k_pdf_viewer, {})
			print(f"{pdf_viewer_data=}")
			pdf_viewer_data.pop(k_c_a)
			st.session_state.update({
				k_pdf_viewer: pdf_viewer_data
			})
		else:
			print("NO POP")
		st.rerun()


@st.dialog(title="Create New Meeting", width="large")
def create_new_meeting():
	k_date_input_meeting = "k_date_input_meeting"
	st.session_state.setdefault(k_date_input_meeting, datetime.datetime.now().date())

	usual_suspects = [
		{"name": "Avery Briggs", "email": "avery.briggs@bwstrailers.com"},
		{"name": "Jamie Merrithew", "email": "jamie.merrithew@bwstrailers.com"},
		{"name": "Lori Piper", "email": "lori.piper@bwstrailers.com"},
		{"name": "Jason Somerville", "email": "jason.somerville@bwstrailers.com"},
		{"name": "Lance Lunn", "email": "lance.lunn@bwstrailers.com"},
		{"name": "Gary Thomas", "email": "gary.thomas@bwstrailers.com"},
		{"name": "Sarah Lord", "email": "sarah.lord@bwstrailers.com"},
		{"name": "Saied Parsaeian", "email": "saied.parsaeian@stargatetrailers.ca"},
		{"name": "Jason Morgan", "email": "jason.morgan@bwstrailers.com"}
	]

	cont = st.container(border=1, height=500)
	cols = cont.columns(2, border=1)
	k_multiselect_attendance = "k_multiselect_attendance"
	multiselect_attendance = cols[1].multiselect(
		label="Attendance",
		key=k_multiselect_attendance,
		options=[s["name"] for s in usual_suspects]
	)
	date_input_meeting = cols[0].date_input(
		label="Meeting Date",
		key=k_date_input_meeting,
		format="YYYY-MM-DD",
		min_value=df_meetings["DateMeeting"].max() + datetime.timedelta(days=4),
		max_value=datetime.datetime.now() + datetime.timedelta(days=7)
	)
	k_time_input_meeting = "k_time_input_meeting"
	st.session_state.setdefault(k_time_input_meeting, datetime.datetime.now())
	time_input_meeting = cols[0].time_input(
		label="Meeting Time",
		key=k_time_input_meeting,
		label_visibility="hidden"
	)
	if date_input_meeting:
		if len(multiselect_attendance) > 1:
			mt = datetime.datetime(
				date_input_meeting.year,
				date_input_meeting.month,
				date_input_meeting.day,
				time_input_meeting.hour,
				time_input_meeting.minute,
				time_input_meeting.second
			)
			attendance = ";".join(multiselect_attendance)
			if st.button(
				label="save",
				key="k_btn_save_new_meeting"
			):
				sql = (f"""
INSERT INTO 
	[BWSdb].[dbo].[WSOM_Meetings]
(
	[DateMeeting],
	[Attendance] 
)
VALUES
('{mt:%Y-%m-%d %H:%M:%S}', '{attendance}')
;
				""").strip()
				# st.code(sql, language="sql", line_numbers=True)
				print(sql)
				load_meetings.clear()
				df_meetings_new = load_meetings()
				st.session_state.update({"meeting_id": df_meetings_new["ID"].max()})
				st.rerun()


s_h = streamlit_js_eval(js_expressions='parent.innerHeight', key='SCR_H')
s_w = streamlit_js_eval(js_expressions='parent.innerWidth', key='SCR_W')

if s_h is None or not s_h:
	s_h = 900
if s_w is None or not s_w:
	s_w = 1600

root_path = r"\\bwsfp01\public\SALES OFFICE\Weekly WO Meetings"
list_meetings = [d for d in os.listdir(root_path) if d != "Scripts"]

df_meetings = load_meetings()
df_meeting_notes = load_meeting_notes()

st.write("df_meetings")
st.dataframe(df_meetings)
st.write("df_meeting_notes")
st.dataframe(df_meeting_notes)

st.session_state.setdefault("selected_directory", list_meetings[-1])
selected_directory = st.selectbox(
	label="SELECT",
	options=list_meetings,
	key="selected_directory"
)

if "meeting_id" not in st.session_state:
	if st.button(
		label="New Meeting",
		key='k_btn_new_meeting'
	):

		create_new_meeting()

		db_name = "SysproCompanyA.accdb"
		macro_name = "WSOM_MacroAutoRunWOReports"
		cmd = f"msaccess.exe \"{db_name}\" /x \"{macro_name}\""
		st.code(cmd, language="bash", line_numbers=True)
else:
	m_id = st.session_state.get("meeting_id")
	st.header(f"Editing Meeting ID#{m_id}")


if selected_directory:
	itinerary_file_name_prefix = "wo_meeting_"
	itinerary_file_name_suffix = ".pdf"
	wo_rpt_file_name_template = "WO_Rpt_q{QUOTE}.pdf"
	dir_files = os.listdir(os.path.join(root_path, selected_directory))
	itinerary_file = [
		f for f in dir_files
		if f.lower().startswith(itinerary_file_name_prefix) and f.lower().endswith(itinerary_file_name_suffix)
	]
	if not itinerary_file:
		st.error(f"Cannot find Itinerary file within this directory.")
		st.stop()
	else:
		itinerary_file = os.path.join(root_path, selected_directory, itinerary_file[0])

	list_quotes = parse_quotes_list(itinerary_file)
	rpt_files = {}
	for i, qn in enumerate(list_quotes):
		path_wo_rpt = os.path.join(root_path, selected_directory, wo_rpt_file_name_template.format(QUOTE=qn))
		if not os.path.exists(path_wo_rpt):
			path_wo_rpt = None
		rpt_files[qn] = path_wo_rpt

	st.write(rpt_files)
	similar_quotes = check_similar_quotes()
	# st.dataframe(similar_quotes)
	df_products = load_products()
	df_orders = load_orders()
	if "df_meeting_quotes" not in st.session_state:
		df_meeting_quotes = pd.DataFrame(data={"Quote": map(int, list_quotes)})
		df_meeting_quotes = df_meeting_quotes.merge(
			df_orders[[
				"Quote#",
				"ProductID",
				"DealerID"
			]],
			how="inner",
			left_on="Quote",
			right_on="Quote#"
		)

		df_meeting_quotes = df_meeting_quotes.merge(
			df_products[[
				"IDTrailer",
				"Class",
				"Model No"
			]],
			how="inner",
			left_on="ProductID",
			right_on="IDTrailer"
		)

		df_meeting_quotes["Q_WORpt"] = df_meeting_quotes["Quote"].apply(lambda q: rpt_files.get(str(q)))
		df_meeting_quotes[["Reviewed", "Approved"]] = False, False
	else:
		df_meeting_quotes = st.session_state.get("df_meeting_quotes")

	st.session_state.setdefault("df_meeting_quotes", df_meeting_quotes)

	similar_quotes_m1 = similar_quotes.merge(
		df_orders[[
			"Quote#",
			"ProductID",
			"DealerID"
		]],
		how="inner",
		left_on="Q",
		right_on="Quote#"
	)

	similar_quotes_tree = {

	}

	similar_quotes_m1 = similar_quotes_m1.merge(
		df_products[[
			"IDTrailer",
			"Class",
			"Model No"
		]],
		how="inner",
		left_on="ProductID",
		right_on="IDTrailer"
	)

	similar_quotes_m1["Q_WORpt"] = similar_quotes_m1["Q"].apply(lambda q: rpt_files.get(str(q)))
	similar_quotes_m1["SimQ_WORpt"] = similar_quotes_m1["SimQ"].apply(lambda q: rpt_files.get(str(q)))

	st.write(df_meeting_notes)
	st.write(df_meeting_quotes)
	st.write(similar_quotes_m1)

	list_models = similar_quotes_m1["Model No"].dropna().unique().tolist()

	st.header(f"{len(list_quotes)} quote(s) to review across {len(list_models)} model(s):")

	selected_model = pills(
		label="Models",
		options=list_models,
		key="pills_selected_model"
	)
	if selected_model:

		st.write(selected_model)
		df_model_quotes = df_meeting_quotes.loc[df_meeting_quotes["Model No"] == selected_model]
		st.write(f"{df_model_quotes.shape[0]} quote(s) to Review:")
		stdf_model_quotes = st.dataframe(
			df_model_quotes,
			selection_mode="single-row",
			key="stdf_model_quotes",
			hide_index=True,
			on_select="rerun"
		)

		if stdf_model_quotes["selection"]["rows"]:
			df_selected_quote = df_model_quotes.iloc[stdf_model_quotes["selection"]["rows"][0]]
			selected_quote = df_selected_quote["Quote"]
			pdf_file = df_selected_quote["Q_WORpt"]
			st.write(df_selected_quote)
			st.write(pdf_file)

			if pdf_file:
				annotations = [
					{
						"page": 1,
						"x": 220,
						"y": 155,
						"height": 22,
						"width": 65,
						"color": "red"
					},
					{
						"page": 1,
						"x": 220,
						"y": 155,
						"height": 22,
						"width": 65,
						"color": "red"
					}
				]
				def my_custom_annotation_handler(annotation):
					# print(f"Annotation {annotation} clicked.")
					idx = annotation.get("index")
					page = annotation.get("page")
					x = annotation.get("x")
					y = annotation.get("y")
					w = annotation.get("width")
					h = annotation.get("height")
					c = annotation.get("color")
					bbox = (x, y, x + w, y + h)
					et = annotation.get("text")
					# line_texts = ';; '.join([line['text'] for line in et])
					# print(f"{line_texts=}")
					text = annotation.get("text")
					print(f"ANNOTATION (P={page}, I={idx}) ({x=}, {y=}) => {text=}")
					key = f"issues_{selected_quote}_{idx}"
					st.session_state.update({
						f"need_details_{key}": True
					})
					# list_issues = st.session_state.setdefault(key, [])
					ask_details(key, selected_quote, annotation)

				parsed_annotations = load_pdf_annotations(pdf_file)
				# # st.write(parsed_annotations)
				# st.write(f"{len(parsed_annotations)=}")
				# st.write(f"{(len(parsed_annotations) == 15)=}")
				# # st.write(f"Parsed Annotation Texts:")
				# # st.write(jsonify({(a["page"], a["y"]): [l["text"] for l in a["text"]] for a in parsed_annotations}))
				#
				# st.write("SESSION_STATE:")
				# st.write(st.session_state)

				k_c_a = "clicked_annotation"
				k_pdf_viewer = f"pdf_viewer_wo"
				pdf_click_callback = my_custom_annotation_handler
				if (k_pdf_viewer in st.session_state) and (k_c_a in st.session_state[k_pdf_viewer]):
					print("==A")
					annotation = st.session_state[k_pdf_viewer][k_c_a]
					idx = annotation.get("index")
					key = f"issues_{selected_quote}_{idx}"
					if not st.session_state.get(key, True):
						print("==B")
						# st.session_state.update({
						# 	f"need_details_{key}": False
						# })
						pdf_click_callback = None
					else:
						print("==C")
				else:
					print("==D")
				pdf_viewer = pdf_viewer(
					input=load_pdf_binary(pdf_file),
					width=s_w,
					# annotations=annotations,
					key=k_pdf_viewer,
					annotations=parsed_annotations,
					on_annotation_click=pdf_click_callback,
					annotation_outline_size=2,
					pages_vertical_spacing=10
				)

				if k_c_a in pdf_viewer:
					print("_A")
					if pdf_viewer[k_c_a]:
						print("_B")
						annotation = pdf_viewer[k_c_a]
						idx = annotation.get("index")
						key = f"issues_{selected_quote}_{idx}"
						if not st.session_state.get(key, True):
							print("_C")
							pdf_viewer.pop(k_c_a)
							st.session_state.update({
								f"need_details_{key}": False
							})
						else:
							print("_D")
					else:
						print("_E")
				else:
					print("_F")

				st.write(pdf_viewer)

				if st.button(
					label="Approve",
					key=f"btn_approve_quote"
				):
					df_meeting_quotes.loc[df_meeting_quotes["Quote"] == selected_quote, ["Approved", "Reviewed"]] = True, True
					st.session_state.update({
						"df_meeting_quotes": df_meeting_quotes,
						f"approve_{selected_quote}_date": datetime.datetime.now(),
						f"approve_{selected_quote}_by": "Avery Briggs"
					})
					st.rerun()
				if st.button(
					label="Issue",
					key="btn_issue_quote"
				):
					df_meeting_quotes.loc[df_meeting_quotes["Quote"] == selected_quote, ["Approved", "Reviewed"]] = False, True
					st.session_state.update({
						"df_meeting_quotes": df_meeting_quotes,
						f"approve_{selected_quote}_date": datetime.datetime.now(),
						f"approve_{selected_quote}_by": "Avery Briggs"
					})
					st.rerun()




		# df_model_quotes = similar_quotes_m1.loc[similar_quotes_m1["Model No"] == selected_model]
		# model_quote_options = [q for q in df_model_quotes["Q"].dropna().unique().tolist() if q in rpt_files]
		# if model_quote_options:
		# 	selected_quote = pills(
		# 		label="Quotes",
		# 		options=model_quote_options
		# 	)
		# 	if selected_quote:
		# 		df_quote = df_model_quotes.loc[df_model_quotes["SimQ"] == selected_quote]
		# 		st.write(df_quote)


	# similar_quotes_m2 = similar_quotes_m1.copy()
	# # similar_quotes_m2[["ModelCount", "ClassCount"]] = 0, 0
	# # st.write("A")
	# # st.write(similar_quotes_m2.groupby(by="Q").value_counts())
	# # st.write("B")
	# # df_model_group = similar_quotes_m2.groupby(
	# # 	by="Model No"
	# # ).agg({"ModelCount": "count"})
	# # df_class_group = similar_quotes_m2.groupby(
	# # 	by=["Q", "Class"]
	# # ).agg({"ClassCount": "count"})
	# #
	# # st.write(df_model_group)
	# # st.write(df_class_group)
	# #
	# # df_model_group = similar_quotes_m1.groupby(
	# # 	by="Model No"
	# # )[["Model No", "Q"]].head().drop_duplicates(["Model No", "Q"])
	#
	# df_model_group = similar_quotes_m1.groupby(
	# 	by="Q"
	# ).head()
	# st.write("==")
	# st.write(df_model_group)

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
# s_h = streamlit_js_eval(js_expressions='parent.innerHeight', key='SCR_H')
# s_w = streamlit_js_eval(js_expressions='parent.innerWidth', key='SCR_W')
#
# if s_h is None or not s_h:
# 	s_h = 900
# if s_w is None or not s_w:
# 	s_w = 1600
#
#
# # pages_per_render = 5
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
# # ----------------------------------------------------------------------
# # ----------------------------------------------------------------------
# # ----------------------------------------------------------------------
#
# # # Version 2025-01-27 1900
# #
# # import os
# # import datetime
# # from copy import deepcopy
# #
# # import pdfplumber
# # from PyPDF2 import PdfMerger
# #
# # import streamlit as st
# #
# # from streamlit_pdf_viewer import pdf_viewer
# # from streamlit_js_eval import streamlit_js_eval
# # from streamlit_tree_select import tree_select
# # from streamlit_float import float_init
# # from streamlit_scroll_navigation import scroll_navbar
# #
# # from utility import next_available_file_name
# #
# # st.set_page_config(
# # 	layout="wide",
# # 	page_title="Weekly WO Meeting"
# # )
# #
# #
# # list_meetings = [d for d in os.listdir(r"\\bwsfp01\public\SALES OFFICE\Weekly WO Meetings") if d != "Scripts"]
# # st.multiselect(
# # 	label="SELECT",
# # 	options=list_meetings,
# # 	key="selected_directory"
# # )
# # # import wx
# # #
# # # if st.button("Browse"):
# # # 	dialog = wx.DirDialog(None, "Select a folder:", style=wx.DD_DEFAULT_STYLE | wx.DD_NEW_DIR_BUTTON)
# # # 	if dialog.ShowModal() == wx.ID_OK:
# # # 		folder_path = dialog.GetPath()  # folder_path will contain the path of the folder you have selected as string
# # # 		st.write(f"{folder_path=}")
# # # 	st.write(f"B")
# # # st.write(f"A")
# #
# #
# # # # Create a dummy streamlit page
# # # import streamlit as st
# # # from streamlit_scroll_navigation import scroll_navbar
# # #
# # # # Anchor IDs and icons
# # # anchor_ids = ["About", "Features", "Settings", "Pricing", "Contact"]
# # # anchor_icons = ["info-circle", "lightbulb", "gear", "tag", "envelope"]
# # #
# # # # 1. as sidebar menu
# # # with st.sidebar:
# # #     st.subheader("Example 1")
# # #     scroll_navbar(
# # #         anchor_ids,
# # #         anchor_labels=None, # Use anchor_ids as labels
# # #         anchor_icons=anchor_icons)
# # #
# # # # 2. horizontal menu
# # # st.subheader("Example 2")
# # # scroll_navbar(
# # #         anchor_ids,
# # #         key = "navbar2",
# # #         anchor_icons=anchor_icons,
# # #         orientation="horizontal")
# # #
# # # # Dummy page setup
# # # for anchor_id in anchor_ids:
# # #     st.subheader(anchor_id,anchor=anchor_id)
# # #     st.write("content " * 100)
# #
# #
# # float_init()
# #
# #
# # @st.cache_data(ttl=None, show_spinner=True)
# # def parse_quotes_list(pdf_obj, column_name="Quote #") -> tuple[int, list[str]]:
# # 	quotes = []
# #
# # 	with pdfplumber.open(pdf_file) as pdf_obj:
# #
# # 		max_pages = len(pdf_obj.pages) + 1
# #
# # 		for page in pdf_obj.pages[:2]:
# # 			tables = page.extract_tables()
# # 			for table in tables:
# # 				# Check if the column name exists in the table header
# # 				if column_name in table[0]:  # table[0] is assumed to be the header row
# # 					# Get the index of the desired column
# # 					col_index = table[0].index(column_name)
# #
# # 					# Extract data from the column
# # 					quotes += [row[col_index] for row in table[1:] if len(row) > col_index]
# #
# # 		return max_pages, quotes
# #
# #
# # def refresh():
# # 	print(f"REFRESH")
# # 	sel = st.session_state.get("tree_select_selected_nodes", [])
# # 	print(f"AA 'problem_option_wording_leaf_31080' in sel => '{'problem_option_wording_leaf_31080' in sel}'")
# # 	st.rerun()
# #
# #
# # @st.dialog(title="Issue Details", width="large")
# # def ask_details(key: str):
# # 	*key, quote = key.rsplit("_", 1)
# # 	key = "".join(key).removeprefix("_").removesuffix("_")
# # 	st.header(f"Please describe your '{key}' issue with quote '{quote}':")
# # 	st.write(f"issue_details_{key}")
# # 	t_key: str = f"issue_details_{key}"
# # 	# IMPORTANT!
# # 	# widget keys in dialog functions are popped from session_state before they can share their values.
# # 	inp = st.text_area(
# # 		label="Details",
# # 		key=f"text_area_{t_key}",
# # 		placeholder=f"Contact sales for further details",
# # 		label_visibility="hidden"
# # 		# ,
# # 		# on_change=lambda: st.session_state.update({t_key: ""})
# # 	)
# # 	cols = st.columns(2)
# # 	with cols[0]:
# # 		if st.button(
# # 			label="cancel",
# # 			key=f"cancel_details_input"
# # 		):
# # 			st.rerun()
# # 	with cols[1]:
# # 		if st.button(
# # 			label="submit",
# # 			key=f"submit_details_input"
# # 		):
# # 			st.session_state.update({t_key: inp})
# # 			print(t_key)
# # 			print(f"SS=> '{st.session_state.get(t_key, 'N/A').strip()}'")
# # 			st.rerun()
# #
# #
# # def merge_pdfs_from_folder(
# # 		folder_path: str,
# # 		quote_order: list[str],
# # 		output_file: str = "merged_output.pdf"
# # ) -> str:
# # 	"""
# # 	Merges all PDF files in a specified folder into a single PDF file.
# #
# # 	Args:
# # 		folder_path (str): The path to the folder containing PDF files.
# # 		quote_order (list[str)): The order of quotes to reference when ordering the PDFs. Read from itinerary_file.
# # 		output_file (str): The name of the output merged PDF file (default: "merged_output.pdf").
# #
# # 	Returns:
# # 		str: The path to the merged output file.
# # 	"""
# #
# # 	print(f"Starting...")
# # 	start_time = datetime.datetime.now()
# #
# # 	# Check if the folder exists
# # 	if not os.path.exists(folder_path):
# # 		raise FileNotFoundError(f"The folder '{folder_path}' does not exist.")
# #
# # 	if not os.path.exists(os.path.join(folder_path, itinerary_file)):
# # 		raise FileNotFoundError(f"The Itinerary file '{itinerary_file}' does not exist.")
# #
# # 	files = []
# #
# # 	print(f"Searching...")
# #
# # 	# Iterate through files in the folder
# # 	for filename in sorted(os.listdir(folder_path)):
# # 		# Check if the file is a PDF
# # 		if filename.lower().endswith(".pdf"):
# # 			if filename != itinerary_file:
# # 				file_path = os.path.join(folder_path, filename)
# # 				# print(f"Adding: {file_path}")
# # 				files.append(file_path)
# #
# # 	print(f"Combining...")
# #
# # 	# Create a PdfMerger object
# # 	merger = PdfMerger()
# # 	merger.append(os.path.join(folder_path, itinerary_file))
# #
# # 	for i, quote_number in enumerate(quote_order):
# # 		if not isinstance(quote_number, str):
# # 			quote_number = str(quote_number)
# # 		for j, file_name in enumerate(files):
# # 			if f"q{quote_number}.pdf".lower() in file_name.lower():
# # 				merger.append(file_name)
# #
# # 	print(f"Saving...")
# #
# # 	# Save the merged PDF to the specified output file
# # 	output_path = os.path.join(folder_path, output_file)
# # 	merger.write(output_path)
# # 	merger.close()
# #
# # 	end_time = datetime.datetime.now()
# # 	print(f"Finished...")
# # 	print(f"Merged PDF saved as: {output_path}")
# # 	print(f"Results in {(end_time - start_time).total_seconds()} second(s)")
# # 	return output_path
# #
# #
# # def extract_quote_column(pdf_file_path, column_name="Quote #"):
# # 	"""
# # 	Extract data from a specific column in a table within a PDF.
# #
# # 	Args:
# # 		pdf_file_path (str): Path to the PDF file.
# # 		column_name (str): Name of the column to extract (default: "Quote").
# #
# # 	Returns:
# # 		list: A list of values from the specified column.
# # 	"""
# # 	quotes = []
# #
# # 	# Open the PDF file using pdfplumber
# # 	with pdfplumber.open(pdf_file_path) as pdf:
# # 		for page in pdf.pages:
# # 			# Extract tables from the page
# # 			tables = page.extract_tables()
# # 			for table in tables:
# # 				# Check if the column name exists in the table header
# # 				if column_name in table[0]:  # table[0] is assumed to be the header row
# # 					# Get the index of the desired column
# # 					col_index = table[0].index(column_name)
# #
# # 					# Extract data from the column
# # 					quotes += [row[col_index] for row in table[1:] if len(row) > col_index]
# # 	return quotes
# #
# #
# # s_h = streamlit_js_eval(js_expressions='parent.innerHeight', key='SCR_H')
# # s_w = streamlit_js_eval(js_expressions='parent.innerWidth', key='SCR_W')
# #
# # if s_h is None or not s_h:
# # 	s_h = 900
# # if s_w is None or not s_w:
# # 	s_w = 1600
# #
# #
# # pages_per_render = 5
# # checklist_float_pos = 50, 60
# #
# #
# # # column_pdf, column = st.columns([50, 50])
# # cols_main = st.columns([0.75, 0.25])
# # container_pdf = cols_main[0].container(border=1)
# # container_pdf_ctls = st.container(border=1, height=25)
# # # container_pdf_ctls.float()
# # container_pdf_ctls.float("bottom: 0;background-color: grey;")
# #
# # cols_main[1].float(f"right: {checklist_float_pos[0]}px; top: {checklist_float_pos[1]}px;")
# #
# # st.write(f"Screen width is '{s_w}'")
# # st.write(f"Screen height is '{s_h}'")
# # pdf_render_pages = st.session_state.setdefault("pdf_render_pages", list(range(1, pages_per_render + 1)))
# # iss_log = {}
# # valid_log = []
# #
# # with container_pdf:
# # 	pdf_file = st.file_uploader(
# # 		"Upload PDF file",
# # 		type=('pdf',),
# # 		key="file_uploader_pdf_file",
# # 		accept_multiple_files=False
# # 	)
# #
# # 	# prep_date = datetime.datetime(2025, 1, 14)
# # 	prep_date = datetime.datetime.today()
# #
# # 	output_file = r"merged_output.pdf"
# # 	folder_path = fr"\\bwsfp01\Public\SALES OFFICE\Weekly WO Meetings\{prep_date:%Y-%m-%d}"
# #
# # 	output_file = next_available_file_name(os.path.join(folder_path, output_file))
# # 	output_file = os.path.basename(output_file)
# #
# # 	itinerary_file = fr"WO_Meeting_{prep_date:%Y-%m-%d}.pdf"
# # 	if os.path.exists(os.path.join(folder_path, itinerary_file)):
# # 		quote_order = extract_quote_column(
# # 			os.path.join(folder_path, itinerary_file)
# # 		)
# # 		# print(f"{quote_order=}")
# #
# # 		merge_pdfs_from_folder(
# # 			folder_path,
# # 			quote_order,
# # 			os.path.join(folder_path, output_file)
# # 		)
# # 	else:
# # 		print(f"Please follow the steps to create an Itinerary file first.")
# #
# # 	if pdf_file:
# # 		st.write(pdf_file.name)
# # 		binary_data = pdf_file.getvalue()
# #
# # 		max_pages, quotes_list = parse_quotes_list(pdf_file)
# # 		# pdf_obj = PyPDF2.PdfReader(pdf_file)
# #
# # 		pdf_viewer(
# # 			input=binary_data,
# # 			width=s_w,
# # 			pages_to_render=pdf_render_pages
# # 		)
# # 	else:
# # 		pdf_render_pages = None, None
# # 		max_pages, quotes_list = None, []
# # 		st.session_state.pop("pdf_render_pages")
# #
# #
# # st.write(f"Max_pages: '{max_pages}'")
# # st.write(f"pdf_render_pages: '{pdf_render_pages}'")
# #
# #
# # if any(pdf_render_pages):
# # 	with container_pdf_ctls:
# # 		cols_ctls = st.columns(5)
# #
# # 		with cols_ctls[0]:
# # 			a, b = 0, pages_per_render
# # 			st.write(f"0 {a=}, {b=}")
# # 			if st.button(
# # 				label=f"1 - {pages_per_render}",
# # 				key="btn_pdf_ctl_first",
# # 				disabled=pdf_render_pages[0] == 1
# # 			):
# # 				st.session_state.update({
# # 					"pdf_render_pages": list(range(a+1, b+1))
# # 				})
# # 				st.rerun()
# # 		with cols_ctls[1]:
# # 			a, b = (
# # 				max(1, pdf_render_pages[0] - pages_per_render - 1),
# # 				max(pages_per_render, pdf_render_pages[0] - 1)
# # 			)
# # 			st.write(f"1 {a=}, {b=}")
# # 			if st.button(
# # 				label=f"{a} - {b}",
# # 				key="btn_pdf_ctl_prev",
# # 				disabled=pdf_render_pages[0] == 1
# # 			):
# # 				st.session_state.update({
# # 					"pdf_render_pages": list(range(a, b+1))
# # 				})
# # 				st.rerun()
# # 		with cols_ctls[2]:
# # 			st.write(f"2 {pdf_render_pages=}")
# # 			st.write(f"2 {max_pages=}")
# # 			st.write(f"Page ({pdf_render_pages[0]} - {pdf_render_pages[-1]}) of {max_pages} pages(s)")
# # 		with cols_ctls[3]:
# # 			a, b = (
# # 				min(max_pages - (1 + (max_pages % pages_per_render)), pdf_render_pages[0] + pages_per_render),
# # 				min(max_pages, pdf_render_pages[-1] + pages_per_render)
# # 			)
# # 			st.write(f"3 {a=}, {b=}")
# # 			if st.button(
# # 				label=f"{a} - {b}",
# # 				key="btn_pdf_ctl_next",
# # 				disabled=pdf_render_pages[-1] == max_pages
# # 			):
# # 				st.session_state.update({
# # 					"pdf_render_pages": list(range(a, b+1))
# # 				})
# # 				st.rerun()
# # 		with cols_ctls[4]:
# # 			a, b = max_pages - (1 + (max_pages % pages_per_render)), max_pages
# # 			st.write(f"4 {a=}, {b=}")
# # 			if st.button(
# # 				label=f"{a} - {b}",
# # 				key="btn_pdf_ctl_last",
# # 				disabled=pdf_render_pages[-1] == max_pages
# # 			):
# # 				st.session_state.update({
# # 					"pdf_render_pages": list(range(a, b+1))
# # 				})
# # 				st.rerun()
# #
# # with cols_main[1]:
# #
# # 	with st.container(
# # 		border=1,
# # 		height=int(s_h * 0.75)
# # 	):
# # 		st.subheader("Checklist:")
# #
# # 		# Create nodes to display
# # 		# nodes = [
# # 		# 	{"label": "Folder A", "value": "folder_a"},
# # 		# 	{
# # 		# 		"label": "Folder B",
# # 		# 		"value": "folder_b",
# # 		# 		"children": [
# # 		# 			{"label": "Sub-folder A", "value": "sub_a"},
# # 		# 			{"label": "Sub-folder B", "value": "sub_b"},
# # 		# 			{"label": "Sub-folder C", "value": "sub_c"},
# # 		# 		],
# # 		# 	},
# # 		# 	{
# # 		# 		"label": "Folder C",
# # 		# 		"value": "folder_c",
# # 		# 		"children": [
# # 		# 			{"label": "Sub-folder D", "value": "sub_d"},
# # 		# 			{
# # 		# 				"label": "Sub-folder E",
# # 		# 				"value": "sub_e",
# # 		# 				"children": [
# # 		# 					{"label": "Sub-sub-folder A", "value": "sub_sub_a"},
# # 		# 					{"label": "Sub-sub-folder B", "value": "sub_sub_b"},
# # 		# 				],
# # 		# 			},
# # 		# 			{"label": "Sub-folder F", "value": "sub_f"},
# # 		# 		],
# # 		# 	},
# # 		# ]
# # 		lf = "leaf_"
# # 		ch = "check_"
# # 		pb = "problem_"
# # 		qn = "question_"
# # 		aa = "all_of_the_above_"
# # 		node_structure = {
# # 			"problem": (["Code", "Option-Wording", "Typo"], pb),
# # 			"question": (["Beams", "Load-Securement"], qn),
# # 			"all of the above": ([], aa)
# # 		}
# # 		nodes = [{
# # 			"label": q,
# # 			"value": f"{ch}{q}",
# # 			# "showCheckbox": False,
# # 			"children": [{
# # 				"label": lbl.title(),
# # 				"value": f"{node_structure[lbl][1]}{q}",
# # 				# "showCheckbox": False,
# # 				"children": [{
# # 					# "label": child.title(),
# # 					"label": f"{node_structure[lbl][1]}{child.lower().replace(' ', '_').replace('-', '_')}_{lf}{q}",
# # 					"value": f"{node_structure[lbl][1]}{child.lower().replace(' ', '_').replace('-', '_')}_{lf}{q}"
# # 					}
# # 					for child in node_structure[lbl][0]
# # 				]}
# # 				for lbl in node_structure
# # 			]}
# # 			for i, q in enumerate(quotes_list)
# # 		]
# # 		possible_keys = []
# # 		for i, q in enumerate(quotes_list):
# # 			possible_keys.append(nodes[i]["value"])
# # 			for j, lbl in enumerate(node_structure):
# # 				possible_keys.append(nodes[i]["children"][j]["value"])
# # 				if not nodes[i]["children"][j].get("children", []):
# # 					del nodes[i]["children"][j]["children"]
# # 				else:
# # 					for child in nodes[i]["children"][j].get("children", []):
# # 						possible_keys.append(child["value"])
# # 		st.write(possible_keys)
# # 		st.write(nodes)
# # 		# nodes = [
# # 		# 	{
# # 		# 		"label": q,
# # 		# 		"value": f"{ch}{q}",
# # 		# 		"children": [
# # 		# 			{
# # 		# 				"label": "problem",
# # 		# 				"value": f"{pb}{q}",
# # 		# 				"children": [
# # 		# 					{
# # 		# 						"label": "code",
# # 		# 						"value": f"{pb}code_{lf}{q}"
# # 		# 					},
# # 		# 					{
# # 		# 						"label": "option-wording",
# # 		# 						"value": f"{pb}wording_{lf}{q}"
# # 		# 					},
# # 		# 					{
# # 		# 						"label": "typo",
# # 		# 						"value": f"{pb}typo_{lf}{q}"
# # 		# 					}
# # 		# 				]
# # 		# 			},
# # 		# 			{
# # 		# 				"label": "question",
# # 		# 				"value": f"{qn}{q}",
# # 		# 				"children": [
# # 		# 					{
# # 		# 						"label": "Beams",
# # 		# 						"value": f"{qn}beams_{lf}{q}"
# # 		# 					},
# # 		# 					{
# # 		# 						"label": "Load Securement",
# # 		# 						"value": f"{qn}load_securement_{lf}{q}"
# # 		# 					}
# # 		# 				]
# # 		# 			},
# # 		# 			{
# # 		# 				"label": "all of the above",
# # 		# 				"value": f"{lf}{aa}{q}"
# # 		# 			}
# # 		# 		]
# # 		# 	}
# # 		# 	for q in quotes_list
# # 		# ]
# #
# # 		with st.container(border=True):
# # 			pre_select = st.session_state.get("tree_select_selected_nodes", [])
# # 			print(f"BB 'problem_option_wording_leaf_31080' in pre_select => '{'problem_option_wording_leaf_31080' in pre_select}'")
# #
# # 			return_select = tree_select(
# # 				nodes,
# # 				checked=pre_select,
# # 				# key="tree_select",
# # 				direction="ltr"
# # 			)
# #
# # 			if st.button(
# # 				label="select all",
# # 				key="btn_select_all_checklist"
# # 			):
# # 				children = deepcopy(nodes)
# # 				checked = []
# # 				while children:
# # 					node = children.pop(0)
# # 					val = node.get("value")
# # 					children.extend(node.get("children", []))
# # 					checked.append(val)
# # 					# st.session_state.update({val: True})
# # 				st.session_state.update({"tree_select_selected_nodes": checked})
# # 				# if val not in return_select["checked"]:
# # 				# 	return_select["checked"].append(val)
# #
# # 				st.rerun()
# #
# # 			st.write("pre_select")
# # 			st.write(pre_select)
# #
# # 		with st.container(border=True):
# # 			st.write(return_select)
# #
# # 		checked = return_select["checked"]
# #
# # 		old_checked = st.session_state.get("tree_select_selected_nodes", [])
# # 		new_checked = set(checked).difference(set(old_checked))
# # 		new_removed = set(old_checked).difference(set(checked))
# #
# # 		added: bool = False
# # 		for i, key in enumerate(new_checked):
# # 			if key.startswith(aa):
# # 				for j, k in enumerate(node_structure):
# # 					ok = f"{k}_{q}".lower().replace(' ', '_').replace('-', '_')
# # 					if ok not in checked:
# # 						checked.append(ok)
# # 						added = True
# # 						print(f"ADD '{ok}'")
# # 						if ok not in possible_keys:
# # 							raise ValueError(f"NO '{ok}'")
# # 					for lbl in node_structure[k][0]:
# # 						ok = f"{k}_{lbl}_{lf}{q}".lower().replace(' ', '_').replace('-', '_')
# # 						if ok not in checked:
# # 							checked.append(ok)
# # 							added = True
# # 							print(f"ADD '{ok}'")
# # 							if ok not in possible_keys:
# # 								raise ValueError(f"NO '{ok}'")
# # 			ask_details(key)
# # 			print("XX '" + st.session_state.get(f"issue_details{key}", "n/a") + "'")
# #
# # 		removed: bool = False
# # 		for i, key in enumerate(new_removed):
# # 			if key.startswith(aa):
# # 				for j, k in enumerate(node_structure):
# # 					ok = f"{k}_{q}".lower().replace(' ', '_').replace('-', '_')
# # 					if ok in checked:
# # 						checked.remove(ok)
# # 						removed = True
# # 						print(f"ADD '{ok}'")
# # 						if ok not in possible_keys:
# # 							raise ValueError(f"NO '{ok}'")
# # 					for lbl in node_structure[k][0]:
# # 						ok = f"{k}_{lbl}_{lf}{q}".lower().replace(' ', '_').replace('-', '_')
# # 						if ok in checked:
# # 							checked.remove(ok)
# # 							removed = True
# # 							print(f"ADD '{ok}'")
# # 							if ok not in possible_keys:
# # 								raise ValueError(f"NO '{ok}'")
# #
# # 		st.session_state.update({"tree_select_selected_nodes": checked})
# # 		st.write("old_checked")
# # 		st.write(old_checked)
# # 		st.write("new_checked")
# # 		st.write(new_checked)
# # 		st.write("new_removed")
# # 		st.write(new_removed)
# # 		st.write("checked")
# # 		st.write(checked)
# # 		#
# # 		#
# # 		# st.session_state.update({"tree_select_selected_nodes": return_select["checked"]})
# # 		if added or removed:
# # 			# print(f"{st.session_state.get('tree_select_selected_nodes')=}")
# # 			print(f"RERUN {datetime.datetime.now():%Y-%m-%d %H:%M:%S}")
# # 			# st.rerun()
# # 			refresh()
# #
# # 		chk_quotes = set()
# # 		for i, check_key in enumerate(checked):
# # 			*key, quote = check_key.rsplit("_", 1)
# # 			key = "".join(key)
# # 			# print(f"Quote: '{quote}', ISS: '{key}'")
# # 			chk_quotes.add(quote)
# # 		quotes_left = list(set(quotes_list).difference(chk_quotes))
# #
# # 		with st.container(border=True):
# # 			if st.button(
# # 				label="End Meeting",
# # 				key=f"btn_end_meeting",
# # 				disabled=bool(quotes_left)
# # 			):
# # 				for i, check_key in enumerate(return_select["checked"]):
# # 					*key, quote = check_key.rsplit("_", 1)
# # 					key = "".join(key).removeprefix("_").removesuffix("_")
# # 					# iss = key.removeprefix(pb).removeprefix(qn).removesuffix(lf)
# # 					print(f"Quote: '{quote}', ISS: '{key}'")
# # 					if key == ch.removeprefix("_").removesuffix("_"):
# # 						# checked Tag
# # 						valid_log.append(quote)
# # 					else:
# # 						if quote not in valid_log:
# # 							# if key == aa.removesuffix("_").removeprefix("_"):
# # 							if quote not in iss_log:
# # 								iss_log[quote] = []
# # 							# if key.removeprefix(lf).removeprefix(ch) == aa:
# # 							# 	for j
# # 							# else:
# # 								iss_log[quote].append({
# # 									"iss": key,
# # 									"comm": st.session_state.get(f"issue_details_{key}", "N/A")
# # 								})
# #
# # with st.expander("RESULTS"):
# # 	st.write("Checked")
# # 	st.write(valid_log)
# # 	st.write("---")
# # 	st.write("Issues")
# # 	st.write(iss_log)
# #
# #
# #
# # # # Script run 2025-01-28 1450
# # # x_cols = st.columns(3)
# # # with x_cols[0]:
# # # 	if st.button(
# # # 		label="APPROVE PAST WO's"
# # # 	):
# # # 		r_lst = [
# # # 			30983,
# # # 			31111,
# # # 			31124,
# # # 			30875,
# # # 			31005,
# # # 			31011,
# # # 			30757,
# # # 			31039,
# # # 			31040,
# # # 			31044,
# # # 			31045,
# # # 			31046,
# # # 			31047,
# # # 			30921,
# # # 			31053,
# # # 			31055,
# # # 			31056,
# # # 			31058,
# # # 			31059,
# # # 			31061,
# # # 			31062,
# # # 			31073,
# # # 			30947,
# # # 			31080,
# # # 			31083,
# # # 			31084,
# # # 			31096,
# # # 			31102,
# # # 			31103
# # # 		]
# # #
# # # 		sql = f"""
# # # 	UPDATE
# # # 		[BWSdb].[dbo].[Orders]
# # # 	SET
# # # 		[WO Reviewed] = 1,
# # # 		[WO Review Date] = '{datetime.datetime.now():%Y-%m-%d %H:%M:%S}'
# # # 	WHERE
# # # 		[Quote#] IN (
# # # 			{',\n\t\t'.join(map(str, r_lst))}
# # # 		)
# # # 		"""
# # #
# # # 		st.code(sql, language="sql", line_numbers=True)