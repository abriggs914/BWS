USE [Stargatedb]
GO

/****** Object:  View [dbo].[v_Order Book Detail v2_All]    Script Date: 2023-11-14 2:47:15 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--2022-09-28 James Crawford - Added where clause to exclude 3 Half Round Work Orders from reports: 10015030 - 10015032
--IT Request #001197

ALTER VIEW [dbo].[v_Order Book Detail v2_All]
AS
SELECT     
	[v_Orders Raw Pricing V2].[SGQuote],
	[v_Orders Raw Pricing V2].[Price],
	[v_Orders Raw Pricing V2].[Base Cost],
	[v_Orders Raw Pricing V2].[NPO Price], 
	[v_Orders Raw Pricing V2].[NPO Cost],
	[v_Orders Raw Pricing V2].[Options Price],
	[v_Orders Raw Pricing V2].[Options Cost], 
	[v_Orders Raw Pricing V2].[Gross Price], 
	CONVERT(
		INT,
		dbo.fn_QuoteRptV2_SellingPrice(
			[OrdersV2].[SGQuote],
			[Gross Price],
			[OrdersV2].[Discount3_Type],
			[OrdersV2].[Discount3],
			[OrdersV2].[Volume Discount],
			[OrdersV2].[Program Discount],
			[OrdersV2].[Discount1_Type],
			[OrdersV2].[Discount1],
			[OrdersV2].[Discount2_Type],
			[OrdersV2].[Discount2]
		) /*(dbo.[v_Orders Raw Pricing].[Gross Price] * (1 - dbo.Orders.[Volume Discount])) 
                      * (1 - dbo.Orders.[Program Discount])*/
	) AS [Selling Price], 
	[v_Orders Raw Pricing V2].[Total Cost], 
	(CASE
		WHEN CONVERT(
			INT,
			dbo.fn_QuoteRptV2_SellingPrice(
				[OrdersV2].[SGQuote],
				[Gross Price],
				[OrdersV2].[Discount3_Type],
				[OrdersV2].[Discount3],
				[OrdersV2].[Volume Discount],
				[OrdersV2].[Program Discount],
				[OrdersV2].[Discount1_Type],
				[OrdersV2].[Discount1],
				[OrdersV2].[Discount2_Type],
				[OrdersV2].[Discount2]
			)
		) = 0 THEN 0
		ELSE (
			(
				CONVERT(
					INT,
					dbo.fn_QuoteRptV2_SellingPrice(
						[OrdersV2].[SGQuote],
						[Gross Price],
						[OrdersV2].[Discount3_Type],
						[OrdersV2].[Discount3],
						[OrdersV2].[Volume Discount],
						[OrdersV2].[Program Discount],
						[OrdersV2].[Discount1_Type],
						[OrdersV2].[Discount1],
						[OrdersV2].[Discount2_Type],
						[OrdersV2].[Discount2]
					)
				) - [v_Orders Raw Pricing V2].[Total Cost]
			) / CONVERT(
				INT,
				dbo.fn_QuoteRptV2_SellingPrice(
					[OrdersV2].[SGQuote],
					[Gross Price],
					[OrdersV2].[Discount3_Type],
					[OrdersV2].[Discount3],
					[OrdersV2].[Volume Discount],
					[OrdersV2].[Program Discount],
					[OrdersV2].[Discount1_Type],
					[OrdersV2].[Discount1],
					[OrdersV2].[Discount2_Type],
					[OrdersV2].[Discount2]
				)
			)
		) END) AS Margin, 
		[OrdersV2].[Volume Discount],
		[OrdersV2].[Program Discount],
		[v_Orders Raw Pricing V2].[Model No],
		[v_Orders Raw Pricing V2].[Grouping],
		CONVERT(
			INT, 
			[v_Orders Raw Pricing V2].[Gross Price] * 1 
			- [OrdersV2].[Volume Discount]
		) AS [Vol Dis],
		CONVERT(
			INT, 
			([v_Orders Raw Pricing V2].[Gross Price] * 1 
			- [OrdersV2].[Volume Discount])
			* (1 - [OrdersV2].[Program Discount])
		) AS [Pro Dis], 
		[v_Orders Raw Pricing V2].[COMPANY NAME],
		[OrdersV2].[PO Date],
		[OrdersV2].[Shipped Date],
		[OrdersV2].[Date Declined], 
		(CASE 
			WHEN [OrdersV2].[GL Override Date] IS NOT NULL THEN [OrdersV2].[GL Override Date]
			WHEN [OrdersV2].[Invoice Date] IS NULL THEN [v_CompletedJobInfo].[EntInvoiceDate] 
			ELSE [OrdersV2].[Invoice Date] 
		END) AS [Invoice Date], 
		[v_Orders Raw Pricing V2].[Initials],
		[v_Orders Raw Pricing V2].[Class],
		[Payment Terms V2].[Payment Terms],
		[OrdersV2].[US Sale],
		[OrdersV2].[WO#], 
		[OrdersV2].[DealerID],
		[OrdersV2].[Order Date],
		[v_Orders Raw Pricing V2].[# NPOs],
		[OrdersV2].[Special Instructions],
		[v_Orders Raw Pricing V2].[TtlHrs]
FROM
	[BWSdb].[dbo].[OrdersV2] WITH (NOLOCK) 
INNER JOIN
	[BWSdb].[dbo].[v_Orders Raw Pricing V2]
ON 
	[OrdersV2].[SGQuote] = [v_Orders Raw Pricing V2].[SGQuote]
LEFT OUTER JOIN
	[BWSdb].[dbo].[Payment Terms V2] WITH (NOLOCK) 
ON 
	[OrdersV2].[PayID] = [Payment Terms V2].[PayID]
LEFT OUTER JOIN
	[SysproCompanyS].[dbo].[v_CompletedJobInfo] ON CAST([OrdersV2].[WO#] AS NVARCHAR(20)) = [v_CompletedJobInfo].[Job]

--************************** CODE TO HIDE SANDER BODES FOR BWS MANUFACTURING FROM REPORT!!! **************************
WHERE
--(
--	[OrdersV2].WO# not in ('10012132', '10012241')
--	and [OrdersV2].WO# not between 10012189 and 10012193
--	and [OrdersV2].WO# not between 10012204 and 10012209
--	and [OrdersV2].WO# not between 10012536 and 10012544
--	and [OrdersV2].WO# not between 10013070 and 10013079
--	and [OrdersV2].WO# not in (10015030, 10015031, 10015032)
--	) 
--or 
[OrdersV2].WO# IS NULL
AND [CompanyID] = 1
--********************************************************************************************************************




GO


