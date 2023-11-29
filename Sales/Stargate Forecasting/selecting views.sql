USE BWSdb
GO

SELECT
	'v_SFC_BWSUnionSTGOrders' AS [Table]
	,*
FROM
	[v_SFC_BWSUnionSTGOrders]
;

SELECT
	'v_SFC_SalesPersonCountsMasterData' AS [Table]
	,*
FROM
	[v_SFC_SalesPersonCountsMasterData]
;

SELECT
	'v_SFC_SalesPersonIndividualSalesCounts' AS [Table]
	,*
FROM
	[v_SFC_SalesPersonIndividualSalesCounts]
;

SELECT
	'v_SFC_SalesPersonTotalSalesCounts' AS [Table]
	,*
FROM
	[v_SFC_SalesPersonTotalSalesCounts]
;

SELECT
	[Dealers_COMPANYNAME]
	,[Orders_CompanyID]
FROM
	[v_SFC_BWSUnionSTGOrders]
WHERE
	[OriginTable] = 'BWS'
	AND [Orders_CompanyID] = 0
GROUP BY
	[Dealers_COMPANYNAME]
	,[Orders_CompanyID]
;

SELECT
	'v_SFC_BWSUnionSTGOrders' AS [Table]
	,[OriginTable]
	,[Dealers_ID]
	,[Dealers_CompanyID]
	,[Dealers_COMPANYNAME]
	,[Dealers_CURRENTDEALER]
	,[Dealers_EasternUS]
	,[Dealers_WesternUS]
	,[Dealers_EasternCanada]
	,[Dealers_WesternCanada]
	,[Dealers_CURRENTDEALERCDN]
	,[Dealers_CURRENTDEALERUS]
FROM
	[v_SFC_BWSUnionSTGOrders]
--WHERE
--	[Dealers_CURRENTDEALERCDN] = 
GROUP BY
	[OriginTable]
	,[Dealers_ID]
	,[Dealers_CompanyID]
	,[Dealers_COMPANYNAME]
	,[Dealers_CURRENTDEALER]
	,[Dealers_EasternUS]
	,[Dealers_WesternUS]
	,[Dealers_EasternCanada]
	,[Dealers_WesternCanada]
	,[Dealers_CURRENTDEALERCDN]
	,[Dealers_CURRENTDEALERUS]
;

SELECT
	COUNT(*) AS [C]
	,[OriginTable]
	,[Dealers_ID]
	,[Dealers_CompanyID]
	,[Dealers_COMPANYNAME]
	,(CASE WHEN (
		CAST(ISNULL([Dealers_CURRENTDEALER], 0) AS INT) 
		+ CAST(ISNULL([Dealers_CURRENTDEALERCDN], 0) AS INT) 
		+ CAST(ISNULL([Dealers_CURRENTDEALERUS], 0) AS INT)) <> 0 THEN 1 
		ELSE 0
	END) AS [CurrentDealer]
	,(CASE WHEN (
		CAST(ISNULL([Dealers_EasternUS], 0) AS INT) 
		+ CAST(ISNULL([Dealers_WesternUS], 0) AS INT)) <> 0 THEN 1 
		ELSE 0
	END) AS [USDealer]
	,(CASE WHEN (
		CAST(ISNULL([Dealers_EasternCanada], 0) AS INT)
		+ CAST(ISNULL([Dealers_WesternCanada], 0) AS INT)) <> 0 THEN 1
		ELSE 0
	END) AS [CDNDealer]
	--,[Dealers_CURRENTDEALER]
	--,[Dealers_EasternUS]
	--,[Dealers_WesternUS]
	--,[Dealers_EasternCanada]
	--,[Dealers_WesternCanada]
	--,[Dealers_CURRENTDEALERCDN]
	--,[Dealers_CURRENTDEALERUS]
FROM
	[v_SFC_BWSUnionSTGOrders]
--WHERE
--	[Dealers_CURRENTDEALERCDN] = 
GROUP BY
	[OriginTable]
	,[Dealers_ID]
	,[Dealers_CompanyID]
	,[Dealers_COMPANYNAME]
	,[Dealers_CURRENTDEALER]
	,[Dealers_EasternUS]
	,[Dealers_WesternUS]
	,[Dealers_EasternCanada]
	,[Dealers_WesternCanada]
	,[Dealers_CURRENTDEALERCDN]
	,[Dealers_CURRENTDEALERUS]
ORDER BY
	[Dealers_COMPANYNAME]
;

EXEC [sp_SFC_IndividualSalesData] @dealerID = 140, @companyID=1;