import datetime
import os
import shutil
import tkinter
from tkinter import filedialog
from tkinter import messagebox

import pandas
import pandas as pd

from tkinter_utility import *

root_location_pdfs = r"J:\VaultWorkspace_BWS\PDFS"
root_location_dwg_dxf = r"J:\DRAWINGS"
root_location_stp = r"J:\SheetMetal_Step_Files_"
root_destination = r"\\bwsfp01.bwsdomain.local\public\Janet Orser\po\dont delete me"
# test_file = r"\\nas1\domain user home folders\ABriggs\Quick files\Junk\Part Number Copier.xlsx"
# root_test_file = r"\\nas1\domain user home folders\ABriggs\Quick files\Junk"

suffixes = ["pdf", "stp", "dwg", "dxf"]


def check_has_dwg_or_dxf(files) -> bool:
    pass


def click_ff(*event):
    # sel_file = filedialog.askopenfilename(
    #     initialdir=root_test_file,
    #     title="Select an Excel file containg part numbers",
    #     filetypes=(("Excel Files", ".xlsx"), ("Excel Macro Files", ".xlsm"))
    # )
    sel_file = test_file
    if sel_file:
        df = pandas.read_excel(sel_file)
        col0 = list(df.columns)[0]
        print(f"{col0=}")
        try:
            # if successful, then col header not supplied
            col0_i = int(col0)
            df = df.rename(columns={col0: "COL0"})
            df_head = pd.DataFrame({"COL0": [col0_i]})
            df = pd.concat([df_head, df], ignore_index=True)
        except ValueError as ve:
            # column header was supplied
            print(f"COLUMN HEADER SUPPLIED")
            pass

        print(f"{df=}")
        pns = df["COL0"].tolist()
        print(f"{pns=}")


def click_sr(*event):
    pn = res_tv_entry.get()
    print(f"click {pn=}")
    if pn:
        f_names = [f"{pn}.{sfx}" for sfx in suffixes]
        pn_pdf = f"{pn}.pdf"
        pn_stp = f"{pn}.stp"

        # error on not found
        pn_dwg = f"{pn}.dwg"
        pn_dxf = f"{pn}.dxf"

        pns = {pn_dwg, pn_dxf}
        walked = os.walk(root_location_dwg_dxf)
        found_files = []
        results = {}
        for dir_path, dir_names, file_names in walked:
            for file in file_names:
                if file in pns:
                    pn_ = file.split(".")[0]
                    found_files.append((dir_path, dir_names, file))
                    is_dxf = file.endswith(".dxf")
                    results[pn_] = {
                        "dp": dir_path,
                        "dn": dir_names,
                        "pdf": None,
                        "dwg": None if is_dxf else file,
                        "dxf": None if not is_dxf else file,
                        "stp": None
                    }
                    pns.remove(file)
                if len(pns) == 0:
                    break

            if len(pns) == 0:
                break

        print(f"{found_files=}")

        err_msg = ""
        pns_c = pns.copy()
        for pn_ in pns_c:
            found = False
            for dp, dn, fn in found_files:
                for f in fn:
                    if f == pn_:
                        found = True
            if not found:
                err_msg += f"\n\tCould not find file: {pn_}"
                pns.remove(pn_)

        err_msg = err_msg.strip()
        if err_msg:
            print(f"Could not complete due to errors:\n\t{err_msg}")
            # quit()
        else:
            print(f"Completed dxf and dwg search successfully.")

        for k, data in results.items():
            pdf_file = os.path.join(root_location_pdfs, f"{k}.pdf")
            stp_file = os.path.join(root_location_stp, f"{k}.stp")
            if os.path.exists(pdf_file):
                data.update({"pdf": pdf_file})
            if os.path.exists(stp_file):
                data.update({"stp": stp_file})

        for k, data in results.items():
            print(f"{k=}")
            for k_, v_ in data.items():
                print(f"\t{k_=}, {v_=}")


# Press the green button in the gutter to run the script.
if __name__ == '__main__':

    exec_times = OrderedDict()
    exec_times.update({"start_program": datetime.datetime.now()})
    # # read_file_root = r"C:\Users\ABriggs\Downloads\vba collecting laser pdf dxf step files.xlsx"
    read_file_root = r"\\bwsfp01.bwsdomain.local\public\Janet Orser\po\dont delete me\PO LIST.xlsx"
    df = pd.read_excel(read_file_root, index_col=None, header=None)
    df = df.rename(columns={
        0: "PN"
    })
    # df = pd.DataFrame(columns=["PN"])

    # test number
    test_df = pd.DataFrame({"PN": ["40997777"]})
    df = pd.concat([df, test_df])

    df["PDF"] = df['PN'].apply(lambda x: f"{x}.pdf")
    df["DXF"] = df['PN'].apply(lambda x: f"{x}.dxf")
    df["DWG"] = df['PN'].apply(lambda x: f"{x}.dwg")
    df["STP"] = df['PN'].apply(lambda x: f"{x}.stp")

    u_pns = set(df["PN"].unique().tolist())
    pns = set(df["DXF"].unique().tolist()).union(set(df["DWG"].unique().tolist()))

    exec_times.update({"end df search read": datetime.datetime.now()})
    print(f"Finished collecting Part Numbers to search.")
    for pn in u_pns:
        print(f"\t{pn}")

    print(f"About to search DWG and DXF directory.")
    walked_dwg_folder = os.walk(root_location_dwg_dxf)
    not_found = []
    found = {}
    for dir_path, dir_names, file_names in walked_dwg_folder:
        for file in file_names:
            if file in pns:
                file_dwg, file_dxf = None, None
                if file.endswith(".dwg"):
                    pn = df.loc[df["DWG"] == file]["PN"].reset_index().iloc[0]["PN"]
                    file_dwg = os.path.join(dir_path, file)
                else:
                    pn = df.loc[df["DXF"] == file]["PN"].reset_index().iloc[0]["PN"]
                    file_dxf = os.path.join(dir_path, file)
                # print(f"Found: {pn=}")
                file_pdf = os.path.join(root_location_pdfs, f"{pn}.pdf")
                if not os.path.exists(file_pdf):
                    print(f"\tCouldn't find PDF: {file_pdf=}")
                    file_pdf = None
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
                dest_file = os.path.join(root_destination, f"{pn}.{ft.lower()}")
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
    print(f"\t\tCould not find:")
    for pn in not_found:
        print(f"\t\t\t{pn}")
    t_program_time_msg = f"\nResults in {t_program_time:,.2f} second(s)"

    if not_found:
        message = f"Could not locate a DXF or DWG file for the following part numbers:"
        for nf in not_found:
            message += f"\n\t{nf}"
        message += f"\n\n{t_program_time_msg}"
    else:
        message = f"Completed without errors!"
        message += f"\n\n{t_program_time_msg}"

    messagebox.showinfo(
        title="PO List File Copier",
        message=message
    )

    print(t_program_time_msg)

    input("\nHit enter to quit.")

    # app = tkinter.Tk()
    #
    # app.geometry(calc_geometry_tl(1.0, 1.0, rtype=dict)["geometry"])
    #
    # res_tv_label, res_label, res_tv_entry, res_entry = entry_factory(
    #     app
    # )
    # res_tv_btn_sr, res_btn_sr = button_factory(
    #     app,
    #     "single run",
    #     command=click_sr
    # )
    # res_tv_btn_ff, res_btn_ff = button_factory(
    #     app,
    #     "From File",
    #     command=click_ff
    # )
    #
    # res_label.pack()
    # res_entry.pack()
    # res_btn_sr.pack()
    # res_btn_ff.pack()
    #
    # app.mainloop()

