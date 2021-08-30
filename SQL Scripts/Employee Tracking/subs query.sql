USE SysproCompanyA
GO


DECLARE @JOBS TABLE ([JobNumber] VARCHAR(10) PRIMARY KEY);
/*
INSERT INTO @JOBS VALUES 
	('70003117'),
	('80000224')
;*/

INSERT INTO @JOBS VALUES 
	('70003117')
;
DECLARE @WODATA TABLE (
	[Operation] VARCHAR(25),
	[OperationComplete] BIT,
	[EmployeeNumber] VARCHAR(20),
	[EmployeeName] VARCHAR(100),
	[LoggedOff] DATETIME,
	[TransactionID] BIGINT
);

-- All who worked on this job
--SELECT * FROM [ClkTransaction] WHERE [JobNumber] IN (SELECT [JobNumber] FROM @JOBS) AND [WorkCentreCode] LIKE '%S%' 
--SELECT * FROM [ClkTransaction] WHERE LEFT([JobNumber], 1) != '1' AND [WorkCentreCode] LIKE '%S%' ORDER BY [JobNumber]
--DECLARE @JOB2 AS VARCHAR(20);
--SET @JOB2 = '20044765'

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
SELECT
	*
FROM
	@WODATA
ORDER BY
	[Operation]



-- Employees who worked on this job:
SELECT DISTINCT	
	[EmployeeName]
FROM
	@WODATA
ORDER BY 
	[EmployeeName]
;

-- Operations for this job
SELECT DISTINCT	
	[Operation]
FROM
	@WODATA
ORDER BY 
	[Operation]
;

-- Last employee on this job
DECLARE @OPERATIONS TABLE (
	[RowNum] INT,
	[Operation] VARCHAR(25)
);
INSERT INTO @OPERATIONS
SELECT DISTINCT	
	ROW_NUMBER() OVER (
		PARTITION BY [Operation]
		ORDER BY [Operation]
	) AS [RowNum],
	[Operation]
FROM
	@WODATA
;

SELECT * FROM @OPERATIONS

SELECT TOP (SELECT COUNT(*) FROM @OPERATIONS WHERE [RowNum] = 1)
	[@OPERATIONS].[Operation],
	[OperationComplete],
	[EmployeeNumber],
	[EmployeeName],
	[LoggedOff],
	[TransactionID]
FROM
	@WODATA
INNER JOIN
	@OPERATIONS
ON
	[@OPERATIONS].[Operation] = [@WODATA].[Operation]
WHERE
	[RowNum] = 1
ORDER BY
	[LoggedOff] DESC, [TransactionID] DESC
;

DECLARE @LEDATA TABLE (
	[Operation] VARCHAR(25),
	[OperationComplete] BIT,
	[EmployeeNumber] VARCHAR(20),
	[EmployeeName] VARCHAR(100),
	[LoggedOff] DATETIME,
	[TransactionID] BIGINT
);
/*
DECLARE @I INT = 0;
WHILE @I < (SELECT COUNT(*) FROM @OPERATIONS)
BEGIN

INSERT INTO @LEDATA
SELECT
	[Operation],
	[OperationComplete],
	[EmployeeNumber],
	[EmployeeName],
	[LoggedOff],
	[TransactionID]
FROM
	@WODATA
ORDER BY
	[LoggedOff] DESC,
	[TransactionID] DESC
OFFSET @I ROWS   
FETCH NEXT 1 ROWS ONLY 
;

SET @I = @I + 1;
END

SELECT * FROM [BomEmployee] ORDER BY [Name] OFFSET 6 ROWS;*/