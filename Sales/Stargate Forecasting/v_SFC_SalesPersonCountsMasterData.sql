/****** Script for SelectTopNRows command from SSMS  ******/

USE BWSdb
GO

CREATE VIEW [v_SFC_SalesPersonCountsMasterData] AS

SELECT
	*
	,(100 * ([NumQuotesPrepared] + 0.0) / [GrandTotalNumQuotesPrepared]) AS [PctGlobalNumQuotesPrepared]
	,(100 * ([NumInvalidQuotes] + 0.0) / [GrandTotalNumInvalidQuotes]) AS [PctGlobalNumInvalidQuotes]

	,(100 * ([NumSoldDeliveredUnits] + 0.0) / [GrandTotalNumSoldDeliveredUnits]) AS [PctGlobalNumSoldDeliveredUnits]
	,(100 * ([NumUnitsOnOrder] + 0.0) / [GrandTotalNumUnitsOnOrder]) AS [PctGlobalNumUnitsOnOrder]
	,(100 * ([NumQuotesOutToDealer] + 0.0) / [GrandTotalNumQuotesOutToDealer]) AS [PctGlobalNumQuotesOutToDealer]
	,(100 * ([NumCancelledQuotes] + 0.0) / [GrandTotalNumCancelledQuotes]) AS [PctGlobalNumCancelledQuotes]
	,(100 * ([NumCancelledOrders] + 0.0) / [GrandTotalNumCancelledOrders]) AS [PctGlobalNumCancelledOrders]
FROM (
	SELECT
		[Sales Person]
		,[Sale PersonID]

		,[NumQuotesPrepared]
		,[NumInvalidQuotes]
		,[NumSoldDeliveredUnits]
		,[NumUnitsOnOrder]
		,[NumQuotesOutToDealer]
		,[NumCancelledQuotes]
		,[NumCancelledOrders]

		,[PctInvalidQuotes]
		,[PctSoldDeliveredUnits]
		,[PctUnitsOnOrder]
		,[PctQuotesOutToDealer]
		,[PctCancelledQuotes]
		,[PctCancelledOrders]
	
		,[NumSalesPeople]
		,[GrandTotalNumQuotesPrepared]
		,[GrandTotalNumInvalidQuotes]
		,[GrandTotalNumSoldDeliveredUnits]
		,[GrandTotalNumUnitsOnOrder]
		,[GrandTotalNumQuotesOutToDealer]
		,[GrandTotalNumCancelledQuotes]
		,[GrandTotalNumCancelledOrders]

		,[GlobalAvgQuotesPerSalesPerson]
		,[GlobalAvgInvalidQuotesPerSalesPerson]
		,[GlobalAvgSoldDeliveredPerSalesPerson]
		,[GlobalAvgUnitsOnOrderPerSalesPerson]
		,[GlobalAvgQuotesOutToDealerPerSalesPerson]
		,[GlobalAvgCancelledQuotesPerSalesPerson]
		,[GlobalAvgCancelledOrdersPerSalesPerson]
	FROM 
		[BWSdb].[dbo].[v_SFC_SalesPersonIndividualSalesCounts]
	CROSS JOIN
		[v_SFC_SalesPersonTotalSalesCounts]
) AS [SrcA]