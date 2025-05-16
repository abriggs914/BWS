import streamlit as st
import os
import pdfplumber


resume_path = r"C:\Users\abriggs\Documents\Coding_Practice\Python\Job Hunting\resume.pdf"


@st.cache_data()
def read_resume(path):
	text_data = {}
	with pdfplumber.open(path) as pdf:
		for page in pdf.pages:
			# text_data[page.page_number] = page.extract_text_lines()
			# text_data[page.page_number] = page.extract_words()
			# text_data[page.page_number] = page.extract_tables()
			text_data[page.page_number] = page.objects
	return text_data


if not os.path.exists(resume_path):
	st.error(f"cannot find '{resume_path}'")
else:
	st.write("g2g")
	st.write(read_resume(resume_path))
