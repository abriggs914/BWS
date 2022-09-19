SELECT DISTINCT 
	InvMaster.StockCode,
	InvMaster.Description,
	InvMaster.LongDesc,
	InvMaster.StockUom,
	InvMaster.ProductClass
FROM
	[SysproCompanyA].[dbo].InvMaster
INNER JOIN
	[SysproCompanyA].[dbo].BomStructure
ON
	InvMaster.StockCode=BomStructure.ParentPart
ORDER BY 
	[InvMaster].[StockCode]
;

SELECT DISTINCT 
	InvMaster.StockCode,
	InvMaster.Description,
	InvMaster.LongDesc,
	InvMaster.StockUom,
	InvMaster.ProductClass
FROM
	[SysproCompanyA].[dbo].InvMaster
ORDER BY 
	[InvMaster].[StockCode]
;