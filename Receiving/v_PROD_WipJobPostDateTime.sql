USE [SysproCompanyA]
GO

-- 2025-09-23 0928 - Avery Briggs - View to capture the [TrnDate] and [LTrnTime] columns as a single DATETIME

CREATE VIEW [v_PROD_WipJobPostDateTime]
AS

	SELECT
		[JP].[Job],
		[JP].[Line],
		[JP].[MStockCode],
		DATEADD(MINUTE, ([JP].[LTrnTime] % 100), 
					DATEADD(HOUR, FLOOR([JP].[LTrnTime] / 100), CAST([JP].[TrnDate] AS DATETIME))) AS [TrnDateTime]
	FROM
		[SysproCompanyA].[dbo].[WipJobPost] [JP]
;