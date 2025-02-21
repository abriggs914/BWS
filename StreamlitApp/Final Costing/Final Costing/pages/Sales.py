import json
# Version 2025-01-27 1800
# import PyPDF2
import os
import datetime
import subprocess
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
from datetime_utility import is_date, date_str_format
from json_utility import jsonify
from pyodbc_connection import connect
from streamlit_utility import aligned_text
from utility import number_suffix

st.set_page_config(
	layout="wide",
	page_title="Weekly WO Meeting"
)

DEFAULT_NEW_FOLDER: str = "Create New"
k_meeting_id: str = "k_meeting_id"
k_df_meeting_quotes: str = "k_df_meeting_quotes"
k_selectbox_choose_edit_meeting: str = "k_selectbox_choose_edit_meeting"
k_date_input_meeting: str = "k_date_input_meeting"
k_multiselect_attendance: str = "k_multiselect_attendance"
k_time_input_meeting: str = "k_time_input_meeting"
k_selectbox_directory: str = "k_selectbox_directory"
k_input_menu_dirty: str = "k_input_menu_dirty"

meeting_id: str = k_meeting_id.removeprefix("k_")
date_input_meeting: str = k_date_input_meeting.removeprefix("k_")
multiselect_attendance: str = k_multiselect_attendance.removeprefix("k_")
time_input_meeting: str = k_time_input_meeting.removeprefix("k_")
selectbox_directory: str = k_selectbox_directory.removeprefix("k_")

now = datetime.datetime.now()


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
def load_gather_meetings():
	return connect("EXEC [BWSdb].[dbo].[sp_WSOM_GatherMeetingQuotes]")


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
def load_dealers():
	return connect("Dealers")


@st.cache_data(ttl=None, show_spinner=True)
def load_orders():
	return connect("Orders")


# @st.cache_data(ttl=None, show_spinner=True)
# def check_similar_quotes():
# 	# return connect("SELECT 30001 AS [Quote#], 30001 AS [Q], 30001 AS [SimQ]")
# 	sql = """
# SET NOCOUNT ON;
# DECLARE @sd DATETIME = '{SD}';
# DECLARE @ed DATETIME = '{ED}';
#
# DECLARE @t TABLE (
#         [ID] INT IDENTITY(0, 1),
#         [Q] INT
# );
# DECLARE @r TABLE (
#         [ID] INT IDENTITY(0, 1),
#         [Q] INT,
#         [SimQ] INT
# );
# INSERT INTO @t ([Q])
# SELECT
#         [Orders].[Quote#]
# FROM (
#         [BWSdb].[dbo].[Sales Staff] WITH (NOLOCK)
# INNER JOIN
#         [BWSdb].[dbo].[Orders] WITH (NOLOCK)
# ON
#         [Sales Staff].[ID-SaleStaff] = [Orders].[Sale PersonID]
# )
# INNER JOIN
#         [BWSdb].[dbo].[Production] WITH (NOLOCK)
# ON
#         [Orders].[Quote#]=[Production].[Quote#]
# WHERE (
#         (
#                 ([Production].[Prod Date]) Between @sd And @ed
#         )
#         And (
#                 ([Orders].[WO Reviewed])=0 Or ([Orders].[WO Reviewed]) Is Null
#         )
# )
# /*
# ORDER BY
#         [Orders].[Model No]
#         ,[Production].[Prod Date]
#         ,[Orders].[Quote#]
# */
# ;
#
# DECLARE @i INT;
# DECLARE @c INT;
# declare @modelno NVARCHAR(255);
# declare @quote INT;
#
# SELECT
#         @i = 0,
#         @c = COUNT(*)
# FROM
#         @t
# ;
#
# WHILE @i < @c BEGIN
#
#         SELECT
#                 @quote = [Q]
#         FROM
#                 @t
#         WHERE
#                 [ID] = @i
#         ;
#
#     -- Insert statements for procedure here
#         --Grab Model No for future referencing
#         SELECT
# 			@modelno = (select [Model No]
# 		from
# 			[BWSdb].[dbo].Orders with (nolock)
# 		where
# 			Quote# = @quote);
#
#         --Drop and create temp table in tmpdb SQL database for faster processing
#         IF OBJECT_ID('tempdb..#QuoteOptions') IS NOT NULL BEGIN
# 			DROP TABLE #QuoteOptions
# 		END
#
#         create table #QuoteOptions
#         (
#                 #Options int,
#                 [Option No] nvarchar(255),
#         [Price] money,
#         [Qty] int,
#         [Sections] nvarchar(255),
#         [Description] nvarchar(max)
#         );
#
#         --Grab Quotes with same Model No and Options as @quote parameter
#         insert into #QuoteOptions ([Option No], Price, Qty, Sections, Description)
#         select [Option No], Price, Qty, Sections, Description
#         from [BWSdb].[dbo].[Order Options] with (nolock)
#         where Quote# = @quote
# 		;
#
#         update #QuoteOptions
#         set #Options = NoOptions
#         from (select count(*) as NoOptions
#                   from [BWSdb].[dbo].[Order Options] with (nolock)
#                   where Quote# = @quote) as subCountOptions
# 		;
#
#         --Drop and create temp table in tmpdb SQL database for faster processing
#         IF OBJECT_ID('tempdb..#QuoteswithsameOptions') IS NOT NULL BEGIN
# 			DROP TABLE #QuoteswithsameOptions
# 		END
#
#         create table #QuoteswithsameOptions
#         (
#                 [Quote#] int,
#                 [WO#] int,
#                 [Quote Date] datetime,
#                 [Prod Date] datetime
#         );
#
#         insert into #QuoteswithsameOptions
#         select Orders.Quote#, Orders.WO#, Orders.[Quote Date], [Prod Date]
#         from [BWSdb].[dbo].[Order Options] as main with (nolock)
#         inner join [BWSdb].[dbo].Orders with (nolock) on main.Quote# = Orders.Quote#
#         left outer join [BWSdb].[dbo].Production with (nolock) on Orders.Quote# = Production.Quote#
#         inner join #QuoteOptions as QuoteOptions on main.[Option No] = QuoteOptions.[Option No]
#                                                                                                 and (case when main.Sections is null then '' else main.Sections end) = (case when QuoteOptions.Sections is null then '' else QuoteOptions.Sections end)
#                                                                                                 and main.Description = QuoteOptions.Description
#                                                                                                 AND main.[Qty] = [QuoteOptions].[Qty]
#         where main.Quote# in (select Quote#
#                                                   from [BWSdb].[dbo].[Order Options] with (nolock)
#                                                   group by Quote#
#                                                   having count(*) in (select #Options from #QuoteOptions))
#         and Orders.[Model No] = @modelno
#         and [Date Declined] is null
#         group by Orders.Quote#, Orders.WO#, Orders.[Quote Date], [Prod Date]
#         having count(*) = (select distinct #Options from #QuoteOptions)
# 		;
#
#         --Drop and create temp table in tmpdb SQL database for faster processing
#         IF OBJECT_ID('tempdb..#QuoteNPOs') IS NOT NULL BEGIN
# 			DROP TABLE #QuoteNPOs
# 		END
#
#         create table #QuoteNPOs
#         (
#                 #NPOs int,
#         [Description] nvarchar(max)
#         );
#
#         --Grab Quotes with same NPOs
#         insert into #QuoteNPOs (Description)
#         select Description
#         from [BWSdb].[dbo].[Custom Work] with (nolock)
#         where Quote# = @quote
# 		;
#
#         update #QuoteNPOs
#         set #NPOs = NoNPOs
#         from (select count(*) as NoNPOs
#                   from [BWSdb].[dbo].[Custom Work] with (nolock)
#                   where Quote# = @quote) as subCountNPOs
# 		;
#
#         --Drop and create temp table in tmpdb SQL database for faster processing
#         IF OBJECT_ID('tempdb..#QuoteswithsameNPOs') IS NOT NULL BEGIN
# 			DROP TABLE #QuoteswithsameNPOs
# 		END
#
#         create table #QuoteswithsameNPOs
#         (
#                 [Quote#] int,
#                 [WO#] int,
#                 [Quote Date] datetime,
#                 [Prod Date] datetime
#         );
#
#         insert into #QuoteswithsameNPOs
#         select Orders.Quote#, Orders.WO#, Orders.[Quote Date], [Prod Date]
#         from [BWSdb].[dbo].[Custom Work] as main with (nolock)
#         inner join [BWSdb].[dbo].Orders with (nolock) on main.Quote# = Orders.Quote#
#         left outer join [BWSdb].[dbo].Production with (nolock) on Orders.Quote# = Production.Quote#
#         inner join #QuoteNPOs as QuoteNPOs on main.Description = QuoteNPOs.Description
#         where main.Quote# in (select Quote#
#                                                   from [BWSdb].[dbo].[Custom Work] with (nolock)
#                                                   group by Quote#
#                                                   having count(*) in (select #NPOs from #QuoteNPOs))
#         and Orders.[Model No] = @modelno
#         and [Date Declined] is null
#         group by Orders.Quote#, Orders.WO#, Orders.[Quote Date], [Prod Date]
#         having count(*) = (select distinct #NPOs from #QuoteNPOs)
# 		;
#
#         --Final select statement
#         INSERT INTO @r ([Q], [SimQ])
#         select @quote, Options.Quote#
#         from #QuoteswithsameOptions as Options
#         inner join #QuoteswithsameNPOs as NPOs on Options.Quote# = NPOs.Quote#
#         LEFT JOIN @t ON [Options].[Quote#] = [@t].[Q]
#         where Options.Quote# <> @quote
# 		;
#
#
#         SELECT @i = @i + 1;
#
# END
# /*
# SELECT
#         *
# FROM
#         @t
# */
#
# SELECT
#         *
# FROM
#         @r
# ;
# 	""".format(SD=f"{datetime.datetime.now():%Y-%m-%d}", ED=f"{(datetime.datetime.now() + datetime.timedelta(days=185)):%Y-%m-%d}")
# 	print(sql)
# 	return connect(sql, returns_records=True)


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

		print(f"{pdf_file=}, {len(highlighted_texts)}")
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
def ask_details(key, idx, selected_quote, annotation):
	st.subheader(f"Describe the issue with quote {selected_quote}")
	st.subheader(f"{annotation['text']}")
	st.write(f"{type(annotation['text'])=}")
	issues = st.session_state.setdefault(key, [])
	text_area_known_issues = st.text_area(
		label="Known Issues:",
		value="\n".join(issues),
		disabled=True
	)
	text_area_new_issues = st.text_area(
		label="Known Issues:",
		key="text_area_new_issues"
	)
	if st.button(
			label="save"
	):
		issues.append(f"{datetime.datetime.now():%Y-%m-%d %H:%M:%S}")
		f"status_{m_id}_{selected_quote}"
		if st.session_state.get(key, None) is None:
			st.session_state.update({key: {}})
		st.session_state[key].update({
			f"issue_{now:%Y-%m-%d %H:%M:%S}": issues
		})
		# st.session_state
		if "clicked_annotation" in st_pdf_viewer:
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
	if st.button(
			label="cancel"
	):
		st.rerun()


def copy_wos_via_access(directory):
	st.info(
		"Please wait while SysproCompanyA processes the requested WOs..\nThis will take between 5 and 20 minutes (~30s per WO).")
	st.info("Please wait for the 'RUNNING' icon to disappear before you try any successive reruns.")
	access = r"C:\Program Files\Microsoft Office\root\Office16\MSACCESS.EXE"
	db_name = r"C:\Access\SysproCompanyA.accdb"
	macro_name = "WSOM_MacroAutoRunWOReports"
	param_dir = os.path.basename(directory)
	cmd = f"\"{access}\" \"{db_name}\" /x \"{macro_name}\" /cmd \"{param_dir}\""
	print(f"{cmd=}")
	st.code(cmd, language="shellSession", line_numbers=True)
	try:
		subprocess.run(cmd, shell=True)
	except Exception as e:
		st.error(f"Failure:\n{e}")
		print(f"Failure:\n{e}")


@st.dialog(title="Meeting Details", width="large")
def meeting_input_menu(mode: str = "new"):
	print(f"meeting_input_menu({mode=})")

	m_id = st.session_state.get(k_meeting_id)
	ser_saved = df_meetings.loc[df_meetings["ID"] == m_id]
	saved_date = ser_saved.iloc[0]["DateMeeting"] if not ser_saved.empty else None
	saved_attendance = ser_saved.iloc[0]["Attendance"] if not ser_saved.empty else None
	saved_directory = ser_saved.iloc[0]["MeetingDirectory"] if not ser_saved.empty else None
	if isinstance(saved_date, pd.Timestamp):
		saved_date = saved_date.to_pydatetime()

	# st.session_state.setdefault({k_input_menu_dirty: {
	# 	"mid": m_id,
	# 	"mdate": mdate,
	# 	"mtime": mtime,
	# 	"mattendance": mattendance,
	# 	"mdirectory": mdirectory
	# }})

	if mode == "new":
		date_input_min_value = df_meetings["DateMeeting"].max() + datetime.timedelta(days=4)
		date_input_max_value = datetime.datetime.now() + datetime.timedelta(days=7)

		m_thresh = 0
	else:
		m_id = st.session_state.get(k_meeting_id)
		st.header(f"Edit Meeting #{m_id}")
		date_input_min_value = None
		date_input_max_value = None

		m_thresh = 1

	usual_suspects = [
		{"name": "Avery Briggs", "email": "avery.briggs@bwstrailers.com"},
		{"name": "Jamie Merrithew", "email": "jamie.merrithew@bwstrailers.com"},
		{"name": "Lori Piper", "email": "lori.piper@bwstrailers.com"},
		{"name": "Jason Somerville", "email": "jason.somerville@bwstrailers.com"},
		{"name": "Lance Lunn", "email": "lance.lunn@bwstrailers.com"},
		{"name": "Gary Thomas", "email": "gary.thomas@bwstrailers.com"},
		{"name": "Sarah Lord", "email": "sarah.lord@bwstrailers.com"},
		{"name": "Saied Parsaeian", "email": "saied.parsaeian@stargatetrailers.ca"},
		{"name": "Jason Morgan", "email": "jason.morgan@bwstrailers.com"},
		{"name": "Aaron Faulkner", "email": "aaron.faulkner@bwstrailers.com"}
	]

	cont = st.container(border=1, height=500)
	cols = cont.columns(2, border=1)
	list_directories = df_meetings["MeetingDirectory"].dropna().apply(
		lambda d: os.path.basename(d)
	).unique().tolist() + list_meeting_folders
	# list_directories = [f"{d} - {(n - is_date(d)).days} day(s) ago" for d in list_directories]
	list_directories = [DEFAULT_NEW_FOLDER] + sorted(list(set(list_directories)), reverse=True)
	if cols[1].button(
			label="Add all",
			key="k_btn_attendance_add_all"
	):
		st.session_state.update({
			k_multiselect_attendance: [s["name"] for s in usual_suspects]
		})
	multiselect_attendance = cols[1].multiselect(
		label="Attendance",
		key=k_multiselect_attendance,
		options=[s["name"] for s in usual_suspects]
	)
	date_input_meeting = cols[0].date_input(
		label="Meeting Date:",
		key=k_date_input_meeting,
		format="YYYY-MM-DD",
		min_value=date_input_min_value,
		max_value=date_input_max_value
	)
	if date_input_meeting:
		df_c = df_meetings.loc[df_meetings["DateMeeting"].dt.date == date_input_meeting]
		if df_c.shape[0] > m_thresh:
			st.markdown(
				body=aligned_text(
					f"This date is already used in {df_c.shape[0]} other Meeting Record(s)"
				),
				unsafe_allow_html=True
			)
	time_input_meeting = cols[0].time_input(
		label="Time:",
		key=k_time_input_meeting
	)
	selectbox_directory = cols[0].selectbox(
		label="Directory",
		# key=_k_selectbox_directory,
		key=f"k_{k_selectbox_directory}",
		options=list_directories
	)
	if (selectbox_directory == DEFAULT_NEW_FOLDER) or (not selectbox_directory):
		mt = is_date(date_input_meeting)
		if mt:
			selectbox_directory = f"{date_input_meeting:%Y-%m-%d}"
		else:
			selectbox_directory = f"{now:%Y-%m-%d}"
	if directory := st.session_state.get(k_selectbox_directory, ""):
		dir_date = os.path.basename(directory)
		if dir_date != DEFAULT_NEW_FOLDER:
			cols[0].write(f"'{dir_date}' - {(now - is_date(dir_date)).days} day(s) ago")
		else:
			cols[0].write(f"==> '{selectbox_directory}'")
	if date_input_meeting:
		if len(st.session_state[k_multiselect_attendance]) > 1:
			mt = datetime.datetime(
				date_input_meeting.year,
				date_input_meeting.month,
				date_input_meeting.day,
				time_input_meeting.hour,
				time_input_meeting.minute,
				time_input_meeting.second
			)
			attendance = ";".join(st.session_state[k_multiselect_attendance])
			directory = os.path.join(root_path, selectbox_directory)
			# st.session_state.update({k_selectbox_directory: directory})

			is_dirty: bool = any([
				saved_date != date_input_meeting,
				saved_attendance != attendance,
				saved_directory != directory
			])
			st.write(f"{m_id=}")
			st.write(f"{saved_date=}, {mt=}, {(saved_date != mt)=}")
			st.write(f"{saved_attendance=}, {attendance=}, {(saved_attendance != attendance)=}")
			st.write(f"{saved_directory=}, {directory=}, {(saved_directory != directory)=}")
			st.write(f"{is_dirty=}")
			print(f"{m_id=}")
			print(f"{saved_date=}, {mt=}, {(saved_date != mt)=}")
			print(f"{saved_attendance=}, {attendance=}, {(saved_attendance != attendance)=}")
			print(f"{saved_directory=}, {directory=}, {(saved_directory != directory)=}")
			print(f"{is_dirty=}")

			st.warning("Please ensure that Access is closed before trying this resource-intensive operation!")
			if is_dirty:
				if st.button(
						label="save",
						key="k_btn_save_new_meeting"
				):
					print(f"=A")
					if mode == "new":
						# Create new meeting record
						print(f"=B")
						sql = (f"""
	INSERT INTO 
		[BWSdb].[dbo].[WSOM_Meetings]
	(
		[DateMeeting],
		[Attendance],
		[MeetingDirectory]
	)
	VALUES (
		'{mt:%Y-%m-%d %H:%M:%S}',
		'{attendance}',
		'{directory}'
	)
	;
							""").strip()
					else:
						# Update existing meeting record
						print(f"=C")
						sql = (f"""
	UPDATE
		[BWSdb].[dbo].[WSOM_Meetings]
	SET
		[DateMeeting] = '{mt:%Y-%m-%d %H:%M:%S}',
		[Attendance] = '{attendance}',
		[MeetingDirectory] = '{directory}'
	WHERE
		[ID] = {st.session_state.get(k_meeting_id)}
	;
						""").strip()
					# connect(sql, do_exec=False, do_print=False, do_show=False)

					# st.code(sql, language="sql", line_numbers=True)
					print("sql:")
					print(sql)
					connect(sql, do_exec=True, do_print=True, do_show=True)
					load_meetings.clear()
					df_meetings_new = load_meetings()
					if not os.path.exists(os.path.join(root_path, directory)):
						os.mkdir(os.path.join(root_path, directory))
					if mode == "new":
						st.session_state.update({k_meeting_id: df_meetings_new["ID"].max()})
						copy_wos_via_access(directory)
					st.session_state.update({
						# k_multiselect_attendance: attendance,
						# k_date_input_meeting: k_date_input_meeting,
						# k_time_input_meeting: k_time_input_meeting,
						k_selectbox_directory: directory
					})
					st.rerun()
			else:
				if st.button(
					label=f"continue",
					key=f"kd_btn_continue_editing"
				):
					load_meetings.clear()
					df_meetings_new = load_meetings()
					if not os.path.exists(os.path.join(root_path, directory)):
						os.mkdir(os.path.join(root_path, directory))
					if mode == "new":
						st.session_state.update({k_meeting_id: df_meetings_new["ID"].max()})
						copy_wos_via_access(directory)
					st.session_state.update({
						# k_multiselect_attendance: attendance,
						# k_date_input_meeting: k_date_input_meeting,
						# k_time_input_meeting: k_time_input_meeting,
						k_selectbox_directory: directory
					})
					st.rerun()
	# 	else:
	# 		print(f"not len(multiselect_attendance) > 1")
	# 		print(f"{multiselect_attendance=}")
	# else:
	# 	print(f"not date_input_meeting")

	if st.button(
			label=f"cancel",
			key=f"k_btn_cancel_input"
	):
		st.session_state.update({"btn_cancel_input": True})

	if st.session_state.get("btn_cancel_input"):
		if any([date_input_meeting, time_input_meeting, selectbox_directory]):
			st.markdown(
				body=aligned_text(
					txt=f"Are you sure?",
					tag_style="span",
					colour="#9F3434"
				),
				unsafe_allow_html=True
			)
			btn_cols = st.columns(2)
			if btn_cols[0].button(
					label=f"no",
					key=f"k_btn_ays_cancel_no"
			):
				st.session_state.update({"btn_cancel_input": False})
			if btn_cols[1].button(
					label=f"yes",
					key=f"k_btn_ays_cancel_yes"
			):
				st.session_state.clear()
				st.session_state.update({
					"btn_cancel_input": True
				})
				# print(f"{st.session_state=}")
				st.rerun()


def edit_meeting():
	print(f"edit_meeting")
	m_id = st.session_state.get(k_meeting_id)
	print(f"{m_id=}")
	ser_meeting = df_meetings.loc[df_meetings["ID"] == m_id].iloc[0]
	meeting_attendance = ser_meeting["Attendance"]
	meeting_date = ser_meeting["DateMeeting"]
	directory = ser_meeting["MeetingDirectory"]
	if pd.isna(directory):
		directory = DEFAULT_NEW_FOLDER
	else:
		directory = os.path.basename(directory)
	st.session_state.update({
		k_date_input_meeting: meeting_date,
		k_multiselect_attendance: meeting_attendance.split(";"),
		k_time_input_meeting: meeting_date,
		k_selectbox_directory: directory
	})
	meeting_input_menu(mode="edit")


def create_new_meeting():
	print(f"create_new_meeting")
	k_date_input_meeting = "k_date_input_meeting"
	k_multiselect_attendance = "k_multiselect_attendance"
	k_time_input_meeting = "k_time_input_meeting"
	st.session_state.update({
		k_selectbox_directory: DEFAULT_NEW_FOLDER,
		k_date_input_meeting: datetime.datetime.now(),
		k_multiselect_attendance: [],
		k_time_input_meeting: datetime.datetime.now()
	})
	meeting_input_menu(mode="new")


def set_orders_quotes_approved_from_wsom(lq):
	sql = ("""	
UPDATE
	[BWSdb].[dbo].[Orders]
SET
	[WO Reviewed] = 1
	,[WO Review Date] = '2025-02-05'
WHERE
	[Quote#] IN ({LQ});
""").strip()
	lqs = ", ".join(map(str, lq))
	sql = sql.format(LQ=lqs)
	connect(sql, do_print=True, do_show=True)


s_h = streamlit_js_eval(js_expressions='parent.innerHeight', key='SCR_H')
s_w = streamlit_js_eval(js_expressions='parent.innerWidth', key='SCR_W')

if s_h is None or not s_h:
	s_h = 900
if s_w is None or not s_w:
	s_w = 1600

root_path = r"\\bwsfp01\public\SALES OFFICE\Weekly WO Meetings"
list_meeting_folders = [d for d in os.listdir(root_path) if d != "Scripts"]

df_meetings = load_meetings()
df_gather_meetings = load_gather_meetings()
df_meeting_notes = load_meeting_notes()
df_meeting_notes["Quote"] = df_meeting_notes["Quote"].apply(int)

cont = st.container(key="master", border=1)

with cont:
	st.write("df_gather_meetings")
	st.dataframe(df_gather_meetings)
	st.write("df_meetings")
	st.dataframe(df_meetings)
	st.write("df_meeting_notes")
	st.dataframe(df_meeting_notes)

# st.session_state.setdefault("selected_directory", list_meeting_folders[-1])
# selected_directory = st.selectbox(
# 	label="SELECT",
# 	options=list_meeting_folders,
# 	key="selected_directory"
# )


with cont:
	st.write("st.session_state")
	st.write(st.session_state)

if st.session_state.get(k_meeting_id, None) is None:

	cont.empty()
	cont.write(f"{df_meetings.shape[0]} Meeting(s) on record")

	m_id = None
	selected_directory = None
	st.session_state.update({k_selectbox_directory: None})
	st.session_state.setdefault(k_selectbox_choose_edit_meeting, df_meetings["ID"].max())

	selectbox_choose_edit_meeting = cont.selectbox(
		label="Edit Meeting:",
		key=k_selectbox_choose_edit_meeting,
		options=df_meetings["ID"].values.tolist()
	)

	edit_m_id: int = int(st.session_state.get(k_selectbox_choose_edit_meeting))
	if cont.button(
			label=f"Edit Meeting #{edit_m_id}",
			key=f"k_btn_edit_last_meeting"
	):
		# st.session_state.update({k_meeting_id: df_meetings["ID"].max()})
		m_id = edit_m_id
		st.session_state.update({k_meeting_id: edit_m_id})
		print(f"IF & EM# {m_id=}, m_id2={st.session_state.get(k_meeting_id)}")
		edit_meeting()

	if cont.button(
			label="New Meeting",
			key='k_btn_new_meeting'
	):
		create_new_meeting()
else:
	m_id = st.session_state.get(k_meeting_id)
	ser_meeting = df_meetings.loc[df_meetings["ID"] == m_id].iloc[0]
	mt = ser_meeting["DateMeeting"]
	print(f"ELSE {m_id=}")
	cont.header(f"Editing Meeting ID#{m_id}")
	cont.subheader(f"{date_str_format(mt, include_time=True, include_weekday=True)}")
	dds = (mt - now).total_seconds()
	dd = round(abs(dds) / (60 * 60 * 24), 2)
	cont.subheader(f"{dd} day{'' if dd == 1 else 's'} {'from now' if dds >= 0 else 'ago'}")
	if cont.button(
			label=f"Edit Meeting #{m_id}",
			key="k_btn_edit_meeting"
	):
		edit_meeting()

	selected_directory = st.session_state.get(k_selectbox_directory, DEFAULT_NEW_FOLDER)
	# if (selected_directory == DEFAULT_NEW_FOLDER) or (not selected_directory):
	# 	selected_directory = f"{now:%Y-%m-%d}"

	if (selected_directory == DEFAULT_NEW_FOLDER) or (not selected_directory):
		mt = is_date(selected_directory)
		print(f"{selected_directory=}, {mt=}")
		print(f"{st.session_state.get(date_input_meeting)=}, {mt=}")
		if mt:
			selected_directory = f"{selected_directory:%Y-%m-%d}"
		else:
			mt = is_date(st.session_state.get(date_input_meeting))
			d = st.session_state.get(date_input_meeting)
			if mt:
				selected_directory = f"{d:%Y-%m-%d}"
			else:
				selected_directory = f"{now:%Y-%m-%d}"

if selected_directory:
	if not os.path.exists(os.path.join(root_path, selected_directory)):
		cont.write(f"BLOCKED PATH '{selected_directory}'")
		selected_directory = None
		st.session_state.update({
			selectbox_directory: DEFAULT_NEW_FOLDER
		})

cont.write(selected_directory)
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
		cont.error(f"Cannot find Itinerary file within this directory.")
		with cont.container(border=1):
			st.warning("Please ensure that Access is closed before trying this resource-intensive operation!")
			if st.button(
					label="Try rerunning access commands?",
					key="k_btn_rerun_access_command"
			):
				copy_wos_via_access(directory=selected_directory)
		# streamlit_rea
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

	cont.write("rpt_files")
	cont.write(rpt_files)
	cont.write("list_quotes")
	cont.write(list_quotes)
	# similar_quotes = check_similar_quotes()
	# # st.dataframe(similar_quotes)
	df_products = load_products()
	df_dealers = load_dealers()
	df_orders = load_orders()
	if (k_df_meeting_quotes not in st.session_state) or (st.session_state.get(k_df_meeting_quotes) is None) or (
	st.session_state.get(k_df_meeting_quotes).empty):
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
		df_meeting_quotes = df_meeting_quotes.merge(
			df_meeting_notes.loc[
				(df_meeting_notes["MeetingID"] <= m_id)
				& (
						pd.isna(df_meeting_notes["DateResolved"])
						| (str(df_meeting_notes["DateResolved"]).strip() != "")
				)
				],
			how="outer",
			on="Quote"
		)
		df_meeting_quotes = df_meeting_quotes.merge(
			df_dealers[[
				"ID",
				"COMPANY NAME"
			]],
			how="inner",
			left_on="DealerID",
			right_on="ID"
		)
		df_meeting_quotes.loc[:, ["Reviewed", "Approved"]] = False, False

		for i, row in df_meeting_quotes.iterrows():
			df_meeting_quotes.loc[i, "Reviewed"] = not pd.isna(row["Quote#"])
			df_meeting_quotes.loc[i, "Approved"] = not pd.isna(row["DateResolved"]) and not pd.isna(row["ResolvedBy"])
		# CopyWithSlice
		# df_meeting_quotes.iloc[i]["Reviewed"] = not pd.isna(row["Quote#"])
		# df_meeting_quotes.iloc[i]["Approved"] = not pd.isna(row["DateResolved"]) and not pd.isna(row["ResolvedBy"])
		# print(f"{i=}, {df_meeting_quotes.iloc[i][['Reviewed', 'Approved']]}, {row['Quote#']=}, {row['DateResolved']=}, {row['ResolvedBy']=}")
	else:
		df_meeting_quotes = st.session_state.get(k_df_meeting_quotes)

	st.session_state.update({k_df_meeting_quotes: df_meeting_quotes})

	# similar_quotes_m1 = similar_quotes.merge(
	# 	df_orders[[
	# 		"Quote#",
	# 		"ProductID",
	# 		"DealerID"
	# 	]],
	# 	how="inner",
	# 	left_on="Q",
	# 	right_on="Quote#"
	# )
	#
	# similar_quotes_tree = {
	#
	# }
	#
	# similar_quotes_m1 = similar_quotes_m1.merge(
	# 	df_products[[
	# 		"IDTrailer",
	# 		"Class",
	# 		"Model No"
	# 	]],
	# 	how="inner",
	# 	left_on="ProductID",
	# 	right_on="IDTrailer"
	# )

	similar_quotes_m1 = df_meeting_quotes.merge(
		df_orders[[
			"Quote#",
			"ProductID",
			"DealerID"
		]],
		how="inner",
		left_on="Quote",
		right_on="Quote#"
	)

	similar_quotes_m1 = similar_quotes_m1.merge(
		df_products[[
			"IDTrailer",
			"Class",
			"Model No"
		]],
		how="inner",
		left_on="ProductID_x",
		right_on="IDTrailer"
	)

	similar_quotes_m1 = similar_quotes_m1.merge(
		df_dealers[[
			"ID",
			"COMPANY NAME"
		]],
		how="inner",
		left_on="DealerID_y",
		right_on="ID"
	)

	similar_quotes_m1["Q_WORpt"] = similar_quotes_m1["Quote"].apply(lambda q: rpt_files.get(str(q)))
	# similar_quotes_m1["SimQ_WORpt"] = similar_quotes_m1["SimQ"].apply(lambda q: rpt_files.get(str(q)))

	cont.write(f"df_meeting_notes == {df_meeting_notes.shape}")
	cont.write(df_meeting_notes)
	cont.write(f"df_meeting_quotes == {df_meeting_quotes.shape}")
	cont.write(df_meeting_quotes)
	cont.write(f"similar_quotes_m1 == {similar_quotes_m1.shape}")
	cont.write(similar_quotes_m1)

	quotes_approved_wsom_not_orders = df_meeting_quotes.merge(
		df_orders[["Quote#"]].loc[(pd.isna(df_orders["WO Reviewed"])) | (df_orders["WO Reviewed"] == 0)],
		how="inner",
		left_on="Quote",
		right_on="Quote#"
	)
	quotes_approved_wsom_not_orders = quotes_approved_wsom_not_orders.loc[
		quotes_approved_wsom_not_orders["Approved"] == 1]
	with cont.container(border=1):
		if not quotes_approved_wsom_not_orders.empty:
			st.write("quotes_approved_wsom_not_orders")
			st.write(quotes_approved_wsom_not_orders)
			btn_set_orders_quotes_approved_from_wsom = st.button(
				label="Set these quotes to approved",
				key="k_btn_set_orders_quotes_approved_from_wsom",
				on_click=lambda
					lq=quotes_approved_wsom_not_orders["Quote"].values.tolist(): set_orders_quotes_approved_from_wsom(
					lq)
			)
		else:
			st.write("All Quotes approved in meeting history are also approved in WSOM tables.")
			st.write("Good to Go!")

	view_as_options = ["By Class", "By Model", "By Dealer", "All"]

	list_models = sorted(similar_quotes_m1["Model No_x"].dropna().unique().tolist())
	list_classes = sorted(similar_quotes_m1["Class_x"].dropna().unique().tolist())
	list_dealers = sorted(similar_quotes_m1["COMPANY NAME_y"].dropna().unique().tolist())

	cols__ = st.columns(3)
	with cols__[0]:
		st.write(list_classes)
	with cols__[1]:
		st.write(list_models)
	with cols__[2]:
		st.write(list_dealers)

	def change_selectbox_view_quotes():
		va = st.session_state.get(f"k_{k_selectbox_view_quotes}", view_as_options[0])
		lst = list_dealers if (va == view_as_options[2]) else (list_classes if (va == view_as_options[1]) else list_models)
		st.session_state.update({
			"pills_selected_model": 0,
			"need_rerun": True
		})

	with cont:
		k_selectbox_view_quotes = "selectbox_view_quotes"
		st.session_state.setdefault(f"k_{k_selectbox_view_quotes}", view_as_options[-1])
		selectbox_view_quotes = st.selectbox(
			label=f"View quotes as:",
			key=f"k_{k_selectbox_view_quotes}",
			options=view_as_options,
			on_change=change_selectbox_view_quotes
		)

		print(f"{st.session_state.get('pills_selected_model')=}")
		if selectbox_view_quotes == view_as_options[0]:
			# class
			st.header(f"{len(list_quotes)} quote(s) to review across {len(list_classes)} classes:")
			selected_model = pills(
				label="Classes",
				options=list_classes,
				key="pills_selected_model"
			)
			df_k = "Class"
		elif selectbox_view_quotes == view_as_options[1]:
			# model
			st.header(f"{len(list_quotes)} quote(s) to review across {len(list_models)} models:")
			selected_model = pills(
				label="Models",
				options=list_models,
				key="pills_selected_model"
			)
			df_k = "Model No"
		elif selectbox_view_quotes == view_as_options[2]:
			# dealer
			st.header(f"{len(list_quotes)} quote(s) to review across {len(list_dealers)} dealers:")
			selected_model = pills(
				label="Dealers",
				options=list_dealers,
				key="pills_selected_model"
			)
			df_k = "COMPANY NAME"
		else:
			# All
			df_k = None

		if selected_model:

			if df_k is not None:
				df_model_quotes = df_meeting_quotes.loc[df_meeting_quotes[df_k] == selected_model]
			else:
				df_model_quotes = df_meeting_quotes
			df_quotes_left_to_review = df_model_quotes.loc[~df_model_quotes["Approved"]]
			st.write(f"{df_quotes_left_to_review.shape[0]} / {df_model_quotes.shape[0]} quote(s) left to Approve:")
			stdf_model_quotes = st.dataframe(
				df_model_quotes[
					["Quote", "Class", "Model No", "MeetingID", "IssueDescription", "DateResolved", "ResolutionDetails",
					 "ResolvedBy", "Reviewed", "Approved"]],
				selection_mode="single-row",
				key="stdf_model_quotes",
				hide_index=True,
				on_select="rerun"
			)

			if stdf_model_quotes["selection"]["rows"]:
				ser_selected_quote = df_model_quotes.iloc[stdf_model_quotes["selection"]["rows"][0]]
				selected_quote = ser_selected_quote["Quote"]
				pdf_file = ser_selected_quote["Q_WORpt"]
				known_issues = df_meeting_notes.loc[df_meeting_notes["Quote"] == selected_quote][
					["MeetingID", "IssueDescription"]]
				if not known_issues.empty:
					st.write(f"Known Issues:")
					st.write(known_issues)
				else:
					st.write("No Known Issues")
				st.write(ser_selected_quote)
				st.write(pdf_file)

				if pdf_file:
					# annotations = [
					# 	{
					# 		"page": 1,
					# 		"x": 220,
					# 		"y": 155,
					# 		"height": 22,
					# 		"width": 65,
					# 		"color": "red"
					# 	},
					# 	{
					# 		"page": 1,
					# 		"x": 220,
					# 		"y": 155,
					# 		"height": 22,
					# 		"width": 65,
					# 		"color": "red"
					# 	}
					# ]


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
						# key = f"issues_{selected_quote}_{idx}"
						key = f"status_{m_id}_{selected_quote}"
						st.session_state.update({
							f"need_details_{key}": True
						})
						# list_issues = st.session_state.setdefault(key, [])
						ask_details(key, idx, selected_quote, annotation)


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
					if (k_pdf_viewer in st.session_state) and isinstance(st.session_state[k_pdf_viewer],
																		 (dict, list, tuple)) and (
							k_c_a in st.session_state[k_pdf_viewer]):
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

					if st.button(
							label=f"Approve {selected_quote}",
							key=f"btn_approve_quote"
					):
						df_meeting_quotes.loc[
							df_meeting_quotes["Quote"] == selected_quote, ["Approved", "Reviewed"]] = True, True
						if st.session_state.get(f"status_{m_id}_{selected_quote}", None) is None:
							st.session_state[f"status_{m_id}_{selected_quote}"] = {}
						st.session_state[f"status_{m_id}_{selected_quote}"].update({
							k_df_meeting_quotes: df_meeting_quotes,
							f"approve_{selected_quote}_date": datetime.datetime.now(),
							f"approve_{selected_quote}_by": "Avery Briggs"
						})
						st.rerun()
					print(f"AA == {pdf_file=}")
					st_pdf_viewer = pdf_viewer(
						input=load_pdf_binary(pdf_file),
						width=s_w,
						# key=f"kp_{k_pdf_viewer}",
						annotations=parsed_annotations,
						on_annotation_click=pdf_click_callback,
						annotation_outline_size=2,
						pages_vertical_spacing=10
					)
					# st.session_state.update({k_pdf_viewer: st.session_state.get(f"kp_{k_pdf_viewer}")})
					st.session_state.update({k_pdf_viewer: st_pdf_viewer})
					print(f"{st_pdf_viewer=}")
					if isinstance(st_pdf_viewer, (dict, list)):
						if k_c_a in st_pdf_viewer:
							print("_A")
							if st_pdf_viewer[k_c_a]:
								print("_B")
								annotation = st_pdf_viewer[k_c_a]
								idx = annotation.get("index")
								key = f"issues_{selected_quote}_{idx}"
								if not st.session_state.get(key, True):
									print("_C")
									st_pdf_viewer.pop(k_c_a)
									st.session_state.update({
										f"need_details_{key}": False
									})
								else:
									print("_D")
							else:
								print("_E")
						else:
							print("_F")
					st.write(st_pdf_viewer)

				# TODO add a submit issue button at the bottom of the screen
				# if st.button(
				# 	label="Issue",
				# 	key="btn_issue_quote"
				# ):
				# 	df_meeting_quotes.loc[df_meeting_quotes["Quote"] == selected_quote, ["Approved", "Reviewed"]] = False, True
				#
				# 	idx = annotation.get("index")
				# 	page = annotation.get("page")
				# 	x = annotation.get("x")
				# 	y = annotation.get("y")
				# 	w = annotation.get("width")
				# 	h = annotation.get("height")
				# 	c = annotation.get("color")
				# 	bbox = (x, y, x + w, y + h)
				# 	et = annotation.get("text")
				# 	# line_texts = ';; '.join([line['text'] for line in et])
				# 	# print(f"{line_texts=}")
				# 	text = annotation.get("text")
				# 	print(f"ANNOTATION (P={page}, I={idx}) ({x=}, {y=}) => {text=}")
				# 	key = f"issues_{selected_quote}_{idx}"
				# 	st.session_state.update({
				# 		f"need_details_{key}": True
				# 	})
				# 	# list_issues = st.session_state.setdefault(key, [])
				# 	ask_details(key, selected_quote, annotation)
				#
				# 	# st.session_state.update({
				# 	# 	k_df_meeting_quotes: df_meeting_quotes,
				# 	# 	f"approve_{selected_quote}_date": datetime.datetime.now(),
				# 	# 	f"approve_{selected_quote}_by": "Avery Briggs"
				# 	# })
				# 	st.rerun()

if m_id is not None:
	if st.button(
			label=f"End Meeting #{m_id}",
			key=f"k_end_meeting"
	):

		editing = not df_meeting_notes.loc[df_meeting_notes["MeetingID"] == m_id].empty
		if editing:
			sql = ("""
UPDATE
	[BWSdb].[dbo].[WSOM_MeetingNotes]
SET
		
			""").strip()
		else:
			sql = ("""
INSERT INTO
	[BWSdb].[dbo].[WSOM_MeetingNotes]
			""").strip()

		# for k, v in st.session_state.items():
		# 	print(f"{k=}, {v=}")

		df_meetings_results = st.session_state.get(k_df_meeting_quotes)

		print("k_df_meeting_quotes")
		print(df_meetings_results)

		# new_quotes = []
		# for i, row in df_meetings_results.iterrows():

		# TODO iterate through meeting quotes and set the approved status to the the table
		connect(sql, do_exec=False, do_print=True, do_show=True)
		st.session_state.update({
			k_meeting_id: None,
			k_df_meeting_quotes: None
		})
		cont.empty()
		st.rerun()

if st.session_state.get("need_rerun", False):
	st.session_state.update({"need_rerun": False})
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
# 		st_pdf_viewer(
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
# # from streamlit_pdf_viewer import st_pdf_viewer
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
# # list_meeting_folders = [d for d in os.listdir(r"\\bwsfp01\public\SALES OFFICE\Weekly WO Meetings") if d != "Scripts"]
# # st.multiselect(
# # 	label="SELECT",
# # 	options=list_meeting_folders,
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
# # 		st_pdf_viewer(
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
