USE BWSdb
GO

SELECT TOP 50 * FROM [SysproCompanyA].[dbo].[WipMaster]

-- Includes a date column
SELECT TOP 50 * FROM [dtProductionSchedule]
SELECT TOP 50 * FROM [Production]
SELECT TOP 50 * FROM [Production Slots]
SELECT TOP 50 * FROM [Orders]


-- Not important
SELECT TOP 50 * FROM [SysproCompanyA].[dbo].[v_CalendarWorkDays]
SELECT TOP 50 * FROM [Prod Lines]

-- [tr_dtProductionSchedule_Updates] 
-- [dbo].[tr_ApplyUpdates]

	--left outer join dtProductionSchedule with (nolock) on [Prod Lines].[Prod Line] = dtProductionSchedule.[WO Line 1]
	--left outer join Orders with (nolock) on dtProductionSchedule.Quote# = Orders.Quote#
	--left outer join Production with (nolock) on Orders.Quote# = Production.Quote#
	--left outer join SysproCompanyA.dbo.WipMaster with (nolock) on cast(Production.[Steel Kit WO#] as varchar(20)) collate Latin1_General_BIN = WipMaster.Job

