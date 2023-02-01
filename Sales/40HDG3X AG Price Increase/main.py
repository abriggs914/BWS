import calendar

from pyodbc_connection import connect
from utility import date_suffix, date_str_format


DO_WRITE = True
output_file = "Price changes for 40HDG3X AG.txt"


if __name__ == '__main__':

    final_result = ""

    sql_40hdg3x_ag = """
        SELECT
            [Archive Date]
            , [Model No]
            , [Price]
        FROM
        	[arcProducts]
        WHERE
        	[Model No] = '40HDG3X AG'
        ORDER BY
        	[Archive Date]
        ;
        """

    df_40hdg3x_ag = connect(sql=sql_40hdg3x_ag)

    min_date = df_40hdg3x_ag["Archive Date"].min()
    max_date = df_40hdg3x_ag["Archive Date"].max()

    final_result += f"Price changes for 40HDG3X AG from\n\t{date_str_format(min_date)}\n\tTo\n\t{date_str_format(max_date)}\n\n"
    print(final_result)

    last_price = None
    for i, date, model, price in df_40hdg3x_ag.itertuples():
        fp = f"$ {price:.2f}"
        y, m, d = date.year, date.month, date.day
        d = f"{d}{date_suffix(d)}"
        df = f"{calendar.month_name[m].ljust(9)} {str(d).ljust(4)} {y}"
        if i == 0:
            line = f"{df}".ljust(19) + f"|\tprice = {fp}"
            print(line)
            last_price = price
        else:
            diff = ""
            if price != last_price:
                diff = price - last_price
                diff = (f"+ $ {abs(diff):.2f}" if diff > 0 else f"- $ {abs(diff): .2f}").ljust(15)
                diff += f", {(price / last_price):.2f} %"
            line = f"{df}".ljust(19) +\
                    f"|\tprice = {fp}".ljust(23) +\
                    (f"|\tchange {diff}" if diff else "|")
            print(line)
            last_price = price

        final_result += f"{line}\n"

    if DO_WRITE:
        with open(output_file, "w") as f:
            f.write(final_result)
