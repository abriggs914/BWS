import datetime

import pandas as pd
import pyodbc


def connect(sql, cstr="DRIVER={SQL Server};SERVER=server3;DATABASE=BWSdb;UID=user5;PWD=M@gic456", do_print=False):
    df = None
    try:
        # sql_opt = "SELECT [IT Requests].*, [dept].[Dept] AS [DeptName], [IT Personnel].[Name] AS [ITPersonnelAssignedName] FROM [IT Requests] LEFT JOIN [Dept] ON [IT Requests].[Department] = [Dept].[DeptID] LEFT JOIN [IT Personnel] ON [IT Requests].[ITPersonAssignedID] = [IT Personnel].[ITPersonID#]"
        if do_print:
            print("connecting...")
        conn = pyodbc.connect(cstr)
        if do_print:
            print("querying...")
        df = pd.DataFrame(pd.read_sql_query(sql, conn))
        conn.close()
    except pyodbc.DatabaseError as de:
        print(f"DatabaseError\n{de}")
    return df


def gen_inserts(mode="ET"):
    match mode:
        case "ET":
            file_name = "ET Option Comparison.xlsx"
            output_file = "ET Option Comparison.sql"
            sheet_name = "Test"
            op_no_name = "Option No"
            stop_idx = -1
        case "TAG":
            file_name = "Tag Option Comparison.xlsx"
            output_file = "TAG Option Comparison.sql"
            sheet_name = "All of em not gonna blow up 0,1"
            op_no_name = "Options"
            stop_idx = -3
        case _:
            raise ValueError(f"Error param 'mode' must be either 'TAG' OR 'ET'. Got '{mode}'")
    df = pd.read_excel(f"./{file_name}", sheet_name=sheet_name)
    # this df marks the correct option number from a 'completed' option,
    # and whether to map it or not to the rest of the models listed as columns.

    tables = ["Options", "Budget Options", "Options_FactoryLines", "Options_SpecLines"]
    table = tables[0]

    query_results = {}
    all_sql_opt = f"SELECT * FROM [Options]"
    query_results[all_sql_opt] = connect(all_sql_opt)
    all_sql_bud = f"SELECT * FROM [Budget Options]"
    query_results[all_sql_bud] = connect(all_sql_bud)
    results_by_table = {"Options": [], "Budget Options": []}
    results_by_model = {}

    def next_option_id_opt(model_in=None):
        if model_in is None:
            return query_results[all_sql_opt] + 1
        else:
            sql = f"SELECT * FROM [Options] WHERE [Model No] LIKE '%{model_in}%'"
            if sql in query_results:
                query_results[sql] += 1
                n = query_results[sql]
                # df.loc[len(df.index)] = [None for col in df.columns]
            else:
                query_results[sql] = connect(sql).shape[0] + 1
                n = query_results[sql]
            return f"{model_in}-{f'00000{n + 1}'[-5:]}"

    def next_option_id_bud(model_in=None):
        if model_in is None:
            return query_results[all_sql_bud] + 1
        else:
            sql = f"SELECT * FROM [Budget Options] WHERE [Model No] LIKE '%{model_in}%'"
            if sql in query_results:
                query_results[sql] += 1
                n = query_results[sql]
                # df.loc[len(df.index)] = [None for col in df.columns]
            else:
                query_results[sql] = connect(sql).shape[0] + 1
                n = query_results[sql]
            return f"{model_in}-{f'00000{n + 1}'[-5:]}"

    columns = list(df.columns)
    models = columns[1:stop_idx].copy()
    i_option_no = columns.index(op_no_name)
    # print(f"header = {columns}")
    # print(f"{len(columns)=}")
    for idx, row in df.iterrows():
        # print(f"{row=}, {type(row)=}, {len(row)=}")
        option = row[i_option_no]
        section_opt = connect(f"SELECT [Sections] FROM [Options] WHERE [Option No] = '{option}'")["Sections"].tolist()
        if section_opt:
            section_opt = section_opt[0]
        else:
            section_opt = "NULL"
        section_bud = \
        connect(f"SELECT [Sections] FROM [Budget Options] WHERE [Option No] = '{option}'")["Sections"].tolist()
        if section_bud:
            section_bud = section_bud[0]
        else:
            section_bud = "NULL"
        desc = row[0]
        model_data = row[1:stop_idx].tolist()
        model_data = [models[i] for i, v in enumerate(model_data) if v]
        print(f"map {option=} to models {model_data=}")
        for model in model_data:
            sql_opt = f"SELECT * FROM [Options] WHERE [Model No] LIKE '%{model}%'"
            sql_bud = f"SELECT * FROM [Budget Options] WHERE [Model No] LIKE '%{model}%'"
            record_opt = [
                model,
                next_option_id_opt(model),
                datetime.datetime.now().strftime("%Y-%m-%d"),
                (datetime.datetime.now() + datetime.timedelta(days=365)).strftime("%Y-%m-%d"),
                0.0,
                section_opt,
                desc,
                0,  # weight
                "NULL",
                0,
                "NULL",
                1,
                "NULL",
                "NULL",
                0,
                0,
                "NULL",
                "NULL",
                0,
                "NULL",
                "NULL",
                "NULL",
                0.00
            ]
            record_bud = [
                datetime.datetime.now().strftime("%Y-%m-%d"),
                model,
                next_option_id_bud(model),
                desc,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                section_bud,
                0,
                0
            ]
            query_opt = f"""\tINSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ({", ".join([str(rec) if not isinstance(rec, str) or rec == "NULL" else f"'{rec}'" for rec in record_opt])});"""
            print(query_opt)
            query_bud = f"""\tINSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ({", ".join([str(rec) if not isinstance(rec, str) or rec == "NULL" else f"'{rec}'" for rec in record_bud])});"""
            print(query_bud)
            results_by_table["Options"].append(query_opt)
            results_by_table["Budget Options"].append(query_bud)
            if model not in results_by_model:
                results_by_model[model] = {"Options": [], "Budget Options": []}
            results_by_model[model]["Options"].append(query_opt)
            results_by_model[model]["Budget Options"].append(query_bud)
            if sql_opt in query_results:
                df = query_results[sql_opt]
                # df.loc[len(df.index)] = [None for col in df.columns]
            else:
                query_results[sql_opt] = connect(sql_opt)
                df = query_results[sql_opt]

            if sql_bud in query_results:
                df = query_results[sql_bud]
                # df.loc[len(df.index)] = [None for col in df.columns]
            else:
                query_results[sql_bud] = connect(sql_bud)
                df = query_results[sql_bud]

    obsolete_template = "\nUPDATE\n\t[XXXXX]\nSET\n\t[Obsolete] = 1\nWHERE\n\t[Model No] IN (YYYYY\n\t);\n"
    model_names = list(results_by_model.keys())
    table_names = list(results_by_table.keys())
    # raise ValueError(f"models: {results_by_model.keys()}")
    with open(output_file, "w") as f:
        block = "-" * 120
        m1 = f"{block}\nUSE BWSdb\nGO\n\nBEGIN TRAN;"
        print(m1)
        f.write(m1 + "\n\n")
        for table in results_by_table.keys():
            m2 = obsolete_template.replace("YYYYY", "\n\t\t'" + "'\n\t\t, '".join(model_names) + "'").replace("XXXXX", table)
            print(m2)
            f.write(m2 + "\n")
        for model, m_values in results_by_model.items():
            m3 = f"--MODEL={model}"
            print(m3)
            f.write("\n" + m3 + "\n")
            for table, t_values in m_values.items():
                m4 = f"\t--TABLE=[{table}]"
                print(m4)
                f.write(m4 + "\n")
                for query in t_values:
                    m5 = f"\t\t{query}"
                    print(m5)
                    f.write(m5 + "\n")
        m6 = f"\nROLLBACK;\nCOMMIT;\n{block}"
        print(m6)
        f.write(m6 + "\n")


if __name__ == '__main__':

    # generate SQL statements to update option wordings for ET models
    # source -- "ET Option Comparison.xlsx"
    gen_inserts("ET")

    # generate SQL statements to update option wordings for TAG models
    # source -- "TAG Option Comparison.xlsx"
    gen_inserts("TAG")


