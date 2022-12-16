USE BWSdb
GO


SELECT 
	*
FROM
	[Production]
;


SELECT 
	YEAR(ISNULL([Prod Date], [Prod Date2])) AS [Year]
	, MONTH(ISNULL([Prod Date], [Prod Date2])) AS [Month]
	, COUNT(*) AS [# Units]
FROM
	[Production]
GROUP BY
	YEAR(ISNULL([Prod Date], [Prod Date2]))
	, MONTH(ISNULL([Prod Date], [Prod Date2]))
ORDER BY
	YEAR(ISNULL([Prod Date], [Prod Date2]))
	, MONTH(ISNULL([Prod Date], [Prod Date2]))
;


SELECT 
	YEAR([Delivery Date]) AS [Year]
	, MONTH([Delivery Date]) AS [Month]
	, COUNT(*) AS [# Units]
FROM
	[Orders]
GROUP BY
	YEAR([Delivery Date])
	, MONTH([Delivery Date])
ORDER BY
	YEAR([Delivery Date])
	, MONTH([Delivery Date])
;