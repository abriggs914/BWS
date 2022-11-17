

DECLARE @WO NVARCHAR(MAX);
SELECT @WO = '10015962';

SELECT
	*
			--'' AS [Job],
			--SUM(IExpUnitRunTim) AS [4 Total Budgeted Hours],
			--SUM([RunTimeIssued]) AS [4 Total Hours Issued],
			--SUM([RunTimeIssued]) - SUM(IExpUnitRunTim) AS [4 Hours Over Budget],
			--0 AS [5 Total Budgeted Hours],
			--0 AS [5 Total Hours Issued],
			--0 AS [5 Hours Over Budget]
		FROM
			[WipJobAllLab]
		WHERE
			[Job] LIKE @WO
			AND ([Operation] = 4 OR [Operation] = 5)
			/*AND (
				[IMachine] = 41
				OR [IMachine] = 42
			)*/
		
		/*GROUP BY
		[Job]
		*/


DECLARE @t AS TABLE ([Job] NVARCHAR(MAX), [Operation] INT, [IMachine] NVARCHAR(MAX))
INSERT INTO @t

SELECT
	[Job],
	[Operation],
	[IMachine]
FROM
	[WipJobAllLab]
WHERE
	[Operation] = 4
	OR
	[Operation] = 5
GROUP BY
	[Job],
	[Operation],
	[IMachine]
--HAVING
--	COUNT([Job]) > 1
ORDER BY
	[Job],
	[Operation],
	[IMachine]
;

SELECT [Job] FROM @t GROUP BY [Job], [Operation] HAVING COUNT(*) > 1