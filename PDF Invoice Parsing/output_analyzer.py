import json
import os
import glob

import pandas as pd

if __name__ == '__main__':

    # Get the current directory
    current_directory = os.getcwd()

    # Get a list of all files in the current directory
    all_files = glob.glob(os.path.join(current_directory + "/Outputs/", "*.json"))

    # Sort the files by creation date
    sorted_files = sorted(all_files, key=os.path.getctime)

    failed = [f for f in sorted_files if "failed" in f]
    passed = [f for f in sorted_files if "passed" in f]
    # print(f"{current_directory=}\n{all_files=}\n{sorted_files=}\n{failed=}\n{passed=}")
    new_pass = passed[-1]
    new_fail = failed[-1]
    print(f"{new_pass=}\n{new_fail=}")

    passed_data = pd.read_json(new_pass)
    failed_data = pd.read_json(new_fail)
    # with open(new_pass, "r") as f:
    #     passed_data = json.load(f)
    # with open(new_fail, "r") as f:
    #     failed_data = json.load(f)

    # print(f"{passed_data=}\n{failed_data=}")
    num_passed = passed_data.shape[0]
    num_failed = failed_data.shape[0]
    print(f"{num_passed=}\n{num_failed=}")

    failed_files = sorted(failed_data["fileName"].unique().tolist())
    print(f"{failed_files=}")
    print(failed_data)

