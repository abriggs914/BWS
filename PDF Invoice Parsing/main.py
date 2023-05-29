import asyncio
import time
import os
import pandas as pd
import PyPDF2
from utility import *


# def parse_pdf(dir):
#     # text, qtys, p_nums, revs, prices, amounts, invoice, order
#     return 0, 1, 2, 3, 4, 5, 6, 7


async def process_pdf(fn, files, qtys, p_nums, revs, prices, amounts, invoices, orders):
    # fn = r"C:\Users\ABriggs\Downloads\2023-04 LASER AMP 244246 PO 140194 POSTED.pdf"

    print(f"processing '{fn}'")

    # open the PDF file in binary mode
    with open(fn, 'rb') as f:
        # create a PDF reader object
        pdf_reader = PyPDF2.PdfFileReader(f)
        # pdf_reader = PdfReader(f)
        # read each page of the PDF file
        text = ''
        for page_num in range(pdf_reader.numPages):
            page = pdf_reader.getPage(page_num)
            # extract text from the page
            page_text = page.extractText()
            # append the text from this page to the overall text
            text += page_text

    splitter = 0, "Price Montant"
    num_pages = text.count(splitter[1])
    print(f"{text=}")
    print(f"{num_pages=}")
    if num_pages == 0:
        splitter = 1, "Montant / amount"
        num_pages = text.count(splitter[1])
        print(f"NEW {num_pages=}")

    if num_pages == 0:
        splitter = -1, ""

    print(f"{splitter=}")
    rows = text.split(splitter[1])
    # print(f"A {values=}")
    # rows = values.split("\n")
    columns = [
        "Qté /qty",
        "Numéro de pièce / Part Number",
        "Rev.",
        "Prix /Price",
        "Montant / amount"
    ]
    print(f"{rows=}")
    # invoice, order = "INVOICE", "ORDER"
    invoice_number = None
    order_number = None
    for row in rows:
        if row:
            vals_list = list(row.split("\n"))  # [1].split(" ")
            # print("\nVALS")
            # print_by_line(vals)
            for val_s in vals_list:
                print(f"{val_s=}")
                if "No.:" in val_s:
                    print(f"FOUND 1 {val_s=}")
                    invoice_number = int(val_s.split("No.:")[-1].strip())
                    order_number = int(val_s.split("No.:")[0].split(" ")[-1].strip())

                vals = val_s.split(" ")
                if len(vals) > 1:
                    try:
                        # print(f"{row=}, {vals=}, {splitter=}")
                        if splitter[0] == 0:
                            qty_part_number, rev, price, amount = vals
                            part_number = qty_part_number.split("-")[-1]
                            idx = qty_part_number.index("-")
                            part_number = f"{qty_part_number[idx - 5:idx]}-{part_number}"
                            qty = int(qty_part_number[:idx][:-5])
                        else:
                            part_number, qty, amount, price, rev = vals

                        qty = int(qty)
                        rev = int(rev)
                        # print(f"{qty=}, {part_number=}, {int(rev)=}, {money_value(price)=}, {money_value(amount)=}")
                    except (TypeError, ValueError) as e:
                        # print(f"{e=}")
                        pass
                    else:
                        # print(f"ELSE")
                        qtys.append(qty)
                        p_nums.append(part_number)
                        revs.append(rev)
                        prices.append(price)
                        amounts.append(amount)
                        invoices.append(invoice_number)
                        orders.append(order_number)
                        files.append(fn)
    print(f"{text=}, {files=}, {qtys=}, {p_nums=}, {revs=}, {prices=}, {amounts=}, {invoices=}, {orders=}")
    return text, qtys, p_nums, revs, prices, amounts, invoices, orders


async def test_batch_laser_amp(stop_num=None):
    timings["batch_start"] = time.time()
    root_laser_amp = r"\\nas1\Public\Accounts Payable\AP - BWS Manufacturing\Posted\Laser AMP"
    sub_dirs = [(f"{root_laser_amp}\\{s_d}", "", "") for s_d in os.listdir(root_laser_amp)]

    i = 0
    files = {}
    file_template = [
        "file_name",
        "dir",
        "s_dir",
        "text_extracted",
        "invoice",
        "order_number",
        "data"
    ]
    data_template = [
        "qty",
        "part_number",
        "rev",
        "price",
        "amount"
    ]

    while sub_dirs:
        a, b, c = sub_dirs.pop(0)
        # s_s_dirs = '\n'.join(a)
        # print(f"\n{i=}\n{files=}\ns_s_dirs=\n{s_s_dirs}")
        dir = a
        if os.path.isfile(dir):
            # text, qtys, p_nums, revs, prices, amounts, invoice, order = parse_pdf(dir)
            # data_values = [qtys, p_nums, revs, prices, amounts]
            # data = dict(zip(data_template, data_values))
            data = {}
            # file_values = [dir, b, c, text, invoice, order, data]
            file_values = [dir, b, c, None, None, None, data]
            files[dir] = dict(zip(file_template, file_values))
        elif os.path.isdir(dir):
            for s_dir in os.listdir(dir):
                # print(f"{dir=}, {s_dir=}")
                sub_dirs.append((f"{dir}\\{s_dir}", dir, s_dir))
        else:
            print(f"unsure what to do with path '{dir}'")
        i += 1

    tasks = []
    # print(f"{files=}")
    print(f"{len(files)=}")
    qtys, files_l, p_nums, revs, prices, amounts, invoices, orders = [], [], [], [], [], [], [], []
    for i, file in enumerate(files):
        tasks.append(asyncio.create_task(process_pdf(file, files_l, qtys, p_nums, revs, prices, amounts, invoices, orders)))
        if (i + 1) == stop_num:
            break
        # text, qtys, p_nums, revs, prices, amounts, invoice, order = parse_pdf(dir)
        # data_values = [qtys, p_nums, revs, prices, amounts]
        # data = dict(zip(data_template, data_values))

    timings["batch_end"] = time.time()
    return asyncio.gather(*tasks)


    # for i, f_name in enumerate(files):


if __name__ == "__main__":

    timings = {"program_start": time.time()}

    results = asyncio.run(test_batch_laser_amp(1))
    print(f"{results=}")
    print(f"{type(results)=}")
    print(f"{dir(results)=}")
    print(f"{results.result=}")
    timings["program_end"] = time.time()
    print(dict_print(timings, "Timings"))

    # files[file]["data"] = dict()
    #
    # print(f"{files=}")
    # print(f"{len(files)=}")
    # df = pd.DataFrame(files)
    # print(f"\n\tdf\n{df}")
