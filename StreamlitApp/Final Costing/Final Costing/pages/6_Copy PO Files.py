import os
import shutil

import pandas as pd
import streamlit as st

from utility import next_available_file_name, percent, number_suffix

st.set_page_config(layout="wide")


@st.cache_data(ttl=60*60)
def hold_walk_dwg_dxf():
    # SUPER SLOW
    return list(os.walk(root_location_dwg_dxf))


@st.cache_data(ttl=60*60)
def hold_walk_pdf():
    # SUPER SLOW
    return list(os.walk(root_location_pdfs))


@st.cache_data(ttl=60*60)
def hold_walk_pdf_stg():
    # SUPER SLOW
    return list(os.walk(root_location_stg_pdfs))


@st.cache_data(ttl=60*60)
def hold_walk_stp():
    # SUPER SLOW
    return list(os.walk(root_location_stp))


read_file_root: str = r"\\bwsfp01.bwsdomain.local\public\Janet Orser\po\po copied files"
read_file: str = r"PO LIST.xlsx"
output_location: str = next_available_file_name("output")
output_location: str = os.path.join(read_file_root, output_location)
read_file_path: str = os.path.join(read_file_root, read_file)
root_location_pdfs: str = r"\\server4.bwsdomain.local\Design\VaultWorkspace_BWS\PDFS"
root_location_stg_pdfs: str = r"\\server4.bwsdomain.local\Design\VaultWorkspace_BWS\PDFS\STARGATE PDF"
root_location_dwg_dxf: str = r"\\server4.bwsdomain.local\Design\DRAWINGS"
root_location_stp: str = r"\\server4.bwsdomain.local\Design\SheetMetal_Step_Files_"
instructions: str = f"The file must contain a single column of part numbers.\nDo not add headers or any other columns.\nIt must be called '{read_file}'.\nPlease contact IT for any additional help with this program."
# quit_message: str = "\nHit enter to quit."


file_extensions: dict[str: str] = {
    "PDF": root_location_pdfs,
    "DXF": root_location_dwg_dxf,
    "DWG": root_location_dwg_dxf,
    "STP": root_location_stp
}

necessery_files = [
    read_file_root,
    root_location_pdfs,
    root_location_dwg_dxf,
    root_location_stg_pdfs,
    root_location_stp,
    read_file_path
]
for pth in necessery_files:
    if not os.path.exists(pth):
        raise ValueError(f"File '{pth}' does not exist.")

if not os.path.exists(output_location):
    os.makedirs(output_location)

button_cols = st.columns([1, 1, 1])
result_cols = st.columns([1] if st.session_state.get("has_run", False) else [1, 4])

button_load_part_data = button_cols[0].button(
    label="load parts",
    key="button_load_part_data",
    on_click=lambda: st.session_state.update({
        "df": pd.read_excel(
            read_file_path,
            index_col=None,
            header=None
        ),
        "has_run": False
    })
)
button_reset_part_data = button_cols[1].button(
    label="reset parts",
    key="button_reset_part_data",
    on_click=lambda: st.session_state.update({
        "df": pd.DataFrame(),
        "has_run": False
    })
)
button_run_part_data = button_cols[2].button(
    label="run",
    key="button_run_part_data",
    on_click=lambda: st.session_state.update({
        "has_run": True
    })
)

df: pd.DataFrame = st.session_state.get("df", pd.DataFrame())

if not df.empty:
    df = df.rename(columns={
        0: "PN"
    })
else:
    st.write(f"Enter your part numbers in this excel first: '{read_file}'")
    st.write(instructions)

if not st.session_state.get("has_run", False):
    result_cols[0].dataframe(df, use_container_width=True, hide_index=True)
result_cols[0].write(f"{df.shape[0]} part{'' if (df.shape[0] == 1) else 's'} loaded")

if (not df.empty) and st.session_state.get("button_run_part_data"):

    progress_walking = st.progress(value=0, text=f"searching... {percent(0)}")
    progress_copying = st.progress(value=0, text=f"copying... {percent(0)}")

    walked_pdf_folder = hold_walk_pdf()
    walked_pdf_stg_folder = hold_walk_pdf_stg()
    walked_dwg_dxf_folder = hold_walk_dwg_dxf()
    walked_stp_folder = hold_walk_stp()

    for fe in file_extensions:
        df[f"{fe}_F"] = df.apply(lambda row: f"{row['PN']}.{fe.lower()}", axis=1)
        df[fe] = False
        df[f"{fe}_P"] = ""
    df["COMP"] = ""

    u_pns = set(df["PN"].unique().tolist())
    n_parts = len(u_pns)
    pns = set(df["DXF_F"].unique().tolist()).union(
        set(df["DWG_F"].unique().tolist()).union(set(df["PDF_F"].unique().tolist())))

    t_pdfs = sum([len(fn) for dp, dn, fn in walked_pdf_folder])
    t_pdfs_stg = sum([len(fn) for dp, dn, fn in walked_pdf_stg_folder])
    t_dxfs = sum([len(fn) for dp, dn, fn in walked_dwg_dxf_folder])
    t_stps = sum([len(fn) for dp, dn, fn in walked_stp_folder])
    t_to_walk = t_pdfs + t_pdfs_stg + t_dxfs + t_stps
    i = 0
    not_found = []
    found = {}

    # pdfs
    for dir_path, dir_names, file_names in walked_pdf_folder:
        # print(f"{len(file_names)=}, {file_names[:5]:}")
        for file in file_names:
            i += 1
            if file in pns:
                spl = file.split(".")
                pn = ".".join(spl[:-1])
                suffix = spl[-1].upper()
                df.loc[df["PDF_F"] == file, ["PDF", "PDF_P", "COMP"]] = True, dir_path, "BWS"
                progress_walking.progress(i / t_to_walk, f"searching... {percent(i / t_to_walk)}")
    if i < n_parts:
        # search stargate too
        for dir_path, dir_names, file_names in walked_pdf_stg_folder:
            # print(f"{len(file_names)=}, {file_names[:5]:}")
            for file in file_names:
                i += 1
                if file in pns:
                    spl = file.split(".")
                    pn = ".".join(spl[:-1])
                    suffix = spl[-1].upper()
                    df.loc[df["PDF_F"] == file, ["PDF", "PDF_P", "COMP"]] = True, "STG"
                    progress_walking.progress(i / t_to_walk, f"searching... {percent(i / t_to_walk)}")
    else:
        # all parts were found in bws directory
        i += t_pdfs_stg
        progress_walking.progress(i / t_to_walk, f"searching... {percent(i / t_to_walk)}")
        pass

    # parts_with_found_pdfs = set(df.loc[df["PDF"]]["PN"].values.tolist())
    # st.write(parts_with_found_pdfs)

    for dir_path, dir_names, file_names in walked_dwg_dxf_folder:
        # print(f"{len(file_names)=}, {file_names[:5]:}")
        for file in file_names:
            i += 1
            is_dxf: bool = file.endswith(".dxf")
            is_dwg: bool = file.endswith(".dwg")
            if is_dxf or is_dwg:
                spl = file.split(".")
                pn = ".".join(spl[:-1])
                suffix = spl[-1].upper()
                # if pn in parts_with_found_pdfs
                if pn in u_pns:
                    df.loc[df[f"{suffix}_F"] == file, [suffix, f"{suffix}_P"]] = True, dir_path
                    progress_walking.progress(i / t_to_walk, f"searching... {percent(i / t_to_walk)}")

    for dir_path, dir_names, file_names in walked_stp_folder:
        # print(f"{len(file_names)=}, {file_names[:5]:}")
        for file in file_names:
            i += 1
            if file.endswith(".stp"):
                spl = file.split(".")
                pn = ".".join(spl[:-1])
                suffix = spl[-1].upper()
                # if pn in parts_with_found_pdfs
                if pn in u_pns:
                    df.loc[df[f"{suffix}_F"] == file, [suffix, f"{suffix}_P"]] = True, dir_path
                    progress_walking.progress(i / t_to_walk, f"searching... {percent(i / t_to_walk)}")

    progress_walking.progress(100, f"searching... {percent(1)}")

    result_cols[0 if st.session_state.get("has_run", False) else 1].dataframe(
        df[["PN", *file_extensions, "COMP"]],
        use_container_width=True,
        hide_index=True
    )

    st.subheader("Results")
    sub_results_cols = st.columns(len(file_extensions))
    kpfe = 1 / len(file_extensions)
    k = 0
    progress_copying.progress(k, percent(k))
    for i, fe in enumerate(file_extensions):
        root = file_extensions[fe]
        df_nf: pd.DataFrame = df.loc[~df[fe]]
        df_f: pd.DataFrame = df.loc[df[fe]]
        t_to_check: int = df_f.shape[0]
        kpc = kpfe / t_to_check
        print(f"{k=}, {kpfe=}, {kpc=}")
        for j, row in df_f.iterrows():
            k += kpc
            pn: str = row["PN"]
            pp: str = row[f"{fe}_P"]
            pf: str = row[f"{fe}_F"]
            found: bool = row[fe]
            # st.write(f"{i=}, {j=}, {pn=}, {pp=}, {pf=}, {found=}")
            if found:
                src_file = os.path.join(pp, pf)
                dest_file = os.path.join(output_location, pf)
                # st.write(f"{i=}, {j=}, {pn=}, {src_file=}, {dest_file=}")
                # print(f"{i=}, {j=}, {pn=}, {src_file=}, {dest_file=}")
                if not os.path.exists(dest_file):
                    shutil.copyfile(src_file, dest_file)
            progress_copying.progress(k, f"copying... {percent(k)}")

        missing_file_parts: list[str] = df_nf["PN"].values.tolist()
        sub_results_cols[i].write(f"{df.shape[0] - df_nf.shape[0]} {fe} files copied" + (
            "" if not df_nf.shape[0] else f", missing {df_nf.shape[0]}"))
        with sub_results_cols[i].popover(label="show missing part #s"):
            st.write(missing_file_parts)
    progress_copying.progress(100, f"copying... {percent(1)}")

    st.link_button(label="Folder", url=r"\\bwsfp01.bwsdomain.local\public\Janet Orser\po\po copied files\output")
    st.markdown("<p><a href = \"" + r"\\bwsfp01.bwsdomain.local\public\Janet Orser\po\po copied files\output" + "\"> Some Network Folder (Works in Edge and IE)</a></p>", unsafe_allow_html=True)
    st.link_button(label="Folder", url=output_location)
    st.markdown("<p><a href = \"" + output_location + "\"> Some Network Folder (Works in Edge and IE)</a></p>", unsafe_allow_html=True)
