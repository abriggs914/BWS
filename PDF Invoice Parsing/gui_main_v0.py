import asyncio
import os
import re
import time
import tkinter

import PyPDF2
import pandas as pd
import screeninfo

from tkinter.filedialog import askdirectory

from PyPDF2 import PdfReader

from datetime_utility import date_str_format
from tkinter_utility import *
from utility import get_largest_monitor, is_money, print_by_line, next_available_file_name

LEN_ORDER_NUMBER = 6


def collect_files(root_in):
    # print(f"COLLECTING!")

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
            data = {k: None for k in data_template}
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


class App(tkinter.Tk):

    def __init__(self, width="zoomed", height="zoomed"):
        super().__init__()

        self.dims_root = self.calc_geometry(width, height)

        self.timings = {}

        # self.tv_last_directory = tkinter.StringVar(self, value=os.getcwd())
        self.tv_last_directory = tkinter.StringVar(self,
                                                   value=r"\\nas1\Public\Accounts Payable\AP - BWS Manufacturing\Posted\Laser AMP")
        self.tv_list_directories = tkinter.Variable(self, value=[])
        self.tv_list_files = tkinter.Variable(self, value=[])
        self.tv_data = tkinter.Variable(self, value={})
        self.tv_data.trace_variable("w", self.update_data())

        self.frame_listviews = tkinter.Frame(self, name="listviews")

        self.tv_lbl_listview_dir, \
            self.lbl_listview_dir, \
            self.tv_listview_dir, \
            self.listview_dir = \
            list_factory(
                self.frame_listviews,
                tv_label="Directorie(s):",
                tv_list=self.tv_list_directories.get(),
                kwargs_list={
                    "width": 120
                }
            )

        self.tv_lbl_listview_file, \
            self.lbl_listview_file, \
            self.tv_listview_file, \
            self.listview_file = \
            list_factory(
                self.frame_listviews,
                tv_label="File(s):",
                tv_list=self.tv_list_files.get(),
                kwargs_list={
                    "width": 120
                }
            )

        self.frame_control_btns = tkinter.Frame(self, name="ctl_btns")

        self.tv_btn_new_directory, \
            self.btn_new_directory, = \
            button_factory(
                self.frame_control_btns,
                tv_btn="+",
                command=self.click_ask_for_file
            )

        self.tv_btn_clear_files, \
            self.btn_clear_files, = \
            button_factory(
                self.frame_control_btns,
                tv_btn="clear",
                command=self.click_clear_files
            )

        self.tv_btn_parse_files, \
            self.btn_parse_files, = \
            button_factory(
                self.frame_control_btns,
                tv_btn="parse",
                command=self.click_parse_files
            )

        self.tv_btn_see_data, \
            self.btn_see_data, = \
            button_factory(
                self.frame_control_btns,
                tv_btn="see data",
                command=self.click_see_data
            )

        self.frame_listviews.grid()
        self.lbl_listview_dir.grid(row=0, column=0)
        self.lbl_listview_file.grid(row=0, column=1)
        self.listview_dir.grid(row=1, column=0)
        self.listview_file.grid(row=1, column=1)
        self.frame_control_btns.grid(columnspan=2)
        self.btn_new_directory.grid(row=0, column=0)
        self.btn_clear_files.grid(row=0, column=1)
        self.btn_parse_files.grid(row=0, column=2)
        self.btn_see_data.grid(row=0, column=3)

        self.bind("<Control-p>", self.click_ctrl_p)
        self.bind("<Control-o>", self.click_ctrl_o)
        self.bind("<Control-i>", self.click_ctrl_i)

    def click_ctrl_p(self, event=None):
        print(f"click_ctrl_p {event=}")
        self.tv_list_directories.set(
            [r"\\nas1\Public\Accounts Payable\AP - BWS Manufacturing\Posted\Laser AMP\2021\August 2021"])
        self.tv_listview_dir.set(
            [r"\\nas1\Public\Accounts Payable\AP - BWS Manufacturing\Posted\Laser AMP\2021\August 2021"])

    def click_ctrl_o(self, event=None):
        self.click_ctrl_p(event)
        self.click_parse_files()

    def click_ctrl_i(self, event=None):
        self.tv_list_directories.set(
            [r"\\nas1\Public\Accounts Payable\AP - BWS Manufacturing\Posted\Laser AMP\2023\4. APR 2023"])
        self.tv_listview_dir.set(
            [r"\\nas1\Public\Accounts Payable\AP - BWS Manufacturing\Posted\Laser AMP\2023\4. APR 2023"])
        self.click_parse_files()

    def calc_geometry(self, width, height):
        self.x_, self.y_, self.width_, self.height_ = self.calc_monitor_dims()
        t_width, t_height = self.width_, self.height_

        if isinstance(height, float):
            assert 0 < height < 1, "Error, if param 'height' is a float, it must be between 0 and 1."
            height = int(height * self.height_)

        if isinstance(width, float):
            assert 0 < width < 1, "Error, if param 'width' is a float, it must be between 0 and 1."
            width = int(width * self.width_)

        if width == height == "zoomed":
            self.state(width)
        else:
            if width == "zoomed":
                self.x_ = 0
                height_c = clamp(1, height, self.height_)
                self.y_ = (self.height_ - height_c) // 2
                self.height_ = height
            elif height == "zoomed":
                self.y_ = 0
                width_c = clamp(1, width, self.width_)
                self.x_ = (self.width_ - width_c) // 2
                self.width_ = width
            else:
                width_c = clamp(1, width, self.width_)
                height_c = clamp(1, height, self.height_)
                x = (self.width_ - width_c) // 2
                y = (self.height_ - height_c) // 2
                self.x_, self.y_, self.width_, self.height_ = x, y, width_c, height_c

            # print(f"x={self.x_}, y={self.y_}, w={self.width_}, h={self.height_}" + f"geo=({self.width_}x{self.height_}+{self.x_}+{self.y_})")
            self.geometry(f"{self.width_}x{self.height_}+{self.x_}+{self.y_}")
        return self.x_, self.y_, self.width_, self.height_

    def update_data(self):
        print(f"{self.tv_data.get()=}")

    def click_ask_for_file(self):
        dir_path = askdirectory(initialdir=self.tv_last_directory.get())
        dir_parent = os.path.dirname(dir_path)
        self.tv_last_directory.set(dir_parent)
        print(f"\n{self.tv_list_directories.get()=}")
        c_val = self.tv_list_directories.get() if self.tv_list_directories.get() else []
        print(f"{dir_path=}\n{dir_parent=}\n{c_val=}")
        c_val = (*c_val, dir_path)
        self.tv_list_directories.set(c_val)
        self.tv_listview_dir.set(c_val)

    def click_clear_files(self):
        self.tv_list_directories.set([])
        self.tv_listview_dir.set([])

    def click_see_data(self):
        print(f"{self.tv_data.get()=}")

    def click_parse_files(self):

        async def helper(d, print_test=False, stop_num=None):
            return await self.async_click_parse_files(d, print_test=print_test, stop_num=stop_num)

        col_names = ["page_idxs", "fails", "qtys", "passes", "p_nums", "revs", "prices", "amounts", "invoices",
                     "orders"]

        with open("./Outputs/" + date_str_format(
                datetime.datetime.now(),
                file_name=True
        ), "w") as f:
            for direc in self.tv_list_directories.get():

                # fut = asyncio.ensure_future(self.async_click_parse_files(direc))
                # results = loop.run_until_complete(fut)
                # print(f"1 - {results=}")
                # results = results.result()
                # print(f"2 - {results=}")

                # fut = asyncio.ensure_future(helper(direc))
                # results = loop.run_until_complete(fut)

                results = asyncio.run(helper(direc, print_test=True, stop_num=1))
                # results = loop.run_until_complete(fut)
                # print(f"1 - {type(results)=}")
                results = results.result()

                print(f"{type(results)=}")
                print(f"{type(results)=}")

                # for col, lst in zip(col_names, results):
                #     f.write(f"{col} = {lst}")
                df_cols = [
                    "file_name",
                    "page_idx",
                    "qty",
                    "part_num",
                    "rev",
                    "price",
                    "amount",
                    "invoice",
                    "order"
                ]
                df = pd.DataFrame(columns=df_cols)

                for i, lst in enumerate(results):
                    # print(f"{lst[:20]}")
                    print(f"{len(lst)=}")
                    f.write(f"\t{i}\n")
                    for j, sub_lst in enumerate(lst):
                        f.write(f"{col_names[j].ljust(10)}{str(len(sub_lst)).ljust(3)}\t{sub_lst}\n")
                    break

            l_page_idxs, l_fails, l_qtys, l_passes, l_p_nums, l_amounts, l_prices, l_revs, l_invoices, l_orders = \
            results[0]

            for i, z_values in enumerate(
                    zip(l_passes, l_page_idxs, l_qtys, l_p_nums, l_revs, l_prices, l_amounts, l_invoices, l_orders)):
                df.loc[i] = z_values

            print(f"{df}")
            out_file = "./Outputs/" + date_str_format(datetime.datetime.now(), file_name=True)
            df.to_excel(next_available_file_name(out_file + ".xlsx"))

            with open(next_available_file_name(out_file + ".txt"), "w") as f:
                f.write("Failed to parse these files:\n")
                if not l_fails:
                    f.write(f"\nAll files passed!\n")
                for file in l_fails:
                    f.write(f"{file}\n")

            # print(f"2 - {results=}")
            # df = pandas.DataFrame(columns=col_names)
            # failed = results[1]
            # passed = results[3]
            # print(f"{failed=}")
            # print(f"{passed=}")
            # for i in range()

    async def async_click_parse_files(self, root_in=None, stop_num=None, print_test=False):

        page_idxs, fails, qtys, passes, p_nums, revs, prices, amounts, invoices, orders = [], [], [], [], [], [], [], [], [], []
        self.timings.update({"start_collect_files": time.time()})
        if isinstance(root_in, (tuple, list)):
            # print(f"A")
            files = root_in
        else:
            # print(f"B")
            files = collect_files(root_in)

        print(f"{files.keys()=}")
        print(f"{type(files)=}")
        print(f"{self.tv_data=}")
        print(f"{self.tv_list_files=}")
        print(f"{type(self.tv_data)=}")
        print(f"{type(self.tv_list_files)=}")
        old_files = self.tv_data.get()
        self.tv_data.set((*old_files, *files))
        self.tv_list_files.set(files)
        old_files = self.tv_list_files.get()
        self.tv_list_files.set((*old_files, *files))
        self.timings.update({"end_collect_files": time.time()})
        file = None
        stop_num = stop_num if stop_num is not None else len(files)
        tasks = []
        self.timings.update({"start_task_creation": time.time()})
        for i, file in enumerate(files):
            # tasks.append(asyncio.create_task(process_pdf(file, fails, files_l, qtys, p_nums, revs, prices, amounts, invoices, orders)))
            tasks.append(asyncio.create_task(
                self.process_pdf(
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
        self.timings.update({"end_task_creation": time.time()})
        return asyncio.gather(*tasks)

    async def process_pdf(self, fn, page_idxs, fails, qtys, passes, p_nums, revs, prices, amounts, invoices, orders,
                          print_test=False):

        print(f"processing '{fn}'")

        text = ""
        pages_real_pages = []

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
        print(f"FINISHED LAMBDAS")

        invoices_l, orders_l = [], []

        i = 0
        try:

            # open the PDF file in binary mode
            with open(fn, 'rb') as f:
                # create a PDF reader object
                # pdf_reader = PyPDF2.PdfFileReader(f)
                pdf_reader = PdfReader(f)
                # read each page of the PDF file
                # for page_num in range(pdf_reader.numPages):
                # print(f"{pdf_reader=}")
                # assert pdf_reader is not None, "Else IS NONE"
                for page_num in range(len(pdf_reader.pages)):
                    # page = pdf_reader.getPage(page_num)
                    page = pdf_reader.pages[page_num]
                    # extract text from the page
                    # page_text = page.extractText()
                    page_text = page.extract_text()
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
            # if print_test:
            #     print(f"{text=}")
            #     print(f"{num_pages=}")
            #     print(f"{splitter=}")
            pages_real_pages = text.split(splitter[1])  # [1:]
            invoice_match, order_match = None, None

            print(f"{len(pages_real_pages)=}")

            for i, page in enumerate(pages_real_pages):

                try:
                    print(f"{i}-{page=}")
                    la_idx = lstindex(page, "laseramp")
                    assert la_idx >= 0 or (
                                (i + 1) == len(pages_real_pages)), f"Error 'laseramp' not found on page {i + 1}."

                    if print_test:
                        print(f"\nNewPage {i}")

                    # if invoice_number == None and order_number == None:
                    re_check_order_1 = False
                    re_check_order_2 = False
                    iv_idx = lstindex(page, in_spl_invoice)
                    # if print_test:
                    #     print(f"{iv_idx=}, {page=}")
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
                        # if print_test:
                        #     print(f"\t\t{p_a=}, {p_b=}, {p_c}, {(p_b - p_c)=}")
                        if l_match and ((len(p_a)) - len(in_spl_invoice) == LEN_ORDER_NUMBER) and any(
                                [r_match1, r_match2]):
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
                        # if print_test:
                        #     print(f"B> {iv_idx=} {l_match=}, {left=}\n{r_match=}, {right=}")
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
                        right = in_spl_order_2 + (page[iv_idx:].replace(in_spl_order_2, "").split(" ")[0]).replace(" ",
                                                                                                                   "")
                        l_match = re.search(r'(\d+)' + in_spl_order_2, left)
                        r_match = re.search(in_spl_order_2 + r'(\d+)', right)
                        # if print_test:
                        #     print(f"C> {iv_idx=} {l_match=}, {left=}\n{r_match=}, {right=}")
                        if r_match:
                            order_match = r_match.group(1)
                            # if print_test:
                            #     print(f"\n\t1-0 {order_match=}")
                        elif l_match:
                            order_match = l_match.group(1)
                            # if print_test:
                            #     print(f"\n\t1-1 {order_match=}")
                        else:
                            order_match = None
                            # if print_test:
                            #     print(f"\n\t1-2 {order_match=}")

                    if invoice_match:
                        invoice_number = invoice_match.replace(in_spl_invoice, "")
                        invoices_l.append(invoice_number)
                    if order_match:
                        order_number = order_match
                        orders_l.append(order_number)

                    page_lines = [pl for pl in page.split("\n") if (pl.count("$") == 2) or (in_spl_invoice in pl)]
                    # page_lines = [pl.replace(in_spl_invoice, f"{in_spl_invoice} ") for pl in page.split("\n") if (pl.count("$") == 2) or (in_spl_invoice in pl)]
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
                            # if print_test:
                            #     print("! 5 !")
                            a, b, c, d, e = vals
                            if is_money(a) and "$" in a:
                                # money value first
                                a, b, c, d, e = e, d, c, b, a
                            l_vals = [a, b, c, d, e]

                        if is_money(l_vals[-2]) and is_money(l_vals[-1]):
                            # if print_test:
                            #     print(f"\t{a=}, {b=}, {c=}, {d=}")
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
                            print(f"ELSE")
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
                except (ValueError, AttributeError, KeyError, NameError, TypeError, IndexError, AssertionError) as e2:
                    print(f"FAILURE, {fn=}, {e2=}")
                    # raise e2
                    fails.append((fn, i + 1, e2))

            # if print_test:
            #     print(f"{invoices_l=}")
            #     print(f"{orders_l=}")
            for j, idx in enumerate(page_idxs):
                invoices[j] = invoices_l[idx]
                orders[j] = orders_l[idx]

        except (ValueError, AttributeError, KeyError, NameError, TypeError, IndexError, AssertionError) as e1:
            # print(f"FAILURE")
            # raise e
            fails.append((fn, i + 1, e1))

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
                                     ("invoices_l", invoices),
                                     ("orders_l", orders)
                                 ]])
            print(f"{s_lists}")

        return page_idxs, fails, qtys, passes, p_nums, revs, prices, amounts, invoices, orders

    def calc_monitor_dims(self):
        monitors = screeninfo.get_monitors()

        for mon in monitors:
            print(f"{mon=}")

        lm = get_largest_monitor()
        print(f"\n{lm}")
        return lm.x, lm.y, lm.width, lm.height


if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    # app = App(height=300)
    app = App(width=0.75, height=0.75)
    app.mainloop()
