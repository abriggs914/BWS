USE SysproCompanyA
GO
DECLARE @JOB AS VARCHAR(20);
SET @JOB = '10014747'






DECLARE @JOB AS VARCHAR(20);
SET @JOB = '10014747'
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

	SELECT
		ROW_NUMBER() OVER (
				PARTITION BY [Operation]
				ORDER BY [LoggedOff], [TransactionID] ASC
			) AS row_num, *
	FROM
		[ClkTransaction] WITH (NOLOCK)
	WHERE
		[JobNumber] LIKE @JOB
		AND ([Operation] = 4 OR [Operation] = 5)
				ORDER BY [LoggedOff], [TransactionID] DESC


















SELECT
	ROW_NUMBER() OVER (
			PARTITION BY [Operation]
			ORDER BY [LoggedOff], [TransactionID] DESC
		) AS row_num, *
FROM
	[ClkTransaction] WITH (NOLOCK)
WHERE
	[JobNumber] LIKE @JOB
	AND ([Operation] = 4 OR [Operation] = 5)
ORDER BY
	[LoggedOff], [TransactionID] DESC
;

-- List of all employees who worked on this WO in operation 4 OR 5
SELECT DISTINCT
	[EmployeeName]
FROM (
	SELECT
		*
	FROM
		[ClkTransaction] WITH (NOLOCK)
	WHERE
		[JobNumber] LIKE @JOB
		AND ([Operation] = 4 OR [Operation] = 5)
) AS [SrcTable]
ORDER BY
	[EmployeeName]
;

SELECT
	*
FROM (
DECLARE @JOB AS VARCHAR(20);
SET @JOB = '10014747'
	SELECT
		ROW_NUMBER() OVER (
				PARTITION BY [Operation]
				ORDER BY [LoggedOff], [TransactionID] DESC
			) AS row_num, *
	FROM
		[ClkTransaction] WITH (NOLOCK)
	WHERE
		[JobNumber] LIKE @JOB
		AND ([Operation] = 4 OR [Operation] = 5)
) AS [SrcTable]
WHERE
	[row_num] = 1
;
	--ORDER BY
		--[LoggedOff], [TransactionID] DESC