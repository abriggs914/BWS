

-- total revenue by month

SELECT
	YEAR([Quote Date]) AS [Year],
	MONTH([Quote Date]) AS [Month],
	COUNT(*) AS [# orders],
	SUM([Price]) AS [Total Revenue]
	--RIGHT('0000000000000000000000000' + CAST(SUM([Price]) AS NVARCHAR(25)), 15) AS [Total Revenue]
FROM 
	[Orders]
WHERE
	[Date Declined] IS NULL
GROUP BY
	YEAR([Quote Date]),
	MONTH([Quote Date])
ORDER BY
	YEAR([Quote Date]),
	MONTH([Quote Date])


-- total revenue by year

SELECT
	YEAR([Quote Date]) AS [Year],
	COUNT(*) AS [# orders],
	SUM([Price]) AS [Total Revenue]
	--RIGHT('0000000000000000000000000' + CAST(SUM([Price]) AS NVARCHAR(25)), 15) AS [Total Revenue]
FROM 
	[Orders]
WHERE
	[Date Declined] IS NULL
GROUP BY
	YEAR([Quote Date])
ORDER BY
	YEAR([Quote Date])