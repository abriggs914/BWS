import pygwalker as pyg
from pyodbc_connection import *
import streamlit as st
import streamlit.components.v1 as components


# https://www.youtube.com/watch?v=ogyxjkYRgPE&t=988s


if __name__ == '__main__':

    title = "IT Requests Streamlit + PygWalker Demo"

    st.set_page_config(
        page_title=title,
        layout="wide"
    )

    st.title(title)

    # df = connect("SELECT * FROM [IT Requests] LEFT JOIN [Department] ON [IT Requests].[Department] = [Department].[Dept ID]")
    # df = connect("exec sp_BudgetCostVariance_AllCurrentProposedUnits 'December 31 2019', '1.5', '1', '1'")
    # df = connect("exec [sp_DSR_ACD_PygWalker2023_10_04]")

#     df = connect("""SELECT
# 	[DateGroup]
# 	,2023 - [DateGroup] AS [Year]
# 	,[Class]
# 	,[NumOrders]
# 	,[TtlPrice]
# 	,[TtlPrice] / (CASE WHEN [NumOrders] = 0 THEN 1 ELSE [NumOrders] END) AS [AveragePerSale]
# FROM (
# 	SELECT
# 		[DateGroup]
# 		,[Class]
# 		,COUNT(*) AS [NumOrders]
# 		,SUM([OPrice]) AS [TtlPrice]
# 	FROM (
# 		SELECT
# 			CAST(ABS(DATEDIFF(DAY, GETDATE(), ISNULL([O].[Order Date], [O].[Quote Date]))) / 365.0 AS INT) AS [DateGroup]
# 			,[O].[Quote#], [O].[Quote Date], [O].[Order Date]
# 			,[O].[WO#], [O].[Sales Order#], [O].[Model No] AS [OModelNo]
# 			,[O].[Width] AS [OWidth], [O].[Spread] AS [OSpread], [O].[DealerID]
# 			,[O].[Sale PersonID], [O].[Price] AS [OPrice], [O].[Prom Drawing]
# 			,[O].[Special Instructions], [O].[Date Declined], [O].[Decline/Rejected]
# 			,[O].[Serial Number], [Available Date], [Delivery Date]
# 			,[O].[Requested Delivery Date], [O].[Finish Date], [O].[Purchase Order]
# 			,[O].[PO Date], [O].[PayID], [O].[Volume Discount], [O].[Program Discount]
# 			,[O].[Discount1_Name], [O].[Discount1_Type], [O].[Discount1]
# 			,[O].[Discount2_Name], [O].[Discount2_Type], [O].[Discount2]
# 			,[O].[Discount3_Name], [O].[Discount3_Type], [O].[Discount3]
# 			,[O].[Est Pro Date], [O].[Notes], [O].[EngNotes]
# 			,[O].[CarrierID], [O].[CustID], [O].[US Sale]
# 			,[O].[Shipped Date], [O].[GL Override Date], [O].[FE Rate]
# 			,[O].[PDD], [O].[Deck Length] AS [ODeckLength], [O].[Invoice #]
# 			,[O].[Date Registered], [O].[Date In Service], [O].[Invoice Date]
# 			,[O].[Date Requested], [O].[GVWR], [O].[Tare]
# 			,[O].[Selection] AS [OSelection], [O].[Warranty], [O].[BWSPaid]
# 			,[O].[BWSPaidDate], [O].[CommPaid], [O].[CommPaidDate]
# 			,[O].[ts_timestamp], [O].[ModifiedBy], [O].[Lead Date]
# 			,[O].[Lead Source], [O].[LeadID], [O].[DealerBranchID]
# 			,[O].[DealerSalesPersonID], [O].[DataEntryCheck], [O].[DataEntryUser]
# 			,[O].[FinishedGoodsDealerLocID], [O].[WO Reviewed], [O].[WO Review Date]
# 			,[O].[Follow Up Date], [O].[MSOIsDifferent], [O].[MSOLocID]
# 			,[O].[EstInvDateOverride], [O].[Estimated Invoice Date], [O].[AdditionalPricingInfo]
# 			,[O].[Slot#], [O].[TempModel?], [O].[HighRiskUnit]
# 			,[O].[EngNotes V2], [O].[CompanyID] AS [OCompanyID], [O].[Customer WO#]
# 			,[O].[Step 2 Slot#], [O].[PriceSecured], [O].[DateSecured]
# 			,[O].[SecuredBy], [O].[InternalSalesComment], [O].[InternalSalesCommentDate]
# 			,[O].[InternalSalesCommenter], [O].[DiscountID], [O].[DiscountSetDate]
# 			,[O].[DiscountSetBy], [O].[ProductID]
#
# 			,[P].[IDTrailer], [P].[Class], [P].[Proposed]
# 			,[P].[Non-Current], [P].[Model], [P].[Model No] AS [PModelNo]
# 			,[P].[Top Level Part# (SYSPRO)], [P].[Grouping], [P].[Start Date]
# 			,[P].[End Date], [P].[Price] AS [PPrice], [P].[Weight]
# 			,[P].[Make], [P].[NVIS], [P].[Promo Drawing]
# 			,[P].[Width] AS [PWidth], [P].[Spread] AS [PSpread], [P].[Deck Length] AS [PDeckLength]
# 			,[P].[Days], [P].[GN], [P].[Paint]
# 			,[P].[Finish], [P].[S/NL1], [P].[S/NL2]
# 			,[P].[S/NT1], [P].[S/NT2], [P].[S/NAxles]
# 			,[P].[Selection] AS [PSelection], [P].[EffComDate], [P].[ComRate]
# 			,[P].[LastCostUpdate], [P].[LCUInitials], [P].[QR_Discount1]
# 			,[P].[QR_Discount2], [P].[QR_Discount3], [P].[product_timestamp]
# 			,[P].[QR_ExpectedMargin], [P].[tmpProductsClassesID], [P].[QRUS_Discount1]
# 			,[P].[QRUS_Discount2], [P].[QRUS_Discount3], [P].[QRUS_ExpectedMargin]
# 			,[P].[US Price], [P].[Customer], [P].[Top Level Part# (SYSPRO 8)]
# 			,[P].[Promo Drawing V2], [P].[CompanyID] AS [PCompanyID]
#
# 		FROM
# 			[Orders] AS [O]
# 		INNER JOIN
# 			[Products] AS [P]
# 		ON
# 			[O].[Model No] = [P].[Model No]
# 		WHERE
# 			[Order Date] IS NOT NULL
# 			--[Decline/Rejected] = 4
# 	--		[Date Declined] IS NULL
# 	) AS [SubA]
# 	GROUP BY
# 		[DateGroup]
# 		,[Class]
# ) AS [SubB]
# ORDER BY
# 	[DateGroup]""")

#     # Units by year with average price per sale
    df = connect("""SELECT
	[DateGroup]
	,2023 - [DateGroup] AS [Year]
	,[OModelNo]
	,[Class]
	,[NumOrders]
	,[TtlPrice]
	,[TtlPrice] / (CASE WHEN [NumOrders] = 0 THEN 1 ELSE [NumOrders] END) AS [AveragePerSale]
FROM (
	SELECT 
		[DateGroup]
		,[OModelNo]
		,[Class]
		,COUNT(*) AS [NumOrders]
		,SUM([OPrice]) AS [TtlPrice]
	FROM (
		SELECT
			CAST(ABS(DATEDIFF(DAY, GETDATE(), ISNULL([O].[Order Date], [O].[Quote Date]))) / 365.0 AS INT) AS [DateGroup]
			,[O].[Quote#], [O].[Quote Date], [O].[Order Date]
			,[O].[WO#], [O].[Sales Order#], [O].[Model No] AS [OModelNo]
			,[O].[Width] AS [OWidth], [O].[Spread] AS [OSpread], [O].[DealerID]
			,[O].[Sale PersonID], [O].[Price] AS [OPrice], [O].[Prom Drawing]
			,[O].[Special Instructions], [O].[Date Declined], [O].[Decline/Rejected]
			,[O].[Serial Number], [Available Date], [Delivery Date]
			,[O].[Requested Delivery Date], [O].[Finish Date], [O].[Purchase Order]
			,[O].[PO Date], [O].[PayID], [O].[Volume Discount], [O].[Program Discount]
			,[O].[Discount1_Name], [O].[Discount1_Type], [O].[Discount1]
			,[O].[Discount2_Name], [O].[Discount2_Type], [O].[Discount2]
			,[O].[Discount3_Name], [O].[Discount3_Type], [O].[Discount3]
			,[O].[Est Pro Date], [O].[Notes], [O].[EngNotes]
			,[O].[CarrierID], [O].[CustID], [O].[US Sale]
			,[O].[Shipped Date], [O].[GL Override Date], [O].[FE Rate]
			,[O].[PDD], [O].[Deck Length] AS [ODeckLength], [O].[Invoice #]
			,[O].[Date Registered], [O].[Date In Service], [O].[Invoice Date]
			,[O].[Date Requested], [O].[GVWR], [O].[Tare]
			,[O].[Selection] AS [OSelection], [O].[Warranty], [O].[BWSPaid]
			,[O].[BWSPaidDate], [O].[CommPaid], [O].[CommPaidDate]
			,[O].[ts_timestamp], [O].[ModifiedBy], [O].[Lead Date]
			,[O].[Lead Source], [O].[LeadID], [O].[DealerBranchID]
			,[O].[DealerSalesPersonID], [O].[DataEntryCheck], [O].[DataEntryUser]
			,[O].[FinishedGoodsDealerLocID], [O].[WO Reviewed], [O].[WO Review Date]
			,[O].[Follow Up Date], [O].[MSOIsDifferent], [O].[MSOLocID]
			,[O].[EstInvDateOverride], [O].[Estimated Invoice Date], [O].[AdditionalPricingInfo]
			,[O].[Slot#], [O].[TempModel?], [O].[HighRiskUnit]
			,[O].[EngNotes V2], [O].[CompanyID] AS [OCompanyID], [O].[Customer WO#]
			,[O].[Step 2 Slot#], [O].[PriceSecured], [O].[DateSecured]
			,[O].[SecuredBy], [O].[InternalSalesComment], [O].[InternalSalesCommentDate]
			,[O].[InternalSalesCommenter], [O].[DiscountID], [O].[DiscountSetDate]
			,[O].[DiscountSetBy], [O].[ProductID]

			,[P].[IDTrailer], [P].[Class], [P].[Proposed]
			,[P].[Non-Current], [P].[Model], [P].[Model No] AS [PModelNo]
			,[P].[Top Level Part# (SYSPRO)], [P].[Grouping], [P].[Start Date]
			,[P].[End Date], [P].[Price] AS [PPrice], [P].[Weight]
			,[P].[Make], [P].[NVIS], [P].[Promo Drawing]
			,[P].[Width] AS [PWidth], [P].[Spread] AS [PSpread], [P].[Deck Length] AS [PDeckLength]
			,[P].[Days], [P].[GN], [P].[Paint]
			,[P].[Finish], [P].[S/NL1], [P].[S/NL2]
			,[P].[S/NT1], [P].[S/NT2], [P].[S/NAxles]
			,[P].[Selection] AS [PSelection], [P].[EffComDate], [P].[ComRate]
			,[P].[LastCostUpdate], [P].[LCUInitials], [P].[QR_Discount1]
			,[P].[QR_Discount2], [P].[QR_Discount3], [P].[product_timestamp]
			,[P].[QR_ExpectedMargin], [P].[tmpProductsClassesID], [P].[QRUS_Discount1]
			,[P].[QRUS_Discount2], [P].[QRUS_Discount3], [P].[QRUS_ExpectedMargin]
			,[P].[US Price], [P].[Customer], [P].[Top Level Part# (SYSPRO 8)]
			,[P].[Promo Drawing V2], [P].[CompanyID] AS [PCompanyID]

		FROM
			[Orders] AS [O]
		INNER JOIN
			[Products] AS [P]
		ON
			[O].[Model No] = [P].[Model No]
		WHERE
			[Order Date] IS NOT NULL
			--[Decline/Rejected] = 4
	--		[Date Declined] IS NULL
	) AS [SubA]
	GROUP BY
		[DateGroup]
		,[OModelNo]
		,[Class]
) AS [SubB]
ORDER BY
	[DateGroup]
	,[OModelNo]""")


    # conn = st.experimental_connection(
    #     "BWSdb",
    #     type="sql",
    #     # url="server3://user5:M@gic456@localhost:3306/BWSdb"
    #     # url="server3://user5:M@gic456@localhost/BWSdb"
    #     # url="mssql://user5:M@gic456@localhost/BWSdb"
    #     # url="mssql://user5:M@gic456@localhost/Server3/BWSdb"
    #     # url="mssql://user5:M@gic456@localhost/Server3"
    #     # url="mssql://user5:M@gic456@localhost:1433/Server3"
    #     # url="mssql+pyodbc://user5:M@gic456@localhost:1433/Server3"
    #     # url="mssql+pyodbc://user5:M@gic456@localhost:1433/BWSdb"
    #     # url="mssql://user5:M@gic456@localhost:1433/Server3/BWSdb"
    #
    #     # mssql://[Server_Name[:Portno]]/[Database_Instance_Name]/[Database_Name]?FailoverPartner=[Partner_Server_Name]&InboundId=[Inbound_ID]
    #     url="mssql://Server3:1433/user5:M@gic456@localhost:1433/Server3/BWSdb"
    # )
    # df = conn.query("SELECT * FROM [IT Requests] LEFT JOIN [Department] ON [IT Requests].[Department] = [Department].[Dept ID]")

    pyg_html = pyg.walk(df, return_html=True)

    components.html(pyg_html, height=1000, scrolling=True)
