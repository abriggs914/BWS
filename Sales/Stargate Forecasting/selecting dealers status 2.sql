
DECLARE @dID INT = 52375;


SELECT
	(CASE WHEN ISNULL([Dealers_ID], -1) = @dID THEN [Dealers_COMPANYNAME] ELSE (
		CASE WHEN [CDNDealer] = 1 THEN 'CDN Dealers' ELSE 'US Dealers' END
	) END) AS [Company]
	,[CurrentDealer]
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
) AS [A]
--LEFT JOIN
--	[v_SFC_SalesPersonCountsMasterData] AS [M]
--ON
--	[A].[Dealers_ID] = [M].[De]
GROUP BY
	[Dealers_COMPANYNAME]
	,[Dealers_ID]
	,[CDNDealer]
	,[CurrentDealer]
ORDER BY
	[Company]
;
