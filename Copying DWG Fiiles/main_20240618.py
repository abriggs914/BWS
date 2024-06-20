import tkinter
from collections import OrderedDict

import datetime
import os
import shutil
import pandas as pd
from tkinter import messagebox, filedialog


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
root_location_pdfs = r"\\server4.bwsdomain.local\Design\VaultWorkspace_BWS\PDFS"
root_location_stg_pdfs = r"\\server4.bwsdomain.local\Design\VaultWorkspace_BWS\PDFS\STARGATE PDF"
root_location_dwg_dxf = r"\\server4.bwsdomain.local\Design\DRAWINGS"
root_location_stp = r"\\server4.bwsdomain.local\Design\SheetMetal_Step_Files_"
instructions = f"The file must contain a single column of part numbers.\nDo not add headers or any other columns.\nIt must be called '{read_file}'.\nPlease contact IT for any additional help with this program."
quit_message = "\nHit enter to quit."


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
                dest_file = os.path.join(read_file_root, f"{pn}.{ft.lower()}")
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

    if not_found:
        message = f"Could not locate a DXF or DWG file for the following part numbers:"
        for nf in not_found:
            message += f"\n\t{nf}"
        message += f"\n\n{t_program_time_msg}"
    else:
        message = f"Completed without errors!"
        message += f"\n\n{t_program_time_msg}"

    messagebox.showinfo(
        title=title,
        message=message
    )
    input(quit_message)
