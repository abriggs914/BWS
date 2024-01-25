import datetime

import pandas as pd

from pyodbc_connection import connect
from sql_utility import select_with_alias, create_history_table


def test_select_with_alias():

    print(select_with_alias([
        ("ITR Customers", "C", "C"),
        ("ITD Dept", "D", "D")
    ]))
    print(select_with_alias([
        ("Orders", "O", "O"),
        ("OrdersV2", "O2", "O2")
    ]))
    print(select_with_alias([
        ("ITD Dept", "D"),
        ("ITF Flags", "F")
    ]))
    print(select_with_alias(
        [
            ("Orders", "O"),
            ("Dealers", "D")
        ],
        f_keys=("inner", "DealerID", "ID")
    ))
    print(select_with_alias(
        [
            ("Orders", "O", "O", "DealerID"),
            ("Dealers", "D", "D", "ID")
        ]
    ))
    print(select_with_alias(
        [
            ("Orders", "O", "O"),
            ("Dealers", "D", "D"),
            # ("Orders", "O", "O", "DealerID"),
            # ("Sales Staff", "S", "S", "Sales PersonID")
            ("Sales Staff", "S", "S")
        ],
        f_keys=(
            ("inner", "DealerID", "ID"),
            ("inner", "Sale PersonID", "ID-SaleStaff")
        )
    ))
    print(select_with_alias(
        [
            ("Orders", "O"),
            ("Dealers", "D"),
            ("Sales Staff", "S"),
            ("Products", "P")
        ],
        f_keys=(
            ("left", "DealerID", "ID"),
            ("left", "Sale PersonID", "ID-SaleStaff"),
            ("left", "ProductID", "IDTrailer")
        )
    ))

def test_create_history_table():
    print(f"{create_history_table('ITF Flags')}")



if __name__ == '__main__':

#     table = "ITF Flags"
#
#     sql = """
#     SELECT *
#     FROM INFORMATION_SCHEMA.COLUMNS
#     WHERE TABLE_NAME = '{TABLE}';
#     """.format(TABLE=table)
#
#     df = connect(sql)
#     sql_trigger = """
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
# CREATE TRIGGER  [dbo].[tr_Update{TABLE}History]
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
# 			[Column] NVARCHAR(255),
# 			[ValueBefore] NVARCHAR(MAX),
# 			[ValueAfter] NVARCHAR(MAX)
# 		)
# 	;
# 	"""
#     sql_differences = ["{TD}IF {COLA} <> {COLB} BEGIN\n{TDp1}INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])\n{TDp1}SELECT '{COL}', CAST({COLA} AS NVARCHAR(MAX)), CAST({COLB} AS NVARCHAR(MAX));\n{TD}END", ""]
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
# 					[dbo].[OrdersV2 History]
#
# 				   ([OrderID]
#            ,[Action]
#            ,[When]
#            ,[User]
#            ,[Column]
#            ,[OldValue]
#            ,[NewValue]
#            ,[SGQuote]
#            ,[Quote Date]
#            ,[Order Date]
#            ,[WO#]
#            ,[Sales Order#]
#            ,[Model No]
#            ,[Width]
#            ,[Spread]
#            ,[DealerID]
#            ,[Sale PersonID]
#            ,[Price]
#            ,[Prom Drawing]
#            ,[Special Instructions]
#            ,[Date Declined]
#            ,[Decline/Rejected]
#            ,[Serial Number]
#            ,[Available Date]
#            ,[Delivery Date]
#            ,[Requested Delivery Date]
#            ,[Finish Date]
#            ,[Purchase Order]
#            ,[PO Date]
#            ,[PayID]
#            ,[Volume Discount]
#            ,[Program Discount]
#            ,[Discount1_Name]
#            ,[Discount1_Type]
#            ,[Discount1]
#            ,[Discount2_Name]
#            ,[Discount2_Type]
#            ,[Discount2]
#            ,[Discount3_Name]
#            ,[Discount3_Type]
#            ,[Discount3]
#            ,[Est Pro Date]
#            ,[Notes]
#            ,[EngNotes]
#            ,[CarrierID]
#            ,[CustID]
#            ,[US Sale]
#            ,[Shipped Date]
#            ,[GL Override Date]
#            ,[FE Rate]
#            ,[PDD]
#            ,[Deck Length]
#            ,[Invoice #]
#            ,[Date Registered]
#            ,[Date In Service]
#            ,[Invoice Date]
#            ,[Date Requested]
#            ,[GVWR]
#            ,[Tare]
#            ,[Selection]
#            ,[Warranty]
#            ,[BWSPaid]
#            ,[BWSPaidDate]
#            ,[CommPaid]
#            ,[CommPaidDate]
#            ,[ModifiedBy]
#            ,[Lead Date]
#            ,[Lead Source]
#            ,[LeadID]
#            ,[DealerBranchID]
#            ,[DealerSalesPersonID]
#            ,[DataEntryCheck]
#            ,[DataEntryUser]
#            ,[FinishedGoodsDealerLocID]
#            ,[WO Reviewed]
#            ,[WO Review Date]
#            ,[Follow Up Date]
#            ,[MSOIsDifferent]
#            ,[MSOLocID]
#            ,[EstInvDateOverride]
#            ,[Estimated Invoice Date]
#            ,[AdditionalPricingInfo]
#            ,[Slot#]
#            ,[TempModel?]
#            ,[HighRiskUnit]
#            ,[EngNotes V2]
#            ,[CompanyID]
#            ,[Customer WO#]
#            ,[PriceSecured]
#            ,[DateSecured]
#            ,[SecuredBy]
#            ,[InternalSalesComments]
#            ,[InternalSalesCommentDate]
#            ,[InternalSalesCommenter]
#            ,[DiscountSetDate]
#            ,[DiscountSetBy]
#            ,[ProductID]
#            ,[DiscountID]
#            ,[DateLastQuoteReport]
#            ,[JobAvailableLine]
#            ,[JobAvailableScheduled]
#            ,[JobAvailableScheduledBy])
#         SELECT
# 			[OrderID]
# 			,@activity
#            ,GETDATE()
#            ,@user
# 			,@column
# 			,@value_before
# 			,@value_after
#            ,[SGQuote]
#            ,[Quote Date]
#            ,[Order Date]
#            ,[WO#]
#            ,[Sales Order#]
#            ,[Model No]
#            ,[Width]
#            ,[Spread]
#            ,[DealerID]
#            ,[Sale PersonID]
#            ,[Price]
#            ,[Prom Drawing]
#            ,[Special Instructions]
#            ,[Date Declined]
#            ,[Decline/Rejected]
#            ,[Serial Number]
#            ,[Available Date]
#            ,[Delivery Date]
#            ,[Requested Delivery Date]
#            ,[Finish Date]
#            ,[Purchase Order]
#            ,[PO Date]
#            ,[PayID]
#            ,[Volume Discount]
#            ,[Program Discount]
#            ,[Discount1_Name]
#            ,[Discount1_Type]
#            ,[Discount1]
#            ,[Discount2_Name]
#            ,[Discount2_Type]
#            ,[Discount2]
#            ,[Discount3_Name]
#            ,[Discount3_Type]
#            ,[Discount3]
#            ,[Est Pro Date]
#            ,[Notes]
#            ,[EngNotes]
#            ,[CarrierID]
#            ,[CustID]
#            ,[US Sale]
#            ,[Shipped Date]
#            ,[GL Override Date]
#            ,[FE Rate]
#            ,[PDD]
#            ,[Deck Length]
#            ,[Invoice #]
#            ,[Date Registered]
#            ,[Date In Service]
#            ,[Invoice Date]
#            ,[Date Requested]
#            ,[GVWR]
#            ,[Tare]
#            ,[Selection]
#            ,[Warranty]
#            ,[BWSPaid]
#            ,[BWSPaidDate]
#            ,[CommPaid]
#            ,[CommPaidDate]
#            ,[ModifiedBy]
#            ,[Lead Date]
#            ,[Lead Source]
#            ,[LeadID]
#            ,[DealerBranchID]
#            ,[DealerSalesPersonID]
#            ,[DataEntryCheck]
#            ,[DataEntryUser]
#            ,[FinishedGoodsDealerLocID]
#            ,[WO Reviewed]
#            ,[WO Review Date]
#            ,[Follow Up Date]
#            ,[MSOIsDifferent]
#            ,[MSOLocID]
#            ,[EstInvDateOverride]
#            ,[Estimated Invoice Date]
#            ,[AdditionalPricingInfo]
#            ,[Slot#]
#            ,[TempModel?]
#            ,[HighRiskUnit]
#            ,[EngNotes V2]
#            ,[CompanyID]
#            ,[Customer WO#]
#            ,[PriceSecured]
#            ,[DateSecured]
#            ,[SecuredBy]
#            ,[InternalSalesComments]
#            ,[InternalSalesCommentDate]
#            ,[InternalSalesCommenter]
#            ,[DiscountSetDate]
#            ,[DiscountSetBy]
#            ,[ProductID]
#            ,[DiscountID]
#            ,[DateLastQuoteReport]
#            ,[JobAvailableLine]
#            ,[JobAvailableScheduled]
#            ,[JobAvailableScheduledBy]
# 				FROM
# 					[OrdersV2]
# 				WHERE
# 					[OrderID] = ISNULL(@new_OrderID, @old_OrderID)
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
#         old_col = f"old_{col.replace(' ', '_')}".replace("?", "_").replace("#", "_").replace("/", "_")
#         new_col = f"new_{col.replace(' ', '_')}".replace("?", "_").replace("#", "_").replace("/", "_")
#
#         siz = "MAX" if siz == -1 else (int(siz) if not pd.isnull(siz) else siz)
#         # print(f"{col=}, {typ=}")
#         new_declare = sql_declares[0].format(TD=td, COL=old_col, TYP=typ)
#         old_declare = sql_declares[0].format(TD=td, COL=new_col, TYP=typ)
#         if typ == "NVARCHAR":
#             new_declare += f"({siz})"
#             old_declare += f"({siz})"
#         sql_declares[1] += new_declare + ";\n"
#         sql_declares[2] += old_declare + ";\n"
#
#         old_assign = sql_assigns[0].format(TDp1=tdp1, COL_A=old_col, COL=col)
#         new_assign = sql_assigns[0].format(TDp1=tdp1, COL_A=new_col, COL=col)
#         sql_assigns[1] += old_assign + ",\n"
#         sql_assigns[2] += new_assign + ",\n"
#
#         diff = sql_differences[0].format(TD=td, TDp1=tdp1, COLA=f"@{old_col}", COLB=f"@{new_col}", COL=col)
#         sql_differences[1] += diff + "\n"
#
#     print(f"A {len(sql_assigns[1])=}, {sql_assigns[1][-1]=}")
#
#     # clean up
#     sql_declares[1] = sql_declares[1].removesuffix("\n")
#     sql_declares[2] = sql_declares[2].removesuffix("\n")
#     sql_assigns[1] = sql_assigns[1].removesuffix(",\n")
#     sql_assigns[2] = sql_assigns[2].removesuffix(",\n")
#
#     print(f"B {len(sql_assigns[1])=}, {sql_assigns[1][-1]=}")
#
#     sql_assigns[1] += sql_assigns[3].format(TD=td, TDp1=tdp1, TAB_A=f"DELETED [D]")
#     sql_assigns[2] += sql_assigns[3].format(TD=td, TDp1=tdp1, TAB_A=f"INSERTED [I]")
#
#     author = "Avery Briggs"
#     date_created = f"{datetime.datetime.now():%Y-%m-%d %H:%M:%S}"
#     description = f"SQL Trigger to check changes to all columns, and if found, then will create a history record to mark the change"
#     sql_c = sql_declares[1] + '\n' + sql_declares[2]
#     sql_a = sql_assigns[1] + '\n' + sql_assigns[2]
#     sql_u = ""
#     sql_i = ""
#     sql_d = ""
#     print(f"{sql_trigger.format(TABLE=table, SQL_DECLARES=sql_c, SQL_ASSIGNS=sql_a, SQL_INSERTED=sql_i, SQL_UPDATED=sql_u, SQL_DELETED=sql_d, AUTHOR=author, DATE_CREATED=date_created, DESCRIPTION=description, SQL_DIFF_TABLE=sql_differences_t, SQL_DIFF=sql_differences[1], SQL_HIST_UPDATE=sql_hist_update)}")
#
#     # print(f"{sql_declares[1]}")
#     # print(f"{sql_declares[2]}")
#     # print(f"{sql_assigns[1]}")
#     # print(f"{sql_assigns[2]}")

    # print(select_with_alias("Orders", "O", "O"))

    # test_select_with_alias()
    test_create_history_table()

