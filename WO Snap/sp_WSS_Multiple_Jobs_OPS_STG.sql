USE [SysproCompanyS]
GO
/****** Object:  StoredProcedure [dbo].[sp_WO Performance Snapshot Ops 5to8]    Script Date: 2024-04-10 4:43:53 PM ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_WSS_Multiple_Jobs_OPS_STG]
	@WOS NVARCHAR(MAX)
	,@OPS NVARCHAR(MAX)
	,@unk NVARCHAR(MAX) = 'UNKNOWN'
AS BEGIN

/*
-----------------------------------------------------------------------------------------------------------------------------
DECLARE @WOS NVARCHAR(MAX);
DECLARE @OPS NVARCHAR(MAX);
SELECT @WOS = '10016980';
SELECT @OPS = '2;3;4;5;6;7;8;12';
DECLARE @unk NVARCHAR(MAX) = 'UNKNOWN';
-----------------------------------------------------------------------------------------------------------------------------
*/

DECLARE @ops_split TABLE ([ID] INT, [OP] NVARCHAR(MAX));
INSERT INTO @ops_split
SELECT * FROM [BWSdb].[dbo].[split_string_idx](@OPS, ';')
;
DECLARE @wos_split TABLE ([ID] INT, [WO] NVARCHAR(MAX));
INSERT INTO @wos_split
SELECT * FROM [BWSdb].[dbo].[split_string_idx](@WOS, ';')
;

/*
SELECT
	[OP]
FROM
	@ops_split
GROUP BY
	[OP]
;

SELECT
	[WO]
FROM
	@wos_split
GROUP BY
	[WO]
;*/

	SELECT
		[Src1].[Job],
		[Src1].[Operation],
		ISNULL([Src1].[Total Budgeted Hours], 0) AS [Total Budgeted Hours],
		ISNULL([Src1].[Total Hours Issued], 0) AS [Total Hours Issued],
		ISNULL([Src1].[Hours Over Budget], 0) AS [Hours Over Budget],
		ISNULL([Src1].[Total Defects], 0) AS [Total Defects],
		[Src2].[Employee],
		ISNULL([Src2].[Name], @unk) AS [Name],
		ISNULL([Src2].[SumHours], 0) AS [SumHours],
		[Src2].[PlaceMostHoursOnOP]
	FROM
		@ops_split [OS]
	LEFT OUTER JOIN (
		SELECT
			[Job],
			[Operation],
			SUM(IExpUnitRunTim) AS [Total Budgeted Hours],
			SUM([RunTimeIssued]) AS [Total Hours Issued],
			SUM([RunTimeIssued]) - SUM(IExpUnitRunTim) AS [Hours Over Budget],
			ISNULL(SUM([#Defects]), 0) AS [Total Defects]
		FROM
			[WipJobAllLab] [W]
		INNER JOIN
			@ops_split [OS]
		ON
			[W].[Operation] = CAST([OS].[OP] AS DECIMAL(14, 4))
		INNER JOIN
			@wos_split [WO]
		ON
			[W].[Job] = [WO].[WO]
		FULL OUTER JOIN
			[BWSdb].[dbo].[Defects] [D]
		ON
			CAST([D].[WO#] AS NVARCHAR(MAX)) = [WO].[WO]
		GROUP BY
			[Job]
			, [WO].[WO]
			, [D].[WO#]
			, [Operation]
	) AS [Src1]
	ON
		CAST([OS].[OP] AS DECIMAL(14, 4)) = [Src1].[Operation]
	LEFT OUTER JOIN (
		SELECT
			[Job]
			,ROW_NUMBER() OVER(
				PARTITION BY
					[Job],
					[Operation]
				ORDER BY
					[Operation]
					,CAST(ROUND(SUM([RunTime]), 2) AS DECIMAL(14, 2)) DESC
			) AS [PlaceMostHoursOnOP]
			,[C].[Employee]
			,ISNULL([C].[Name], @unk) AS [Name]
			,[Operation]
			,CAST(ROUND(SUM([RunTime]), 2) AS DECIMAL(14, 2)) AS [SumHours]
		FROM
			[WipLabJnl] [W]
		LEFT JOIN 
			[ClkEmployee] [C]
		ON
			[W].[Employee] = [C].[Employee]
		INNER JOIN
			@ops_split [OS]
		ON
			[W].[Operation] = CAST([OS].[OP] AS DECIMAL(14, 4))
		INNER JOIN
			@wos_split [WO]
		ON
			[W].[Job] = [WO].[WO]
		GROUP BY
			[Job]
			,[C].[Employee]
			,[C].[Name]
			,[Operation]
	) AS [Src2]
	ON
		[Src1].[Job] = [Src2].[Job]
		AND [Src1].[Operation] = [Src2].[Operation]
	
	ORDER BY
		[Job],
		[Src1].[Operation],
		[PlaceMostHoursOnOP]

END