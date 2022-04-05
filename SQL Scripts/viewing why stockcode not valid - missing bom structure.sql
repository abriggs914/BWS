USE [SysproCompanyA]
GO

/****** Object:  View [dbo].[v_BOMRecostingReport]    Script Date: 2022-04-05 11:43:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


DECLARE @sc AS NVARCHAR(100);
SET @sc = UPPER('42fhr2x-102-25964');

SELECT * FROM [InvMaster] WHERE [StockCode] = @sc
SELECT * FROM v_BOMCostingReport WHERE ParentPart = @sc
SELECT * FROM dbo.BomStructure WHERE [Component] = @sc

--ALTER view [dbo].[v_BOMRecostingReport] as 
select ParentPart, Route, InvMaster.Description as [InvMasterDescription], InvMaster.LongDesc as [InvMasterLongDesc], 
v_BOMCostingReport.StockUom as StockUom, Operation, Component, SequenceNum, v_BOMCostingReport.Description as [v_BOMCostingReportDescription],
v_BOMCostingReport.LongDesc as [v_BOMCostingReportLongDesc], QP, ScrapPercentage, QtyPer, v_BOMCostingReport.StockUom as [v_BOMCostingReportStockUom], v_BOMCostingReport.PartCategory, 
v_BOMCostingReport.MaterialCost, NetMaterial, LabourHours, v_BOMCostingReport.LabourCost, v_BOMCostingReport.FixOverhead, 
v_BOMCostingReport.NetLabour, TotalCost, v_BOMCostingReport.Mass, TechSpec, LastReceived, Test, [OldCosting?], CompNarration, v_BOMCostingReport.Supplier
from InvMaster with (nolock)
inner join v_BOMCostingReport with (nolock) on InvMaster.StockCode = v_BOMCostingReport.ParentPart

order by [ParentPart]


--where Component <> 'LABOUR COST'



--GO


