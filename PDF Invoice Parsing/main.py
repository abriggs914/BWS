import asyncio
import time
import os
import pandas as pd
import PyPDF2
from utility import *


# def parse_pdf(dir):
#     # text, qtys, p_nums, revs, prices, amounts, invoice, order
#     return 0, 1, 2, 3, 4, 5, 6, 7


async def process_pdf(fn, fails, files, qtys, p_nums, revs, prices, amounts, invoices, orders):
    # fn = r"C:\Users\ABriggs\Downloads\2023-04 LASER AMP 244246 PO 140194 POSTED.pdf"

    print(f"processing '{fn}'")

    f0, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10 = [True for i in range(11)]
    text = ""

    try:

        # open the PDF file in binary mode
        with open(fn, 'rb') as f:
            # create a PDF reader object
            pdf_reader = PyPDF2.PdfFileReader(f)
            # pdf_reader = PdfReader(f)
            # read each page of the PDF file
            for page_num in range(pdf_reader.numPages):
                page = pdf_reader.getPage(page_num)
                # extract text from the page
                page_text = page.extractText()
                # append the text from this page to the overall text
                text += page_text
        f0 = False

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
        f1 = False
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
                    f0, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10 = [True for i in range(11)]
                    print(f"{val_s=}")
                    if "No.:" in val_s:
                        print(f"FOUND 1 {val_s=}")
                        invoice_number = int(val_s.split("No.:")[-1].strip())
                        f2 = False
                        order_number = int(val_s.split("No.:")[0].split(" ")[-1].strip())
                        f3 = False

                    vals = val_s.split(" ")
                    if len(vals) > 1:
                        try:
                            # print(f"{row=}, {vals=}, {splitter=}")
                            if splitter[0] == 0:
                                qty_part_number, rev, price, amount = vals
                                f4 = False
                                part_number = qty_part_number.split("-")[-1]
                                f5 = False
                                idx = qty_part_number.index("-")
                                f6 = False
                                part_number = f"{qty_part_number[idx - 5:idx]}-{part_number}"
                                f7 = False
                                qty = int(qty_part_number[:idx][:-5])
                                f8 = False
                            else:
                                part_number, qty, amount, price, rev = vals
                                f4 = False

                            qty = int(qty)
                            f9 = False
                            rev = int(rev)
                            f10 = False
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
    except (ValueError, TypeError, KeyError, AttributeError):
        msg = ""
        if f0:
            # all failed except text
            print(f"f0 -- {fn}")
            msg = "all failed except text"
        if f1:
            # splitting failed
            print(f"f1 -- {fn}")
            msg = "splitting failed"
        if f2:
            # invoice_number failed
            print(f"f2 -- {fn}")
            msg = "invoice_number failed"
        if f3:
            # order_number failed
            print(f"f3 -- {fn}")
            msg = "order_number failed"
        if f4:
            # unpacking vals failed
            print(f"f4 -- {fn}")
            msg = "unpacking vals failed"
        if f5:
            # qty_part_number split failed
            print(f"f5 -- {fn}")
            msg = "qty_part_number split failed"
        if f6:
            # qty_part_number index failed
            print(f"f6 -- {fn}")
            msg = "qty_part_number index failed"
        if f7:
            # part_number slicing failed
            print(f"f7 -- {fn}")
            msg = "part_number slicing failed"
        if f8:
            # int qty_number failed
            print(f"f8 -- {fn}")
            msg = "int qty_number failed"
        if f9:
            # int qty failed
            print(f"f9 -- {fn}")
            msg = "int qty failed"
        if f10:
            # int rev failed
            print(f"f10 -- {fn}")
            msg = "int rev failed"

        fails.append(f"{fn}|||{msg}")

    print(f"{fails=}, {text=}, {files=}, {qtys=}, {p_nums=}, {revs=}, {prices=}, {amounts=}, {invoices=}, {orders=}")
    return fails, text, files, qtys, p_nums, revs, prices, amounts, invoices, orders


async def test_batch_laser_amp(stop_num=None):
    timings["batch_start"] = time.time()
    root_laser_amp = r"\\nas1\Public\Accounts Payable\AP - BWS Manufacturing\Posted\Laser AMP"
    sub_dirs = [(f"{root_laser_amp}\\{s_d}", "", "") for s_d in os.listdir(root_laser_amp)]

    i = 0
    files = {}
    file_template = [
        "file_name",
        "p_dir",
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

    k1 = None

    while sub_dirs:
        a, b, c = sub_dirs.pop(0)
        # s_s_dirs = '\n'.join(a)
        # print(f"\n{i=}\n{files=}\ns_s_dirs=\n{s_s_dirs}")
        p_dir = a
        if os.path.isfile(p_dir) and p_dir.endswith(".pdf"):
            if k1 is None:
                k1 = p_dir
            # text, qtys, p_nums, revs, prices, amounts, invoice, order = parse_pdf(p_dir)
            # data_values = [qtys, p_nums, revs, prices, amounts]
            # data = dict(zip(data_template, data_values))
            data = {}
            # file_values = [p_dir, b, c, text, invoice, order, data]
            file_values = [p_dir, b, c, None, None, None, data]
            files[p_dir] = dict(zip(file_template, file_values))
        elif os.path.isdir(p_dir):
            for s_dir in os.listdir(p_dir):
                # print(f"{p_dir=}, {s_dir=}")
                sub_dirs.append((f"{p_dir}\\{s_dir}", p_dir, s_dir))
        else:
            print(f"unsure what to do with path '{p_dir}'")
        i += 1

    tasks = []
    # print(f"{files=}")
    print(f"{k1=}")
    print(f"{len(files)=}")
    print(f"{list(files.keys())=}")
    print(f"{list(files[k1].keys())=}")
    print(f"\n\n\tfiles[k1]\n")
    for i, k_v in enumerate(files[k1].items()):
        k, v = k_v
        print(f"{i=}, {k=}, {v=}")
    print(f"\n\n")
    # print(f"{list(files[k1]['data'])=}")
    fails, qtys, files_l, p_nums, revs, prices, amounts, invoices, orders = [], [], [], [], [], [], [], [], []
    for i, file in enumerate(files):
        tasks.append(asyncio.create_task(process_pdf(file, fails, files_l, qtys, p_nums, revs, prices, amounts, invoices, orders)))
        if (i + 1) == stop_num:
            break
        # text, qtys, p_nums, revs, prices, amounts, invoice, order = parse_pdf(p_dir)
        # data_values = [qtys, p_nums, revs, prices, amounts]
        # data = dict(zip(data_template, data_values))

    timings["batch_end"] = time.time()
    return asyncio.gather(*tasks)


    # for i, f_name in enumerate(files):


if __name__ == "__main__":

    timings = {"program_start": time.time()}

    results = asyncio.run(test_batch_laser_amp())
    print(f"{results=}")
    print(f"{type(results)=}")
    print(f"{dir(results)=}")
    results = results.result()
    print(f"{results=}")
    print(f"{len(results)=}")
    timings["program_end"] = time.time()
    print(dict_print(timings, "Timings"))

    fails, text, files, qtys, p_nums, revs, prices, amounts, invoices, orders = results[0]
    with open(r"C:\Users\ABriggs\Documents\BWS\PDF Invoice Parsing\output" + f"{datetime.datetime.now():%Y-%m-%d}" + ".txt", "w") as f:
        f.write(f"\n{len(fails)=}, {fails=}",)
        f.write(f"\n{len(text)=}, {text=}")
        f.write(f"\n{len(files)=}, {files=}")
        f.write(f"\n{len(qtys)=}, {qtys=}")
        f.write(f"\n{len(p_nums)=}, {p_nums=}")
        f.write(f"\n{len(revs)=}, {revs=}")
        f.write(f"\n{len(prices)=}, {prices=}")
        f.write(f"\n{len(amounts)=}, {amounts=}")
        f.write(f"\n{len(invoices)=}, {invoices=}")
        f.write(f"\n{len(orders)=}, {orders=}")

    # files[file]["data"] = dict()
    #
    # print(f"{files=}")
    # print(f"{len(files)=}")
    # df = pd.DataFrame(files)
    # print(f"\n\tdf\n{df}")
