import re

import streamlit as st

from itertools import zip_longest


st.set_page_config(
    layout="wide",
    page_title="Module Diff"
)


@st.cache_data(show_spinner=True)
def load_file(file_bytes):
    # print("-LF-" + str(file)[:250])
    lines = file_bytes.decode("utf-8", errors="ignore").splitlines()
    return "\n".join(lines)  # adjust as needed


@st.cache_data(show_spinner=True)
def file_diff(file_a: dict[str: dict], file_b: dict[str: dict]) -> list[str]:
    file_al = str(file_a).strip().lower()
    file_bl = str(file_b).strip().lower()
    if file_al == file_bl:
        return []
    
    funcs_a = list(file_a)
    funcs_b = list(file_b)

    if len(funcs_a) == len(funcs_b):
        for p_name in zip_longest(funcs_a, funcs_b):
            p_a = funcs_a.get(p_name)
            p_b = funcs_b.get(p_name)

    return [file_al, file_bl]


def parse_vba_blocks_0(vba_text: str) -> dict:
    pattern = re.compile(r'^\s*(Public|Private)?\s*(Sub|Function|Property|Const)\s+(\w+).*$', re.IGNORECASE | re.MULTILINE)
    blocks = {}
    current_block = None
    lines = vba_text.splitlines()

    for line in lines:
        header_match = pattern.match(line)
        if header_match:
            current_block = header_match.group(3)
            blocks[current_block] = [line]
        elif current_block:
            blocks[current_block].append(line)

    return blocks


def parse_vba_blocks_1(vba_text: str) -> dict:
    """
    Parses VBA code into logical blocks keyed by their name, preserving leading comments.

    Returns:
        dict[str, list[str]]: Mapping of block name to list of lines
    """
    # Match the start of a block and capture the name
    header_pattern = re.compile(
        r"^\s*(Public|Private)?\s*(Sub|Function|Property|Const)\s+(\w+)",
        re.IGNORECASE
    )

    lines = vba_text.splitlines()
    blocks = {}
    current_block = []
    current_name = None

    for i, line in enumerate(lines):
        match = header_pattern.match(line)

        if match:
            # Save the previous block
            if current_name and current_block:
                blocks[current_name] = current_block

            # Capture leading comments
            j = i - 1
            leading_comments = []
            while j >= 0 and lines[j].strip().startswith("'"):
                leading_comments.insert(0, lines[j])
                j -= 1

            current_name = match.group(3)
            current_block = leading_comments + [line]  # Start new block

        elif current_block is not None:
            current_block.append(line)

    # Catch the final block
    if current_name and current_block:
        blocks[current_name] = current_block

    return blocks


def parse_vba_blocks(vba_text: str) -> dict:
    """
    Parses VBA code into logical blocks keyed by block name.
    Each block is returned as a dict with 'comment' and 'script' sections.

    Returns:
        dict[str, dict[str, list[str]]]
    """
    header_pattern = re.compile(
        r"^\s*(Public|Private)?\s*(Sub|Function|Property|Const)\s+(\w+)",
        re.IGNORECASE
    )

    lines = vba_text.splitlines()
    blocks = {}
    current_block = []
    current_name = None
    current_comments = []

    for i, line in enumerate(lines):
        match = header_pattern.match(line)

        if match:
            if current_name and current_block:
                blocks[current_name] = {
                    "comment": current_comments,
                    "script": current_block
                }

            # Prepare next block
            current_name = match.group(3)
            current_block = [line]

            # Look back for comment block
            j = i - 1
            current_comments = []
            while j >= 0 and lines[j].strip().startswith("'"):
                current_comments.insert(0, lines[j])
                j -= 1

        elif current_block is not None:
            current_block.append(line)

    # Save final block
    if current_name and current_block:
        blocks[current_name] = {
            "comment": current_comments,
            "script": current_block
        }

    return blocks


cont_top = st.container(border=1)
cont_cols = st.container(border=1)
cols_ab = cont_cols.columns(2)


k_file_uploader_a: str = "file_uploader_a"
k_file_uploader_b: str = "file_uploader_b"


with cols_ab[0]:
    file_a = st.file_uploader(
        label="Drop a file",
        key=f"k_{k_file_uploader_a}",
        type="txt",
        accept_multiple_files=False
    )


with cols_ab[1]:
    file_b = st.file_uploader(
        label="Drop a file",
        key=f"k_{k_file_uploader_b}",
        type="txt",
        accept_multiple_files=False
    )


txt_a: str = ""
txt_b: str = ""


if file_a is not None:

    txt_a = load_file(file_a.read())
    vba_a = parse_vba_blocks(txt_a)

    with cols_ab[0]:
        code_a = st.code(
            body=txt_a,
            language="VBA"
        )
        st.write(
            vba_a
        )

if file_b is not None:

    txt_b = load_file(file_b.read())
    vba_b = parse_vba_blocks(txt_b)

    with cols_ab[1]:
        code_b = st.code(
            body=txt_b,
            language="VBA"
        )
        st.write(
            vba_b
        )


if txt_a and txt_b:
    diff: list[str] = file_diff(vba_a, vba_b)
    with cont_top:
        st.write("diff")
        st.write(diff)
        checkbox_same_file = st.checkbox(
            label="Files are the same?",
            value=not bool(diff),
            disabled=True
        )
