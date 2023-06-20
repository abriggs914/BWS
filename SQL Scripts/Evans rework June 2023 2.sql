USE SysproCompanyA
GO

--SELECT
--	*
--FROM
--	[WipMaster]
--WHERE

DECLARE @sd AS DATETIME = '2022-06-01';
DECLARE @ed AS DATETIME = '2023-06-01 23:59:59';

DECLARE @m AS TABLE ([ID] INT IDENTITY(0, 1), [M] NVARCHAR(200))
INSERT INTO @m ([M]) VALUES
('12'), ('13'), ('17'), ('19'), ('26'), ('27'), ('28'), ('44'), ('45'), ('46'), ('51');


SELECT
	*
FROM
	[BomMachine]
INNER JOIN
	@m
ON
	[BomMachine].[Machine] = [@m].[M]
;

--SELECT
--	*
--FROM
--	[v_JobReworkHours];

--SELECT
--	*
--FROM
--	[WipJobPost] WITH (NOLOCK)
--;

--SELECT
--	*
--FROM
--	[WipLabJnl] WITH (NOLOCK)
--;

SELECT
	[Machine]
	, SUM([RunTime]) AS [TRunTIme]
	--, [ITimeTaken]
	--, [IWaitTime]
	--, [IQuantity]
	--, [IExpUnitRunTimEnt]
	--, [ITimeTakenEnt]
	--, [IQuantityEnt]
	--, *
FROM
	[WipLabJnl]
INNER JOIN
	@m
ON
	[WipLabJnl].[Machine] = [@m].[M]
WHERE
	[EntryDate] BETWEEN @sd AND @ed
GROUP BY
	[Machine]
ORDER BY
	[Machine]
