import datetime
import os
import shutil

import pandas as pd
import streamlit as st

from pyodbc_connection import connect
from streamlit_utility import display_df
# from tkinter import filedialog
# import wx
# from wx import DirDialog, ID_OK, DD_DEFAULT_STYLE, DD_NEW_DIR_BUTTON
from utility import next_available_file_name, percent, number_suffix

st.set_page_config(layout="wide")


@st.cache_data(ttl=60*60)
def hold_walk_dwg_dxf():
    # SUPER SLOW
    return list(os.walk(root_location_dwg_dxf))


@st.cache_data(ttl=60*60)
def hold_walk_pdf():
    # SUPER SLOW
    # return []
    return list(os.walk(root_location_pdfs))


@st.cache_data(ttl=60*60)
def hold_walk_pdf_stg():
    # SUPER SLOW
    return list(os.walk(root_location_stg_pdfs))


@st.cache_data(ttl=60*60)
def hold_walk_stp():
    # SUPER SLOW
    return list(os.walk(root_location_stp))


def check_folder_exists():
    folder_name = st.session_state.get("text_input_output_folder", "").strip()
    if folder_name:
        dir_name = os.path.dirname(output_location_default)
        path = os.path.join(dir_name, folder_name)
        path_exists = os.path.exists(path)
        has_files = os.listdir(path) if path_exists else []
        if has_files:
            st.info(body=f"{len(has_files)} file{'' if len(has_files) == 1 else 's'} already exists in this folder")
        elif path_exists:
            st.info(body="This folder already exists, and is empty")


@st.cache_data(ttl=60*60)
def get_open_POs_dash_mach() -> pd.DataFrame:
    sql = "v_REC-MACHParts"
    return connect(
        sql
    )



read_file_root: str = r"\\bwsfp01.bwsdomain.local\public\Janet Orser\po\po copied files"
read_file: str = r"PO LIST.xlsx"
output_location_default: str = next_available_file_name("output")
output_location_default: str = os.path.join(read_file_root, output_location_default)
read_file_path: str = os.path.join(read_file_root, read_file)
root_location_pdfs: str = r"\\server4.bwsdomain.local\Design\VaultWorkspace_BWS\PDFS"
root_location_stg_pdfs: str = r"\\server4.bwsdomain.local\Design\VaultWorkspace_BWS\PDFS\STARGATE PDF"
root_location_dwg_dxf: str = r"\\server4.bwsdomain.local\Design\DRAWINGS\STANDARDS"
root_location_stp: str = r"\\server4.bwsdomain.local\Design\SheetMetal_Step_Files_"
instructions: str = f"The file must contain a single column of part numbers.\nDo not add headers or any other columns.\nIt must be called '{read_file}'.\nPlease contact IT for any additional help with this program."
# quit_message: str = "\nHit enter to quit."


file_extensions: dict[str: str] = {
    "PDF": root_location_pdfs,
    "DXF": root_location_dwg_dxf,
    "DWG": root_location_dwg_dxf,
    "STP": root_location_stp,
    "STEP": root_location_stp
}

necessary_files = [
    read_file_root,
    root_location_pdfs,
    root_location_dwg_dxf,
    # root_location_stg_pdfs,
    root_location_stp,
    read_file_path
]
for pth in necessary_files:
    if not os.path.exists(pth):
        raise ValueError(f"File '{pth}' does not exist.")

# if st.button(
#     label="choose output folder"
# ):
#     # ol = filedialog.askdirectory()
#     #
#     # dialog = DirDialog(None,"Select a Folder", style=DD_DEFAULT_STYLE | DD_NEW_DIR_BUTTON)
#     # if dialog.ShowModal() == ID_OK:
#     #     ol = dialog.GetPath()
#     # else:
#     #     ol = output_location_default
#     #
#     st.file_uploader()
#     st.session_state.update({
#         "output_location": ol
#     })
# st.text_input(
#     "Output Location:",
#     key="output_location",
#     disabled=True
# )

output_location = st.session_state.get("output_location", output_location_default)
output_folder = st.session_state.get("text_input_output_folder", "output").strip()
if not output_folder:
    output_folder = "output"
if output_folder != "output":
    output_location = os.path.join(os.path.dirname(output_location), output_folder)
if not output_location.strip():
    output_location = output_location_default

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
        "df": pd.DataFrame(columns=["PN"]),
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

text_input_output_folder = st.text_input(
    label="Enter a PO Number to save the copied files into as a folder.",
    placeholder=os.path.basename(output_location_default),
    key="text_input_output_folder",
    on_change=check_folder_exists
)

df: pd.DataFrame = st.session_state.get("df", pd.DataFrame(columns=["PN"]))

if not df.empty:
    df = df.rename(columns={
        0: "PN"
    })
    df["PN"] = df["PN"].astype(str)
else:
    st.write(f"Enter your part numbers in this excel first: '{read_file}'")
    st.write(instructions)

if not st.session_state.get("has_run", False):
    result_cols[0].dataframe(df["PN"], use_container_width=True, hide_index=True)
result_cols[0].write(f"{df.shape[0]} part{'' if (df.shape[0] == 1) else 's'} loaded")

if (not df.empty) and st.session_state.get("button_run_part_data"):

    progress_fetching = st.progress(value=0, text=f"fetching files... {percent(0)}")
    progress_walking = st.progress(value=0, text=f"searching... {percent(0)}")
    progress_copying = st.progress(value=0, text=f"copying... {percent(0)}")

    t_fetching = datetime.datetime.now(), None
    walked_pdf_folder = hold_walk_pdf()
    progress_fetching.progress(value=0.25, text=f"fetching files... {percent(0.25)}")
    walked_pdf_stg_folder = hold_walk_pdf_stg()
    progress_fetching.progress(value=0.5, text=f"fetching files... {percent(0.5)}")
    walked_dwg_dxf_folder = hold_walk_dwg_dxf()
    progress_fetching.progress(value=0.75, text=f"fetching files... {percent(0.75)}")
    walked_stp_folder = hold_walk_stp()
    t_fetching = t_fetching[0], datetime.datetime.now()
    tt_fetching = (t_fetching[1] - t_fetching[0]).total_seconds()
    progress_fetching.progress(100, f"fetching files... {percent(1)} -- results in {tt_fetching:.2f} seconds")

    for fe in file_extensions:
        # df[f"{fe}_F"] = df.apply(lambda row: f"{row['PN']}.{fe.upper()}", axis=1)
        df[f"{fe}_F".upper()] = df.apply(lambda row: f"{row['PN']}.{fe}".upper(), axis=1)
        df[fe.upper()] = False
        df[f"{fe}_P".upper()] = ""
    df["COMP"] = ""

    u_pns = set(map(str, df["PN"].unique().tolist()))
    n_parts = len(u_pns)
    pns = set(df["DXF_F"].unique().tolist()).union(
        set(df["DWG_F"].unique().tolist()).union(set(df["PDF_F"].unique().tolist())).union(set(df["STP_F"].unique().tolist())))

    t_pdfs = sum([len(fn) for dp, dn, fn in walked_pdf_folder])
    t_pdfs_stg = sum([len(fn) for dp, dn, fn in walked_pdf_stg_folder])
    t_dxfs = sum([len(fn) for dp, dn, fn in walked_dwg_dxf_folder])
    t_stps = sum([len(fn) for dp, dn, fn in walked_stp_folder])
    t_to_walk = t_pdfs + t_pdfs_stg + t_dxfs + t_stps
    i = 0
    not_found = []
    found = {}

    # st.write("pns")
    # st.write(pns)

    t_walking = datetime.datetime.now(), None
    # pdfs
    for dir_path, dir_names, file_names in walked_pdf_folder:
        # st.write(f"{len(file_names)=}, {file_names[:5]:}")
        for file in file_names:
            file = file.upper()
            i += 1
            if file in pns:
                # st.write(f"BWS {file=}")
                spl = file.split(".")
                pn = ".".join(spl[:-1])
                suffix = spl[-1].upper()
                df.loc[df["PDF_F"] == file, ["PDF", "PDF_P", "COMP"]] = True, dir_path, "BWS"
                progress_walking.progress(i / t_to_walk, f"searching... {percent(i / t_to_walk)}")
    # st.write(pns)
    # st.write(f"A = {i=}")
    if i < n_parts:
        # search stargate too
        for dir_path, dir_names, file_names in walked_pdf_stg_folder:
            # print(f"{len(file_names)=}, {file_names[:5]:}")
            # st.write(f"{len(file_names)=}, {file_names[:5]:}")
            for file in file_names:
                file = file.upper()
                i += 1
                if file in pns:
                    # st.write(f"STG {file=}")
                    spl = file.split(".")
                    pn = ".".join(spl[:-1])
                    suffix = spl[-1].upper()
                    df.loc[df["PDF_F"] == file, ["PDF", "PDF_P", "COMP"]] = True, dir_path, "STG"
                    progress_walking.progress(i / t_to_walk, f"searching... {percent(i / t_to_walk)}")
        # st.write(f"B = {i=}")
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
            file = file.upper()
            # st.write(f"DXF -> {file=}")
            i += 1
            is_dxf: bool = file.endswith(".DXF")
            is_dwg: bool = file.endswith(".DWG")
            if is_dxf or is_dwg:
                spl = file.split(".")
                pn = ".".join(spl[:-1])
                suffix = spl[-1].upper()
                # if pn in parts_with_found_pdfs
                if pn in u_pns:
                    df.loc[df[f"{suffix}_F"] == file, [suffix, f"{suffix}_P"]] = True, dir_path
                    progress_walking.progress(i / t_to_walk, f"searching... {percent(i / t_to_walk)}")
                # else:
                #     if len(pn) < 12:
                #         st.write(f"skipped {pn=}")

    for dir_path, dir_names, file_names in walked_stp_folder:
        # print(f"{len(file_names)=}, {file_names[:5]:}")
        for file in file_names:
            file = file.upper()
            i += 1

            if file.replace(".STEP", ".STP").endswith(".STP"):
                spl = file.split(".")
                pn = ".".join(spl[:-1])
                suffix = spl[-1].upper()
                # if pn in parts_with_found_pdfs
                if pn in u_pns:
                    df.loc[df[f"{suffix}_F"] == file, [suffix, f"{suffix}_P"]] = True, dir_path
                    progress_walking.progress(i / t_to_walk, f"searching... {percent(i / t_to_walk)}")

    t_walking = t_walking[0], datetime.datetime.now()
    tt_walking = (t_walking[1] - t_walking[0]).total_seconds()
    progress_walking.progress(100, f"searching... {percent(1)} -- results in {tt_walking:.2f} seconds")

    result_cols[0 if st.session_state.get("has_run", False) else 1].dataframe(
        df[["PN", *file_extensions, "COMP"]],
        use_container_width=True,
        hide_index=True
    )

    st.subheader("Results")
    sub_results_cols = st.columns(len(file_extensions))
    kpfe = 1 / len(file_extensions)
    k = 0
    t_copying = datetime.datetime.now(), None
    progress_copying.progress(k, percent(k))
    t_copied = 0
    for i, fe in enumerate(file_extensions):
        root = file_extensions[fe]
        df_nf: pd.DataFrame = df.loc[~df[fe]]
        df_f: pd.DataFrame = df.loc[df[fe]]
        t_to_check: int = df_f.shape[0]
        kpc = kpfe / (1 if t_to_check == 0 else t_to_check)
        # print(f"{k=}, {kpfe=}, {kpc=}")
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
        t_copied += df_f.shape[0]
        with sub_results_cols[i].popover(label="show missing part #s"):
            st.write(missing_file_parts)
    t_copying = t_copying[0], datetime.datetime.now()
    tt_copying = (t_copying[1] - t_copying[0]).total_seconds()
    progress_copying.progress(100, f"copying... {percent(1)} -- results in {tt_copying:.2f} seconds")

    st.write(f"{t_copied} File{'' if t_copied == 1 else 's'} copied to:")
    st.code(output_location)

    # st.link_button(label="Folder", url=r"\\bwsfp01.bwsdomain.local\public\Janet Orser\po\po copied files\output")
    # st.markdown("<p><a href = \"" + r"\\bwsfp01.bwsdomain.local\public\Janet Orser\po\po copied files\output" + "\"> Some Network Folder (Works in Edge and IE)</a></p>", unsafe_allow_html=True)
    # st.link_button(label="Folder", url=output_location)
    # st.markdown("<p><a href = \"" + output_location + "\"> Some Network Folder (Works in Edge and IE)</a></p>", unsafe_allow_html=True)


## Open POs that have -MACH

st.divider()
st.subheader("Open POs that have -MACH")
df_dash_mach = get_open_POs_dash_mach()
display_df(
    df_dash_mach,
    hide_index=True,
    width=1200
)

#
# @st.cache_data(ttl=1000*60)  # 1 hour
# def load_material_issued() -> pd.DataFrame:
#     return connect("""
# SELECT
# 	[WM].[Job],
# 	[WM].[Warehouse],
# 	[WM].[OperationOffset],
# 	[WM].[StockCode],
# 	[WM].[StockDescription],
# 	[JP].[SumQtyIssued],
# 	[WM].[UnitQtyReqd],
# 	[WM].[AllocCompleted],
# 	(CASE WHEN ISNULL([WM].[UnitQtyReqd], 0) > ISNULL([JP].[SumQtyIssued], 0) THEN 0 ELSE 1 END) AS [Check]
# 	, (CASE WHEN (
# 			([JP].[Job] IS NOT NULL)
# 			AND ([JP].[MStockCode] IS NOT NULL)
# 			AND ([JP].[MWarehouse] IS NOT NULL)
# 			AND ([JP].[SumQtyIssued] IS NOT NULL)
# 		)
# 		THEN 1 ELSE 0 END) AS [IsPosted],
# 	[JP].[FirstTransaction],
# 	[JP].[LastTransaction],
#     (CASE
#         WHEN [WM].[AllocCompleted] = 'Y' THEN 1  -- SYSPRO says done
#         WHEN ISNULL([WM].[UnitQtyReqd],0) <= ISNULL([JP].[SumQtyIssued],0) THEN 1
#         ELSE 0
#     END) AS [IsSatisfied],
#     (CASE
#         WHEN ISNULL([WM].[UnitQtyReqd],0) > ISNULL([JP].[SumQtyIssued],0) THEN 1 ELSE 0
#     END) AS [StillMissing]
# FROM
# 	[SysproCompanyA].[dbo].[WipJobAllMat] [WM] WITH (NOLOCK)
# LEFT JOIN (
# 	SELECT
# 		[JP].[Job],
# 		[JP].[MStockCode],
# 		[JP].[LOperation],
# 		[JP].[MWarehouse],
# 		[JP].[TrnType],
# 		ISNULL(SUM(ISNULL([JP].[MQtyIssued], 0)), 0) AS [SumQtyIssued],
# 		MIN([WJP].[TrnDateTime]) AS [FirstTransaction],
# 		MAX([WJP].[TrnDateTime]) AS [LastTransaction]
# 	FROM
# 		[SysproCompanyA].[dbo].[WipJobPost] [JP] WITH (NOLOCK)
# 	INNER JOIN
# 		[SysproCompanyA].[dbo].[v_PROD_WipJobPostDateTime] [WJP] WITH (NOLOCK)
# 	ON
# 		([JP].[Job] = [WJP].[Job])
# 		AND ([JP].[MStockCode] = [WJP].[MStockCode])
# 		AND ([JP].[Line] = [WJP].[Line])
# 	WHERE
# 		([JP].[TrnType] <> 'L')
# 	GROUP BY
# 		[JP].[Job],
# 		[JP].[MStockCode],
# 		[JP].[LOperation],
# 		[JP].[MWarehouse],
# 		[JP].[TrnType]
# ) AS [JP]
# ON
# 	([WM].[Job] = [JP].[Job])
# 	AND ([WM].[StockCode] = [JP].[MStockCode])
# 	AND ([WM].[Warehouse] = [JP].[MWarehouse])
# 	--AND ([WM].[QtyIssued] = [JP].[SumQtyIssued])
# WHERE
# 	(ISNUMERIC(LEFT([WM].[Job], 1)) = 1)
# 	AND ([WM].[Warehouse] <> '**')
#     """)
#
#
# df_mat: pd.DataFrame = load_material_issued()
# list_jobs = sorted(df_mat["Job"].dropna().unique().tolist())
#
# k_multiselect_jobs: str = "key_multiselect_jobs"
# n_max_jobs: int = 5
# if k_multiselect_jobs not in st.session_state:
#     st.session_state[k_multiselect_jobs] = [j for j in list_jobs if j[0] == "1"][-n_max_jobs:]
# multiselect_jobs = st.multiselect(
#     label="Select a job",
#     key=k_multiselect_jobs,
#     options=list_jobs,
#     max_selections=n_max_jobs
# )
#
#
#
# k_multiselect_job_mat_sort: str = "key_multiselect_job_mat_sort"
# multiselect_job_mat_sort = st.multiselect(
#     label="Sort",
#     key=k_multiselect_job_mat_sort,
#     options=df_mat.columns.tolist(),
#     max_selections=3
# )
#
# if multiselect_job_mat_sort:
#     df_mat.sort_values(
#         by=multiselect_job_mat_sort,
#         inplace=True
#     )
#
# if multiselect_jobs:
#     df_mat_0 = df_mat.loc[df_mat["Job"].isin(multiselect_jobs)]
#     display_df(
#         df_mat_0,
#         "Material Issued"
#     )