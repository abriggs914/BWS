	
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

--DECLARE @JOB AS VARCHAR(20);
SET @JOB = '20014154'
SET @JOB = '20045600'
--SET @JOB = '20032509'
SET @JOB = '70003117'

DECLARE @JOBS TABLE ([JobNumber] VARCHAR(10) PRIMARY KEY);
/*
INSERT INTO @JOBS VALUES 
	('70003117'),
	('80000224')
;*/

INSERT INTO @JOBS VALUES 
	('70003117')
;

--SELECT * FROM @JOBS


-- All who worked on this job
SELECT * FROM [ClkTransaction] WHERE [JobNumber] = @JOB AND [WorkCentreCode] LIKE '%S%' 
--SELECT * FROM [ClkTransaction] WHERE LEFT([JobNumber], 1) != '1' AND [WorkCentreCode] LIKE '%S%' ORDER BY [JobNumber]
DECLARE @JOB2 AS VARCHAR(20);
SET @JOB2 = '20044765'
SELECT
	*
FROM 
	[ClkTransaction] WITH (NOLOCK)
WHERE
	[JobNumber] IN (SELECT [JobNumber] FROM @JOBS)
	AND [WorkCentreCode] LIKE '%S%'
ORDER BY
	[LoggedOff] DESC, [TransactionID] ASC
;


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
SELECT * FROM [ClkTransaction] WHERE [JobNumber] IN (SELECT [JobNumber] FROM @JOBS) AND [WorkCentreCode] LIKE '%S%' 
--SELECT * FROM [ClkTransaction] WHERE LEFT([JobNumber], 1) != '1' AND [WorkCentreCode] LIKE '%S%' ORDER BY [JobNumber]
--DECLARE @JOB2 AS VARCHAR(20);
SET @JOB2 = '20044765'

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