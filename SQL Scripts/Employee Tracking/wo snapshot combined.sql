USE SysproCompanyA
GO






DECLARE @JOB AS VARCHAR(20);
SET @JOB = '10014747';
SELECT
	*
FROM
	SELECT TOP 2
		ROW_NUMBER() OVER (
				PARTITION BY [Operation]
				ORDER BY [LoggedOff] DESC
			) AS row_num, *
	FROM
		[ClkTransaction] WITH (NOLOCK)
	WHERE
		[JobNumber] LIKE @JOB
		AND ([Operation] = 4 OR [Operation] = 5)
				ORDER BY [LoggedOff] DESC
)



USE SysproCompanyA
GO

DECLARE @JOB AS VARCHAR(20);
SET @JOB = '10014747'
SELECT
	*
FROM 
	[ClkTransaction] WITH (NOLOCK)
WHERE
	[JobNumber] LIKE @JOB
	AND ([Operation] = 4 OR [Operation] = 5)
ORDER BY
	[Operation], [LoggedOff]
;


SELECT TOP 200
	*
FROM (
	SELECT TOP 1
		*
	FROM 
		[ClkTransaction] WITH (NOLOCK)
	WHERE
		[JobNumber] LIKE @JOB
		AND [Operation] = 4
	ORDER BY
		[LoggedOff] DESC, [TransactionID] ASC
	UNION 
		SELECT TOP 1
			*
		FROM 
			[ClkTransaction] WITH (NOLOCK)
		WHERE
			[JobNumber] LIKE @JOB
			AND [Operation] = 5
	ORDER BY
		[LoggedOff] DESC, [TransactionID] ASC
) AS [SrcTable]
ORDER BY
	[LoggedOff] DESC, [TransactionID] ASC

	
USE SysproCompanyA
GO

DECLARE @JOB AS VARCHAR(20);
SET @JOB = '10014747'
SELECT
	*
FROM 
	[ClkTransaction] WITH (NOLOCK)
WHERE
	[JobNumber] LIKE @JOB
	AND [WorkCentreCode] LIKE '%S%'
ORDER BY
	[LoggedOff] DESC, [TransactionID] ASC
;

DECLARE @JOB AS VARCHAR(20);
SET @JOB = '70000202'

SELECT * FROM [ClkTransaction] WHERE [JobNumber] = @JOB AND [WorkCentreCode] LIKE '%S%'
SELECT * FROM [ClkTransaction] WHERE LEFT([JobNumber], 1) = '7' AND [WorkCentreCode] LIKE '%S%' ORDER BY [JobNumber]
DECLARE @JOB2 AS VARCHAR(20);
SET @JOB2 = '20044765'
SELECT
	[Operation],
	[OperationComplete],
	[EmployeeNumber],
	[EmployeeName],
	[LoggedOff],
	[TransactionID]
FROM 
	[ClkTransaction] WITH (NOLOCK)
WHERE
	[JobNumber] = @JOB
	AND [WorkCentreCode] LIKE '%S%'
GROUP BY
	[Operation],
	[OperationComplete],
	[EmployeeNumber],
	[EmployeeName],
	[LoggedOff],
	[TransactionID]
ORDER BY
	[LoggedOff] DESC, [TransactionID] ASC
;

SELECT * FROM (
SELECT [JobNumber], [Operation] FROM [ClkTransaction] WHERE LEFT([JobNumber], 1) != '1' AND [WorkCentreCode] LIKE '%S%' GROUP BY [JobNumber], [Operation], [WorkCentreCode]
) AS [SrcTable]
GROUP BY
	[Operation],
	[JobNumber]
HAVING
	COUNT([Operation]) = 1