print("Hello from python file.")

from utility import *
import os
import csv

csvs = [f for f in os.listdir() if f.endswith(".csv")]
spec_csvs = [f for f in csvs if "spec" in f.lower() and "option" not in f.lower()]
option_csvs = [f for f in csvs if "option" in f.lower() and "spec" not in f.lower()]
# print("\n\tAll\n" + str(csvs))
# print("\n\tSpecs\n" + str(spec_csvs))
# print("\n\tOptions\n" + str(option_csvs))

main_header = []
count = []
odd_files = []

def clean_name(name):
    return "".join(let for let in list(name) if ord(let) in range(32, 127))

def check_files(csvs_in, res_title):
    res = {}
    for csv_file in csvs_in:
        with open(csv_file, 'r') as csvf:
            f = csv.DictReader(csvf)
            header = f.fieldnames
            header = list(map(clean_name, header))
            res[csv_file.title()] = dict(zip(header, [1 for i in range(len(header))]))
            if header not in main_header:
                main_header.append(header)
                odd_files.append((csv_file, len(header), header))
                count.append(1)
            else:
                i = main_header.index(header)
                count[i] += 1
            # print(header)

    print(dict_print(res, res_title, number=True))

check_files(spec_csvs, "Specs")
check_files(option_csvs, "Options")


with open("53ET3X_options.csv", 'r') as f:
    res = {}
    f = csv.DictReader(f)
    header = f.fieldnames
    print(header)
    for head in header:
        h = "".join(let for let in list(head) if ord(let) in range(32, 127))
        res[head] = {
            "cleaned": h,
            "letters": list(head)
        }
        # print(head + ", " + str(h) + "," + str(list(head)))
    print(dict_print(res, "53ET3X Options", number=True))