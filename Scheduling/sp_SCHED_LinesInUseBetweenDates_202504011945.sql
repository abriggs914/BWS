
USE [BWSdb]
GO

-- 2025-04-01 1945 - Avery Briggs - Use this SP to quickly determine which known Schedule lines will be in use between 2 dates.

CREATE PROCEDURE [dbo].[sp_SCHED_LinesInUseBetweenDates] 
	@sd DATETIME = NULL,
	@ed DATETIME = NULL
AS
BEGIN

	/*
	DECLARE @sd DATETIME = '2025-03-01'
	DECLARE @ed DATETIME = '2025-03-31'
	*/

	SELECT
		@sd = ISNULL(@sd, CAST(GETDATE() AS DATE)),
		@ed = ISNULL(@ed, DATEADD(MONTH, 1, CAST(GETDATE() AS DATE)))
	;

	SELECT 
		[PL].*
	FROM (
		SELECT [WO Line 1] AS [ProdLine] FROM	[BWSdb].[dbo].[dtProductionSchedule] WHERE [Prod Date 1] BETWEEN @sd AND @ed GROUP BY [WO Line 1]
		UNION
		SELECT [WO Line 2] FROM	[BWSdb].[dbo].[dtProductionSchedule] WHERE [Prod Date 2] BETWEEN @sd AND @ed GROUP BY [WO Line 2]
		UNION
		SELECT [Beam Line] FROM	[BWSdb].[dbo].[dtProductionSchedule] WHERE [Beam Date] BETWEEN @sd AND @ed GROUP BY [Beam Line]
		UNION
		SELECT [GN Line] FROM [BWSdb].[dbo].[dtProductionSchedule] WHERE [GN Date] BETWEEN @sd AND @ed GROUP BY [GN Line]
		UNION
		SELECT [Other Line] FROM [BWSdb].[dbo].[dtProductionSchedule] WHERE [Other Date] BETWEEN @sd AND @ed GROUP BY [Other Line]
	) AS [Src]
	INNER JOIN 
		[BWSdb].[dbo].[Prod Lines] [PL]
	ON 
		[Src].[ProdLine] = [PL].[Prod Line]
	--ORDER BY [LO]

END