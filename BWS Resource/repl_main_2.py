import datetime

import pandas as pd

from pyodbc_connection import connect

if __name__ == '__main__':

    table = "OrdersV2"
    pk = "OrderID"

    sql = """
    SELECT *
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = '{TABLE}';
    """.format(TABLE=table)

    df = connect(sql)
    df_history = connect()
    sql_trigger = """
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
CREATE TRIGGER  [dbo].[tr_Update{TABLE}History]
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
			[Column] NVARCHAR(255),
			[ValueBefore] NVARCHAR(MAX),
			[ValueAfter] NVARCHAR(MAX)
		)
	;
	"""
    sql_differences = [
        "{TD}IF {COLA} <> {COLB} BEGIN\n{TDp1}INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])\n{TDp1}SELECT '{COL}', CAST({COLA} AS NVARCHAR(MAX)), CAST({COLB} AS NVARCHAR(MAX));\n{TD}END",
        ""]
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
					[dbo].[{TABLE} History]
				(
					[Action]
					,[When]
					,[User]
					,[Column]
					,[OldValue]
					,[NewValue]
					,{HIST_TABLE_COLS})
				
				SELECT
					@activity
					,GETDATE()
					,@user
					,@column
					,@value_before
					,@value_after
					,{TABLE_COLS}
				FROM
					[{TABLE}]
				WHERE 
					[{PK}] = ISNULL(@new_{PK}, @old_{PK})
			END
		END
    """
    sql_new_table = ["""SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[{TABLE} History]("""]

    invalid_types = list(map(str.upper, ["text", "ntext", "image", "timestamp"]))
    td = 2 * "\t"
    tdp1 = (len(td) + 1) * "\t"
    sql_assigns[1] = sql_assigns[1].format(TD=td)
    sql_assigns[2] = sql_assigns[2].format(TD=td)
    table_cols = []

    # loop the table schema and collect the column names and types to prepare declarative statements.
    # 1 new and 1 old declare per column name
    for i, row in df.iterrows():
        col = row["COLUMN_NAME"]
        typ = row["DATA_TYPE"].upper()
        siz = row["CHARACTER_MAXIMUM_LENGTH"]

        if typ in invalid_types:
            continue

        table_cols.append(col)

        old_col = f"old_{col.replace(' ', '_')}".replace("?", "_").replace("#", "_").replace("/", "_")
        new_col = f"new_{col.replace(' ', '_')}".replace("?", "_").replace("#", "_").replace("/", "_")

        siz = "MAX" if siz == -1 else (int(siz) if not pd.isnull(siz) else siz)
        # print(f"{col=}, {typ=}")
        new_declare = sql_declares[0].format(TD=td, COL=old_col, TYP=typ)
        old_declare = sql_declares[0].format(TD=td, COL=new_col, TYP=typ)
        if typ == "NVARCHAR":
            new_declare += f"({siz})"
            old_declare += f"({siz})"
        sql_declares[1] += new_declare + ";\n"
        sql_declares[2] += old_declare + ";\n"

        old_assign = sql_assigns[0].format(TDp1=tdp1, COL_A=old_col, COL=col)
        new_assign = sql_assigns[0].format(TDp1=tdp1, COL_A=new_col, COL=col)
        sql_assigns[1] += old_assign + ",\n"
        sql_assigns[2] += new_assign + ",\n"

        diff = sql_differences[0].format(TD=td, TDp1=tdp1, COLA=f"@{old_col}", COLB=f"@{new_col}", COL=col)
        sql_differences[1] += diff + "\n"

    print(f"A {len(sql_assigns[1])=}, {sql_assigns[1][-1]=}")

    # clean up
    sql_declares[1] = sql_declares[1].removesuffix("\n")
    sql_declares[2] = sql_declares[2].removesuffix("\n")
    sql_assigns[1] = sql_assigns[1].removesuffix(",\n")
    sql_assigns[2] = sql_assigns[2].removesuffix(",\n")

    print(f"B {len(sql_assigns[1])=}, {sql_assigns[1][-1]=}")

    sql_assigns[1] += sql_assigns[3].format(TD=td, TDp1=tdp1, TAB_A=f"DELETED [D]")
    sql_assigns[2] += sql_assigns[3].format(TD=td, TDp1=tdp1, TAB_A=f"INSERTED [I]")

    table_cols = "[" + "], [".join(table_cols) + "]"
    hist_table_cols = "[" + "], [".join(hist_table_cols) + "]"
    sql_hist_update = sql_hist_update.format(PK=pk, TABLE=table, TABLE_COLS=table_cols, HIST_TABLE_COLS=hist_table_cols)
    author = "Avery Briggs"
    date_created = f"{datetime.datetime.now():%Y-%m-%d %H:%M:%S}"
    description = f"SQL Trigger to check changes to all columns, and if found, then will create a history record to mark the change"
    sql_c = sql_declares[1] + '\n' + sql_declares[2]
    sql_a = sql_assigns[1] + '\n' + sql_assigns[2]
    sql_u = ""
    sql_i = ""
    sql_d = ""
    print(
        f"{sql_trigger.format(TABLE=table, SQL_DECLARES=sql_c, SQL_ASSIGNS=sql_a, SQL_INSERTED=sql_i, SQL_UPDATED=sql_u, SQL_DELETED=sql_d, AUTHOR=author, DATE_CREATED=date_created, DESCRIPTION=description, SQL_DIFF_TABLE=sql_differences_t, SQL_DIFF=sql_differences[1], SQL_HIST_UPDATE=sql_hist_update)}")

    # print(f"{sql_declares[1]}")
    # print(f"{sql_declares[2]}")
    # print(f"{sql_assigns[1]}")
    # print(f"{sql_assigns[2]}")

