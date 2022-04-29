from utility import *

import pandas as pd
import pyodbc
from xlwt import Workbook

# Program to query and dump Work order status data into an excel spreadsheet
# with each job# on it's own tab. (Yes, A LOT of tabs)
# All jobs are queried for status as of EOD on 2022-03-31.

if __name__ == '__main__':
    directory = "Spreadsheets"
    do_BWS = True
    start_t = dt.datetime.now()

    ranges = [
        (dt.datetime(2020,3,31), dt.datetime(2021,3,31)),
        (dt.datetime(2021,3,31), dt.datetime(2022,3,31))
    ]

    # server = "server3"
    # database = "SysproCompanyA"
    # username = "SRS"
    # password = ""
    # cstr = 'DRIVER={ODBC Driver 17 for SQL Server};SERVER=' + server + ';DATABASE=' + database + ';UID=' + username + ';PWD=' + password

    if do_BWS:
        # BWS output
        cstr = "DRIVER={SQL Server};SERVER=server3;DATABASE=SysproCompanyA;UID=SRS;PWD="
    else:
        # STG output
        cstr = "DRIVER={SQL Server};SERVER=server3;DATABASE=SysproCompanyS;UID=SCSRS;PWD="

    sql = """
    SET NOCOUNT ON;
select ArCustomer.Name, ArCustomer.Customer, 
ShipToAddr1, ShipToAddr2, ShipToAddr3, ShipToAddr4, ShipToAddr5, ArCustomer.ShipPostalCode,
case ArCustomer.Currency when '$' then 'CDN' else ArCustomer.Currency end as Country,
Contact, ArCustomer.Telephone, 
'N/A' as [Public/Private],
'N/A' as [Name of Parent Company],
'N/A' as [Website],
'N/A' as [Registration#],
CurrencyValue as InvoicePrice,
year(InvoiceDate) as InvoiceYear,
'N/A' as [Expected High A/R Balance],
'N/A' as [Currently Outstanding],
TblArTerms.[Description] as [Terms Offered to Buyers],
case ArCustomer.Currency when '$' then 'CDN' else ArCustomer.Currency end as Currency
into #CustomerData
from ArCustomer with (nolock)
inner join ArInvoice with (nolock) on ArCustomer.Customer = ArInvoice.Customer
left outer join TblArTerms with (nolock) on ArCustomer.TermsCode = TblArTerms.TermsCode
where InvoiceDate between '{d1}' and '{d2}'

select Name, #CustomerData.Customer, ShipToAddr1, ShipToAddr2, ShipToAddr3, ShipToAddr4, ShipToAddr5, ShipPostalCode, 
Country, Contact, Telephone, [Public/Private], [Name of Parent Company], [Website], [Registration#],
avg(InvoicePrice) as [Average Invoice Amount],
[Average Annual Invoice Amount], [Expected High A/R Balance], [Currently Outstanding], 
[Terms Offered to Buyers], 
'N/A' as [Average Payment Times],
Currency,
ROW_NUMBER() over (order by avg(InvoicePrice) desc) as [Rank]
into #finaldata
from #CustomerData
inner join (
            select Customer, avg([Total Annual Invoice Amount]) as [Average Annual Invoice Amount]
            from (
                select Customer, InvoiceYear, sum(InvoicePrice) as [Total Annual Invoice Amount]
                from #CustomerData
                group by Customer, InvoiceYear
                ) as mainsub
            group by Customer
            ) as subAvergeAnnual on #CustomerData.Customer = subAvergeAnnual.Customer
group by Name, #CustomerData.Customer, ShipToAddr1, ShipToAddr2, ShipToAddr3, ShipToAddr4, ShipToAddr5, ShipPostalCode,
Country, Contact, Telephone, [Public/Private], [Name of Parent Company], [Website], [Registration#],
[Average Annual Invoice Amount], [Average Annual Invoice Amount], [Expected High A/R Balance], [Currently Outstanding], 
[Terms Offered to Buyers], Currency
order by Customer

drop table #CustomerData

select * from #finaldata
where Rank <= 20

drop table #finaldata

--END


"""

    print("connecting...")
    conn = pyodbc.connect(cstr)
    end_conn_t = dt.datetime.now()

    wb = Workbook()
    sheets = {}
    writeable = False

    for d1, d2 in ranges:
        sheet_name = f"{d1.strftime('%Y-%m-%d')} -- {d2.strftime('%Y-%m-%d')}"
        sheet = wb.add_sheet(sheet_name)
        # sheets[]
        sql_str = sql.format(d1=d1, d2=d2)
        print("querying...")
        df = pd.DataFrame(pd.read_sql_query(sql_str, conn))

        writeable = True
        cols = list(df.columns)
        for i, row_dat in df.iterrows():
            for j, c_r in enumerate(zip(cols, row_dat)):
                c_name, value = c_r
                # print(f"i, j: ({i}, {j}), v: {value}")
                if i == 0:
                    sheet.write(0, j, str(c_name))
                sheet.write(i + 1, j, str(value))

    end_query_t = dt.datetime.now()
    end_process_t = dt.datetime.now()
    # print(data[list(data.keys())[0]])

    f_name = None
    if writeable:
        if do_BWS:
            f_name = "Top 20 Customers BWS 2020-03-31 -- 2022-03-31.xls"
        else:
            f_name = "Top 20 Customers STG 2020-03-31 -- 2022-03-31.xls"
        f_name = directory + "/" + f_name
        wb.save(f_name)
    else:
        print("NOT WRITABLE")

    conn.close()

    print("done!")
    end_t = dt.datetime.now()
    time_diff = (end_t - start_t).seconds
    time_conn = (end_conn_t - start_t).seconds
    time_query = (end_query_t - end_conn_t).seconds
    time_process = (end_process_t - end_query_t).seconds
    time_results = {
        "start time": start_t,
        "end time": end_t,
        "time connecting": time_conn,
        "time querying": time_query,
        "time writing": time_process,
        "Total Time (s)": time_diff,
        "Output File:": "\'" + f_name + "\'"
    }
    print(dict_print(time_results, "Time Results"))
