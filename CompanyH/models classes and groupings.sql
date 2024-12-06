SELECT
	*
FROM
	[CompanyH].[dbo].[Orders]
;

SELECT
	*
FROM
	[BWSdb].[dbo].[Products]
;

SELECT
	*
FROM
	[BWSdb].[dbo].[ProductsV2]
;

SELECT
	[BWSSrc].[Model No],
	[STGSrc].[Model No],
	[BWSSrc].[IDTrailer],
	[STGSrc].[IDTrailer],
	*
FROM
	[BWSdb].[dbo].[ProductsV2] [STGSrc]
FULL JOIN (
	SELECT
		[IDTrailer],
		[Model],
		[Model No],
		[Class],
		[Grouping]
	FROM
		[BWSdb].[dbo].[Products]
	WHERE
		([Model] IS NOT NULL)
		AND ([Model No] IS NOT NULL)
		AND ([Class] IS NOT NULL)
		AND ([Grouping] IS NOT NULL)
	GROUP BY
		[IDTrailer],
		[Model],
		[Model No],
		[Class],
		[Grouping]
	--HAVING COUNT(*) > 1
) AS [BWSSrc]
ON
	[STGSrc].[Model No] = [BWSSrc].[Model No]
	AND [STGSrc].[Model] = [BWSSrc].[Model]
	AND [STGSrc].[Class] = [BWSSrc].[Class]
	AND [STGSrc].[Grouping] = [BWSSrc].[Grouping]
WHERE
	([STGSrc].[Model] IS NOT NULL)
	AND ([STGSrc].[Model No] IS NOT NULL)
	AND ([STGSrc].[Class] IS NOT NULL)
	AND ([STGSrc].[Grouping] IS NOT NULL)
ORDER BY
	[STGSrc].[IDTrailer]
	/*[STGSrc].[Model],
	[STGSrc].[Model No],
	[STGSrc].[Class],
	[STGSrc].[Grouping]*/