USE [SysproCompanyA]
GO

/****** Object:  View [dbo].[v_PROD_InvMovementsDateTime]    Script Date: 2025-12-04 8:13:06 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- 2025-12-01 0830 - Avery Briggs - View to capture the [EntryDate] and [TrnTime] columns as a single DATETIME

ALTER VIEW [dbo].[v_PROD_InvMovementsDateTime]
AS

	SELECT
		[IM].[Job],
		[IM].[StockCode],
		[IM].[Warehouse],
		[IM].[Journal],
		[IM].[JournalEntry],
		[IM].[TrnYear],
		[IM].[TrnMonth],
		[IM].[TrnTime], 
		[IM].[TrnType], 
		/*DATEADD(MINUTE, ([IM].[TrnTime] % 100), 
					DATEADD(HOUR, FLOOR([IM].[TrnTime] / 100), CAST([IM].[EntryDate] AS DATETIME))) AS [TrnDateTime]*/
		DATEADD(MILLISECOND, [IM].[TrnTime], [IM].[EntryDate]) AS [TrnDateTime]
	FROM
		[SysproCompanyA].[dbo].[InvMovements] [IM]
;
GO


