USE BWSdb
GO

BEGIN TRAN;

SELECT COUNT(*) AS [Total To Change] FROM [dtProductionSchedule]
SELECT * FROM [dtProductionSchedule]

UPDATE
	[dtProductionSchedule]
SET
	[Stargate WO#] = [SysproCompanyA].[dbo].[InvMaster].[LongDesc]
FROM
	[dtProductionSchedule]
INNER JOIN
    [SysproCompanyA].[dbo].[WipMaster]
ON
    WipMaster.[Job] = CAST(dtProductionSchedule.[WO#] AS VARCHAR(10)) COLLATE Latin1_General_BIN
INNER JOIN
	[SysproCompanyA].[dbo].InvMaster 
ON
    WipMaster.StockCode = InvMaster.StockCode
	
SELECT COUNT(*) AS [Total Changed] FROM [dtProductionSchedule]
SELECT * FROM [dtProductionSchedule]

ROLLBACK;
COMMIT;