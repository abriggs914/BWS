import os
import datetime
from utility import next_available_file_name

if __name__ == "__main__":

    d1 = datetime.datetime(2025, 5, 25).date()
    d2 = datetime.datetime.now().date()
    root = r"\\bwsfp01\public\IT\Access\Objects"

    outfile = next_available_file_name("lines_to_run.txt")
    cmd = "Application.LoadFromText"
    prefixes = ["report", "module", "query", "form"]

    with open(outfile, "w") as f:
        for i in range((d2 - d1).days + 1):
            d = d1 + datetime.timedelta(days=i)
            path = os.path.join(root, f"{d:%Y-%m-%d}", "SysproCompanyA")
            # print(f"{path=}")
            if os.path.exists(path):
                files = os.listdir(path)
                print(f"{files=}")
                for j, file in enumerate(files):
                    print(f"{j=}, {file=}")
                    for pfx in prefixes:
                        if file.lower().startswith(f"{pfx}__".lower()):
                            f.write(f'{cmd} ac{pfx}, "{file.lower().removeprefix(f"{pfx}__".lower()).removesuffix(".txt")}", "{os.path.join(path, file)}"\n')
