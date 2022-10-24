USE BWSdb
GO
USE SysproCompanyA
GO

DECLARE @WO AS NVARCHAR(MAX) = '10015456';

EXEC [dbo].[sp_WOSnapshotEmployeesOnJob Ops 4 5] @WO=@WO
EXEC [dbo].[sp_WO Performance Snapshot Ops 4 5] @WO=@WO

SELECT
			'' AS [Job],
			SUM(IExpUnitRunTim) AS [4 Total Budgeted Hours],
			SUM([RunTimeIssued]) AS [4 Total Hours Issued],
			SUM([RunTimeIssued]) - SUM(IExpUnitRunTim) AS [4 Hours Over Budget],
			0 AS [5 Total Budgeted Hours],
			0 AS [5 Total Hours Issued],
			0 AS [5 Hours Over Budget]
		FROM
			[WipJobAllLab]
		WHERE
			[Job] LIKE @WO
			AND [Operation] = 4
		GROUP BY
		[Job]

SELECT
	[WO#],
	SUM([4 Total Budgeted Hours]) AS [Total Budgeted Hours OP4],
	SUM([4 Total Hours Issued]) AS [Total Hours Issued OP4],
	SUM([4 Hours Over Budget]) AS [Hours Over Budget OP4],
	SUM([5 Total Budgeted Hours]) AS [Total Budgeted Hours OP5],
	SUM([5 Total Hours Issued]) AS [Total Hours Issued OP5],
	SUM([5 Hours Over Budget]) AS [Hours Over Budget OP5],
	[Total Defects]
FROM (
	SELECT
		@WO AS [WO#],
		[4 Total Budgeted Hours],
		[4 Total Hours Issued],
		[4 Hours Over Budget],
		[5 Total Budgeted Hours],
		[5 Total Hours Issued],
		[5 Hours Over Budget],
		(
			SELECT
				SUM([#Defects])
			FROM
				[BWSdb].[dbo].[Defects]
			WHERE
				CAST([WO#] AS NVARCHAR(MAX)) LIKE @WO
		) AS [Total Defects]
	FROM (
		SELECT
			'' AS [Job],
			SUM(IExpUnitRunTim) AS [4 Total Budgeted Hours],
			SUM([RunTimeIssued]) AS [4 Total Hours Issued],
			SUM([RunTimeIssued]) - SUM(IExpUnitRunTim) AS [4 Hours Over Budget],
			0 AS [5 Total Budgeted Hours],
			0 AS [5 Total Hours Issued],
			0 AS [5 Hours Over Budget]
		FROM
			[WipJobAllLab]
		WHERE
			[Job] LIKE @WO
			AND [Operation] = 4
		GROUP BY
		[Job]
) AS [SrcTable1]
) AS [SrcTable2]
GROUP BY [WO#], [Total Defects]