from pyodbc_connection import *

sql = """SELECT
	[O].[SGQuote]
	,[O].[Quote Date]
	,[O].[Order Date]
	,[O].[WO#]
	,[O].[Model No]
	,[S].[Sales Person]
	,[O].[Price]
	,[O].[Serial Number] AS [OLD SN]
	,[O].[Available Date]
	,[O].[Delivery Date]
	,[O].[Requested Delivery Date]
	,[D].[COMPANY NAME] AS [Dealer]
	,(CASE WHEN [O].[US Sale] = 1 THEN 'Y' ELSE 'N' END) AS [US Sale]
	,[O].[Notes]
FROM
	[OrdersV2] AS [O]
LEFT JOIN
	[DealersV2] AS [D]
ON
	[O].[DealerID] = [D].[ID]
LEFT JOIN
	[Sales Staff] AS [S]
ON
	[O].[Sale PersonID] = [S].[ID-SaleStaff]
WHERE
	[Delivery Date] >= '2023-04-01'
	AND [Date Declined] IS NULL
ORDER BY
	ISNULL([Delivery Date], [Requested Delivery Date])
;"""


data = connect(sql)
list_of_quotes = data["SGQuote"].values.tolist()
list_of_new_sn = []

print(f"{list_of_quotes=}")

sql = """SELECT
	*
FROM
	[SN Type V2]
ORDER BY
	[Model No]
;"""

sn_type_data = connect(sql)

sql = "EXEC sp_SerialNumberCalcSTG @quote='{quote}', @year=2024, @mode=3, @startSeq={startSeq};"

for i, quote in enumerate(list_of_quotes):
    e_sql = sql.format(quote=quote, startSeq=i)
    this_model = data[data["SGQuote"] == quote]["Model No"].values[0]

    position_data = sn_type_data[sn_type_data["Model No"] == this_model][[f"Position{i}" for i in range(4, 9)]]
    pos4, pos5, pos6, pos7, pos8 = position_data.values[0]
    positions_str = f"{pos4=}, {pos5=}, {pos6=}, {pos7=}, {pos8=}"
    print(positions_str)

    # if not all(position_data.values[0]):
    #     raise ValueError(f"\n\tError\nquote='{quote}', model='{this_model}'\ndoes not have valid serial type information on [SN Type V2]\n{positions_str}")

    # query
    val = connect(e_sql)[""].values[0]
    print(f"{i=} {val=}")
    list_of_new_sn.append(val)

data["NEW SN"] = list_of_new_sn
blk = "#" * 120

invalid_serials = data[data['NEW SN'].isna()][["SGQuote", "Model No", "OLD SN", "NEW SN"]]
invalid_models = invalid_serials["Model No"].unique().tolist()

if invalid_serials.empty:
    print(f"\n\n{blk}\n\tFINAL:\n", end="")
    print(f"{data}", end="")
    print(f"\n{blk}\n\n", end="")
else:
    print(f"\n\nPlease fix the following [SN Type V2] entries first")
    print(f"\n\n{blk}\n\tINVALID SERIALS:\n", end="")
    print(f"{invalid_serials}", end="")
    print(f"\n\n\tInvalid Models:")
    print("\t\t" + "\n\t\t".join([m for m in invalid_models]))
    print(f"\n{blk}\n\n", end="")

