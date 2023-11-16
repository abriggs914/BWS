USE [BWSdb]
GO

/****** Object:  View [dbo].[v_SFC_SalesPersonIndividualSalesCounts]    Script Date: 2023-11-15 1:45:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[v_SFC_SalesPersonTotalSalesCounts] AS
SELECT
	SUM([NumQuotesPrepared]) AS [GrandTotalNumQuotesPrepared]
	,SUM([NumInvalidQuotes]) AS [GrandTotalNumInvalidQuotes]
	,SUM([NumSoldDeliveredUnits]) AS [GrandTotalNumSoldDeliveredUnits]
	,SUM([NumUnitsOnOrder]) AS [GrandTotalNumUnitsOnOrder]
	,SUM([NumQuotesOutToDealer]) AS [GrandTotalNumQuotesOutToDealer]
	,SUM([NumCancelledQuotes]) AS [GrandTotalNumCancelledQuotes]
	,SUM([NumCancelledOrders]) AS [GrandTotalNumCancelledOrders]
FROM
	[v_SFC_SalesPersonIndividualSalesCounts]
;