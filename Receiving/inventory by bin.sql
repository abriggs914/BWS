
SELECT
	[Src].[DefaultBin],
	[Src].[TimesUsed],
	[Src].[TotalOnHand],
	[Src].[TotalCost],
	(CASE WHEN ISNULL([Src].[TotalOnHand], 0) = 0 THEN NULL ELSE [Src].[TotalCost] / [Src].[TotalOnHand] END) AS [UnitCost]
FROM (

	SELECT
		LTRIM(RTRIM(UPPER(REPLACE(REPLACE([IW].[DefaultBin], '@', ''), ' ', '')))) AS [DefaultBin],
		COUNT(*) AS [TimesUsed],
		SUM([IW].[QtyOnHand]) AS [TotalOnHand],
		SUM([IW].[LastCostEntered]) AS [TotalCost]
	FROM
		[SysproCompanyA].[dbo].[InvWarehouse] [IW]
	WHERE
		(LTRIM(RTRIM(UPPER(REPLACE(REPLACE(ISNULL([IW].[DefaultBin], ''), '@', ''), ' ', '')))) <> '')
		AND ([IW].[Warehouse] = '01')
	/*	([QtyInInspection] > 0
		OR [QtyInTransit] > 0)
		AND [QtyOnHand] > 0*/
	GROUP BY
		LTRIM(RTRIM(UPPER(REPLACE(REPLACE([IW].[DefaultBin], '@', ''), ' ', ''))))
) AS [Src]
/*LEFT JOIN
	[SysproCompanyA].[dbo].[InvMaster]
ON*/
ORDER BY
	[Src].[TotalCost] DESC