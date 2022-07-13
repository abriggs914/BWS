import pandas as pd
from utility import *

if __name__ == "__main__":

    departments = {
        "Administration": {
            "extra": [
                "Maintenance"
            ]
        },
        "HR": {
            "extra": [
                "Human Resources"
            ]
        },
        "Sales": {
            "extra": [
                "Warranty"
            ]
        },
        "BOM": {
            "extra": [
                "Bill Of Materials",
                "Purchasing"
            ]
        },
        "Engineering": {
            "extra": []
        },
        "IT": {
            "extra": []
        },
        "Parts": {
            "extra": [
                "Parts Dept."
            ]
        },
        "Production": {
            "extra": [
                "Aluminum",
                "Assembly",
                "Axle",
                "Finish - Assembly",
                "Finish - Blast",
                "Finish - Paint",
                "Machine Shop",
                "Sub Beams",
                "Sub GNK",
                "Sub Parts",
                "Screener - Assembly",
                "Special Project",
                "Special Projects",
                "WIP - Work In Progress",
                "Non Productive",
                "Scheduling",
                "Quality Control"
            ]
        }
    }
    for k, v in departments.items():
        v.update({"Departments": []})

    df = pd.read_excel("./dept_raw.xlsx")
    for row in df.iterrows():
        # print(f"{row=}, {type(row)=}")
        i, dept_data = row
        dept, depts = dept_data.to_list()
        # print(f"{dept=}, {depts=}")
        depts = str(depts).split(";")
        f = False
        if dept in departments:
            departments[dept]["Departments"] += depts
            f = True
        else:
            # print("else")
            for d, dct in departments.items():
                lst = dct["extra"]
                # print(f"{lst}")
                if dept in lst:
                    departments[d]["Departments"] += depts
                    f = True
                    break
        if not f:
            print(f"SKIPPED {dept=}")


    print(dict_print(departments, "Final"))
    for k, v in departments.items():
        lst = list(map(int, v["Departments"]))
        lst.sort()
        departments[k]["Departments"] = list(map(str, lst))
        # for d in v["Departments"]:


    # Administration
    # BOM
    # Engineering
    # HR
    # IT
    # Parts
    # Production
    # Sales

    print(f"Administration, {';'.join(departments['Administration']['Departments'])}")
    print(f"BOM, {';'.join(departments['BOM']['Departments'])}")
    print(f"Engineering, {';'.join(departments['Engineering']['Departments'])}")
    print(f"HR, {';'.join(departments['HR']['Departments'])}")
    print(f"IT, {';'.join(departments['IT']['Departments'])}")
    print(f"Parts, {';'.join(departments['Parts']['Departments'])}")
    print(f"Production, {';'.join(departments['Production']['Departments'])}")
    print(f"Sales, {';'.join(departments['Sales']['Departments'])}")


