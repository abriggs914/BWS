import math

import pandas
import pandas as pd


if __name__ == '__main__':
    null = "NULL"
    df = pandas.read_excel("stargate order lengths.xlsx")
    df = df.fillna("NULL")
    print(f"{df=}")

    print(f"DECLARE @order_length_table AS TABLE ([ID] INT IDENTITY(0, 1), [SGQuote] NVARCHAR(MAX), [Input] NVARCHAR(MAX), [Ft Part] INT, [In Part] INT, [Ft Tot] DECIMAL(14, 7), [In Tot] DECIMAL(14, 7))")
    print(f"INSERT INTO @order_length_table ([SGQuote], [Input], [Ft Part], [In Part], [Ft Tot], [In Tot]) VALUES")
    for i, row in df.iterrows():
        if i > 0:
            s = row['SGQuote']
            n = row['Input']
            f = row['Ft Part']
            p = row['In Part']
            g = row['Ft Tot']
            q = row['In Tot']
            s_row = f"('{s}', '{n}', {f}, {p}, {g}, {q})"
            if i < df.shape[0] - 1:
                s_row += ","
            print(f"{s_row}")


