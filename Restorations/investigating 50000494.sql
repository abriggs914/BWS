USE SysproCompanyA
GO

SELECT * FROM [WipMaster] WHERE [Job] <= '50000494' ORDER BY [Job]
SELECT * FROM [WipMaster] WHERE [Job] >= '50000494' ORDER BY [Job]
--SELECT * FROM [BWSdb].[dbo].[Restorations] WHERE [Restorations].ResJob = '50000494'


SELECT * FROM [WipMaster] WHERE [Job] = '50000494' OR [Job] = '5000494'
SELECT * FROM [BWSdb].[dbo].[Restorations] WHERE [Restorations].[ResJob] = '50000494' OR [Restorations].[ResJob V2] = '50000494'

SELECT * FROM [WipJobAllLab] WHERE [Job] = '50000494'
SELECT * FROM [WipJobAllMat] WHERE [Job] = '50000494'
SELECT * FROM [SorMaster] WHERE [Job] = '50000494'
SELECT * FROM [SorDetail] WHERE [SorDetail].[MStockDes] LIKE '%319%' AND [MStockDes] LIKE '%QUOTE%'

SELECT 
	Restorations.ResQuote,
	WipMaster.Job AS Job,
	(CASE WHEN [WipMaster].[SalesOrder]='' THEN 'N/A' ELSE [WipMaster].[SalesOrder] END) AS SalesOrder,
	'*' + [Job] + '*' AS JobBarCode,
	WipMaster.QtyToMake,
	WipMaster.JobTenderDate,
	WipMaster.JobDescription,
	WipMaster.JobStartDate,
	WipMaster.JobDeliveryDate,
	WipMaster.StockCode,
	'*' + rtrim(lTrim([WipMaster].[StockCode])) + '*' AS SCBarCode,
	InvWarehouse.DefaultBin,
	WipMaster.StockDescription,
	InvMaster.LongDesc,
	Fixtures.Application,
	'*' + CAST([Application] AS nvarchar(MAX)) + '*' AS App,
	Fixtures.Location,
	Fixtures.[weight (pounds)/ Maneuverability ],
	Restorations.ResJobNotes,
	WipMaster.CustomerName
FROM 
	[BWSdb].[dbo].Restorations 
INNER JOIN 
	WipMaster
ON
	[Restorations].[ResJob V2] = WipMaster.Job COLLATE SQL_Latin1_General_CP1_CI_AS
LEFT JOIN 
	[BWSdb].[dbo].[Fixtures]
ON 
	WipMaster.StockCode = [Fixtures].[Other Parts Made ] COLLATE SQL_Latin1_General_CP1_CI_AS
LEFT JOIN 
	InvMaster 
ON 
	WipMaster.StockCode = InvMaster.StockCode
LEFT JOIN 
	InvWarehouse 
ON (InvMaster.StockCode = InvWarehouse.StockCode
AND (InvMaster.WarehouseToUse = InvWarehouse.Warehouse)) 

WHERE
	(((WipMaster.Job)='50000494'));
