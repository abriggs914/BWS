
DECLARE @year INT = 2026


SELECT
	MAX([RSN])
FROM (
	SELECT ISNULL(CAST(RIGHT([Serial Number], 6) AS INT), 0) AS [RSN]
	FROM [BWSdb].[dbo].[Orders] with (nolock)
	cross join [BWSdb].[dbo].[SNC Year] with (nolock)
	where [Year] = @year
	and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
	AND LEFT([Serial Number], 3) IN ('2SV', '2XB', '2S9')
	AND [Decline/Rejected] = 4
	AND [QuoteAsStargate] = 1

	UNION

	SELECT ISNULL(CAST(RIGHT([Serial Number], 6) AS INT), 0) AS [RSN]
	FROM [BWSdb].[dbo].[OrdersV2] with (nolock)
	cross join [BWSdb].[dbo].[SNC Year] with (nolock)
	where [Year] = @year
	and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'M' + '%'
	AND LEFT([Serial Number], 3) IN ('2SV')
	AND [Decline/Rejected] = 4
) AS [Src]

------------------------------------

SELECT
	*
FROM
	[BWSdb].[dbo].[Orders]
WHERE
	[Quote#] IN (
	30928,
	30933,
	30945
)
;
SELECT
	*
FROM
	[BWSdb].[dbo].[OrdersV2]
ORDER BY
	[OrdersV2].[OrderID] DESC
;

SELECT
	*
FROM
	[BWSdb].[dbo].[Orders]
WHERE
	[QuoteAsStargate] = 1

	
EXEC [BWSdb].[dbo].[sp_SerialNumberCalc] @quote=30929, @year=@year
EXEC [BWSdb].[dbo].[sp_SerialNumberCalcSTG] @quote='SG101846', @year=@year



--SELECT @maxsn = ISNULL(MAX(CAST(RIGHT([Serial Number], 6) AS INT)), 0)
--select @maxsn2 = COUNT(*) + 2
SELECT *
FROM [BWSdb].[dbo].[Orders] with (nolock)
cross join [BWSdb].[dbo].[SNC Year] with (nolock)
where [Year] = @year
and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
AND LEFT([Serial Number], 3) IN ('2SV')
AND [Decline/Rejected] = 4
AND [QuoteAsStargate] = 1

/*
SELECT @maxsn AS [MAX A]

-----
SELECT ISNULL(MAX(CAST(RIGHT([Serial Number], 6) AS INT)), 0)
--select @maxsn2 = COUNT(*) + 2
FROM [OrdersV2] with (nolock)
cross join [SNC Year] with (nolock)
where [Year] = @year
and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'M' + '%'
AND LEFT([Serial Number], 3) IN ('2SV')
AND [Decline/Rejected] = 4
-----
*/

--SELECT @maxsn = @maxsn + MAX(ISNULL(CAST(RIGHT([Serial Number], 6) AS INT), 0))
--select @maxsn2 = COUNT(*) + 2
SELECT *, ISNULL(CAST(RIGHT([Serial Number], 6) AS INT), 0) AS [RSN]
FROM [BWSdb].[dbo].[OrdersV2] with (nolock)
cross join [BWSdb].[dbo].[SNC Year] with (nolock)
where [Year] = @year
and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'M' + '%'
AND LEFT([Serial Number], 3) IN ('2SV')
AND [Decline/Rejected] = 4
ORDER BY
[RSN] DESC

/*
BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[Orders]
SET
	[Serial Number] = NULL
WHERE
	[Quote#] IN (30929, 30930, 30931, 30932, 30933, 30928, 30920)

ROLLBACK;
COMMIT;
*/

SELECT
	ISNULL(CAST(RIGHT([Serial Number], 6) AS INT), 0) AS [RSN]
	,*
FROM
	[BWSdb].[dbo].[Orders]
CROSS JOIN
	[BWSdb].[dbo].[SNC Year] WITH (NOLOCK)
WHERE
	[Year] = @year
	AND (RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%')
	AND [QuoteAsStargate] = 1
ORDER BY
	[RSN] DESC

SELECT

	ISNULL(CAST(RIGHT([Serial Number], 6) AS INT), 0) AS [RSN]
	,*
FROM
	[BWSdb].[dbo].[OrdersV2]
CROSS JOIN 
	[BWSdb].[dbo].[SNC Year] WITH (NOLOCK)
WHERE
	[Year] = @year
	AND (RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'M' + '%')
ORDER BY
	[RSN] DESC


SELECT
	*
FROM (
	SELECT
		CAST([Quote#] AS NVARCHAR(MAX)) AS [Quote],
		[WO#],
		[Model No],
		[Serial Number],
		ISNULL(CAST(RIGHT([Serial Number], 6) AS INT), 0) AS [RSN]
	FROM
		[BWSdb].[dbo].[Orders]
	CROSS JOIN 
		[BWSdb].[dbo].[SNC Year] WITH (NOLOCK)
	WHERE
		[Year] = @year
		AND (RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%')
		AND [QuoteAsStargate] = 1

	UNION ALL

	SELECT
		[SGQuote],
		[WO#],
		[Model No],
		[Serial Number],
		ISNULL(CAST(RIGHT([Serial Number], 6) AS INT), 0) AS [RSN]
	FROM
		[BWSdb].[dbo].[OrdersV2]
	CROSS JOIN 
		[BWSdb].[dbo].[SNC Year] WITH (NOLOCK)
	WHERE
		[Year] = @year
		AND (RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'M' + '%')
) AS [Src]
ORDER BY
	[RSN] DESC