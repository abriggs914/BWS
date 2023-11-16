USE [BWSdb]
GO

/****** Object:  View [dbo].[v_SFC_SalesPersonTotalSalesCounts]    Script Date: 2023-11-15 3:22:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[v_SFC_SalesPersonTotalSalesCounts] AS
SELECT
	*
	,(([GrandTotalNumQuotesPrepared] + 0.0) / [NumSalesPeople]) AS [GlobalAvgQuotesPerSalesPerson]
	,(([GrandTotalNumInvalidQuotes] + 0.0) / [NumSalesPeople]) AS [GlobalAvgInvalidQuotesPerSalesPerson]
	,(([GrandTotalNumSoldDeliveredUnits] + 0.0) / [NumSalesPeople]) AS [GlobalAvgSoldDeliveredPerSalesPerson]
	,(([GrandTotalNumUnitsOnOrder] + 0.0) / [NumSalesPeople]) AS [GlobalAvgUnitsOnOrderPerSalesPerson]
	,(([GrandTotalNumQuotesOutToDealer] + 0.0) / [NumSalesPeople]) AS [GlobalAvgQuotesOutToDealerPerSalesPerson]
	,(([GrandTotalNumCancelledQuotes] + 0.0) / [NumSalesPeople]) AS [GlobalAvgCancelledQuotesPerSalesPerson]
	,(([GrandTotalNumCancelledOrders] + 0.0) / [NumSalesPeople]) AS [GlobalAvgCancelledOrdersPerSalesPerson]
FROM (
	SELECT
		COUNT(*) AS [NumSalesPeople]
		,SUM([NumQuotesPrepared]) AS [GrandTotalNumQuotesPrepared]
		,SUM([NumInvalidQuotes]) AS [GrandTotalNumInvalidQuotes]
		,SUM([NumSoldDeliveredUnits]) AS [GrandTotalNumSoldDeliveredUnits]
		,SUM([NumUnitsOnOrder]) AS [GrandTotalNumUnitsOnOrder]
		,SUM([NumQuotesOutToDealer]) AS [GrandTotalNumQuotesOutToDealer]
		,SUM([NumCancelledQuotes]) AS [GrandTotalNumCancelledQuotes]
		,SUM([NumCancelledOrders]) AS [GrandTotalNumCancelledOrders]
	FROM
		[v_SFC_SalesPersonIndividualSalesCounts]
) AS [Src]
;
GO


