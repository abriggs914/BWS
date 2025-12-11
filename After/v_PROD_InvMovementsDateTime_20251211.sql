USE [SysproCompanyA]
GO

/****** Object:  View [dbo].[v_PROD_InvMovementsDateTime]    Script Date: 2025-12-11 2:26:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- 2025-12-01 0830 - Avery Briggs - View to capture the [EntryDate] and [TrnTime] columns as a single DATETIME
-- 2025-12-11 1441 - Avery Briggs - Corrected the [TrnDateTime] caclucation and added [EntryDate]

ALTER VIEW [dbo].[v_PROD_InvMovementsDateTime]
AS

	SELECT TOP 1000
		[IM].[Job],
		[IM].[StockCode],
		[IM].[Warehouse],
		[IM].[Journal],
		[IM].[JournalEntry],
		[IM].[TrnYear],
		[IM].[TrnMonth],
		[IM].[TrnTime], 
		[IM].[TrnType], 
		[IM].[EntryDate],
		/*[IM].[TrnTime] / 1000000 AS [A],
		(([IM].[TrnTime] % 1000000 ) / 10000) AS [B],
		(([IM].[TrnTime] % 10000 / 100)) AS [C],*/
		DATEADD(HOUR, [IM].[TrnTime] / 1000000,
			DATEADD(MINUTE, ([IM].[TrnTime] % 1000000 ) / 10000, 
				DATEADD(SECOND, [IM].[TrnTime] % 10000 / 100,
					DATEADD(MILLISECOND, [IM].[TrnTime] % 100,
						CAST([IM].[EntryDate] AS DATETIME)
					)
				)
			)
		) AS [TrnDateTime]
		/*DATEADD(MINUTE, ([IM].[TrnTime] / 10000), 
					DATEADD(HOUR, FLOOR([IM].[TrnTime] / 1000000), CAST([IM].[EntryDate] AS DATETIME))) AS [TrnDateTime]*/
		--DATEADD(MILLISECOND, [IM].[TrnTime], [IM].[EntryDate]) AS [TrnDateTime]
	FROM
		[SysproCompanyA].[dbo].[InvMovements] [IM]
;
GO


