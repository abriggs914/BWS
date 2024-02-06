from typing import Literal

from pyodbc_connection import connect
from itertools import combinations
import pandas as pd
import datetime


def no_specials(text: str, r_char: str = "_") -> str:

    for c in [
        " ", "!", "@", "#", "$", "%",
        "^", "&", "*", "(", ")", "-",
        "+", "=", "'", "\"", "[", "]",
        "{", "}", "\\", "|", ":", ";",
        "<", ",", ">", ".", "?", "/",
        "~", "`"
    ]:
        text = text.replace(c, "")
    return text


def date_first(msg: str, keyword="date") -> str:
    lmsg = msg.lower()
    if keyword in msg:
        idx = msg.index(keyword)
        if msg[idx - 2 : idx].lower() != "up":
            msg = f"Date{msg[:idx]}{msg[idx + len(keyword):]}"
    # print(f"RETURNED MESSAGE '{msg=}'")
    return msg


def parse_connection_data(data: dict) -> dict:
    """Given a dictionary of ODBC connection data, verify that the user and password are pre-verified."""

    valid_ = {
        "bwsdb": {
            "uid": "user5",
            "pwd": "M@gic456"
        },
        "stargatedb": {
            "uid": "SGeu1",
            "pwd": "Pupplies-Hagard->Rio0"
        }
    }

    if isinstance(data, dict):
        server = data.get("server", "SERVER3").lower()
        database = data.get("database", "BWSdb").lower()
        uid = data.get("uid", valid_[database].get("uid", None))
        pwd = data.get("pwd", valid_[database].get("pwd", None))

        r_uid = valid_[database]["uid"]
        r_pwd = valid_[database]["pwd"]

        if (uid == r_uid) and (pwd == r_pwd):
            return {
                "server": server,
                "database": database,
                "uid": uid,
                "pwd": pwd
            }

    return dict()


def select_with_alias(
        table: str | list | tuple,
        alias: str | None = None,
        prefix: str | None = None,
        f_keys: list | tuple | dict = None,
        no_spaces: bool = True,
        specials_replace: bool = True,
        do_print: bool = False,
        connection_data: dict | None = None,
        with_no_locks: bool = True,
        default_join_style: Literal['INNER', 'LEFT', 'RIGHT', 'FULL', 'LEFT OUTER', 'RIGHT OUTER', 'FULL OUTER'] = "INNER"
) -> str:

    if (len(table) > 2) and (not f_keys):
        raise ValueError(f"When joining more than 2 tables, you must use pass join criterion through the 'f_keys' parameter.")

    placeholder = "##__PLACEHOLDER__##"

    l_table_names = []
    l_table_alias = []
    l_alias = []
    l_keys = []
    l_cds = []

    specials = {
        "#": "Num",
        "%": "Pctg",
        "$": "Dollars",
        "?": "",
        "/": "",
        "date": date_first
    }
    og_keys = list(specials.keys())

    for k in og_keys:
        val = specials[k]

        if (lk := len(k)) > 1:
            combos = []
            for i in range(lk + 1):
                combos_sub = list(combinations(range(lk), i))
                combos += combos_sub

            for combo in combos:
                new_key = k
                for ci in combo:
                    new_key = new_key[:ci] + k[ci].upper() + new_key[ci + 1:]
                # print(f"{k=}, {new_key=}, {combo=}")
                specials[new_key] = val

    if not table:
        raise ValueError(f"'table' can't be None or empty")
    else:
        if not alias:
            if not isinstance(table, (tuple, list)):
                raise ValueError(f"'alias' can't be None or empty string")
        else:
            if not prefix:
                raise ValueError(f"'prefix' can't be None or empty string")
            else:
                prefix = alias

    if not isinstance(table, (list, tuple)):
        tables = [(table, alias, prefix)]
    else:
        tables = table


    if f_keys is not None:
        if isinstance(f_keys, (list, tuple)) and isinstance(f_keys[0], (list, tuple)) and (len(tables) > len(f_keys)):
            # print(f"--AA")
            f_keys = list(f_keys) + [f_keys[-1] for _ in range(len(tables) - len(f_keys))]
        elif isinstance(f_keys, (list, tuple)) and (not isinstance(f_keys[0], (list, tuple))):
            # print(f"--BB")
            f_keys = [f_keys for _ in range(len(tables))]
        elif len(tables) != len(f_keys):
            # print(f"--CC")
            f_keys = list(f_keys) + [f_keys[-1] for _ in range(len(tables) - len(f_keys))]

    # print(f"{tables=}\n{f_keys=}")

    i = 0
    for tn, ta, *a in tables:
        # print(f"{tn=}, {ta=}, {a=}, {i=}, {f_keys=}")
        cd = None
        fk = (None, None, None)
        if f_keys:
            fk = f_keys[i]
        if not a:
            # no prefix | connection data | foreign key given
            a = ta
        else:
            if isinstance(a, (list, tuple)) and (len(a) > 1):
                fk = (default_join_style, a[1], placeholder)
            a = a[0]

        # print(f">> {tn=}, {ta=}, {a=}, {cd=}, {fk=}")

        l_table_names.append(tn)
        l_table_alias.append(ta)
        l_alias.append(a)
        l_keys.append(fk)
        l_cds.append(cd)
        i += 1

    select_statement = "SELECT\n"
    if do_print:
        print(select_statement)
    first = True

    re_connect = True
    if connection_data is not None:
        re_connect = False
        connection_data = parse_connection_data(connection_data)

    join_msg = ""
    cols = {}

    for tn, ta, a, cd, l_key in zip(l_table_names, l_table_alias, l_alias, l_cds, l_keys):

        if not a.endswith("_"):
            a += "_"

        # print(f"{tn=}, {ta=}, {a=}, {cd=}, {l_key=}")

        if re_connect:
            connection_data = parse_connection_data(cd)

        df = connect(f"""SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = N'{tn}'""", **connection_data)
        # print(df)

        col_names = df["COLUMN_NAME"].values.tolist()

        if specials_replace:
            spec_results = []
            for word in [ta, a]:
                # l_word = word.lower()
                r_word = word
                for spec in specials:
                    # print(f"1 {spec=}, {r_word=}")
                    if spec in r_word:
                        if callable(specials[spec]):
                            r_word = specials[spec](r_word)
                        else:
                            r_word = r_word.replace(spec, "")
                spec_results.append(r_word)
            ta, a = spec_results

        if no_spaces:
            ta = ta.replace(" ", "")
            a = a.replace(" ", "")

        # print(f"{col_names=}")

        for name in col_names:
            # print(f"{name=}")

            if name not in cols:
                cols[name] = ta

            og_name = name
            if specials_replace:
                r_word = name
                for spec in specials:
                    # print(f"2 {spec=}, {r_word=}")
                    if spec in r_word:
                        if callable(specials[spec]):
                            r_word = specials[spec](r_word, spec)
                        else:
                            r_word = r_word.replace(spec, "")
                name = r_word

            if no_spaces:
                name = name.replace(" ", "")

            result = f"\t{'' if first else ','}[{ta}].[{og_name}] AS [{a}{name}]"
            select_statement += result + "\n"
            if do_print:
                print(result)
            first = False

    select_statement += "FROM\n"
    if do_print:
        print(f"FROM")

    # print(f"{cols=}")

    # print(f"{l_table_names=}, {l_table_alias=}, {l_alias=}, {l_cds=}, {l_keys=}")
    # msg = ""
    for i, lsts in enumerate(zip(l_table_names, l_table_alias, l_alias, l_cds, l_keys)):
        tn, ta, a, cd, l_key = lsts
        # print(f"<< {tn=}, {ta=}, {a=}, {cd=}, {l_key=}")
        msg = f"\t[{tn}] AS [{ta}]" + (" WITH (NOLOCK)" if with_no_locks else "")
        if join_msg:
            msg += join_msg.format(OTHERTABLE=ta)
            msg = msg.replace(placeholder, l_key[1])
            join_msg = ""
            # msg = msg.strip()
            select_statement += msg
        else:
            msg += ","
            select_statement += msg + "\n"

        if do_print:
            print(msg)
        if l_key:
            j_style, l1, l2 = l_key
            if j_style and l1 and l2:
                try:
                    table = cols[l1]
                except KeyError as ke:
                    raise KeyError(f"Invalid join column name '{l1}'")
                select_statement = select_statement.removesuffix(",\n") + "\n"
                msg = f"{j_style.upper()} JOIN"
                join_msg = f"\nON\n\t[{table}].[{l1}] = [{{OTHERTABLE}}].[{l2}]"
                # print(f"{i=}, {msg=}, {j_style=}, {l1=}, {l2=}")
                if i < (len(l_table_names) - 1):
                    # select_statement = select_statement.removesuffix("\n\n") + msg + "\n"
                    select_statement += msg + "\n"
                if do_print:
                    print(msg)

    select_statement = select_statement.strip().removesuffix(",").strip() + "\n;"
    select_statement = select_statement.removesuffix(",\n")

    # print(f"\n--" + ("#" * 120) + "\n")

    return select_statement


def create_history_table(
        table: str,
        history_table: str = "",
        connection_data: dict | None = None,
        block_warnings: bool = True,
        create_alter: Literal['CREATE', 'ALTER'] = "CREATE"
):

    if block_warnings:
        import warnings
        warnings.filterwarnings("ignore", category=UserWarning)

    if " " in table:
        if "[" in table or "]" in table:
            raise ValueError(f"Invalid table name '{table}'.")
        # table = f"[{table}]"

    sql = """
    SELECT *
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = '{TABLE}';
    """

    hist_table = f"[{table}_History]" if not history_table else history_table

    connection_data = parse_connection_data(connection_data)

    df = connect(sql.format(TABLE=table), **connection_data)

    if df.empty:
        raise ValueError(f"Couldn't find any data on table '{table}' for this database. Please check spelling and connection data settings.\n{connection_data=}")

    df_pk = df.loc[(df["TABLE_NAME"] == table) & (df["IS_NULLABLE"] == "NO") & (df["DATA_TYPE"] == "int")]
    if df_pk.empty:
        df_pk = df.loc[(df["TABLE_NAME"] == table) & (df["IS_NULLABLE"] == "NO")]

    pk = df_pk.loc[0]["COLUMN_NAME"]

    # print(f"{pk=}")

    df_history = connect(sql.format(TABLE=hist_table))

    if not df_history.empty:
        raise ValueError(f"Error this table name is already in use '{hist_table}'.")

    new_hist_columns = [
        # "[History_ID]",  # do not include PK
        "[History_DateCreated]",
        "[History_Action]",
        "[History_User]",
        "[History_Column]",
        "[History_OldValue]",
        "[History_NewValue]",
    ]

    sql_create_table = f"""{create_alter} TABLE [dbo].{hist_table} ( 
    [History_ID] [int] IDENTITY(0, 1) NOT NULL, 
    [History_DateCreated] [datetime] NULL, 
    [History_Action] [nvarchar](max) NULL,
    [History_User] [nvarchar](max) NULL,
    [History_Column] [nvarchar](max) NULL,
    [History_OldValue] [nvarchar](max) NULL,
    [History_NewValue] [nvarchar](max) NULL,
    {{REST_COLUMNS}}
    CONSTRAINT [PK_{hist_table.replace('[', '').replace(']', '')}] PRIMARY KEY CLUSTERED 
(
	[History_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO"""
    sql_trigger = """
    
-- BEGIN TABLE CREATION
    {SQL_TABLE_CREATION}
    
    
-- ================================================
-- Template generated from Template Explorer using:
-- Create Trigger (New Menu).SQL
--
-- Use the Specify Values for Template Parameters
-- command (Ctrl-Shift-M) to fill in the parameter
-- values below.
--
-- See additional Create Trigger templates for more
-- examples of different Trigger statements.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<{AUTHOR}>
-- Create date: <{DATE_CREATED}>
-- Description:	<{DESCRIPTION}>
-- =============================================
{CREATE_ALTER} TRIGGER [dbo].[tr_Update{TABLE}History]
   ON [{TABLE}]
   --BEFORE
   AFTER
   --INSTEAD OF
   INSERT
   , DELETE
   , UPDATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF TRIGGER_NESTLEVEL() < 2 BEGIN

	    -- Differences Table
	    {SQL_DIFF_TABLE}

	    -- Declarative Statements
	    {SQL_DECLARES}

	    -- Assignment Statements
	    {SQL_ASSIGNS}

		DECLARE @user NVARCHAR(20);
		DECLARE @activity NVARCHAR(20);

		-- Insert statements for trigger here
		IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) BEGIN
			SET @activity = 'UPDATE';
			SET @user = SYSTEM_USER;
			{SQL_UPDATED}
		END
		IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) BEGIN
			SET @activity = 'INSERT';
			SET @user = SYSTEM_USER;
			{SQL_INSERTED}
		END
		IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted) BEGIN
			SET @activity = 'DELETE';
			SET @user = SYSTEM_USER;
			{SQL_DELETED}
		END

		-- Check if new changes
		{SQL_DIFF}

		-- Update the History table for as many changes as were identified
		{SQL_HIST_UPDATE}

	END
END
GO
    """
    sql_declares = ["{TD}DECLARE @{COL} AS {TYP}", "", ""]
    sql_assigns = ["{TDp1}@{COL_A} = [{COL}]", "{TD}SELECT\n", "{TD}SELECT\n", "\n{TD}FROM\n{TDp1}{TAB_A}\n{TD};"]
    sql_differences_t = """
		DECLARE @t_to_update AS TABLE
		(
			[ID] INT IDENTITY(1, 1),
			[Column] NVARCHAR(MAX),
			[ValueBefore] NVARCHAR(MAX),
			[ValueAfter] NVARCHAR(MAX)
		)
	;
	"""
    sql_differences = ["{TD}IF {COLA} <> {COLB} BEGIN\n{TDp1}INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])\n{TDp1}SELECT '{COL}', CAST({COLA} AS NVARCHAR(MAX)), CAST({COLB} AS NVARCHAR(MAX));\n{TD}END", ""]
    sql_hist_update = """
    -- Finally iteratively update [dbo].[IT Request History] for each changed value

		DECLARE @c AS INT;
		SELECT @c = COUNT(*) FROM @t_to_update;

		IF @c > 0 BEGIN

			IF @user IS NULL BEGIN
				SELECT @user = SYSTEM_USER;
			END

			DECLARE @i AS INT;
			DECLARE @column AS NVARCHAR(MAX);
			DECLARE @value_before AS NVARCHAR(MAX);
			DECLARE @value_after AS NVARCHAR(MAX);

			SELECT @i = 0;

			WHILE @i < @c BEGIN

				SELECT @i = @i + 1;

				SELECT
					@column = [Column]
					,@value_before = [ValueBefore]
					,@value_after = [ValueAfter]
				FROM
					@t_to_update
				WHERE
					[ID] = @i

				INSERT INTO
					[dbo].{HIST_TABLE}
				(
				    {NEW_HIST_COLUMNS}
				    ,{LIST_HISTORY_COLUMNS}
				)
				
				SELECT
				    {NEW_COLUMNS}
                    ,{LIST_COLUMNS}
				FROM
					[{TABLE}]
				WHERE
					[{PK}] = ISNULL(@new_{PK_A}, @old_{PK_A})

			END
		END
    """

    invalid_types = list(map(str.upper, ["text", "ntext", "image", "timestamp"]))
    td = 2 * "\t"
    tdp1 = (len(td) + 1) * "\t"
    sql_assigns[1] = sql_assigns[1].format(TD=td)
    sql_assigns[2] = sql_assigns[2].format(TD=td)

    rest_columns = ""
    # new_hist_columns = "NEW_HISTORY_COLUMNS"
    list_history_columns = ""
    new_columns = [
        # f"'{datetime.datetime.now():%Y-%m-%d %H:%M:%S}'",
        f"GETDATE()",
        "@activity",
        "@user",
        "@column",
        "@value_before",
        "@value_after"
    ]
    list_columns = ""

    # loop the table schema and collect the column names and types to prepare declarative statements.
    # 1 new and 1 old declare per column name
    for i, row in df.iterrows():
        col = row["COLUMN_NAME"]
        typ = row["DATA_TYPE"].upper()
        siz = row["CHARACTER_MAXIMUM_LENGTH"]

        if typ in invalid_types:
            continue

        old_col = no_specials(f"old_{col.replace(' ', '_')}")
        new_col = no_specials(f"new_{col.replace(' ', '_')}")

        siz = "MAX" if siz == -1 else (int(siz) if not pd.isnull(siz) else siz)
        # print(f"{i=}, {col=}, {typ=}, {siz=}")
        new_declare = sql_declares[0].format(TD=td, COL=old_col, TYP=typ)
        old_declare = sql_declares[0].format(TD=td, COL=new_col, TYP=typ)
        r_c_size = ""
        if typ == "NVARCHAR":
            new_declare += f"({siz})"
            old_declare += f"({siz})"
            r_c_size = f"({siz})"
        sql_declares[1] += new_declare + ";\n"
        sql_declares[2] += old_declare + ";\n"

        rest_columns += f"\t[{col}] [{typ}]{r_c_size} NULL,\n"
        list_history_columns += f"{td}{tdp1}[{col}],\n"

        old_assign = sql_assigns[0].format(TDp1=tdp1, COL_A=old_col, COL=col)
        new_assign = sql_assigns[0].format(TDp1=tdp1, COL_A=new_col, COL=col)
        sql_assigns[1] += old_assign + ",\n"
        sql_assigns[2] += new_assign + ",\n"

        diff = sql_differences[0].format(TD=td, TDp1=tdp1, COLA=f"@{old_col}", COLB=f"@{new_col}", COL=col)
        sql_differences[1] += diff + "\n"

    # print(f"A {len(sql_assigns[1])=}, {sql_assigns[1][-1]=}")

    # clean up
    sql_declares[1] = sql_declares[1].removesuffix("\n")
    sql_declares[2] = sql_declares[2].removesuffix("\n")
    sql_assigns[1] = sql_assigns[1].removesuffix(",\n")
    sql_assigns[2] = sql_assigns[2].removesuffix(",\n")

    # print(f"B {len(sql_assigns[1])=}, {sql_assigns[1][-1]=}")

    sql_assigns[1] += sql_assigns[3].format(TD=td, TDp1=tdp1, TAB_A=f"DELETED [D]")
    sql_assigns[2] += sql_assigns[3].format(TD=td, TDp1=tdp1, TAB_A=f"INSERTED [I]")

    author = "Avery Briggs"
    date_created = f"{datetime.datetime.now():%Y-%m-%d %H:%M:%S}"
    description = f"SQL Trigger to check changes to all columns, and if found, then will create a history record to mark the change"
    sql_c = sql_declares[1] + '\n' + sql_declares[2]
    sql_a = sql_assigns[1] + '\n' + sql_assigns[2]
    sql_u = "-- SQL Update"
    sql_i = "-- SQL Insert"
    sql_d = "-- SQL Delete"

    rest_columns = rest_columns.removeprefix("\t").removesuffix(",\n")
    new_hist_columns = f",\n{td}{tdp1}".join(new_hist_columns)
    new_columns = f",\n{td}{tdp1}".join(new_columns)
    list_history_columns = list_history_columns.strip().removesuffix(",")

    pk = pk
    pk_a = no_specials(pk)
    sql_create_table = sql_create_table.format(REST_COLUMNS=rest_columns)
    sql_hist_update = sql_hist_update.format(
        PK=pk,
        PK_A=pk_a,
        NEW_HIST_COLUMNS=new_hist_columns,
        LIST_HISTORY_COLUMNS=list_history_columns,
        TABLE=table,
        HIST_TABLE=hist_table,
        NEW_COLUMNS=new_columns,
        # LIST_COLUMNS=list_columns
        LIST_COLUMNS=list_history_columns
    )
    all_sql = sql_trigger.format(
        TABLE=table,
        CREATE_ALTER=create_alter,
        SQL_DECLARES=sql_c,
        SQL_ASSIGNS=sql_a,
        SQL_INSERTED=sql_i,
        SQL_UPDATED=sql_u,
        SQL_DELETED=sql_d,
        AUTHOR=author,
        DATE_CREATED=date_created,
        DESCRIPTION=description,
        SQL_DIFF_TABLE=sql_differences_t,
        SQL_DIFF=sql_differences[1],
        SQL_HIST_UPDATE=sql_hist_update,
        SQL_TABLE_CREATION=sql_create_table
    )

    # print(f"{all_sql=}")

    # print(f"{sql_declares[1]}")
    # print(f"{sql_declares[2]}")
    # print(f"{sql_assigns[1]}")
    # print(f"{sql_assigns[2]}")

    if block_warnings:
        warnings.resetwarnings()

    return all_sql


# 2024-02-02 1355
# def create_history_table(
#         table: str,
#         history_table: str = "",
#         connection_data: dict | None = None,
#         block_warnings: bool = True,
#         create_alter: Literal['CREATE', 'ALTER'] = "CREATE"
# ):
#     if block_warnings:
#         import warnings
#         warnings.filterwarnings("ignore", category=UserWarning)
#
#     if " " in table:
#         if "[" in table or "]" in table:
#             raise ValueError(f"Invalid table name '{table}'.")
#         # table = f"[{table}]"
#
#     sql = """
#     SELECT *
#     FROM INFORMATION_SCHEMA.COLUMNS
#     WHERE TABLE_NAME = '{TABLE}';
#     """
#
#     hist_table = f"[{table}_History]" if not history_table else history_table
#
#     connection_data = parse_connection_data(connection_data)
#
#     df = connect(sql.format(TABLE=table), **connection_data)
#
#     if df.empty:
#         raise ValueError(
#             f"Couldn't find any data on table '{table}' for this database. Please check spelling and connection data settings.\n{connection_data=}")
#
#     df_pk = df.loc[(df["TABLE_NAME"] == table) & (df["IS_NULLABLE"] == "NO") & (df["DATA_TYPE"] == "int")]
#     if df_pk.empty:
#         df_pk = df.loc[(df["TABLE_NAME"] == table) & (df["IS_NULLABLE"] == "NO")]
#
#     pk = df_pk.loc[0]["COLUMN_NAME"]
#
#     # print(f"{pk=}")
#
#     df_history = connect(sql.format(TABLE=hist_table))
#
#     if not df_history.empty:
#         raise ValueError(f"Error this table name is already in use '{hist_table}'.")
#
#     new_hist_columns = [
#         # "[History_ID]",  # do not include PK
#         "[History_DateCreated]",
#         "[History_Action]",
#         "[History_User]",
#         "[History_Column]",
#         "[History_OldValue]",
#         "[History_NewValue]",
#     ]
#
#     sql_create_table = f"""{create_alter} TABLE [dbo].{hist_table} (
#     [History_ID] [int] IDENTITY(0, 1) NOT NULL,
#     [History_DateCreated] [datetime] NULL,
#     [History_Action] [nvarchar](max) NULL,
#     [History_User] [nvarchar](max) NULL,
#     [History_Column] [nvarchar](max) NULL,
#     [History_OldValue] [nvarchar](max) NULL,
#     [History_NewValue] [nvarchar](max) NULL,
#     {{REST_COLUMNS}}
#     CONSTRAINT [PK_{hist_table.replace('[', '').replace(']', '')}] PRIMARY KEY CLUSTERED
# (
# 	[History_ID] ASC
# )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
# ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
# GO"""
#     sql_trigger = """
#
# -- BEGIN TABLE CREATION
#     {SQL_TABLE_CREATION}
#
#
# -- ================================================
# -- Template generated from Template Explorer using:
# -- Create Trigger (New Menu).SQL
# --
# -- Use the Specify Values for Template Parameters
# -- command (Ctrl-Shift-M) to fill in the parameter
# -- values below.
# --
# -- See additional Create Trigger templates for more
# -- examples of different Trigger statements.
# --
# -- This block of comments will not be included in
# -- the definition of the function.
# -- ================================================
# SET ANSI_NULLS ON
# GO
# SET QUOTED_IDENTIFIER ON
# GO
# -- =============================================
# -- Author:		<{AUTHOR}>
# -- Create date: <{DATE_CREATED}>
# -- Description:	<{DESCRIPTION}>
# -- =============================================
# {CREATE_ALTER} TRIGGER [dbo].[tr_Update{TABLE}History]
#    ON [{TABLE}]
#    --BEFORE
#    AFTER
#    --INSTEAD OF
#    INSERT
#    , DELETE
#    , UPDATE
# AS
# BEGIN
# 	-- SET NOCOUNT ON added to prevent extra result sets from
# 	-- interfering with SELECT statements.
# 	SET NOCOUNT ON;
#
# 	IF TRIGGER_NESTLEVEL() < 2 BEGIN
#
# 	    -- Differences Table
# 	    {SQL_DIFF_TABLE}
#
# 	    -- Declarative Statements
# 	    {SQL_DECLARES}
#
# 	    -- Assignment Statements
# 	    {SQL_ASSIGNS}
#
# 		DECLARE @user NVARCHAR(20);
# 		DECLARE @activity NVARCHAR(20);
#
# 		-- Insert statements for trigger here
# 		IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) BEGIN
# 			SET @activity = 'UPDATE';
# 			SET @user = SYSTEM_USER;
# 			{SQL_UPDATED}
# 		END
# 		IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) BEGIN
# 			SET @activity = 'INSERT';
# 			SET @user = SYSTEM_USER;
# 			{SQL_INSERTED}
# 		END
# 		IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted) BEGIN
# 			SET @activity = 'DELETE';
# 			SET @user = SYSTEM_USER;
# 			{SQL_DELETED}
# 		END
#
# 		-- Check if new changes
# 		{SQL_DIFF}
#
# 		-- Update the History table for as many changes as were identified
# 		{SQL_HIST_UPDATE}
#
# 	END
# END
# GO
#     """
#     sql_declares = ["{TD}DECLARE @{COL} AS {TYP}", "", ""]
#     sql_assigns = ["{TDp1}@{COL_A} = [{COL}]", "{TD}SELECT\n", "{TD}SELECT\n", "\n{TD}FROM\n{TDp1}{TAB_A}\n{TD};"]
#     sql_differences_t = """
# 		DECLARE @t_to_update AS TABLE
# 		(
# 			[ID] INT IDENTITY(1, 1),
# 			[Column] NVARCHAR(MAX),
# 			[ValueBefore] NVARCHAR(MAX),
# 			[ValueAfter] NVARCHAR(MAX)
# 		)
# 	;
# 	"""
#     sql_differences = [
#         "{TD}IF {COLA} <> {COLB} BEGIN\n{TDp1}INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])\n{TDp1}SELECT '{COL}', CAST({COLA} AS NVARCHAR(MAX)), CAST({COLB} AS NVARCHAR(MAX));\n{TD}END",
#         ""]
#     sql_hist_update = """
#     -- Finally iteratively update [dbo].[IT Request History] for each changed value
#
# 		DECLARE @c AS INT;
# 		SELECT @c = COUNT(*) FROM @t_to_update;
#
# 		IF @c > 0 BEGIN
#
# 			IF @user IS NULL BEGIN
# 				SELECT @user = SYSTEM_USER;
# 			END
#
# 			DECLARE @i AS INT;
# 			DECLARE @column AS NVARCHAR(MAX);
# 			DECLARE @value_before AS NVARCHAR(MAX);
# 			DECLARE @value_after AS NVARCHAR(MAX);
#
# 			SELECT @i = 0;
#
# 			WHILE @i < @c BEGIN
#
# 				SELECT @i = @i + 1;
#
# 				SELECT
# 					@column = [Column]
# 					,@value_before = [ValueBefore]
# 					,@value_after = [ValueAfter]
# 				FROM
# 					@t_to_update
# 				WHERE
# 					[ID] = @i
#
# 				INSERT INTO
# 					[dbo].{HIST_TABLE}
# 				(
# 				    {NEW_HIST_COLUMNS}
# 				    ,{LIST_HISTORY_COLUMNS}
# 				)
#
# 				SELECT
# 				    {NEW_COLUMNS}
#                     ,{LIST_COLUMNS}
# 				FROM
# 					[{TABLE}]
# 				WHERE
# 					[{PK}] = ISNULL(@new_{PK_A}, @old_{PK_A})
#
# 			END
# 		END
#     """
#
#     invalid_types = list(map(str.upper, ["text", "ntext", "image", "timestamp"]))
#     td = 2 * "\t"
#     tdp1 = (len(td) + 1) * "\t"
#     sql_assigns[1] = sql_assigns[1].format(TD=td)
#     sql_assigns[2] = sql_assigns[2].format(TD=td)
#
#     rest_columns = ""
#     # new_hist_columns = "NEW_HISTORY_COLUMNS"
#     list_history_columns = ""
#     new_columns = [
#         # f"'{datetime.datetime.now():%Y-%m-%d %H:%M:%S}'",
#         f"GETDATE()",
#         "@activity",
#         "@user",
#         "@column",
#         "@value_before",
#         "@value_after"
#     ]
#     list_columns = ""
#
#     # loop the table schema and collect the column names and types to prepare declarative statements.
#     # 1 new and 1 old declare per column name
#     for i, row in df.iterrows():
#         col = row["COLUMN_NAME"]
#         typ = row["DATA_TYPE"].upper()
#         siz = row["CHARACTER_MAXIMUM_LENGTH"]
#
#         if typ in invalid_types:
#             continue
#
#         old_col = no_specials(f"old_{col.replace(' ', '_')}")
#         new_col = no_specials(f"new_{col.replace(' ', '_')}")
#
#         siz = "MAX" if siz == -1 else (int(siz) if not pd.isnull(siz) else siz)
#         # print(f"{i=}, {col=}, {typ=}, {siz=}")
#         new_declare = sql_declares[0].format(TD=td, COL=old_col, TYP=typ)
#         old_declare = sql_declares[0].format(TD=td, COL=new_col, TYP=typ)
#         r_c_size = ""
#         if typ == "NVARCHAR":
#             new_declare += f"({siz})"
#             old_declare += f"({siz})"
#             r_c_size = f"({siz})"
#         sql_declares[1] += new_declare + ";\n"
#         sql_declares[2] += old_declare + ";\n"
#
#         rest_columns += f"\t[{col}] [{typ}]{r_c_size} NULL,\n"
#         list_history_columns += f"{td}{tdp1}[{col}],\n"
#
#         old_assign = sql_assigns[0].format(TDp1=tdp1, COL_A=old_col, COL=col)
#         new_assign = sql_assigns[0].format(TDp1=tdp1, COL_A=new_col, COL=col)
#         sql_assigns[1] += old_assign + ",\n"
#         sql_assigns[2] += new_assign + ",\n"
#
#         diff = sql_differences[0].format(TD=td, TDp1=tdp1, COLA=f"@{old_col}", COLB=f"@{new_col}", COL=col)
#         sql_differences[1] += diff + "\n"
#
#     # print(f"A {len(sql_assigns[1])=}, {sql_assigns[1][-1]=}")
#
#     # clean up
#     sql_declares[1] = sql_declares[1].removesuffix("\n")
#     sql_declares[2] = sql_declares[2].removesuffix("\n")
#     sql_assigns[1] = sql_assigns[1].removesuffix(",\n")
#     sql_assigns[2] = sql_assigns[2].removesuffix(",\n")
#
#     # print(f"B {len(sql_assigns[1])=}, {sql_assigns[1][-1]=}")
#
#     sql_assigns[1] += sql_assigns[3].format(TD=td, TDp1=tdp1, TAB_A=f"DELETED [D]")
#     sql_assigns[2] += sql_assigns[3].format(TD=td, TDp1=tdp1, TAB_A=f"INSERTED [I]")
#
#     author = "Avery Briggs"
#     date_created = f"{datetime.datetime.now():%Y-%m-%d %H:%M:%S}"
#     description = f"SQL Trigger to check changes to all columns, and if found, then will create a history record to mark the change"
#     sql_c = sql_declares[1] + '\n' + sql_declares[2]
#     sql_a = sql_assigns[1] + '\n' + sql_assigns[2]
#     sql_u = "-- SQL Update"
#     sql_i = "-- SQL Insert"
#     sql_d = "-- SQL Delete"
#
#     rest_columns = rest_columns.removeprefix("\t").removesuffix(",\n")
#     new_hist_columns = f",\n{td}{tdp1}".join(new_hist_columns)
#     new_columns = f",\n{td}{tdp1}".join(new_columns)
#     list_history_columns = list_history_columns.strip().removesuffix(",")
#
#     pk = pk
#     pk_a = no_specials(pk)
#     sql_create_table = sql_create_table.format(REST_COLUMNS=rest_columns)
#     sql_hist_update = sql_hist_update.format(
#         PK=pk,
#         PK_A=pk_a,
#         NEW_HIST_COLUMNS=new_hist_columns,
#         LIST_HISTORY_COLUMNS=list_history_columns,
#         TABLE=table,
#         HIST_TABLE=hist_table,
#         NEW_COLUMNS=new_columns,
#         # LIST_COLUMNS=list_columns
#         LIST_COLUMNS=list_history_columns
#     )
#     all_sql = sql_trigger.format(
#         TABLE=table,
#         CREATE_ALTER=create_alter,
#         SQL_DECLARES=sql_c,
#         SQL_ASSIGNS=sql_a,
#         SQL_INSERTED=sql_i,
#         SQL_UPDATED=sql_u,
#         SQL_DELETED=sql_d,
#         AUTHOR=author,
#         DATE_CREATED=date_created,
#         DESCRIPTION=description,
#         SQL_DIFF_TABLE=sql_differences_t,
#         SQL_DIFF=sql_differences[1],
#         SQL_HIST_UPDATE=sql_hist_update,
#         SQL_TABLE_CREATION=sql_create_table
#     )
#
#     # print(f"{all_sql=}")
#
#     # print(f"{sql_declares[1]}")
#     # print(f"{sql_declares[2]}")
#     # print(f"{sql_assigns[1]}")
#     # print(f"{sql_assigns[2]}")
#
#     if block_warnings:
#         warnings.resetwarnings()
#
#     return all_sql