import tkinter
from collections import OrderedDict

import datetime
import os
import shutil
import pandas as pd
from tkinter import messagebox, filedialog
import tkinter

from pyodbc_connection import connect
from tkinter_utility import label_factory, button_factory, calc_geometry_tl

# 2024-03-27
# Abriggs
# Program to read an excel file and copy network files from separate locations into one common location.


# TODO Allow for all part numbers to be copied to root excel from top level WO #
# TODO create PO # directory for all exported files.
#


title = "PO List File Copier"
# root_destination = r"\\bwsfp01.bwsdomain.local\public\Janet Orser\po\dont delete me"  # old 202403271957
read_file_root = r"\\bwsfp01.bwsdomain.local\public\Janet Orser\po\po copied files"
read_file = r"PO LIST.xlsx"
# read_file = r"PO LIST_testfile.xlsx"
root_location_pdfs = r"\\server4.bwsdomain.local\Design\VaultWorkspace_BWS\PDFS"
root_location_stg_pdfs = r"\\server4.bwsdomain.local\Design\VaultWorkspace_BWS\PDFS\STARGATE PDF"
root_location_dwg_dxf = r"\\server4.bwsdomain.local\Design\DRAWINGS"
root_location_stp = r"\\server4.bwsdomain.local\Design\SheetMetal_Step_Files_"
instructions = f"The file must contain only two columns of part numbers.\nDo not add headers or any other columns.\nIt must be called '{read_file}'.\nPlease contact IT for any additional help with this program."
quit_message = "\nHit enter to quit."


def quit_program(err_message=None):
    if err_message:
        print(err_message)
    input(quit_message)
    quit()


def output_message(msg, s_messages: list = None):

    win = tkinter.Tk()
    win.geometry(calc_geometry_tl(0.3, 0.5))
    win.title(title)

    def quit_window(*args):
        if after_id:
            win.after_cancel(after_id)
        win.destroy()

    def show_question():

        def click_export():
            of = f"output_{datetime.datetime.now():%Y%m%d%H%M%S}.txt"
            with open(of, "w") as f_:
                f_.write(msg)
            messagebox.showinfo(
                title,
                message=f"Successfully saved results!"
            )
            quit_window_q()

        def click_go_back():
            tl.destroy()

        def click_quit():
            # print(f"QUITTING")
            quit_window_q()

        def quit_window_q(*args):
            tl.destroy()
            win.destroy()

        tl = tkinter.Toplevel(win)
        tl.geometry(calc_geometry_tl(0.2, 0.2))

        tv_lbl_q, lbl_q = label_factory(
            tl,
            tv_label=f"Export these results?"
        )
        f_q = tkinter.Frame(tl)
        tv_btn_q_a, btn_q_a = button_factory(
            f_q,
            tv_btn=f"Export",
            command=click_export
        )
        tv_btn_q_b, btn_q_b = button_factory(
            f_q,
            tv_btn=f"Go Back",
            command=click_go_back
        )
        tv_btn_q_c, btn_q_c = button_factory(
            f_q,
            tv_btn=f"Quit Program",
            command=click_quit
        )
        lbl_q.pack()
        f_q.pack(padx=5, pady=5)
        btn_q_a.pack(side=tkinter.LEFT, padx=5, pady=5)
        btn_q_b.pack(side=tkinter.LEFT, padx=5, pady=5)
        btn_q_c.pack(side=tkinter.LEFT, padx=5, pady=5)
        tl.protocol("WM_DELETE_WINDOW", quit_window_q)
        tl.grab_set()
        win.wait_window(tl)

    # tv_lbl, lbl = label_factory(
    #     win,
    #     tv_label=msg
    # )
    # lbl.pack()
    f = tkinter.Frame(win)
    text = tkinter.Text(
        f,
        wrap=tkinter.WORD,
        width=60,
        height=18
    )
    f.pack(padx=5, pady=5)
    text.pack(side=tkinter.LEFT, fill=tkinter.BOTH, expand=True)

    if s_messages:
        f_s = tkinter.Frame(win)
        f_s.pack()
        for txt in s_messages:
            label_factory(
                f_s,
                tv_label=txt
            )[1].pack()

    scrollbar = tkinter.Scrollbar(f, command=text.yview)
    scrollbar.pack(side=tkinter.RIGHT, fill=tkinter.Y)

    text.config(yscrollcommand=scrollbar.set)
    text.insert(tkinter.END, msg)
    text.config(state=tkinter.DISABLED)

    win.protocol("WM_DELETE_WINDOW", quit_window)
    after_id = win.after(2400, show_question)
    win.mainloop()


if __name__ == '__main__':

    # check if all search locations and outputs exist
    for pth in [
        root_location_pdfs,
        root_location_stg_pdfs,
        root_location_dwg_dxf,
        root_location_stp,
        read_file_root
    ]:
        if not os.path.exists(pth):
            messagebox.showerror(
                title=title,
                message=f"The directory '{pth}' must exist for this program to run."
            )
            quit_program()

    read_file_path = os.path.join(read_file_root, read_file)
    if not os.path.exists(read_file_path):
        messagebox.showerror(
            title=title,
            message=f"The file '{read_file}' must exist in the directory '{read_file_root}' for this program to run.\n{instructions}"
        )
        quit_program()

    exec_times = OrderedDict()
    exec_times.update({"start_program": datetime.datetime.now()})

    try:
        df = pd.read_excel(read_file_path, index_col=None)
    except Exception as e:
        messagebox.showerror(
            title=title,
            message=f"Problem reading '{read_file}'.\n{instructions}"
        )
        print(e)
        quit_program()

    print(f"{df=}")

    if df.empty:
        messagebox.showerror(
            title=title,
            message=f"The file '{read_file}' is empty.\n{instructions}"
        )
        quit_program()
    else:
        valid_cols = {"PO", "COMP"}
        columns = set(list(df.columns))
        # print(f"{columns=}\n{valid_cols=}")
        if diff := valid_cols.symmetric_difference(columns):
            quit_program(f"Either necessary columns excluded {valid_cols=} OR unrecognized columns in the excel file {diff=}.")

    df = df.rename(
        columns={
            0: "PO",
            1: "COMP"
        }
    )
    df["PO"] = df['PO'].apply(lambda x: f"{x}".rjust(15, '0'))

    po_sql_bws = f""
    po_sql_stg = f""
    for i, data in df.iterrows():
        if data["COMP"].lower() == "s":
            if not po_sql_stg:
                po_sql_stg += f"SELECT '{data['PO']}' AS [PONum]"
            else:
                po_sql_stg += f" UNION SELECT '{data['PO']}'"
        else:
            if not po_sql_bws:
                po_sql_bws += f"SELECT '{data['PO']}' AS [PONum]"
            else:
                po_sql_bws += f" UNION SELECT '{data['PO']}'"
    sql_temp = """
SELECT
	[Por].[PurchaseOrder] AS [PO]
	, [Por].[MStockCode] AS [PN]
	, {COMP}
FROM
    [PorMasterDetail] [Por]
INNER JOIN (
{PO_SQL}
) AS [SrcA]
ON
	[Por].[PurchaseOrder] = [SrcA].[PONum]
"""
    sql_bws = sql_temp.format(PO_SQL=po_sql_bws, COMP=f"'B' AS [COMP]")
    sql_stg = sql_temp.format(PO_SQL=po_sql_stg, COMP=f"'S' AS [COMP]")

    # x = {
    #     'sql': sql_bws,
    #     'database': 'SysproCompanyA',
    #     'uid': 'SRS',
    #     'pwd': ''
    # }
    # y = {
    #         "sql": sql_stg,
    #         "database": "SysproCompanyS",
    #         "uid": "SCSRS",
    #         "pwd": ""
    #     }
    # print(f"X {connect(**x, do_print=True, do_show=True)}")
    # print(f"Y {connect(**y, do_print=True, do_show=True)}")

    df = pd.concat([
        connect(**{
            "sql": sql_bws,
            "database": "SysproCompanyA",
            "uid": "SRS",
            "pwd": ""
        }),
        connect(**{
            "sql": sql_stg,
            "database": "SysproCompanyS",
            "uid": "SCSRS",
            "pwd": ""
        })
        ],
        ignore_index=True
    )
    print(f"{df=}")

    # df = pd.DataFrame(columns=["PN"])

    # # test number
    # test_df = pd.DataFrame({"PN": ["40997777"]})
    # df = pd.concat([df, test_df])

    df["PDF"] = df['PN'].apply(lambda x: f"{x}.pdf")
    df["DXF"] = df['PN'].apply(lambda x: f"{x}.dxf")
    df["DWG"] = df['PN'].apply(lambda x: f"{x}.dwg")
    df["STP"] = df['PN'].apply(lambda x: f"{x}.stp")

    print(f"{df=}")

    u_pns = set(df["PN"].unique().tolist())
    pns = set(df["DXF"].unique().tolist()).union(set(df["DWG"].unique().tolist()))

    exec_times.update({"end df search read": datetime.datetime.now()})
    print(f"Finished collecting Part Numbers to search.")
    for pn in u_pns:
        print(f"\t{pn}")

    not_found = []
    found = {}
    if len(u_pns) > 0:
        print(f"About to search DWG and DXF directory.")
        walked_dwg_folder = os.walk(root_location_dwg_dxf)
        for dir_path, dir_names, file_names in walked_dwg_folder:
            for file in file_names:
                if file in pns:
                    file_dwg, file_dxf = None, None
                    if file.endswith(".dwg"):
                        df_loc = df.loc[df["DWG"] == file]["PN"]
                        if df_loc.shape[0] != 1:
                            quit_program(f"Too many 'DWG' files found for '{file}'")
                        df_idx = df_loc.index[0]
                        # print(f"A {df_idx=}\n{df_loc=}")
                        # pn = df.loc[df["DWG"] == file]["PN"].reset_index().iloc[0]["PN"]
                        pn = df_loc.iloc[0][0]
                        file_dwg = os.path.join(dir_path, file)
                    else:
                        df_loc = df.loc[df["DXF"] == file]["PN"]
                        if df_loc.shape[0] != 1:
                            quit_program(f"Too many 'DXF' files found for '{file}'")
                        df_idx = df_loc.index[0]
                        # print(f"B {df_idx=}\n{df_loc=}")
                        # pn = df.loc[df["DXF"] == file]["PN"].reset_index().iloc[0]["PN"]
                        pn = df_loc.iloc[0][0]
                        file_dxf = os.path.join(dir_path, file)
                    # print(f"Found: {pn=}")
                    file_pdf = os.path.join(root_location_pdfs, f"{pn}.pdf")
                    file_pdf_stg = os.path.join(root_location_stg_pdfs, f"{pn}.pdf")
                    if not os.path.exists(file_pdf):
                        if not os.path.exists(file_pdf_stg):
                            print(f"\tCouldn't find PDF: {file_pdf=}")
                            file_pdf = None
                        else:
                            file_pdf = file_pdf_stg

                    file_stp = os.path.join(root_location_stp, f"{pn}.stp")
                    if not os.path.exists(file_stp):
                        print(f"\tCouldn't find STP: {file_stp=}")
                        file_stp = None

                    if pn not in found:
                        found[pn] = {}
                    found[pn].update({
                        "PDF": file_pdf,
                        "DXF": file_dxf,
                        "DWG": file_dwg,
                        "STP": file_stp,
                        "IDX": df_idx
                    })
                # break
            # break
    else:
        print(f"No part numbers found to search")

    exec_times.update({"end df walk": datetime.datetime.now()})
    print(f"Finished walking DWG and DXF directory.")

    for pn in u_pns:
        if pn not in found:
            not_found.append(pn)

    print(f"About to copy found files to destination folder.")
    for pn, file_data in found.items():
        # dest_folder = os.path.join(root_destination, str(pn))
        # if not os.path.exists(dest_folder):
        #     os.mkdir(dest_folder)
        po_num = df.iloc[found[pn]["IDX"]]["PO"]
        dest_folder = os.path.join(read_file_root, f"{po_num}")
        if not os.path.isdir(dest_folder):
            os.makedirs(dest_folder)
        for ft, file in file_data.items():
            if ft != "IDX":
                if file is not None:
                    # dest_file = os.path.join(read_file_root, f"{pn}.{ft.lower()}")
                    dest_file = os.path.join(dest_folder, f"{pn}.{ft.lower()}")
                    if not os.path.exists(dest_file):
                        shutil.copyfile(file, dest_file)
    exec_times.update({"end df copying": datetime.datetime.now()})

    keys_exec_time = list(exec_times.keys())
    first_key = keys_exec_time[0]
    last_key = keys_exec_time[-1]
    t_program_time = (exec_times[last_key] - exec_times[first_key]).total_seconds()

    print(f"\n\nProgram Complete!\n\n")
    print(f"\tExecution Times")
    for k, v in exec_times.items():
        print(f"{k.ljust(50)}: {v:%H:%M:%S %p}")
    print(f"\n\tResults:\n\t\tFound:")
    for pn, pn_dat in found.items():
        print(f"\t\t\t{pn}:", end="")
        for k, v in pn_dat.items():
            if v is not None:
                print(f" {k}", end="")
        print(f"")
    if not_found:
        print(f"\t\tCould not find:")
    for pn in not_found:
        print(f"\t\t\t{pn}")
    t_program_time_msg = f"\nResults in {t_program_time:,.2f} second(s)"
    print(t_program_time_msg)

    s_messages = []
    if not_found:
        message = f"Could not locate a DXF or DWG file for the following part numbers:"
        for nf in not_found:
            message += f"\n\t{nf}"
        n_fails = len(not_found)
        p = 0 if (n_fails == 0) else ((len(u_pns) - n_fails) / n_fails) * 100
        s_messages.append(f"\n\n{len(u_pns) - n_fails} / {len(u_pns)} success rate ({p:.2f} %)")
    else:
        message = f"Completed without errors!"

    s_messages.append(f"\n\n{t_program_time_msg}")

    output_message(message, s_messages)
    # end_options = ["Export results", "Ok"]
    # ans = messagebox.askquestion(
    #     title=title,
    #     message=f"{message}"
    # )
    # if ans == end_options[0]:
    # print(f"{ans=}")
    input(quit_message)




# ###############################
# ###############################
#
#
# import tkinter
# from collections import OrderedDict
#
# import datetime
# import os
# import shutil
# import pandas as pd
# from tkinter import messagebox, filedialog
# import tkinter
#
# from pyodbc_connection import connect
# from tkinter_utility import label_factory, button_factory, calc_geometry_tl
#
# # 2024-03-27
# # Abriggs
# # Program to read an excel file and copy network files from separate locations into one common location.
#
#
# # TODO Allow for all part numbers to be copied to root excel from top level WO #
# # TODO create PO # directory for all exported files.
# #
#
#
# title = "PO List File Copier"
# # root_destination = r"\\bwsfp01.bwsdomain.local\public\Janet Orser\po\dont delete me"  # old 202403271957
# read_file_root = r"\\bwsfp01.bwsdomain.local\public\Janet Orser\po\po copied files"
# read_file = r"PO LIST.xlsx"
# read_file = r"PO LIST_testfile.xlsx"
# root_location_pdfs = r"\\server4.bwsdomain.local\Design\VaultWorkspace_BWS\PDFS"
# root_location_stg_pdfs = r"\\server4.bwsdomain.local\Design\VaultWorkspace_BWS\PDFS\STARGATE PDF"
# root_location_dwg_dxf = r"\\server4.bwsdomain.local\Design\DRAWINGS"
# root_location_stp = r"\\server4.bwsdomain.local\Design\SheetMetal_Step_Files_"
# instructions = f"The file must contain a single column of part numbers.\nDo not add headers or any other columns.\nIt must be called '{read_file}'.\nPlease contact IT for any additional help with this program."
# quit_message = "\nHit enter to quit."
#
#
# def quit_program(err_message=None):
#     if err_message:
#         print(err_message)
#     input(quit_message)
#     quit()
#
#
# def output_message(msg):
#
#     win = tkinter.Tk()
#     win.geometry(calc_geometry_tl(0.3, 0.5))
#     win.title(title)
#
#     def quit_window(*args):
#         if after_id:
#             win.after_cancel(after_id)
#         win.destroy()
#
#     def show_question():
#
#         def click_export():
#             print(f"EXPORTING")
#
#         def click_go_back():
#             tl.destroy()
#
#         def click_quit():
#             # print(f"QUITTING")
#             quit_window_q()
#
#         def quit_window_q(*args):
#             tl.destroy()
#             win.destroy()
#
#         tl = tkinter.Toplevel(win)
#         tl.geometry(calc_geometry_tl(0.2, 0.1))
#
#         tv_lbl_q, lbl_q = label_factory(
#             tl,
#             tv_label=f"Export these results?"
#         )
#         f_q = tkinter.Frame(tl)
#         tv_btn_q_a, btn_q_a = button_factory(
#             f_q,
#             tv_btn=f"Export",
#             command=click_export
#         )
#         tv_btn_q_b, btn_q_b = button_factory(
#             f_q,
#             tv_btn=f"Go Back",
#             command=click_go_back
#         )
#         tv_btn_q_c, btn_q_c = button_factory(
#             f_q,
#             tv_btn=f"Quit Program",
#             command=click_quit
#         )
#         lbl_q.pack()
#         f_q.pack(padx=5, pady=5)
#         btn_q_a.pack(side=tkinter.LEFT, padx=5, pady=5)
#         btn_q_b.pack(side=tkinter.LEFT, padx=5, pady=5)
#         btn_q_c.pack(side=tkinter.LEFT, padx=5, pady=5)
#         tl.protocol("WM_DELETE_WINDOW", quit_window_q)
#         tl.grab_set()
#         win.wait_window(tl)
#
#     # tv_lbl, lbl = label_factory(
#     #     win,
#     #     tv_label=msg
#     # )
#     # lbl.pack()
#     f = tkinter.Frame(win)
#     text = tkinter.Text(
#         f,
#         wrap=tkinter.WORD,
#         width=60,
#         height=60
#     )
#     f.pack(padx=5, pady=5)
#     text.pack(side=tkinter.LEFT, fill=tkinter.BOTH, expand=True)
#
#     scrollbar = tkinter.Scrollbar(f, command=text.yview)
#     scrollbar.pack(side=tkinter.RIGHT, fill=tkinter.Y)
#
#     text.config(yscrollcommand=scrollbar.set)
#     text.insert(tkinter.END, msg)
#     text.config(state=tkinter.DISABLED)
#
#     win.protocol("WM_DELETE_WINDOW", quit_window)
#     after_id = win.after(1500, show_question)
#     win.mainloop()
#
#
# if __name__ == '__main__':
#
#     # check if all search locations and outputs exist
#     for pth in [
#         root_location_pdfs,
#         root_location_stg_pdfs,
#         root_location_dwg_dxf,
#         root_location_stp,
#         read_file_root
#     ]:
#         if not os.path.exists(pth):
#             messagebox.showerror(
#                 title=title,
#                 message=f"The directory '{pth}' must exist for this program to run."
#             )
#             quit_program()
#
#     read_file_path = os.path.join(read_file_root, read_file)
#     if not os.path.exists(read_file_path):
#         messagebox.showerror(
#             title=title,
#             message=f"The file '{read_file}' must exist in the directory '{read_file_root}' for this program to run.\n{instructions}"
#         )
#         quit_program()
#
#     exec_times = OrderedDict()
#     exec_times.update({"start_program": datetime.datetime.now()})
#
#     try:
#         df = pd.read_excel(read_file_path, index_col=None)
#     except Exception as e:
#         messagebox.showerror(
#             title=title,
#             message=f"Problem reading '{read_file}'.\n{instructions}"
#         )
#         print(e)
#         quit_program()
#
#     if df.empty:
#         messagebox.showerror(
#             title=title,
#             message=f"The file '{read_file}' is empty.\n{instructions}"
#         )
#         quit_program()
#     else:
#         valid_cols = {"PO", "COMP"}
#         columns = set(list(df.columns))
#         # print(f"{columns=}\n{valid_cols=}")
#         if diff := valid_cols.symmetric_difference(columns):
#             quit_program(f"Either necessary columns excluded {valid_cols=} OR unrecognized columns in the excel file {diff=}.")
#
#     df = df.rename(
#         columns={
#             0: "PO",
#             1: "COMP"
#         }
#     )
#     df["PO"] = df['PO'].apply(lambda x: f"{x}".rjust(15, '0'))
#
#     po_sql_bws = f""
#     po_sql_stg = f""
#     for i, data in df.iterrows():
#         if data["COMP"].lower() == "s":
#             if not po_sql_stg:
#                 po_sql_stg += f"SELECT '{data['PO']}' AS [PONum]"
#             else:
#                 po_sql_stg += f" UNION SELECT '{data['PO']}'"
#         else:
#             if not po_sql_bws:
#                 po_sql_bws += f"SELECT '{data['PO']}' AS [PONum]"
#             else:
#                 po_sql_bws += f" UNION SELECT '{data['PO']}'"
#     sql_temp = """
# SELECT
# 	[Por].[PurchaseOrder] AS [PO]
# 	, [Por].[MStockCode] AS [PN]
# 	, {COMP}
# FROM
#     [PorMasterDetail] [Por]
# INNER JOIN (
# {PO_SQL}
# ) AS [SrcA]
# ON
# 	[Por].[PurchaseOrder] = [SrcA].[PONum]
# """
#     sql_bws = sql_temp.format(PO_SQL=po_sql_bws, COMP=f"'B' AS [COMP]")
#     sql_stg = sql_temp.format(PO_SQL=po_sql_stg, COMP=f"'S' AS [COMP]")
#
#     # x = {
#     #     'sql': sql_bws,
#     #     'database': 'SysproCompanyA',
#     #     'uid': 'SRS',
#     #     'pwd': ''
#     # }
#     # y = {
#     #         "sql": sql_stg,
#     #         "database": "SysproCompanyS",
#     #         "uid": "SCSRS",
#     #         "pwd": ""
#     #     }
#     # print(f"X {connect(**x, do_print=True, do_show=True)}")
#     # print(f"Y {connect(**y, do_print=True, do_show=True)}")
#
#     df = pd.concat([
#         connect(**{
#             "sql": sql_bws,
#             "database": "SysproCompanyA",
#             "uid": "SRS",
#             "pwd": ""
#         }),
#         connect(**{
#             "sql": sql_stg,
#             "database": "SysproCompanyS",
#             "uid": "SCSRS",
#             "pwd": ""
#         })
#         ],
#         ignore_index=True
#     )
#     print(f"{df=}")
#
#     # df = pd.DataFrame(columns=["PN"])
#
#     # # test number
#     # test_df = pd.DataFrame({"PN": ["40997777"]})
#     # df = pd.concat([df, test_df])
#
#     df["PDF"] = df['PN'].apply(lambda x: f"{x}.pdf")
#     df["DXF"] = df['PN'].apply(lambda x: f"{x}.dxf")
#     df["DWG"] = df['PN'].apply(lambda x: f"{x}.dwg")
#     df["STP"] = df['PN'].apply(lambda x: f"{x}.stp")
#
#     print(f"{df=}")
#
#     u_pns = set(df["PN"].unique().tolist())
#     pns = set(df["DXF"].unique().tolist()).union(set(df["DWG"].unique().tolist()))
#
#     exec_times.update({"end df search read": datetime.datetime.now()})
#     print(f"Finished collecting Part Numbers to search.")
#     for pn in u_pns:
#         print(f"\t{pn}")
#
#     not_found = []
#     found = {}
#     if len(u_pns) > 0:
#         print(f"About to search DWG and DXF directory.")
#         walked_dwg_folder = os.walk(root_location_dwg_dxf)
#         for dir_path, dir_names, file_names in walked_dwg_folder:
#             for file in file_names:
#                 if file in pns:
#                     file_dwg, file_dxf = None, None
#                     if file.endswith(".dwg"):
#                         df_loc = df.loc[df["DWG"] == file]["PN"]
#                         if df_loc.shape[0] != 1:
#                             quit_program(f"Too many 'DWG' files found for '{file}'")
#                         df_idx = df_loc.index[0]
#                         # print(f"A {df_idx=}\n{df_loc=}")
#                         # pn = df.loc[df["DWG"] == file]["PN"].reset_index().iloc[0]["PN"]
#                         pn = df_loc.iloc[0][0]
#                         file_dwg = os.path.join(dir_path, file)
#                     else:
#                         df_loc = df.loc[df["DXF"] == file]["PN"]
#                         if df_loc.shape[0] != 1:
#                             quit_program(f"Too many 'DXF' files found for '{file}'")
#                         df_idx = df_loc.index[0]
#                         # print(f"B {df_idx=}\n{df_loc=}")
#                         # pn = df.loc[df["DXF"] == file]["PN"].reset_index().iloc[0]["PN"]
#                         pn = df_loc.iloc[0][0]
#                         file_dxf = os.path.join(dir_path, file)
#                     # print(f"Found: {pn=}")
#                     file_pdf = os.path.join(root_location_pdfs, f"{pn}.pdf")
#                     file_pdf_stg = os.path.join(root_location_stg_pdfs, f"{pn}.pdf")
#                     if not os.path.exists(file_pdf):
#                         if not os.path.exists(file_pdf_stg):
#                             print(f"\tCouldn't find PDF: {file_pdf=}")
#                             file_pdf = None
#                         else:
#                             file_pdf = file_pdf_stg
#
#                     file_stp = os.path.join(root_location_stp, f"{pn}.stp")
#                     if not os.path.exists(file_stp):
#                         print(f"\tCouldn't find STP: {file_stp=}")
#                         file_stp = None
#
#                     if pn not in found:
#                         found[pn] = {}
#                     found[pn].update({
#                         "PDF": file_pdf,
#                         "DXF": file_dxf,
#                         "DWG": file_dwg,
#                         "STP": file_stp,
#                         "IDX": df_idx
#                     })
#                 break
#             break
#     else:
#         print(f"No part numbers found to search")
#
#     exec_times.update({"end df walk": datetime.datetime.now()})
#     print(f"Finished walking DWG and DXF directory.")
#
#     for pn in u_pns:
#         if pn not in found:
#             not_found.append(pn)
#
#     print(f"About to copy found files to destination folder.")
#     for pn, file_data in found.items():
#         # dest_folder = os.path.join(root_destination, str(pn))
#         # if not os.path.exists(dest_folder):
#         #     os.mkdir(dest_folder)
#         po_num = df.iloc[found[pn]["IDX"]]["PO"]
#         dest_folder = os.path.join(read_file_root, f"{po_num}")
#         if not os.path.isdir(dest_folder):
#             os.makedirs(dest_folder)
#         for ft, file in file_data.items():
#             if ft != "IDX":
#                 if file is not None:
#                     # dest_file = os.path.join(read_file_root, f"{pn}.{ft.lower()}")
#                     dest_file = os.path.join(dest_folder, f"{pn}.{ft.lower()}")
#                     if not os.path.exists(dest_file):
#                         shutil.copyfile(file, dest_file)
#     exec_times.update({"end df copying": datetime.datetime.now()})
#
#     keys_exec_time = list(exec_times.keys())
#     first_key = keys_exec_time[0]
#     last_key = keys_exec_time[-1]
#     t_program_time = (exec_times[last_key] - exec_times[first_key]).total_seconds()
#
#     print(f"\n\nProgram Complete!\n\n")
#     print(f"\tExecution Times")
#     for k, v in exec_times.items():
#         print(f"{k.ljust(50)}: {v:%H:%M:%S %p}")
#     print(f"\n\tResults:\n\t\tFound:")
#     for pn, pn_dat in found.items():
#         print(f"\t\t\t{pn}:", end="")
#         for k, v in pn_dat.items():
#             if v is not None:
#                 print(f" {k}", end="")
#         print(f"")
#     if not_found:
#         print(f"\t\tCould not find:")
#     for pn in not_found:
#         print(f"\t\t\t{pn}")
#     t_program_time_msg = f"\nResults in {t_program_time:,.2f} second(s)"
#     print(t_program_time_msg)
#
#     if not_found:
#         message = f"Could not locate a DXF or DWG file for the following part numbers:"
#         for nf in not_found:
#             message += f"\n\t{nf}"
#         n_fails = len(not_found)
#         p = 0 if (n_fails == 0) else ((len(u_pns) - n_fails) / n_fails) * 100
#
#         s_messages = [
#             f"\n\n{len(u_pns) - n_fails} / {len(u_pns)} success rate ({p:.2f} %)",
#             f"{t_program_time_msg}"
#         ]
#     else:
#         message = f"Completed without errors!"
#         message += f"\n\n{t_program_time_msg}"
#
#     output_message(message, p_message)
#     # end_options = ["Export results", "Ok"]
#     # ans = messagebox.askquestion(
#     #     title=title,
#     #     message=f"{message}"
#     # )
#     # if ans == end_options[0]:
#     # print(f"{ans=}")
#     input(quit_message)
