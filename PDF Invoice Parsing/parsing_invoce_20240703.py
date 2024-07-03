import datetime
import re

import pandas
import pandas as pd
import PyPDF2

if __name__ == "__main__":

    fn = r"U:\Quick files\Junk\Bom lines - Starg042.pdf"
    text = ""
    try:

        spl_header_page_title_1 = "Dexter Trailer Products of Canada Corporation"
        spl_header_page_title_2 = "Purchase Inventory"
        spl_header_1 = "\nItem number Item nameStandard\norder quantity\n"
        spl_header_2 = "\nItem number Item name Configuration Size Quantity\n"
        header_1_cols = ["Item number", "Item name", "Standard order quantity", "RAW"]
        header_2_cols = ["Item number", "Item name", "Configuration", "Size", "Quantity", "RAW"]

        table_1 = pd.DataFrame(columns=header_1_cols)
        table_2 = pd.DataFrame(columns=header_2_cols)

        # open the PDF file in binary mode
        with open(fn, 'rb') as f:
            # create a PDF reader object
            # pdf_reader = PyPDF2.PdfFileReader(f)
            pdf_reader = PyPDF2.PdfReader(f)
            # read each page of the PDF file
            # for page_num in range(pdf_reader.numPages):
            for page_num in range(len(pdf_reader.pages)):
                # page = pdf_reader.getPage(page_num)
                page = pdf_reader.pages[page_num]
                # extract text from the page
                # page_text = page.extractText()
                page_text = page.extract_text()
                # append the text from this page to the overall text
                text += page_text

        print(f"{text=}")

        l_text = text.lower()
        idx_spl_header_1 = l_text.index(spl_header_1.lower())
        idx_spl_header_2 = l_text.index(spl_header_2.lower())
        page_header = l_text[:idx_spl_header_1]
        text_table_1 = l_text[idx_spl_header_1 + len(spl_header_1): idx_spl_header_2]
        text_table_2 = l_text[idx_spl_header_2 + len(spl_header_2):]

        print(f"{page_header=}")

        print(f"TABLE 1")
        table_1_row_dfs = list()
        table_2_row_dfs = list()
        for i, line in enumerate(text_table_1.split("\n")):
            print(f"{line=}")
            s_line = line.split(" ")

            r_q_number = s_line[-1]
            if r_q_number:
                d_quantity = float(r_q_number)
            else:
                d_quantity = 0

            r_item_number = s_line[0]
            d_item_number = r_item_number

            r_item_name = s_line[1:-1]
            d_item_name = " ".join(r_item_name)

            table_1_row_dfs.append(pd.DataFrame(data={
                "Item number": [d_item_number],
                "Item name": [d_item_name],
                "Standard order quantity": [d_quantity],
                "RAW": line
            }))

        print(f"TABLE 2")
        for i, page in enumerate(text_table_2.split(spl_header_2)):
            print(f"Page {i+1}")
            handled_new_page = True
            new_page_next = False
            for j, line in enumerate(page.split("\n")):
                # print(f"HNP={handled_new_page}, NPN={new_page_next} {line=}")

                if not handled_new_page:
                    if spl_header_2.strip().lower() not in line:
                        print(f"CONT {line=}")
                    else:
                        handled_new_page = True
                    continue

                new_page_next = line.endswith(spl_header_page_title_1.lower())
                line = line.removesuffix(spl_header_page_title_1.lower())
                # if new_page_next:
                #     if spl_header_page_title_2.lower() not in line:
                #         print(f"CONT {line=}")
                #         continue

                s_line = line.split(" ")

                r_q_number = s_line[-1]
                d_quantity = float(r_q_number)

                r_s_number = s_line[-2]
                size_given = False
                r_w_s_number = "0"
                r_f_s_number = "0"
                # print(f"{r_s_number=}")
                if (r_s_number.count(".") == 1) and bool(re.match(r'^\d+(\.\d+)?$', r_s_number)):
                    s_r_s_number = r_s_number.split(".")
                    r_w_s_number = s_r_s_number[0]
                    r_f_s_number = s_r_s_number[-1]
                    if r_w_s_number.isdigit() and r_f_s_number.isdigit():
                        size_given = True

                r_s_number = float(f"{r_w_s_number}.{r_f_s_number}")
                d_size = r_s_number

                # TODO UNSURE
                d_config = ""

                r_item_number = s_line[0]
                d_item_number = r_item_number

                r_item_name = s_line[1:(-2 if size_given else -1)]
                d_item_name = " ".join(r_item_name)

                table_2_row_dfs.append(pd.DataFrame(data={
                    "Item number": [d_item_number],
                    "Item name": [d_item_name],
                    "Configuration": [d_config],
                    "Size": [d_size],
                    "Quantity": [d_quantity],
                    "RAW": line
                }))

                if new_page_next:
                    handled_new_page = False

        df_table_1 = pd.concat([table_1, *table_1_row_dfs])
        df_table_2 = pd.concat([table_2, *table_2_row_dfs])

        excel_path = f"output_{datetime.datetime.now():%Y%m%d%H%M}.xlsx"

        # Create a Pandas Excel writer using XlsxWriter as the engine
        with pd.ExcelWriter(excel_path, engine='xlsxwriter') as writer:
            # Write each DataFrame to a different worksheet
            df_table_1.to_excel(writer, sheet_name='Sheet1', index=False)
            df_table_2.to_excel(writer, sheet_name='Sheet2', index=False)

        # print(f"TABLE_1\n{df_table_1.shape=}\n{df_table_1}")
        # print(f"TABLE_2\n{df_table_2.shape=}\n{df_table_2}")
    except (ValueError, AttributeError, KeyError, NameError, TypeError, IndexError, AssertionError) as e:
        print(f"FAILURE")
        raise e
