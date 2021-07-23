USE BWSdb
GO
--USE SysproCompanyA
--GO

--No Use
-- [Work Hours]
-- [Order OptionsV2_FactoryLines]
-- [Prod Other]
-- [Hours Required Prod]
-- [ProductionV2]
-- [Design Hours]
-- [Prod Sched Version#]

-- Some Use
-- [Hours Worked]
-- [Employees]
-- [Bonus]
-- [Prod Lines]
-- [Prod Lines Out]

--SELECT
--	*
--FROM
--	[Hours Worked]

--SELECT * FROM [Employees]
	
--SELECT
--	*
--FROM
--	[BomEmployee]

-- SELECT * FROM SysproCompanyA.dbo.WipLabJnl with (nolock)

DECLARE @PRINT BIT = 1;
IF @PRINT = 1 BEGIN
	SELECT * FROM [Employees] WITH (NOLOCK) -- 526 records AS OF 2021-07-22
	SELECT * FROM [SysproCompanyA].[dbo].[WipLabJnl] WITH (NOLOCK) ORDER BY [EntryDate] DESC-- 895 023 records AS OF 2021-07-22
	SELECT * FROM [dtProductionSchedule] WITH (NOLOCK) -- 5035 records AS OF 2021-07-22
END

SELECT
	[2nd Name], [1st Name], [Machine], *
FROM
	[dtProductionSchedule] with (nolock)
LEFT JOIN
	[SysproCompanyA].[dbo].[WipLabJnl] with (nolock)
ON
	cast([dtProductionSchedule].[WO#] as varchar(20)) = [WipLabJnl].[Job]
LEFT JOIN
	[Employees]
ON 
	[Machine] = [SysproCompanyA].[dbo].[WipLabJnl].[Machine]
WHERE
	[Machine] IN ('41', '42')
	AND [Prod Date 1] > '2021-01-01' 
ORDER BY
	[Prod Date 1] DESC

	


DECLARE @SD AS DATETIME;
DECLARE @ED AS DATETIME;
DECLARE @MACHINES AS TABLE ([MachineID] INT);
INSERT INTO @MACHINES VALUES (1);
SET @SD = '2021-01-01'
SET @ED = '2021-08-01'


SELECT
	[2nd Name],
	[1st Name],
	[Machine], 
	*
FROM (
	SELECT
		*
	FROM
		[SysproCompanyA].[dbo].[WipLabJnl] WITH (NOLOCK)
	WHERE
		[EntryDate] BETWEEN @SD AND @ED
) AS [WipLab]
INNER JOIN
	[dtProductionSchedule]
ON 
	CAST([dtProductionSchedule].[WO#] AS VARCHAR(20)) = [WipLab].[Job]
INNER JOIN
	[Employees]
ON 
	(SUBSTRING([Employee], 4, 6)) = CAST([Employees].[Emp#] AS VARCHAR(20))
ORDER BY
	[EntryDate], [Employees].[2nd Name], [Employees].[1st Name]
;


SELECT * FROM [Defects_Location]


SELECT
	*
FROM
	[Defects]
INNER JOIN
	[Defects_Location]
ON
	[Defects].[LocationID] = [Defects_Location].[LocationID#]
WHERE
	((([Defects].[Input Date]) Between @SD And @ED))
;

SELECT * FROM [uniPoint_Live].[dbo].[PT_Equip]
WHERE [Category] in (
	('T1'),
	('T2'),
	('T3'),
	('T4'),
	('T5'),
	('T6'),
	('T7'),
	('T8'),
	('T9'),
	('T10'),
	('T11'),
	('BEAMS'),
	('G1'),
	('G2'),
	('PONY FRAME'),
	('SUB ASSY.')
)


-----------------------------------------------------------------------------------------------------------------------

DECLARE @SD AS DATETIME;
DECLARE @ED AS DATETIME;
DECLARE @MACHINES AS TABLE ([MachineID] INT);
INSERT INTO @MACHINES VALUES (1);
SET @SD = '2021-01-01'
SET @ED = '2021-08-01'


SELECT
	[2nd Name],
	[1st Name],
	[Machine], 
	*
FROM (
	SELECT
		*
	FROM
		[SysproCompanyA].[dbo].[WipLabJnl] WITH (NOLOCK)
	WHERE
		[EntryDate] BETWEEN @SD AND @ED
) AS [WipLab]
INNER JOIN
	[dtProductionSchedule]
ON 
	CAST([dtProductionSchedule].[WO#] AS VARCHAR(20)) = [WipLab].[Job]
INNER JOIN
	[Employees]
ON 
	(SUBSTRING([Employee], 4, 6)) = CAST([Employees].[Emp#] AS VARCHAR(20))
INNER  JOIN
	[uniPoint_Live].[dbo].[PT_Equip]
ON
	[Machine] LIKE CAST([EquipID] AS VARCHAR(20))
ORDER BY
	[EntryDate], [Employees].[2nd Name], [Employees].[1st Name]
;


DECLARE @NEW_RECORD_DATE DATETIME = '2021-07-23'

SELECT
	[2nd Name],
	[1st Name],
	[Emp#],
	[#FrontDefects],
	[#RearDefects],
	[#Defects]
FROM
	[Defects]
LEFT JOIN
	[Employees]
ON
	[EmployeeID] = [Emp#]
WHERE
	[Input Date] >= @NEW_RECORD_DATE
UNION ALL
SELECT
	[2nd Name],
	[1st Name],
	[Emp#],
	[#FrontDefects],
	[#RearDefects],
	[#Defects]
FROM
	[Defects]
LEFT JOIN
	[Employees]
ON
	[EmployeeID] = [Emp#]
WHERE
	[Input Date] < @NEW_RECORD_DATE
	
SELECT * FROM [dtProductionSchedule]
SELECT * FROM [Production] ORDER BY [Prod Date] DESC
SELECT COUNT(1) FROM [Production]
SELECT COUNT(1) FROM (
	SELECT DISTINCT [WO#] FROM [Production]
) AS [A]