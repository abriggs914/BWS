USE BWSdb
GO

SELECT
	[Serial Number]
	, RIGHT([Serial Number], 8) AS [SN]
	,RIGHT(LEFT([Serial Number], 11), 2)
FROM
	[Orders]
WHERE
	LEFT([Serial Number], 3) = '2XB'
	AND RIGHT(LEFT([Serial Number], 11), 2) = 'RA'
ORDER BY
	--RIGHT(LEFT([Serial Number], 11), 2)
	RIGHT([Serial Number], 8)
;


SELECT
	[Serial Number]
	, *
FROM
	[Orders] AS [SrcA]

INNER JOIN (


SELECT
	RIGHT([Serial Number], 8) AS [SN]
FROM
	[Orders]
WHERE
	LEFT([Serial Number], 3) = '2XB'
GROUP BY
	RIGHT([Serial Number], 8)
HAVING
	COUNT(*) > 1
) AS [SrcB]
ON
	RIGHT([SrcA].[Serial Number], 8) = [SrcB].[SN]
ORDER BY
	RIGHT([Serial Number], 8)
;

SELECT COUNT(*) AS [LEFT(Serial Number, 3) = 2XB] FROM [Orders] WHERE LEFT([Serial Number], 3) = '2XB'

declare @maxsn int
	select @maxsn = COUNT(*) + 2
	from Orders with (nolock)
	cross join [SNC Year] with (nolock)
	where [Year] = 2024
	and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
	AND LEFT([Serial Number], 3) IN ('2XB', '2B9')
	AND [Date Declined] IS NULL


	select 
	'A' AS [TABLE]
	,[Serial Number]
	, RIGHT([Serial Number], 8)
	, LEFT([Serial Number], 3)
	, *
	from Orders with (nolock)
	cross join [SNC Year] with (nolock)
	where [Year] = 2024
	and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
	AND LEFT([Serial Number], 3) IN ('2XB', '2B9')
	AND [Date Declined] IS NULL
	ORDER BY
		[Orders].[Serial Number]

SELECT @maxsn AS [@maxsn]


declare @maxsn2 int
	select @maxsn2 = MAX(CAST(RIGHT([Serial Number], 6) AS INT)) + 1
	--select @maxsn2 = COUNT(*) + 2
	from Orders with (nolock)
	cross join [SNC Year] with (nolock)
	where [Year] = 2024
	and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
	AND LEFT([Serial Number], 3) IN ('2XB', '2B9')
	AND [Date Declined] IS NULL
	
SELECT @maxsn2 AS [@maxsn2]