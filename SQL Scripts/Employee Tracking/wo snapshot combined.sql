USE SysproCompanyA
GO






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