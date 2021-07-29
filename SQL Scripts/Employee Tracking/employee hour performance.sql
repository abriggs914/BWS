USE SysproCompanyA
GO

DECLARE @SD AS DATETIME;
DECLARE @ED AS DATETIME;
SET @SD = '2021-07-28'
SET @ED = '2021-07-29'

DECLARE @EMPLOYEES_TO_IGNORE AS TABLE (
	[ID] BIGINT NOT NULL PRIMARY KEY
);

INSERT INTO @EMPLOYEES_TO_IGNORE ([ID]) VALUES
	(100054),	-- SHEAR
	(100055),	-- HORIZONTAL SAW
	(100056),	-- HYDRAULIC IRON WORKER
	(100057),	-- DRILL 1
	(100058),	-- LATHE
	(100059),	-- TAPPING TABLE
	(100060),	-- PRESS BRAKE 1
	(100062),	-- BUFF
	(100063),	-- VERTICAL SAW
	(100064),	-- MANUAL SAW
	(100065),	-- MECHANICAL IRON WORKER
	(100066),	-- DRILL 2
	(100067),	-- DRILL 3
	(100068),	-- DRILL 4
	(100069),	-- PRESS BRAKE 2
	(100070),	-- PRESS BRAKE 3
	(100071),	-- MILLING MACHINE
	(200562),	-- NULL
	(1)			-- MONTH END USE ONLY
;

DECLARE @SRCTABLE AS TABLE (
	[LoggedInTimeHrs] FLOAT,
	[TransactionID]	BIGINT,
	[JobNumber] BIGINT,
	[JobName] VARCHAR(MAX),
	[Operation] INT,
	[OperationComplete] BIT,
	[EmployeeNumber] VARCHAR(6),
	[EmployeeName] VARCHAR(50),
	[WorkCentreCode] VARCHAR(5),
	[WorkCentreCodeDescription] VARCHAR(MAX),
	[LoggedOn] DATETIME,
	[LoggedOff] DATETIME,
	[LoggedOnUTC] DATETIME,
	[LoggedOffUTC] DATETIME,
	[ActualLoggedOnUTC] DATETIME,
	[ActualLoggedOffUTC] DATETIME,
	[IsComplete] BIT,
	[GroupID] INT,
	[GroupName] VARCHAR(50),
	[IsNonProductive] BIT,
	[NonProductiveCode] INT,
	[NonProductiveDescription] VARCHAR(MAX),
	[MachineCode] VARCHAR(10),
	[MachineCodeDescription] VARCHAR(50),
	[PiecesCompleted] FLOAT,
	[QuantityCompleted] FLOAT,
	[RateIndicator] BIT,
	[ShiftID] INT,
	[ShiftName] VARCHAR(MAX),
	[ScrapCode] VARCHAR(MAX),
	[ScrapCodeDescription] VARCHAR(MAX),
	[ScrapQuantity] FLOAT,
	[SetStartRun] INT,
	[IsExported] BIT,
	[IsLoggedOn] BIT,
	[IsOverEstimate] BIT,
	[IsSharedJob] BIT,
	[ProRatingWeight] INT,
	[ProRateValue] FLOAT,
	[SharedID] INT,
	[Timestamp] VARCHAR(MAX),
	[OperationDescription] VARCHAR(MAX),
	[StockCode] VARCHAR(MAX),
	[StockCodeDescription] VARCHAR(MAX)
);
INSERT INTO @SRCTABLE (
	[LoggedInTimeHrs],
	[TransactionID],
	[JobNumber],
	[JobName],
	[Operation],
	[OperationComplete],
	[EmployeeNumber],
	[EmployeeName],
	[WorkCentreCode],
	[WorkCentreCodeDescription],
	[LoggedOn],
	[LoggedOff],
	[LoggedOnUTC],
	[LoggedOffUTC],
	[ActualLoggedOnUTC],
	[ActualLoggedOffUTC],
	[IsComplete],
	[GroupID],
	[GroupName],
	[IsNonProductive],
	[NonProductiveCode],
	[NonProductiveDescription],
	[MachineCode],
	[MachineCodeDescription],
	[PiecesCompleted],
	[QuantityCompleted],
	[RateIndicator],
	[ShiftID],
	[ShiftName],
	[ScrapCode],
	[ScrapCodeDescription],
	[ScrapQuantity],
	[SetStartRun],
	[IsExported],
	[IsLoggedOn],
	[IsOverEstimate],
	[IsSharedJob],
	[ProRatingWeight],
	[ProRateValue],
	[SharedID],
	[Timestamp],
	[OperationDescription],
	[StockCode],
	[StockCodeDescription])

(
	SELECT
		DATEDIFF(MINUTE, [LoggedOn], [LoggedOff]) / 60.0 AS [LoggedInTimeHrs],
		*
	FROM
		[SysproCompanyA].[dbo].[ClkTransaction] WITH (NOLOCK)
	WHERE
		[LoggedOn] BETWEEN @SD AND @ED
		AND [LoggedOff] BETWEEN @SD AND @ED
		AND [EmployeeNumber] NOT IN (
			SELECT
				[ID]
			FROM
				@EMPLOYEES_TO_IGNORE
		)
);

-- SELECT TOP 500 * FROM [WipLabJnl] ORDER BY [EntryDate] DESC;
-- SELECT TOP 500 *  FROM [WipJobAllLab];

WITH BudgetsByJob AS (
	SELECT
		(
			CASE WHEN [IMaxWorkOpertrs] = 0 THEN 0
			ELSE [IExpUnitRunTim] / [IMaxWorkOpertrs]
			END
		) AS [BudgetPerWorker],
		[WipLabJnl].*
	FROM
		[WipLabJnl] WITH (NOLOCK)
	INNER JOIN
		[WipJobAllLab] WITH (NOLOCK)
	ON
		[WipLabJnl].[Job] = [WipJobAllLab].[Job]
		AND [WipLabJnl].[Operation] = [WipJobAllLab].[Operation]
	WHERE
		[EntryDate] BETWEEN @SD AND @ED
		AND [Employee] NOT IN (
			SELECT
				[ID]
			FROM
				@EMPLOYEES_TO_IGNORE
		)
) --select * from [BudgetsByJob] order by [Employee]
SELECT
	[EmployeeName]
	[BudgetPerWorker],
	[RunTime],
	[RunTime] - [BudgetPerWorker] AS [Performance],
	*
FROM 
	@SRCTABLE
INNER JOIN
	[BudgetsByJob]  WITH (NOLOCK)
ON
	[BudgetsByJob].[Employee] = [EmployeeNumber]
	AND [BudgetsByJob].[Job] = [Job]
WHERE
	[LoggedInTimeHrs] IS NOT NULL
	AND [LoggedOn] BETWEEN @SD AND @ED
	AND [LoggedOff] BETWEEN @SD AND @ED
ORDER BY 
	[EmployeeNumber], [WorkCentreCode], [LoggedOff]
;



DECLARE @SD AS DATETIME;
DECLARE @ED AS DATETIME;
SET @SD = '2020-01-01'
SET @ED = '2021-12-31'
SELECT
	ROW_NUMBER() OVER(
		PARTITION BY [EmployeeNumber], [WorkCentreCode]
		ORDER BY [LoggedOff]
	) AS [Row #],
	*
FROM (
	SELECT
		DATEDIFF(MINUTE, [LoggedOn], [LoggedOff]) / 60.0 AS [LoggedInTimeHrs],
		*
	FROM
		[SysproCompanyA].[dbo].[ClkTransaction]
WHERE
	[LoggedOn] BETWEEN @SD AND @ED
	AND [LoggedOff] BETWEEN @SD AND @ED
) AS [SourceTable]