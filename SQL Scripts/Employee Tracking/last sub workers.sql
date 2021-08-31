USE SysproCompanyA
GO

-- Last employees on ops.

DECLARE @JOB AS VARCHAR(25);
SET @JOB = '70003117'
DECLARE @JOBS TABLE ([JobNumber] VARCHAR(10) PRIMARY KEY);
/*
INSERT INTO @JOBS VALUES 
	('70003117'),
	('80000224'),
	('20021300')
;*/

INSERT INTO @JOBS VALUES 
	(@JOB)
;
DECLARE @WODATA TABLE (
	[Operation] VARCHAR(25),
	[OperationComplete] BIT,
	[EmployeeNumber] VARCHAR(20),
	[EmployeeName] VARCHAR(100),
	[LoggedOff] DATETIME,
	[TransactionID] BIGINT
);

INSERT INTO @WODATA
SELECT
	'Operation ' + CAST([Operation] AS VARCHAR(25)) AS [Operation],
	[OperationComplete],
	[EmployeeNumber],
	[EmployeeName],
	[LoggedOff],
	[TransactionID]
FROM 
	[ClkTransaction] WITH (NOLOCK)
WHERE
	[JobNumber] IN (SELECT [JobNumber] FROM @JOBS)
	AND [WorkCentreCode] LIKE '%S%'
	AND [Operation] != 0
GROUP BY
	[Operation],
	[OperationComplete],
	[EmployeeNumber],
	[EmployeeName],
	[LoggedOff],
	[TransactionID]
ORDER BY
	[LoggedOff] DESC, [TransactionID] DESC
;


SELECT * FROM @WODATA

DECLARE @PDATA TABLE (
	[RowNum] INT,
	[Operation] VARCHAR(50),
	[OperationComplete] BIT,
	[EmployeeNumber] VARCHAR(50),
	[EmployeeName] VARCHAR(50),
	[LoggedOff] DATETIME,
	[TransactonID] BIGINT
);

INSERT INTO @PDATA
SELECT
	ROW_NUMBER() OVER (
		PARTITION BY 
			[Operation]
		ORDER BY 
			[LoggedOff] DESC,
			[TransactionID] DESC
	) AS [RowNum],
	*
FROM	
	@WODATA

SELECT
	*
FROM
	@PDATA
WHERE
	[RowNum] = 1

/*
UNION ALL
SELECT
	0 AS [RowNum],
	'Total of Operations' AS [Operation],
	1 AS [OperationComplete],
	NULL AS [EmployeeNumber],
	NULL AS [EmployeeName],
	NULL AS [LoggedOff],
	NULL AS [TransactionID]
*/