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
	AND [Model No] <> 'Truck Box'
ORDER BY
	ISNULL([Delivery Date], [Requested Delivery Date])
;
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

positions_list = [f"Position{i}" for i in range(4, 9)]
positions_list.remove("Position7")

for i, quote in enumerate(list_of_quotes):
    e_sql = sql.format(quote=quote, startSeq=i)
    this_model = data[data["SGQuote"] == quote]["Model No"].values[0]

    position_data = sn_type_data[sn_type_data["Model No"] == this_model][positions_list]
    pos4, pos5, pos6, pos8 = position_data.values[0]
    positions_str = f"{pos4=}, {pos5=}, {pos6=}, {pos8=}"
    print(positions_str)

    # if not all(position_data.values[0]):
    #     raise ValueError(f"\n\tError\nquote='{quote}', model='{this_model}'\ndoes not have valid serial type information on [SN Type V2]\n{positions_str}")

    # Query
    val = connect(e_sql)[""].values[0]
    print(f"{i=} {val=}")
    list_of_new_sn.append(val)

data["NEW SN"] = list_of_new_sn
blk = "#" * 120

invalid_serials = data[data['NEW SN'].isna()][["SGQuote", "Model No", "OLD SN", "NEW SN"]]
invalid_models = invalid_serials["Model No"].unique().tolist()
invalid_model_info = sn_type_data[sn_type_data["Model No"].isin(invalid_models)][["Model No", *positions_list]]

if invalid_serials.empty:
    print(f"\n\n{blk}\n\tFINAL:\n", end="")
    print(f"{data}", end="")
    print(f"\n{blk}\n\n", end="")

    # update [OrdersV2]
    sql = """UPDATE [OrdersV2] SET [Serial Number] = '{new_sn}', [Notes] = '{notes}\nMarch 24th, 2023 - ABRIGGS - 
    Serial Number change: ''{old_sn}'' to ''{new_sn}''' WHERE [SGQuote] = '{quote}';"""
    for i, row in data.iterrows():
        quote = row["SGQuote"]
        new_sn = row["NEW SN"]
        old_sn = row["OLD SN"]
        notes = row["Notes"]
        notes = ("" if not notes else notes).strip().replace("'", "''")
        e_sql = sql.format(quote=quote, new_sn=new_sn, old_sn=old_sn, notes=notes)
        print(e_sql)

    # Export update log
    data.to_excel(r"STG SN Update 2023-03-24 1345.xlsx")

    print(f"{blk}")
    print(f"{blk}")

    for i, row in data[data["Model No"].isin(["Pony Dump 3X17", "42FHR2X"])].iterrows():
        quote = row["SGQuote"]
        new_sn = row["NEW SN"]
        old_sn = row["OLD SN"]
        notes = row["Notes"]
        notes = notes.split("March 24th, 2023 - ABRIGGS - Serial Number change:")
        if notes[1]:
            old_sn = notes[1].split("'")[1]
            # print(f"\nnotes[1]={notes[1]}, old_sn: {old_sn}")
        notes = notes[0].strip()
        notes = ("" if not notes else notes).strip().replace("'", "''")
        e_sql = sql.format(quote=quote, new_sn=new_sn, old_sn=old_sn, notes=notes)
        print(e_sql)

else:
    print(f"\n\nPlease fix the following [SN Type V2] entries first")
    print(f"\n\n{blk}\n\tINVALID SERIALS:\n", end="")
    print(f"{invalid_serials}", end="")
    print(f"\n\n\tInvalid Models:")
    print("\t\t" + "\n\t\t".join([m for m in invalid_models]))
    print(f"\n\n\tData:\n{invalid_model_info}")
    print(f"\n{blk}\n\n", end="")
