import re
import os

import datetime
import pandas as pd


modules_root = r"\\bwsfp01.bwsdomain.local\public\IT\Access\Objects\Modules"
out_file = f"module_help_table.xlsx"
delimiter = "_||_|_||_"
module_prefix = "MODULE__"


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


def valid_module(blocks: dict[str, dict[str, list[str]]], assert_comments: bool = False) -> int:
    err = None
    if not isinstance(blocks, dict):
        err = -1

    if err is None:
        
        if len(blocks) == 0:
            err = -2

        if err is None:
            for func, func_data in blocks.items():
                if not isinstance(func_data, dict):
                    err = -3
                elif not isinstance(func, str):
                    err = -4
                elif not func:
                    err = -5
                else:
                    try:
                        script = "\n".join(func_data.get("script", []))
                        comment = "\n".join(func_data.get("comment", []))
                        if not script.strip():
                            err = -6
                        if assert_comments:
                            if not comment.strip():
                                err = -7
                    except TypeError:
                        err = -8
    if err is not None:
        print(f"{err=}")
    else:
        err = 0
    return err


if __name__ == "__main__":

    if not os.path.exists(modules_root):
        print(f"Could not find the root folder '{modules_root}' to extract modules.")
        quit()

    modules = os.listdir(modules_root)
    modules = [f for f in modules if f.endswith(".txt") and f.lower().startswith(module_prefix.lower())]

    if not modules:
        print(f"Could not extract any modules within the root folder '{modules_root}'.\nThey must start with the prefix 'MODULE__'")
        quit()
        
    df_rows = list()
    # with open(os.path.join(modules_root, out_file), "w") as f1:
    #     f1.write(f"prep_date={datetime.datetime.now():%Y-%m-%d %H:%M:%S}\n")
    #     f1.write(f"delimiter={delimiter}\n")
    #     f1.write(f"{'='*120}\n")
    for mod in modules:
        with open(os.path.join(modules_root, mod), "r") as f2:
            contents = f2.read()
            blocks = parse_vba_blocks(contents)
            valid = valid_module(blocks)
            print(f"{mod=}, {valid=}")
            # print(f"{blocks=}")
            for func, func_data in blocks.items():
                script = "\n".join(func_data.get("script", []))
                comment = "\n".join(func_data.get("comment", []))
                if not script:
                    script = ""
                if not comment:
                    comment = ""
                script = script.replace()
                # row = delimiter.join([func, script, comment])
                # f1.write(f"{row}\n")
                df_rows.append(pd.DataFrame([{
                    "module": mod.title().removeprefix(module_prefix.title()).removesuffix(".Txt"),
                    "validModule": valid,
                    "func": func,
                    "script": script,
                    "comment": comment
                }]))
                
                
    #             f1.write(delimiter.join())
    
    df_modules = pd.concat(df_rows).reset_index(drop=True)

    df_modules.to_excel(os.path.join(modules_root, out_file), index=False)