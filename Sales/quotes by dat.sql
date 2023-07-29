USE BWSdb
GO

SELECT
	--CAST(
	--	CAST(YEAR([Quote Date]) AS NVARCHAR(4))
	--	+ '-' + RIGHT('00' + CAST(MONTH([Quote Date]) AS NVARCHAR(2)), 2)
	--	+ '-' + RIGHT('00' + CAST(DAY([Quote Date]) AS NVARCHAR(2)), 2)
	--AS DATETIME) AS [Date]
	[Calendar].[Date]
	, CASE WHEN [Orders].[Quote Date] IS NULL THEN 0 ELSE COUNT(*) END AS [NumQuotes]
FROM
	[Calendar]
LEFT JOIN
	[Orders]
ON
	[Calendar].[Date] = CAST(
		CAST(YEAR([Quote Date]) AS NVARCHAR(4))
		+ '-' + RIGHT('00' + CAST(MONTH([Quote Date]) AS NVARCHAR(2)), 2)
		+ '-' + RIGHT('00' + CAST(DAY([Quote Date]) AS NVARCHAR(2)), 2)
	AS DATETIME)
GROUP BY
	[Calendar].[Date]
	, [Orders].[Quote Date]
	, YEAR([Quote Date])
	, MONTH([Quote Date])
	, DAY([Quote Date])
ORDER BY
	[Calendar].[Date]
;

SELECT
	CAST(
		CAST(YEAR([Quote Date]) AS NVARCHAR(4))
		+ '-' + RIGHT('00' + CAST(MONTH([Quote Date]) AS NVARCHAR(2)), 2)
		+ '-' + RIGHT('00' + CAST(DAY([Quote Date]) AS NVARCHAR(2)), 2)
	AS DATETIME) AS [Date]
	, COUNT(*) AS [NumQuotes]
FROM
	[Orders]
GROUP BY
	YEAR([Quote Date])
	, MONTH([Quote Date])
	, DAY([Quote Date])
ORDER BY
	[Date]
;

	
SELECT
	MIN([Date]) AS [Min]
	, MAX([Date]) AS [Max]
FROM
	[Calendar]
SELECT
	*
FROM
	[Calendar]
ORDER BY
	[Date]