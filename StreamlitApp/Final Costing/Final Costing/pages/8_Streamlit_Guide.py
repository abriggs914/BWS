# normal imports
import os

# aliases
import streamlit as st

# 3rd-party modules
from streamlit_pdf_viewer import pdf_viewer


# Constants
# -  session_state not required (yet)
pdf_width = 1200
pdf_height = 600
root_pdf_folder = r"\\server4.bwsdomain.local\Design\DRAWINGS\Promos\9E) PROMOS BY MODEL 2025\Tags (2025)"


# First section of a streamlit Application
# this line can only be called once, and should be called at the beginning.
st.set_page_config(
	layout="wide",
	page_title="Streamlit Demo"
)


# Helper Functions


@st.cache_data(ttl=None, show_spinner=True)
def load_pdfs():
	# Function stores the list of pdfs in the cache, making successive reruns go faster.
	return [
		file
		for file in os.listdir(root_pdf_folder)
		if file.lower().endswith(".pdf")
	]


@st.cache_data(ttl=None, show_spinner=True)
def load_pdf_binary(pdf_file):
	# Handle opening and reading of the pdf file, caching the results.
	with open(pdf_file, "rb") as f:
		return f.read()


# Begin streamlit widgets
if not os.path.exists(root_pdf_folder):
	# check folder exists before proceeding
	st.error(NotADirectoryError(f"Could not find '{root_pdf_folder}'."))
	st.stop()


# Gather data
# for a small dataset, looping the folder everytime is fine
# pdf_files = [
# 	file
# 	for file in os.listdir(root_pdf_folder)
# 	if file.lower().endswith(".pdf")
# ]
# for larger datasets, the data should be cached.
pdf_files = load_pdfs()


if pdf_files:

	# maintain keys as variables to save typing and typos.
	k_selectbox_file = f"k_selectbox_file"
	selectbox_file = st.selectbox(
		label="Choose a File:",
		placeholder="select a file",
		key=k_selectbox_file,
		options=pdf_files
	)

	# Use safe accessors to st.session_state to maintain variable integrity
	# st.session_state[k_selectbox_file]  may produce KeyError or return None
	pdf_name = st.session_state.get(k_selectbox_file, "")

	if pdf_name:
		pdf_path = os.path.join(root_pdf_folder, pdf_name)
		file_binary = load_pdf_binary(pdf_path)
		st.write(pdf_path)

		# Some widgets have unexpected behaviour when interacting with the session_state.
		# This widget in-particular will display the same PDF despite receiving a new binary.
		# removing the key returns the widget to normal functionality.
		# k_pdf_viewer = f"k_pdf_viewer"
		st_pdf_viewer = pdf_viewer(
			input=file_binary,
			width=pdf_width
			# , key=k_pdf_viewer
		)
	else:
		st.write(f"Select a PDF file first.")
else:
	# Tell user no files were found, the pdf_viewer and selectbox widgets are not even rendered here.
	st.info(f"No PDF files were found in this folder '{root_pdf_folder}'.")