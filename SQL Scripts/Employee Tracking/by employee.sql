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
