USE [BWSdb]
GO

EXEC [sp_ProductionSlotsvsForecastRpt 2]
	@sd = '2021-06-29'
;
EXEC [sp_GetSlotReport]
	@StartDate = '2021-06-29'
;

SELECT [Prod Date] FROM [Production]