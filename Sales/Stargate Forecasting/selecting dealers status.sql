USE BWSdb
GO


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
		CAST(ISNULL([Dealers_CURRENTDEALERUS], 0) AS INT) 
		+ CAST(ISNULL([Dealers_EasternUS], 0) AS INT) 
		+ CAST(ISNULL([Dealers_CentralUS], 0) AS INT) 
		+ CAST(ISNULL([Dealers_WesternUS], 0) AS INT)
		+ CAST(ISNULL([Dealers_American], 0) AS INT)) <> 0 THEN 1 
		ELSE 0
	END) AS [USDealer]
	,(CASE WHEN (
		CAST(ISNULL([Dealers_CURRENTDEALERCDN], 0) AS INT) 
		+ CAST(ISNULL([Dealers_EasternCanada], 0) AS INT)
		+ CAST(ISNULL([Dealers_CentralCanada], 0) AS INT)
		+ CAST(ISNULL([Dealers_WesternCanada], 0) AS INT)) <> 0 THEN 1
		ELSE 0
	END) AS [CDNDealer]
FROM
	[v_SFC_BWSUnionSTGOrders]
GROUP BY
	[OriginTable]
	,[Dealers_ID]
	,[Dealers_CompanyID]
	,[Dealers_COMPANYNAME]
	,[Dealers_CURRENTDEALER]
	,[Dealers_EasternUS]
	,[Dealers_CentralUS]
	,[Dealers_WesternUS]
	,[Dealers_EasternCanada]
	,[Dealers_CentralCanada]
	,[Dealers_WesternCanada]
	,[Dealers_American]
	,[Dealers_CURRENTDEALERCDN]
	,[Dealers_CURRENTDEALERUS]
;

-- CDN IDs
SELECT
	*
FROM (
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
			CAST(ISNULL([Dealers_CURRENTDEALERUS], 0) AS INT) 
			+ CAST(ISNULL([Dealers_EasternUS], 0) AS INT) 
			+ CAST(ISNULL([Dealers_CentralUS], 0) AS INT) 
			+ CAST(ISNULL([Dealers_WesternUS], 0) AS INT)
			+ CAST(ISNULL([Dealers_American], 0) AS INT)) <> 0 THEN 1 
			ELSE 0
		END) AS [USDealer]
		,(CASE WHEN (
			CAST(ISNULL([Dealers_CURRENTDEALERCDN], 0) AS INT) 
			+ CAST(ISNULL([Dealers_EasternCanada], 0) AS INT)
			+ CAST(ISNULL([Dealers_CentralCanada], 0) AS INT)
			+ CAST(ISNULL([Dealers_WesternCanada], 0) AS INT)) <> 0 THEN 1
			ELSE 0
		END) AS [CDNDealer]
	FROM
		[v_SFC_BWSUnionSTGOrders]
	GROUP BY
		[OriginTable]
		,[Dealers_ID]
		,[Dealers_CompanyID]
		,[Dealers_COMPANYNAME]
		,[Dealers_CURRENTDEALER]
		,[Dealers_EasternUS]
		,[Dealers_CentralUS]
		,[Dealers_WesternUS]
		,[Dealers_EasternCanada]
		,[Dealers_CentralCanada]
		,[Dealers_WesternCanada]
		,[Dealers_American]
		,[Dealers_CURRENTDEALERCDN]
		,[Dealers_CURRENTDEALERUS]
) AS [Src]
WHERE
	[CDNDealer] = 1
;

EXEC [sp_SFC_IndividualSalesData] @dealerID=-52376, @companyID=1