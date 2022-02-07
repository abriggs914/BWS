USE BWSdb
GO

-- Refer here: https://sqlandme.com/2011/05/02/inserting-to-a-view-instead-of-trigger-sql-server/

CREATE View [dbo].[dtProductionScheduleProdInput] 
AS
SELECT
	dtProductionSchedule.[ProdSchedID#], dtProductionSchedule.[Quote#], dtProductionSchedule.[Slot#], dtProductionSchedule.[WO#], [SysproCompanyA].[dbo].[InvMaster].[StockCode], dtProductionSchedule.InputField1, dtProductionSchedule.InputField2, dtProductionSchedule.[Beam Line], dtProductionSchedule.[Beam Date], dtProductionSchedule.[GN Line], dtProductionSchedule.[GN Date], dtProductionSchedule.[WO Line 1], dtProductionSchedule.[Prod Date 1], dtProductionSchedule.[WO Line 2], dtProductionSchedule.[Prod Date 2], dtProductionSchedule.Other, dtProductionSchedule.[Other Line], dtProductionSchedule.[Other Date], Orders.[Requested Delivery Date], dtProductionSchedule.Step1SYSPROBudget, dtProductionSchedule.Step2SYSPROBudget, dtProductionSchedule.HideFromProdInput, dtProductionSchedule.ApplyUpdate, dtProductionSchedule.ApplyUpdateUser, dtProductionSchedule.[Slot/Quote], (CASE [Slot/Quote] WHEN 1 THEN 'Slot' ELSE 'Quote' END) AS SlotType, dtProductionSchedule.[Slot Approved], dtProductionSchedule.dtprodschedts
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
WHERE 
	(((dtProductionSchedule.[Prod Date 1]) Between '1900-01-01' And '2100-01-01'
	Or (dtProductionSchedule.[Prod Date 1]) Is Null)
	AND ((dtProductionSchedule.HideFromProdInput)=0))
ORDER BY 
dtProductionSchedule.[Prod Date 1]

CREATE TRIGGER [dbo].[Trig_Insert_Employee]
ON [dbo].[dtProductionScheduleProdInput]
INSTEAD OF INSERT
AS
BEGIN
INSERT INTO Table1
SELECT I.ID, I.Name
FROM INSERTED I

INSERT INTO Table2
SELECT I.ID, I.Name1
FROM INSERTED I
END