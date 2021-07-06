USE [BWSdb]
GO

EXEC [sp_ProductionSlotsvsForecastRpt 2]
	@sd = '2021-06-29',
	@ss = 0
;

EXEC [sp_ProductionSlotsvsForecastRpt 2]
	@sd = '2021-06-29',
	@ss = 1
;

EXEC [sp_ProductionSlotsvsForecastRpt 2]
	@sd = '2021-06-29',
	@ss = 2
;

EXEC [sp_GetSlotReport]
	@StartDate = '2021-06-29',
	@EndDate = '2022-06-29',
	@SlotStatus = 0
;

EXEC [sp_GetSlotReport]
	@StartDate = '2021-06-29',
	@EndDate = '2022-06-29',
	@SlotStatus = 1
;

EXEC [sp_GetSlotReport]
	@StartDate = '2021-06-29',
	@EndDate = '2022-06-29',
	@SlotStatus = 2
;

SELECT DISTINCT [Slot Status] FROM [Production Slots]

SELECT [Prod Date] FROM [Production]

SELECT * FROM [Production Slots]

EXEC [sp_ProductionSlotsvsForecastRpt 2]
	@sd = '2024-02-01',
	@ss = 2
;