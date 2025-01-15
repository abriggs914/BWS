
# version 202501142025

import_success: bool = False

try:
	import os
	import datetime

	import pdfplumber
	from PyPDF2 import PdfMerger

	from utility import next_available_file_name

	import_success = True

except (ModuleNotFoundError, ImportError) as e:
	print(f"\nImport Errors:")
	print(f"{e}")


def merge_pdfs_from_folder(
		folder_path: str,
		quote_order: list[str],
		output_file: str = "merged_output.pdf"
) -> str:
	"""
	Merges all PDF files in a specified folder into a single PDF file.

	Args:
		folder_path (str): The path to the folder containing PDF files.
		quote_order (list[str)): The order of quotes to reference when ordering the PDFs. Read from itinerary_file.
		output_file (str): The name of the output merged PDF file (default: "merged_output.pdf").

	Returns:
		str: The path to the merged output file.
	"""

	print(f"Starting...")
	start_time = datetime.datetime.now()

	# Check if the folder exists
	if not os.path.exists(folder_path):
		raise FileNotFoundError(f"The folder '{folder_path}' does not exist.")

	if not os.path.exists(os.path.join(folder_path, itinerary_file)):
		raise FileNotFoundError(f"The Itinerary file '{itinerary_file}' does not exist.")

	files = []

	print(f"Searching...")

	# Iterate through files in the folder
	for filename in sorted(os.listdir(folder_path)):
		# Check if the file is a PDF
		if filename.lower().endswith(".pdf"):
			if filename != itinerary_file:
				file_path = os.path.join(folder_path, filename)
				# print(f"Adding: {file_path}")
				files.append(file_path)

	print(f"Combining...")

	# Create a PdfMerger object
	merger = PdfMerger()
	merger.append(os.path.join(folder_path, itinerary_file))

	for i, quote_number in enumerate(quote_order):
		if not isinstance(quote_number, str):
			quote_number = str(quote_number)
		for j, file_name in enumerate(files):
			if f"q{quote_number}.pdf".lower() in file_name.lower():
				merger.append(file_name)

	print(f"Saving...")

	# Save the merged PDF to the specified output file
	output_path = os.path.join(folder_path, output_file)
	merger.write(output_path)
	merger.close()

	end_time = datetime.datetime.now()
	print(f"Finished...")
	print(f"Merged PDF saved as: {output_path}")
	print(f"Results in {(end_time - start_time).total_seconds()} second(s)")
	return output_path


def extract_quote_column(pdf_file_path, column_name="Quote #"):
	"""
	Extract data from a specific column in a table within a PDF.

	Args:
		pdf_file_path (str): Path to the PDF file.
		column_name (str): Name of the column to extract (default: "Quote").

	Returns:
		list: A list of values from the specified column.
	"""
	quotes = []

	# Open the PDF file using pdfplumber
	with pdfplumber.open(pdf_file_path) as pdf:
		for page in pdf.pages:
			# Extract tables from the page
			tables = page.extract_tables()
			for table in tables:
				# Check if the column name exists in the table header
				if column_name in table[0]:  # table[0] is assumed to be the header row
					# Get the index of the desired column
					col_index = table[0].index(column_name)

					# Extract data from the column
					quotes += [row[col_index] for row in table[1:] if len(row) > col_index]
	return quotes


# Example usage
if __name__ == "__main__":

	if import_success:
		# prep_date = datetime.datetime(2025, 1, 14)
		prep_date = datetime.datetime.today()

		output_file = r"merged_output.pdf"
		folder_path = fr"\\bwsfp01\Public\SALES OFFICE\Weekly WO Meetings\{prep_date:%Y-%m-%d}"

		output_file = next_available_file_name(os.path.join(folder_path, output_file))
		output_file = os.path.basename(output_file)

		itinerary_file = fr"WO_Meeting_{prep_date:%Y-%m-%d}.pdf"
		if os.path.exists(os.path.join(folder_path, itinerary_file)):
			quote_order = extract_quote_column(
				os.path.join(folder_path, itinerary_file)
			)
			# print(f"{quote_order=}")

			merge_pdfs_from_folder(
				folder_path,
				quote_order,
				os.path.join(folder_path, output_file)
			)
		else:
			print(f"Please follow the steps to create an Itinerary file first.")

	input("Hit 'Enter' to quit.")
