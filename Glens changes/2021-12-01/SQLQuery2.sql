
USE BWSdb
GO

SELECT
	[SysproCompanyA].[dbo].[InvMaster].[LongDesc]
FROM
	[SysproCompanyA].[dbo].[InvMaster]
WHERE
	[SysproCompanyA].[dbo].[InvMaster].[LongDesc] IS NOT NULL
	AND [SysproCompanyA].[dbo].[InvMaster].[LongDesc] != ''
;


	[SysproCompanyA].[dbo].[InvMaster].[Description],
	[SysproCompanyA].[dbo].[InvMaster].[LongDesc]

SELECT
	[SysproCompanyA].[dbo].[InvMaster].[StockCode]
FROM
	[dtProductionSchedule] WITH (NOLOCK)
LEFT JOIN 
    Orders WITH (NOLOCK)
ON     
    dtProductionSchedule.[Quote#] = Orders.[Quote#]
INNER JOIN
	[SysproCompanyA].[dbo].[WipMaster] WITH (NOLOCK)
ON
    WipMaster.[Job] = CAST(dtProductionSchedule.[WO#] AS VARCHAR(10)) COLLATE Latin1_General_BIN
INNER JOIN
	[SysproCompanyA].[dbo].[InvMaster] WITH (NOLOCK)
ON
    WipMaster.StockCode = InvMaster.StockCode
WHERE
	LEFT(WipMaster.Job, 1) = '7'
;


SELECT
	*
FROM
	[dtProductionSchedule] WITH (NOLOCK)
;

DECLARE @SD AS DATETIME;
DECLARE @ED AS DATETIME;
SET @SD = '1900-01-01';
SET @ED = '2021-08-11';
SELECT dtProductionSchedule.[Stargate WO#], dtProductionSchedule.[ProdSchedID#], dtProductionSchedule.[Quote#], dtProductionSchedule.[Slot#], dtProductionSchedule.[WO#], [SysproCompanyA].[dbo].[InvMaster].[StockCode], dtProductionSchedule.InputField1, dtProductionSchedule.InputField2, dtProductionSchedule.[Beam Line], dtProductionSchedule.[Beam Date], dtProductionSchedule.[GN Line], dtProductionSchedule.[GN Date], dtProductionSchedule.[WO Line 1], dtProductionSchedule.[Prod Date 1], dtProductionSchedule.[WO Line 2], dtProductionSchedule.[Prod Date 2], dtProductionSchedule.Other, dtProductionSchedule.[Other Line], dtProductionSchedule.[Other Date], Orders.[Requested Delivery Date], dtProductionSchedule.Step1SYSPROBudget, dtProductionSchedule.Step2SYSPROBudget, dtProductionSchedule.HideFromProdInput, dtProductionSchedule.ApplyUpdate, dtProductionSchedule.ApplyUpdateUser, dtProductionSchedule.[Slot/Quote], (CASE [Slot/Quote] WHEN 1 THEN 'Slot' ELSE 'Quote' END) AS SlotType, dtProductionSchedule.[Slot Approved], dtProductionSchedule.dtprodschedts
FROM 
    dtProductionSchedule  WITH (NOLOCK)
LEFT JOIN 
    Orders WITH (NOLOCK)
ON     
    dtProductionSchedule.[Quote#] = Orders.[Quote#]
INNER JOIN
    [SysproCompanyA].[dbo].[WipMaster] WITH (NOLOCK)
ON
    WipMaster.[Job] = CAST(dtProductionSchedule.[WO#] AS VARCHAR(10)) COLLATE Latin1_General_BIN
INNER JOIN
	[SysproCompanyA].[dbo].InvMaster WITH (NOLOCK)
ON
    WipMaster.StockCode = InvMaster.StockCode
WHERE (((dtProductionSchedule.[Prod Date 1]) Between @SD And @ED Or (dtProductionSchedule.[Prod Date 1]) Is Null) AND ((dtProductionSchedule.HideFromProdInput)=0))
ORDER BY dtProductionSchedule.[Prod Date 1];
