import asyncio
import time
import re
import os
from collections import OrderedDict

import pandas
import pandas as pd
import PyPDF2

from datetime_utility import date_str_format
from utility import *


# Rule 1
# Laser Amp Order Numbers MUST be 6 digits.
LEN_ORDER_NUMBER = 6

# Rule 2
# Laser Amp Part Numbers come in 2 varieties:
#   -   Including a '-' in the 5th (0-index) position, surrounded by a number of characters.
#   -   ex:
#   -       00108-40973198
#   -       00108-40973156
#   -   Including the prefix '242.' followed by some number of characters.
#   -   ex:
#   -       242.40994128
#   -       242.22200870
#
# This is critical for parsing the quantities value.


# def parse_pdf(dir):
#     # text, qtys, p_nums, revs, prices, amounts, invoice, order
#     return 0, 1, 2, 3, 4, 5, 6, 7


def collect_files(root_in):

    timings["batch_start"] = time.time()
    root_laser_amp = r"\\nas1\Public\Accounts Payable\AP - BWS Manufacturing\Posted\Laser AMP"
    root_laser_amp = root_laser_amp if root_in is None else root_in
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
    return files


async def process_pdf(fn, page_idxs, fails, qtys, passes, p_nums, revs, prices, amounts, invoices, orders, print_test=False):

    print(f"processing '{fn}'")

    text = ""
    pages = []

    def f1(s):
        i = s.index("-")
        return s[:i - 5], s[i - 5:i] + s[i:]

    def f2(s):
        i = s.index("242.")
        return s[:i], s[i:]

    known_prefixes = OrderedDict({
        "242.": lambda s: f2(s),
        "-": lambda s: f1(s)
    })

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

        # t1 = "Expédié via / Ship Via No commande / Order number Incoterms Termes / Terms Date No client Customer No. Page"
        # print(f"{text.count(t1)=}")

        invoice_number = None
        order_number = None
        splitter = 0, "Page"
        in_spl_invoice = "No.:"
        in_spl_order_1 = "TermsIncoterms"
        in_spl_order_2 = "PICK-UP "
        num_pages = text.count(splitter[1])
        if print_test:
            print(f"{text=}")
            print(f"{num_pages=}")
            print(f"{splitter=}")
        pages = text.split(splitter[1])  # [1:]
        invoices_l, orders_l = [], []
        invoice_match, order_match = None, None

        for i, page in enumerate(pages):

            if print_test:
                print(f"\nNewPage {i}")

            # if invoice_number == None and order_number == None:
            re_check_order_1 = False
            re_check_order_2 = False
            iv_idx = lstindex(page, in_spl_invoice)
            if print_test:
                print(f"{iv_idx=}, {page=}")
            if iv_idx >= 0:
                left = (page[:iv_idx]).strip().split(" ")[-1] + in_spl_invoice
                right1 = page[iv_idx:].split(" ")[0].strip()
                right2 = f"{in_spl_invoice} " + (page[iv_idx:].split(" ")[1]).strip()
                # check right first:
                l_match = re.search(r'(\d+)' + in_spl_invoice, left)
                r_match1 = re.search(in_spl_invoice + r'(\d+)', right1)
                r_match2 = re.search(in_spl_invoice + r' (\d+)', right2)
                if print_test:
                    print(f"A> {iv_idx=} {l_match=}, {left=}\n{r_match1=}, {right1=}\n{r_match2=}, {right2=}")
                if r_match1:
                    invoice_match = r_match1.group(1)
                elif r_match2:
                    invoice_match = r_match2.group(1)
                else:
                    invoice_match = l_match.group(1)

                p_a = l_match.group(0)
                p_b = len(p_a)
                p_c = len(in_spl_invoice)
                if print_test:
                    print(f"\t\t{p_a=}, {p_b=}, {p_c}, {(p_b - p_c)=}")
                if l_match and ((len(p_a)) - len(in_spl_invoice) == LEN_ORDER_NUMBER) and any([r_match1, r_match2]):
                    order_match = p_a.replace(in_spl_invoice, "")
                    re_check_order_1 = False
                else:
                    re_check_order_1 = True

            if order_match is None and iv_idx < 0:
                re_check_order_1 = True

            if re_check_order_1:
                # order number not found
                iv_idx = lstindex(page, in_spl_order_1)
                left = (page[:iv_idx].split(" ")[-1] + in_spl_order_1).replace("\n", "")
                right = (page[iv_idx:].split(" ")[0]).replace("\n", "")
                l_match = re.search(r'(\d+)' + in_spl_order_1, left)
                r_match = re.search(in_spl_order_1 + r'(\d+)', right)
                if print_test:
                    print(f"B> {iv_idx=} {l_match=}, {left=}\n{r_match=}, {right=}")
                if r_match:
                    order_match = r_match.group(1)
                    re_check_order_2 = False
                    if print_test:
                        print(f"\n\t0-0 {order_match=}")
                elif l_match:
                    order_match = l_match.group(1)
                    re_check_order_2 = False
                    if print_test:
                        print(f"\n\t0-1 {order_match=}")
                else:
                    re_check_order_2 = True

            if re_check_order_2:
                # order number not found
                iv_idx = lstindex(page, in_spl_order_2)
                left = (page[:iv_idx].split(" ")[-1] + in_spl_order_2).replace(" ", "")
                right = in_spl_order_2 + (page[iv_idx:].replace(in_spl_order_2, "").split(" ")[0]).replace(" ", "")
                l_match = re.search(r'(\d+)' + in_spl_order_2, left)
                r_match = re.search(in_spl_order_2 + r'(\d+)', right)
                if print_test:
                    print(f"C> {iv_idx=} {l_match=}, {left=}\n{r_match=}, {right=}")
                if r_match:
                    order_match = r_match.group(1)
                    if print_test:
                        print(f"\n\t1-0 {order_match=}")
                elif l_match:
                    order_match = l_match.group(1)
                    if print_test:
                        print(f"\n\t1-1 {order_match=}")
                else:
                    order_match = None
                    if print_test:
                        print(f"\n\t1-2 {order_match=}")

            if invoice_match:
                invoice_number = invoice_match.replace(in_spl_invoice, "")
                invoices_l.append(invoice_number)
            if order_match:
                order_number = order_match
                orders_l.append(order_number)

            page_lines = [pl for pl in page.split("\n") if (pl.count("$") == 2) or ("No.:" in pl)]
            values = [pl.split(" ")[:5] for pl in page_lines if len(pl.split(" ")) >= 4]
            if print_test:
                print(f"{page_lines=}\n{values=}")
            for j, vals in enumerate(values):
                if len(vals) == 4:
                    a, b, c, d = vals
                    if is_money(a) and "$" in a:
                        # money value first
                        a, b, c, d = d, c, b, a
                    l_vals = [a, b, c, d]
                else:
                    if print_test:
                        print("! 5 !")
                    a, b, c, d, e = vals
                    if is_money(a) and "$" in a:
                        # money value first
                        a, b, c, d, e = e, d, c, b, a
                    l_vals = [a, b, c, d, e]


                if is_money(l_vals[-2]) and is_money(l_vals[-1]):
                    if print_test:
                        print(f"\t{a=}, {b=}, {c=}, {d=}")
                    if len(vals) == 4:
                        part_func_type = [key for key in known_prefixes.keys() if key in a][0]
                        part_type_func = known_prefixes[part_func_type]
                        qty, part_number = part_type_func(a)
                        rev, price, amount = b, c, d
                    else:
                        part_number = a
                        qty = b
                        rev, price, amount = c, d, e
                    if print_test:
                        print(f"{qty=}, {part_number=}, {rev=}, {price=}, {amount=}")
                    # print(f"ELSE")
                    page_idxs.append(i - 1)
                    qtys.append(qty)
                    p_nums.append(part_number)
                    revs.append(rev)
                    prices.append(price)
                    amounts.append(amount)
                    invoices.append(invoice_number)
                    orders.append(order_number)
                    passes.append(fn)
                else:
                    if print_test:
                        print(f"{i=} {j=}, PASS ON {vals=}")

    except (ValueError) as e:
        print(f"FAILURE")
        raise e

    if print_test:
        print(f"{invoices_l=}")
        print(f"{orders_l=}")
    for i, idx in enumerate(page_idxs):
        invoices[i] = invoices_l[idx]
        orders[i] = orders_l[idx]

    if print_test:
        print(f"\n\n\tFINAL\n")
        s_lists = "\n".join([f"{l_name.ljust(12)} len={len(lst)}, lst={lst}" for l_name, lst in
                         [
                             ("page_idxs", page_idxs),
                             ("fails", fails),
                             ("qtys", qtys),
                             ("passes", passes),
                             ("p_nums", p_nums),
                             ("revs", revs),
                             ("prices", prices),
                             ("amounts", amounts),
                             ("invoices", invoices),
                             ("orders", orders),
                             ("invoices_l", invoices_l),
                             ("orders_l", orders_l)
                         ]])
        print(f"{s_lists}")

    return page_idxs, fails, qtys, passes, p_nums, revs, prices, amounts, invoices, orders


async def test_batch_laser_amp(root_in=None, stop_num=None, print_test=False):

    page_idxs, fails, qtys, passes, p_nums, revs, prices, amounts, invoices, orders = [], [], [], [], [], [], [], [], [], []
    timings.update({"start_collect_files": time.time()})
    files = collect_files(root_in)
    timings.update({"end_collect_files": time.time()})
    file = None
    stop_num = stop_num if stop_num is not None else len(files)
    tasks = []
    timings.update({"start_task_creation": time.time()})
    for i, file in enumerate(files):
        # tasks.append(asyncio.create_task(process_pdf(file, fails, files_l, qtys, p_nums, revs, prices, amounts, invoices, orders)))
        tasks.append(asyncio.create_task(
            process_pdf(
                fn=file,
                page_idxs=page_idxs,
                fails=fails,
                qtys=qtys,
                passes=passes,
                p_nums=p_nums,
                revs=revs,
                prices=prices,
                amounts=amounts,
                invoices=invoices,
                orders=orders,
                print_test=print_test
        )))
        if (i + 1) >= stop_num:
            break
    timings.update({"end_task_creation": time.time()})
    return asyncio.gather(*tasks)


if __name__ == "__main__":

    timings = {"program_start": time.time()}

    t_root_1 = r"\\nas1\Public\Accounts Payable\AP - BWS Manufacturing\Posted\Laser AMP\2021\NOV 2021"
    t_root_2 = r"\\nas1\Public\Accounts Payable\AP - BWS Manufacturing\Posted\Laser AMP\2021\August 2021"
    t_root_3 = r"\\nas1\Public\Accounts Payable\AP - BWS Manufacturing\Posted\Laser AMP\2022\2. FEB 2022\LASER AMP 232142 NGR AND CREDIT 02"
    t_root = t_root_1
    # t_root = t_root_2
    # t_root = None

    # t_root_1 = None
    #
    # results = asyncio.run(
    #     test_batch_laser_amp(
    #         root_in=t_root_1,
    #         stop_num=1
    #     )
    # )
    # print(f"{results=}")
    # print(f"{type(results)=}")
    # print(f"{dir(results)=}")
    # results = results.result()
    # print(f"{results=}")
    # print(f"{len(results)=}")
    # timings["program_end"] = time.time()
    # timings.update({
    #     "program run time (ms)": timings["program_end"] - timings["program_start"],
    #     "batch run time (ms)": timings["batch_end"] - timings["batch_start"]
    # })
    # print(dict_print(timings, "Timings"))
    #
    # fails, text, files, qtys, p_nums, revs, prices, amounts, invoices, orders = results[0]
    # d = date_str_format(datetime.datetime.now(), file_name=True)
    # with open(r"C:\Users\ABriggs\Documents\BWS\PDF Invoice Parsing\output_" + d + ".txt", "w") as f:
    #     s_fails = '\n'.join(fails)
    #     s_files = '\n'.join(files)
    #     f.write(f"{len(fails)=},\n'\\n'.join(fails)={s_fails}",)
    #     f.write(f"\n{len(text)=}, {text=}")
    #     f.write(f"\n{len(files)=},\nfiles=\n{s_files}")
    #     f.write(f"\n{len(qtys)=}, {qtys=}")
    #     f.write(f"\n{len(p_nums)=}, {p_nums=}")
    #     f.write(f"\n{len(revs)=}, {revs=}")
    #     f.write(f"\n{len(prices)=}, {prices=}")
    #     f.write(f"\n{len(amounts)=}, {amounts=}")
    #     f.write(f"\n{len(invoices)=}, {invoices=}")
    #     f.write(f"\n{len(orders)=}, {orders=}")
    #
    # # files[file]["data"] = dict()
    # #
    # # print(f"{files=}")
    # # print(f"{len(files)=}")
    # # df = pd.DataFrame(files)
    # # print(f"\n\tdf\n{df}")


    # scratch(t_root_1)
    # scratch(t_root_2)
    results = asyncio.run(
        test_batch_laser_amp(
            # root_in=None,
            # root_in=t_root_1,
            # root_in=t_root_2,
            root_in=t_root_3,
            stop_num=None,
            # stop_num=20,
            # print_test=False
            print_test=True
        )
    )
    results = results.result()
    timings["program_end"] = time.time()
    timings.update({
        "program run time (ms)": timings["program_end"] - timings["program_start"],
        "collect files time (ms)": timings["end_collect_files"] - timings["start_collect_files"],
        "task creation time (ms)": timings["end_task_creation"] - timings["start_task_creation"]
    })
    # print(f"{results=}\n{type(results)=}")
    page_idxs, fails, files, qtys, p_nums,\
        revs, prices, amounts, invoices, orders \
        = results[0]
    data = [
        files, page_idxs, invoices,
        orders, p_nums, qtys,
        revs, prices, amounts
    ]
    transposed_data = list(zip(*data))
    df_passed = pd.DataFrame(
        columns=[
            "fileName", "pageNum", "invoiceNum",
            "orderNum", "partNum", "qty",
            "rev", "price", "amount"
        ],
        data=transposed_data
    )
    df_failed = pandas.DataFrame(columns=["fileName"], data=[[f] for f in fails])
    print(dict_print(timings, "Timings"))
    print(df_passed)
    print(f"{df_passed['partNum']}")

    output_file_passed = next_available_file_name(f"./output_passed_{datetime.datetime.now():%Y-%m-%d_%H%M}.json")
    output_file_failed = next_available_file_name(f"./output_failed_{datetime.datetime.now():%Y-%m-%d_%H%M}.json")
    df_passed.to_json(output_file_passed, orient="records")
    df_failed.to_json(output_file_failed, orient="records")
