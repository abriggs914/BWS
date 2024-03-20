USE SysproCompanyA
GO

DECLARE @wo NVARCHAR(MAX) = '10016858';

EXEC [dbo].[sp_WOSnapshotEmployeesOnJob Ops 5to8] @WO=@wo
EXEC [dbo].[sp_WO Performance Snapshot Ops 5to8] @WO=@wo


SELECT
	[ClkEmployee].[Employee]
	,[ClkEmployee].[Name]
	,[Operation]
	,CAST(ROUND(SUM([RunTime]), 2) AS DECIMAL(14, 2)) AS [SumHours]
	FROM
		[WipLabJnl]
	INNER JOIN 
		[ClkEmployee]
	ON
		[WipLabJnl].[Employee] = [ClkEmployee].[Employee]
	WHERE
		[Job] LIKE @wo
		--AND ([Operation] = 4 OR [Operation] = 5)
		--AND ([Operation] BETWEEN 4 AND 8)
		--AND ([Machine] = 41 OR [Machine] = 42)
	GROUP BY
		[ClkEmployee].[Employee]
		,[ClkEmployee].[Name]
		,[Operation]
	ORDER BY
		[Operation],
		[SumHours] DESC,
		[ClkEmployee].[Name]