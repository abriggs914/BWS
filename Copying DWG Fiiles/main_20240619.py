import tkinter
from collections import OrderedDict

import datetime
import os
import shutil
import pandas as pd
from tkinter import messagebox, filedialog
from tkinter_utility import button_factory, calc_geometry_tl,label_factory

# 2024-03-27
# Abriggs
# Program to read an excel file and copy network files from separate locations into one common location.


# TODO Allow for all part numbers to be copied to root excel from top level WO #
# TODO create PO # directory for all exported files.
#


class POFileCopier(tkinter.Tk):

    def __init__(self, *args, **kwargs):
        super().__init__()

        self.title_app = "PO List File Copier"
        # root_destination = r"\\bwsfp01.bwsdomain.local\public\Janet Orser\po\dont delete me"  # old 202403271957
        self.read_file_root = r"\\bwsfp01.bwsdomain.local\public\Janet Orser\po\po copied files"
        self.read_file = r"PO LIST.xlsx"
        self.root_location_pdfs = r"\\server4.bwsdomain.local\Design\VaultWorkspace_BWS\PDFS"
        self.root_location_stg_pdfs = r"\\server4.bwsdomain.local\Design\VaultWorkspace_BWS\PDFS\STARGATE PDF"
        self.root_location_dwg_dxf = r"\\server4.bwsdomain.local\Design\DRAWINGS"
        self.root_location_stp = r"\\server4.bwsdomain.local\Design\SheetMetal_Step_Files_"
        self.instructions = f"The file must contain a single column of part numbers.\nDo not add headers or any other columns.\nIt must be called '{read_file}'.\nPlease contact IT for any additional help with this program."
        self.quit_message = "\nHit enter to quit."

        self.geometry(calc_geometry_tl(1.0, 1.0))
        self.title(self.title_app)

        messagebox.showinfo(
            self.title_app,
            f"This version of the program can only process 1 PO number's parts list at a time.\nYou will need to re-run it for each PO."
        )
        self.ans = messagebox.askyesnocancel(
            self.title_app,
            f"Do you want to save the copied files to a new folder?"
        )
        if self.ans == tkinter.YES:
            self.output_location = filedialog.askdirectory()
            if not output_location:
                self.output_location = self.read_file_root
        elif self.ans == tkinter.NO:
            self.output_location = self.read_file_root
        else:
            print(f"Quitting program.")
            self.quit_window()

        # check if all search locations and outputs exist
        for pth in [
            self.root_location_pdfs,
            self.root_location_stg_pdfs,
            self.root_location_dwg_dxf,
            self.root_location_stp,
            self.read_file_root
        ]:
            if not os.path.exists(pth):
                messagebox.showerror(
                    title=self.title_app,
                    message=f"The directory '{pth}' must exist for this program to run."
                )
                input(self.quit_message)
                quit()

        self.read_file_path = os.path.join(self.read_file_root, self.read_file)
        if not os.path.exists(self.read_file_path):
            messagebox.showerror(
                title=self.title_app,
                message=f"The file '{self.read_file}' must exist in the directory '{self.read_file_root}' for this program to run.\n{self.instructions}"
            )
            input(self.quit_message)
            quit()

        self.exec_times = OrderedDict()
        self.exec_times.update({"start_program": datetime.datetime.now()})

        try:
            self.df = pd.read_excel(self.read_file_path, index_col=None, header=None)
        except Exception as e:
            messagebox.showerror(
                title=self.title_app,
                message=f"Problem reading '{self.read_file}'.\n{self.instructions}"
            )
            print(e)
            input(self.quit_message)
            quit()

        if self.df.empty:
            messagebox.showerror(
                title=self.title_app,
                message=f"The file '{self.read_file}' is empty.\n{self.instructions}"
            )
            input(self.quit_message)
            quit()

        self.df = self.df.rename(columns={
            0: "PN"
        })
        # df = pd.DataFrame(columns=["PN"])

        # # test number
        # test_df = pd.DataFrame({"PN": ["40997777"]})
        # df = pd.concat([df, test_df])

        self.df["PDF"] = self.df['PN'].apply(lambda x: f"{x}.pdf")
        self.df["DXF"] = self.df['PN'].apply(lambda x: f"{x}.dxf")
        self.df["DWG"] = self.df['PN'].apply(lambda x: f"{x}.dwg")
        self.df["STP"] = self.df['PN'].apply(lambda x: f"{x}.stp")

        self.u_pns = set(self.df["PN"].unique().tolist())
        self.pns = set(self.df["DXF"].unique().tolist()).union(
            set(self.df["DWG"].unique().tolist()).union(set(self.df["PDF"].unique().tolist())))
        # pns = {str(pn) for pn in pns}

        self.exec_times.update({"end df search read": datetime.datetime.now()})
        print(f"Finished collecting Part Numbers to search.")
        for pn in self.u_pns:
            print(f"\t{pn}")
        # for pn in pns:
        #     print(f"\t{pn}")
        # print(f"{df=}")

        print(f"About to search DWG and DXF directory.")
        self.walked_dwg_folder = os.walk(self.root_location_dwg_dxf)
        self.not_found = []
        self.found = {}
        for dir_path, dir_names, file_names in self.walked_dwg_folder:
            # print(f"{len(file_names)=}, {file_names[:5]:}")
            for file in file_names:
                # if file.endswith(".pdf") and len(file) < 15:
                #     print(f"{file=}")
                # file_prefix = "".join(file.split(".")[:-1])
                # if file_prefix in pns:
                if file in self.pns:
                    file_dwg, file_dxf = None, None
                    suffix = file.split(".")[-1].upper()
                    if file.endswith(".dwg"):
                        pn = self.df.loc[df[suffix] == file]["PN"].reset_index().iloc[0]["PN"]
                        file_dwg = os.path.join(dir_path, file)
                    else:
                        pn = self.df.loc[df[suffix] == file]["PN"].reset_index().iloc[0]["PN"]
                        file_dxf = os.path.join(dir_path, file)
                    # print(f"Found: {pn=}")
                    file_pdf = os.path.join(self.root_location_pdfs, f"{pn}.pdf")
                    file_pdf_stg = os.path.join(self.root_location_stg_pdfs, f"{pn}.pdf")
                    if not os.path.exists(file_pdf):
                        print(f"\t ** Couldn't find PDF: {file_pdf=}")
                        if not os.path.exists(file_pdf_stg):
                            print(f"\t *** Couldn't find STG PDF: {file_pdf_stg=}")
                            file_pdf = None
                        else:
                            print(f"\tFOUND STG PDF: {file_pdf=}")
                            file_pdf = file_pdf_stg
                    else:
                        print(f"\tFOUND PDF: {file_pdf=}")
                        file_pdf = file_pdf

                    file_stp = os.path.join(self.root_location_stp, f"{pn}.stp")
                    if not os.path.exists(file_stp):
                        print(f"\tCouldn't find STP: {file_stp=}")
                        file_stp = None

                    if pn not in self.found:
                        self.found[pn] = {}
                    self.found[pn].update({
                        "PDF": file_pdf,
                        "DXF": file_dxf,
                        "DWG": file_dwg,
                        "STP": file_stp
                    })
        self.exec_times.update({"end df walk": datetime.datetime.now()})
        print(f"Finished walking DWG and DXF directory.")

        for pn in self.u_pns:
            if pn not in self.found:
                self.not_found.append(pn)

        print(f"About to copy found files to destination folder.")
        for pn, file_data in self.found.items():
            # dest_folder = os.path.join(root_destination, str(pn))
            # if not os.path.exists(dest_folder):
            #     os.mkdir(dest_folder)
            for ft, file in file_data.items():
                if file is not None:
                    # dest_file = os.path.join(read_file_root, f"{pn}.{ft.lower()}")
                    dest_file = os.path.join(self.output_location, f"{pn}.{ft.lower()}")
                    if not os.path.exists(dest_file):
                        shutil.copyfile(file, dest_file)
        self.exec_times.update({"end df copying": datetime.datetime.now()})

        self.keys_exec_time = list(self.exec_times.keys())
        self.first_key = keys_exec_time[0]
        self.last_key = keys_exec_time[-1]
        self.t_program_time = (self.exec_times[last_key] - self.exec_times[first_key]).total_seconds()

        self.message1 = ""

        self.message1 += f"\n\nProgram Complete!\n\n"
        self.message1 += f"\tExecution Times"
        for k, v in exec_times.items():
            self.message1 += f"{k.ljust(50)}: {v:%H:%M:%S %p}"
        self.message1 += f"\n\tResults:\n\t\tFound:"
        for pn, pn_dat in self.found.items():
            self.message1 += f"\t\t\t{pn}:"
            for k, v in pn_dat.items():
                if v is not None:
                    self.message1 += f" {k}\n"
        self.message1 += f""
        if self.not_found:
            self.message1 += f"\t\tCould not find:"
        for pn in self.not_found:
            self.message1 += f"\t\t\t{pn}"
        self.t_program_time_msg = f"\nResults in {self.t_program_time:,.2f} second(s)"
        # print(t_program_time_msg)

        if self.not_found:
            self.message1 += f"\nCould not locate a DXF or DWG file for the following part numbers:"
            for nf in self.not_found:
                self.message1 += f"\n\t{nf}"
            self.message1 += f"\n\n{self.t_program_time_msg}"
        else:
            self.message1 = f"Completed without errors!"
            self.message1 += f"\n\n{self.t_program_time_msg}"

        output_message(self.message1)
        # messagebox.showinfo(
        #     title=title,
        #     message=message1
        # )
        # input(quit_message)

        self.protocol("WM_DELETE_WINDOW", self.quit_window)
        # after_id = win.after(2400, show_question)

    def quit_window(self, *args):
        # if after_id:
        #     win.after_cancel(after_id)
        self.destroy()





def output_message(msg, s_messages: list = None):

    win.geometry(calc_geometry_tl(1.0, 1.0))
    win.title(title)

    def quit_window(*args):
        # if after_id:
        #     win.after_cancel(after_id)
        win.destroy()

    # def show_question():
    #
    #     def click_export():
    #         # of = f"output_{datetime.datetime.now():%Y%m%d%H%M%S}.txt"
    #         # with open(of, "w") as f_:
    #         #     f_.write(msg)
    #         messagebox.showinfo(
    #             title,
    #             message=msg
    #         )
    #         quit_window_q()
    #
    #     def click_go_back():
    #         tl.destroy()
    #
    #     def click_quit():
    #         # print(f"QUITTING")
    #         click_export()
    #         quit_window_q()
    #
    #     def quit_window_q(*args):
    #         tl.destroy()
    #         win.destroy()
    #
    #     # tl = tkinter.Toplevel(win)
    #     tl.geometry(calc_geometry_tl(0.2, 0.2))
    #
    #     tv_lbl_q, lbl_q = label_factory(
    #         tl,
    #         tv_label=f"Export these results?"
    #     )
    #     f_q = tkinter.Frame(tl)
    #     # tv_btn_q_a, btn_q_a = button_factory(
    #     #     f_q,
    #     #     tv_btn=f"Export",
    #     #     command=click_export
    #     # )
    #     # tv_btn_q_b, btn_q_b = button_factory(
    #     #     f_q,
    #     #     tv_btn=f"Go Back",
    #     #     command=click_go_back
    #     # )
    #     tv_btn_q_c, btn_q_c = button_factory(
    #         f_q,
    #         tv_btn=f"Quit Program",
    #         command=click_quit
    #     )
    #     lbl_q.pack()
    #     f_q.pack(padx=5, pady=5)
    #     # btn_q_a.pack(side=tkinter.LEFT, padx=5, pady=5)
    #     # btn_q_b.pack(side=tkinter.LEFT, padx=5, pady=5)
    #     btn_q_c.pack(side=tkinter.LEFT, padx=5, pady=5)
    #     tl.protocol("WM_DELETE_WINDOW", quit_window_q)
    #     tl.grab_set()
    #     win.wait_window(tl)

    # tv_lbl, lbl = label_factory(
    #     win,
    #     tv_label=msg
    # )
    # lbl.pack()
    f = tkinter.Frame(win)
    text = tkinter.Text(
        f,
        wrap=tkinter.WORD,
        width=300,
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
    # after_id = win.after(2400, show_question)
    win.mainloop()


if __name__ == '__main__':

    # win = tkinter.Tk()
    # win.geometry(calc_geometry_tl(1.0, 1.0))
    # win.title(title)
    #
    # def quit_window(*args):
    #     # if after_id:
    #     #     win.after_cancel(after_id)
    #     win.destroy()
    #
    # win.protocol("WM_DELETE_WINDOW", quit_window)
    # # after_id = win.after(2400, show_question)
    # win.mainloop()

    messagebox.showinfo(
        title,
        f"This version of the program can only process 1 PO number's parts list at a time.\nYou will need to re-run it for each PO."
    )
    ans = messagebox.askyesnocancel(
        title,
        f"Do you want to save the copied files to a new folder?"
    )
    if ans == tkinter.YES:
        output_location = filedialog.askdirectory()
        if not output_location:
            output_location = read_file_root
    elif ans == tkinter.NO:
        output_location = read_file_root
    else:
        print(f"Quitting program.")
        quit()

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
            input(quit_message)
            quit()

    read_file_path = os.path.join(read_file_root, read_file)
    if not os.path.exists(read_file_path):
        messagebox.showerror(
            title=title,
            message=f"The file '{read_file}' must exist in the directory '{read_file_root}' for this program to run.\n{instructions}"
        )
        input(quit_message)
        quit()

    exec_times = OrderedDict()
    exec_times.update({"start_program": datetime.datetime.now()})

    try:
        df = pd.read_excel(read_file_path, index_col=None, header=None)
    except Exception as e:
        messagebox.showerror(
            title=title,
            message=f"Problem reading '{read_file}'.\n{instructions}"
        )
        print(e)
        input(quit_message)
        quit()

    if df.empty:
        messagebox.showerror(
            title=title,
            message=f"The file '{read_file}' is empty.\n{instructions}"
        )
        input(quit_message)
        quit()

    df = df.rename(columns={
        0: "PN"
    })
    # df = pd.DataFrame(columns=["PN"])

    # # test number
    # test_df = pd.DataFrame({"PN": ["40997777"]})
    # df = pd.concat([df, test_df])

    df["PDF"] = df['PN'].apply(lambda x: f"{x}.pdf")
    df["DXF"] = df['PN'].apply(lambda x: f"{x}.dxf")
    df["DWG"] = df['PN'].apply(lambda x: f"{x}.dwg")
    df["STP"] = df['PN'].apply(lambda x: f"{x}.stp")

    u_pns = set(df["PN"].unique().tolist())
    pns = set(df["DXF"].unique().tolist()).union(
        set(df["DWG"].unique().tolist()).union(set(df["PDF"].unique().tolist())))
    # pns = {str(pn) for pn in pns}

    exec_times.update({"end df search read": datetime.datetime.now()})
    print(f"Finished collecting Part Numbers to search.")
    for pn in u_pns:
        print(f"\t{pn}")
    # for pn in pns:
    #     print(f"\t{pn}")
    # print(f"{df=}")

    print(f"About to search DWG and DXF directory.")
    walked_dwg_folder = os.walk(root_location_dwg_dxf)
    not_found = []
    found = {}
    for dir_path, dir_names, file_names in walked_dwg_folder:
        # print(f"{len(file_names)=}, {file_names[:5]:}")
        for file in file_names:
            # if file.endswith(".pdf") and len(file) < 15:
            #     print(f"{file=}")
            # file_prefix = "".join(file.split(".")[:-1])
            # if file_prefix in pns:
            if file in pns:
                file_dwg, file_dxf = None, None
                suffix = file.split(".")[-1].upper()
                if file.endswith(".dwg"):
                    pn = df.loc[df[suffix] == file]["PN"].reset_index().iloc[0]["PN"]
                    file_dwg = os.path.join(dir_path, file)
                else:
                    pn = df.loc[df[suffix] == file]["PN"].reset_index().iloc[0]["PN"]
                    file_dxf = os.path.join(dir_path, file)
                # print(f"Found: {pn=}")
                file_pdf = os.path.join(root_location_pdfs, f"{pn}.pdf")
                file_pdf_stg = os.path.join(root_location_stg_pdfs, f"{pn}.pdf")
                if not os.path.exists(file_pdf):
                    print(f"\t ** Couldn't find PDF: {file_pdf=}")
                    if not os.path.exists(file_pdf_stg):
                        print(f"\t *** Couldn't find STG PDF: {file_pdf_stg=}")
                        file_pdf = None
                    else:
                        print(f"\tFOUND STG PDF: {file_pdf=}")
                        file_pdf = file_pdf_stg
                else:
                    print(f"\tFOUND PDF: {file_pdf=}")
                    file_pdf = file_pdf

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
                    "STP": file_stp
                })
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
        for ft, file in file_data.items():
            if file is not None:
                # dest_file = os.path.join(read_file_root, f"{pn}.{ft.lower()}")
                dest_file = os.path.join(output_location, f"{pn}.{ft.lower()}")
                if not os.path.exists(dest_file):
                    shutil.copyfile(file, dest_file)
    exec_times.update({"end df copying": datetime.datetime.now()})

    keys_exec_time = list(exec_times.keys())
    first_key = keys_exec_time[0]
    last_key = keys_exec_time[-1]
    t_program_time = (exec_times[last_key] - exec_times[first_key]).total_seconds()

    message1 = ""

    message1 += f"\n\nProgram Complete!\n\n"
    message1 += f"\tExecution Times"
    for k, v in exec_times.items():
        message1 += f"{k.ljust(50)}: {v:%H:%M:%S %p}"
    message1 += f"\n\tResults:\n\t\tFound:"
    for pn, pn_dat in found.items():
        message1 += f"\t\t\t{pn}:"
        for k, v in pn_dat.items():
            if v is not None:
                message1 += f" {k}\n"
    message1 += f""
    if not_found:
        message1 += f"\t\tCould not find:"
    for pn in not_found:
        message1 += f"\t\t\t{pn}"
    t_program_time_msg = f"\nResults in {t_program_time:,.2f} second(s)"
    # print(t_program_time_msg)

    if not_found:
        message1 += f"\nCould not locate a DXF or DWG file for the following part numbers:"
        for nf in not_found:
            message1 += f"\n\t{nf}"
        message1 += f"\n\n{t_program_time_msg}"
    else:
        message1 = f"Completed without errors!"
        message1 += f"\n\n{t_program_time_msg}"

    output_message(message1)
    # messagebox.showinfo(
    #     title=title,
    #     message=message1
    # )
    # input(quit_message)
