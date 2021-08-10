import random
import pyodbc
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib import font_manager as font_manager
import numpy as np

from utility import *
from colour_utility import *

cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER=server3;DATABASE=BWSdb;UID=user5;PWD=M@gic456')
cursor = cnxn.cursor()

# cursor.execute("SELECT WORK_ORDER.TYPE,WORK_ORDER.STATUS, WORK_ORDER.BASE_ID, WORK_ORDER.LOT_ID FROM WORK_ORDER")
top_200_orders = """
    SELECT
        TOP 200 *
    FROM
        [Orders]
    ORDER BY
        [Quote Date]
"""
order_model_counts = """
    SELECT DISTINCT 
        [Orders].[Model No],
        COUNT(*) AS [Times Sold]
    FROM
        [Orders]
    INNER JOIN
        [Products]
    ON	
        [Products].[Model No] = [Orders].[Model No]
    WHERE
        [Non-Current] = 0
        AND [Proposed] = 0
    GROUP BY
        [Orders].[Model No]
    ORDER BY
        [Orders].[Model No]
"""

top_20_most_expensive_orders = """
    SELECT DISTINCT TOP 20
        [Orders].[Model No],
        [Orders].[Price]
    FROM
        [Orders]
    INNER JOIN
        [Products]
    ON	
        [Products].[Model No] = [Orders].[Model No]
    WHERE
        [Non-Current] = 0
        AND [Proposed] = 0
    GROUP BY
        [Orders].[Model No],
        [Orders].[Price]
    ORDER BY
        [Orders].[Price] DESC,
        [Orders].[Model No]
"""

start_date = '1900-01-01'
# start_date = '2021-04-01'
end_date = '2021-08-09'
top_20_highest_grossing_models_2021_07_01__2021_08_01 = """
SELECT TOP 20
    CAST(SUM([Count]) AS VARCHAR(4)) + ' x ' + [Model No] +  + ' ($ ' + REPLACE(CONVERT(VARCHAR(50), (CAST(SUM([SP]) AS MONEY)), 1), '.00', '') + ')' AS [Model No],
    SUM([SP]) AS [Total Sales]
FROM (
    SELECT
        [Model No] AS [Model No],
        [Model No] + ' |BASE|' AS [BASE],
        COUNT(*) AS [Count],
        SUM([Price]) AS [SP]
    FROM
        [Orders]
    WHERE
        [Order Date] IS NOT NULL
        AND [Orders].[Quote Date] BETWEEN '{start_date}' AND '{end_date}'
    GROUP BY
        [Model No]
    UNION (
        SELECT
            [Model No] AS [Model No],
            [Model No] + ' |STDOP|' AS [Options],
            0 AS [Count],
            SUM([Price] * [Qty]) AS [SP]
        FROM (
            SELECT (
                SELECT TOP 1
                    [splited_data]
                FROM
                    split_string([Option No], '-')
                ) AS [Model No],
                *
            FROM
                [Order Options]
            ) AS [Orders Src]
        WHERE
            [Order Date] IS NOT NULL
            AND [Quote Date] BETWEEN '{start_date}' AND '{end_date}'
        GROUP BY
            [Model No]
    )
    UNION (
        SELECT
            [Model No] AS [Model No],
            [Model No] + ' |NPO|' AS [NPO],
            0 AS [Count],
            SUM([Custom Work].[Price] * [Custom Work].[Qty]) AS [SP]
        FROM
            [Custom Work]
        INNER JOIN
            [Orders]
        ON
            [Orders].[Quote#] = [Custom Work].[Quote#]
        WHERE
            [Custom Work].[Order Date] IS NOT NULL
            AND [Custom Work].[Quote Date] BETWEEN '{start_date}' AND '{end_date}'
        GROUP BY
            [Model No]
    )
) AS [SrcTable]
GROUP BY
    [Model No]
ORDER BY
    [Total Sales] DESC
;
""".format(start_date=start_date, end_date=end_date)


def others():
    cursor.execute(top_200_orders)
    for row in cursor.fetchall():
        print(row)

    # Copy to Clipboard for paste in Excel sheet
    def copia(argumento):
        print("argumento:", argumento)
        df = pd.DataFrame(argumento)
        df.to_clipboard(index=False, header=True)

    tableResult = pd.read_sql(order_model_counts, cnxn)

    # Copy to Clipboard
    copia(tableResult)

    # Or create a Excel file with the results
    df = pd.DataFrame(tableResult)
    df.to_excel("All Orders Export.xlsx", sheet_name='Results')
    df.plot(kind='bar', x="Model No", y="Times Sold")
    plt.minorticks_on()
    plt.grid(which='major', linestyle='-', linewidth='0.5', color='green')
    plt.grid(which='minor', linestyle=':', linewidth='0.5', color='black')

    # plt.show()
    plt.savefig('times sold by model.png')

    tableResult = pd.read_sql(top_20_most_expensive_orders, cnxn)
    df = pd.DataFrame(tableResult)
    df.plot(kind='bar', x="Model No", y="Price")
    plt.minorticks_on()
    plt.grid(which='major', linestyle='-', linewidth='0.5', color='green')
    plt.grid(which='minor', linestyle=':', linewidth='0.5', color='black')
    plt.savefig('top 20 most expensive models.png')


# Creating autocpt arguments
def func(pct, allvalues):
    absolute = int(pct / 100. * np.sum(allvalues))
    # return "{:.1f}%\n($ {:d})".format(pct, absolute)
    return "{:.1f}%".format(pct)


# def pie_chart():
#     import matplotlib.pyplot as plt
#     import matplotlib.patches
#
#     total = [100]
#     labels = ["Earth", "Mercury", "Venus", "Mars", "Jupiter", "Saturn",
#               "Uranus", "Neptune", "Pluto *"]
#     plt.title('Origin of Miss Universe since 1952')
#     plt.gca().axis("equal")
#     pie = plt.pie(total, startangle=90, colors=[plt.cm.Set3(0)],
#                   wedgeprops={'linewidth': 2, "edgecolor": "k"})
#     handles = []
#     for i, l in enumerate(labels):
#         handles.append(matplotlib.patches.Patch(color=plt.cm.Set3((i) / 8.), label=l))
#     plt.legend(handles, labels, bbox_to_anchor=(0.85, 1.025), loc="upper left")
#     plt.gcf().text(0.93, 0.04, "* out of competition since 2006", ha="right")
#     plt.subplots_adjust(left=0.1, bottom=0.1, right=0.75)
#     plt.show()


def pie_chart():
    tableResult = pd.read_sql(top_20_highest_grossing_models_2021_07_01__2021_08_01, cnxn)
    df = pd.DataFrame(tableResult)
    print("df A:\n", df)
    df.sort_values(by="Total Sales", inplace=True, ascending=False)
    print("df B:\n", df)
    # df.plot(kind='pie', x="Model No", y="Price")
    # plt.minorticks_on()
    # plt.grid(which='major', linestyle='-', linewidth='0.5', color='green')
    # plt.grid(which='minor', linestyle=':', linewidth='0.5', color='black')
    # plt.savefig('top 20 highest grossing models 2021-07-01 to 2021-08-01.png')

    lbls = df["Model No"]
    vals = df["Total Sales"]
    total_sales = sum(vals)
    total_units = 0

    print("\n\tlbls:\n", "\n".join([str(x) for x in lbls]))

    new_lbls = []
    lbls_pie = []
    max_val = max(vals)
    len_max = len(money(max_val))
    for lbl in lbls:
        spl = lbl.split("$")
        count, x, *model_name = spl[0].split(" ")
        x = x.strip()
        count = int(count.strip())
        cost = spl[-1].strip()[:-1]
        if "." not in cost:
            cost = cost + ".00"
        model_name = model_name[:-1]
        model_name = " ".join(model_name)
        print("parsed model name:", model_name)
        lbls_pie.append(model_name)
        total_units += count
        l_d = 40 - (max(6, len(str(count))) + max(18, len(str(model_name))) + max(len_max, len(str(cost))) - 2)
        print("<" + str(count).ljust(5) + " " + x + " " + model_name.ljust(18) + " $ " + ">")
        # new_lbls.append(str(count).ljust(5) + " " + x + " " + model_name.ljust(18) + " $ " + cost.rjust(len_max + l_d))
        new_lbls.append(str(count).ljust(5) + " " + x + " " + model_name.ljust(18) + " " + ("$ " + cost).rjust(len_max + l_d))

    lbls = new_lbls
    # Creating color parameters
    colours = []
    remaining_colours = get_all_colours()
    ic = 0
    while ic in range(min(len(df), len(remaining_colours))):
        chx = choice(remaining_colours)
        remaining_colours.remove(chx)
        if sum(chx) < 100:
            continue
        colours.append((chx[0] / 255, chx[1] / 255, chx[2] / 255))
        ic += 1

    # Wedge properties
    wp = {'linewidth': 1, 'edgecolor': "black"}

    # Creating explode data
    max_r = 0.2
    inc = max_r / len(df)
    explode = [(len(df) - i) * inc for i in range(len(df))]

    fig, ax = plt.subplots(figsize=(15, 8))
    plt.subplots_adjust(left=-0.15, right=0.9, top=0.8, bottom=0.05)
    # plt.subplot(2, 1, 1)
    # plt.pie(vals, labels=lbls)
    wedges, texts, autotexts = ax.pie(vals,
                                      autopct=lambda pct: func(pct, vals),
                                      explode=explode,
                                      labels=lbls_pie,
                                      colors=colours,
                                      shadow=True,
                                      startangle=0,
                                      wedgeprops=wp,
                                      textprops=dict(color="black"))
    # Adding legend
    # loc="lower right",
    legend_font = font_manager.FontProperties(family='Courier New',
                                              style='normal', size=11)
    ax.legend(wedges, lbls,
              title="Qty Sold".ljust(15) + pad_centre("Model Name", 25) + "Total Sales (CDN)".rjust(40),
              bbox_to_anchor=(1, 0, 1, 1.1),
              prop=legend_font)

    plt.setp(autotexts, size=8, weight="bold")

    # ax.xaxis.set_label_position('top')
    # ax.set_title("Top 20 Highest Grossing Models from 2021-07-01 to 2021-08-01", y=0.0, pad=500, fontweight="Bold")
    plt.title("Top 20 Highest Grossing Models from {start_date} to {end_date}".format(start_date=start_date,
                                                                                      end_date=end_date),
              fontweight="bold", y=1, pad=30)
    # show plot

    plt.gcf().text(0.93, 0.04, "Total Units Sold: {}\n Total Gross (CDN): {}".format(str(total_units).rjust(36),
                                                                               money(total_sales).rjust(25)),
                   ha="right")

    plt.savefig('Top 20 Highest Grossing Models from {start_date} to {end_date}.png'.format(start_date=start_date,
                                                                                            end_date=end_date))
    plt.show()
