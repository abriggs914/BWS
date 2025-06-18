import pandas as pd
import os


excel_file_path: str = r"\\bwsfp01\public\Receiving\JobIssueLog.xlsx"
output_file: str = r"\\bwsfp01\public\Receiving\init_rec_events_20250618.sql"


sql_insert_template_0 = """
INSERT INTO [dbo].[REC_Events]
           ([DateEvent]
           ,[TimeEvent]
           ,[Contact]
           ,[Job]
           ,[Qty]
           ,[UOM]
           ,[StockCode]
           ,[DateIssued]
           ,[TimeIssued]
           ,[IssueComplete]
           ,[Notes])
     VALUES
"""

sql_insert_template_1 = """
({DateEvent}
    ,{TimeEvent}
    ,{Contact}
    ,{Job}
    ,{Qty}
    ,{UOM}
    ,{StockCode}
    ,{DateIssued}
    ,{TimeIssued}
    ,{IssueComplete}
    ,{Notes})
"""

if __name__ == "__main__":
    if not os.path.exists(excel_file_path):
        print(f'could not find file')
        quit()

    # with open(excel_file_path, "r") as excel_file:
    df = pd.read_excel(excel_file_path)

    with open(output_file, "w") as f:

        f.write(sql_insert_template_0 + "\n")
        rows = []
        for i, row in df.iterrows():
            contact = row["Contact"]
            date = row["Date"]
            time = row["Time"]
            job = row["Job"]
            qty = row["Qty"]
            uom = row["UOM"]
            stock_code = row["StockCode"]
            iss_date = row["IssuedDate"]
            iss_time = row["IssuedTime"]
            iss_comp = row["IssueComplete"]
            notes = row["Notes"]
            
            valid = any([
                not pd.isna(stock_code),
                not pd.isna(job),
                not pd.isna(contact),
                not pd.isna(date)
            ])

            if valid:

                contact = f"'{contact}'" if not pd.isna(contact) else "NULL"
                date = f"'{date}'" if not pd.isna(date) else "NULL"
                time = f"'{time}'" if not pd.isna(time) else "NULL"
                job = f"'{job}'" if not pd.isna(job) else "NULL"
                qty = qty if not pd.isna(qty) else "NULL"
                uom = f"'{uom}'" if not pd.isna(uom) else "NULL"
                stock_code = f"'{stock_code}'" if not pd.isna(stock_code) else "NULL"
                iss_date = f"'{iss_date}'" if not pd.isna(iss_date) else "NULL"
                iss_time = f"'{iss_time}'" if not pd.isna(iss_time) else "NULL"
                iss_comp = int(bool(iss_comp)) if not pd.isna(iss_comp) else "NULL"
                notes = f"'{notes}'" if not pd.isna(notes) else "NULL"

                rows.append(sql_insert_template_1.format(
                    DateEvent=date
                    ,TimeEvent=time
                    ,Contact=contact
                    ,Job=job
                    ,Qty=qty
                    ,UOM=uom
                    ,StockCode=stock_code
                    ,DateIssued=iss_date
                    ,TimeIssued=iss_time
                    ,IssueComplete=iss_comp
                    ,Notes=notes
                ))

        f.write(",\n".join(rows))
        f.write(";")


