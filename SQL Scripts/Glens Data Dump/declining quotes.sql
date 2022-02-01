USE SysproCompanyA

GO


SELECT * FROM [BWSdb].[dbo].[dtProductionSchedule] WHERE [ProdSchedID#] IN (24500, 5654, 311742)

BEGIN TRAN;

SELECT * FROM [BWSdb].[dbo].[Orders] 
WHERE
	[WO#] = 50000164
	OR [WO#] = 70001045
	OR [Quote#] = 20691
UPDATE
	[BWSdb].[dbo].[Orders]
SET
	[Date Declined] = '2022-01-02'
WHERE
	[WO#] = 50000164
	OR [WO#] = 70001045
	OR [Quote#] = 20691
	

SELECT * FROM [BWSdb].[dbo].[Orders] 
WHERE
	[WO#] = 50000164
	OR [WO#] = 70001045
	OR [Quote#] = 20691
ROLLBACK;
COMMIT;