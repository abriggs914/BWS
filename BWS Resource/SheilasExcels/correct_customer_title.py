from pyodbc_connection import connect


def mc_mac_title(name: str) -> str:
    names = name.split(" ")
    if len(names) > 1:
        # print(f"A", end="")
        f_names = " ".join([n.strip() for n in names[:-1] if n]).title()
        last_name = names[-1].lower().strip()
        if last_name.startswith("mc"):
            # print(f"A", end="")
            last_name = f"Mc{last_name[2:].title()}"
        elif last_name.startswith("mac"):
            # print(f"B", end="")
            last_name = f"Mac{last_name[2:].title()}"
        else:
            # print(f"C, '{f_names}', '{last_name}'", end="")
            last_name = last_name.title()
        r_name = f"{f_names} {last_name}"
    else:
        # print(f"B", end="")
        r_name = name
    # print(f" {r_name=}")
    return r_name


if __name__ == '__main__':
    # df_customers = connect("SELECT * FROM [ITR Customers];")
    df_customers = connect("[ITR Customers]")
    for i, row in df_customers.iterrows():
        cust_id = row["CustomerID"]
        name = row["Name"]
        t_name = mc_mac_title(row["Name"])
        if name != t_name:
            connect(f"UPDATE [ITR Customers] SET [Name] = '{t_name}' WHERE [CustomerID] = {cust_id}", do_exec=True, do_show=True)
        else:
            print(f"skip {name=}")
