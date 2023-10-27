USE BWSdb
GO


SELECT TOP 25
	*
FROM
	[SysproCompanyA].[dbo].[SorDetail]
;
SELECT TOP 25
	*

FROM
	[SysproCompanyA].[dbo].[SorMaster]
;
SELECT TOP 25
	*
FROM
	[SysproCompanyA].[dbo].[PorMasterDetail]
WHERE
	[PurchaseOrder] <> ''
;
SELECT
	*
FROM
	[SysproCompanyA].[dbo].[PorMasterDetail]
WHERE
	[MStockCode] = 'PONY 3X17-102-28440'
	OR [MStockCode] = '53ET3XP-102-27167'
;


SELECT
	*
FROM
	[SysproCompanyA].[dbo].[SorDetail] AS [S]
INNER JOIN
	[Orders] AS [O]
ON
	[S].[SalesOrder] = [O].[Sales Order#]
WHERE
	[MStockCode] = 'PONY 3X17-102-28440'
	OR [MStockCode] = '53ET3XP-102-27167'
;



SELECT
	[O].[Quote#],
	[COMPANY NAME],
	[Purchase Order],
	[Price],
	[S].[MPrice],
	[S].[MTrfCostMult],
	[S].[MUnitCost],
	[S].[NMscChargeCost],
	[S].[NSrvUnitCost],
	[MStockCode],
	[MStockDes],
	--[Cost],
	*
FROM
	[Orders] AS [O]
INNER JOIN
	[Dealers] AS [D]
ON
	[O].[dealerID] = [D].[ID]
INNER JOIN
	[SysproCompanyA].[dbo].[SorDetail] AS [S]
ON
	[O].[Sales Order#] = [S].[SalesOrder] COLLATE DATABASE_DEFAULT
ORDER BY
	[O].[Quote#]
;


SELECT
	[O].[Quote#],
	[D].[COMPANY NAME],
	[O].[Purchase Order],
	[P].[Price] AS [ModelPrice],
	[O].[Price] AS [OrderPrice],
	[S].[MPrice],
	[S].[MTrfCostMult],
	[S].[MUnitCost],
	[S].[NMscChargeCost],
	[S].[NSrvUnitCost],
	[MStockCode],
	[MStockDes],
	--[Cost],
	*
FROM
	[Orders] AS [O]
INNER JOIN
	[Dealers] AS [D]
ON
	[O].[dealerID] = [D].[ID]
INNER JOIN
	[Products] AS [P]
ON
	[O].[Model No] = [P].[Model No]
	OR [O].[ProductID] = [P].[IDTrailer]
INNER JOIN
	[SysproCompanyA].[dbo].[SorDetail] AS [S]
ON
	[O].[Sales Order#] = [S].[SalesOrder] COLLATE DATABASE_DEFAULT
WHERE
	[O].[Price] >= [S].[MPrice]
	AND [S].[MPrice] <> 0
ORDER BY
	[O].[Quote#]
;
