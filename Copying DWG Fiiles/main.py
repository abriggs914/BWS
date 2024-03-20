import os
import tkinter
from tkinter import filedialog

import pandas
import pandas as pd

from tkinter_utility import *

root_location_pdfs = r"J:\VaultWorkspace_BWS\PDFS"
root_location_dwg_dxf = r"J:\DRAWINGS"
root_location_stp = r"J:\SheetMetal_Step_Files_"
root_destiniation = "B:\Janet Orser\po\dont delete me"
test_file = r"\\nas1\domain user home folders\ABriggs\Quick files\Junk\Part Number Copier.xlsx"
root_test_file = r"\\nas1\domain user home folders\ABriggs\Quick files\Junk"

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

    app = tkinter.Tk()

    app.geometry(calc_geometry_tl(1.0, 1.0, rtype=dict)["geometry"])

    res_tv_label, res_label, res_tv_entry, res_entry = entry_factory(
        app
    )
    res_tv_btn_sr, res_btn_sr = button_factory(
        app,
        "single run",
        command=click_sr
    )
    res_tv_btn_ff, res_btn_ff = button_factory(
        app,
        "From File",
        command=click_ff
    )

    res_label.pack()
    res_entry.pack()
    res_btn_sr.pack()
    res_btn_ff.pack()

    app.mainloop()

