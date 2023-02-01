USE BWSdb
GO


SELECT 
	[Archive Date]
FROM
	[arcProducts]
WHERE
	[Model No] = '20ART'

UNION ALL

SELECT 
	[Archive Date]
FROM
	[arcProducts]
WHERE
	[Model No] = '53ET3X'
ORDER BY
	[Archive Date]

SELECT DISTINCT
	[D]
FROM (
	SELECT 
		[Archive Date] AS [D]
	FROM
		[arcProducts]
	WHERE
		[Model No] = '20ART'

	UNION ALL

	SELECT 
		[Archive Date]
	FROM
		[arcProducts]
	WHERE
		[Model No] = '53ET3X'
) AS [Sub]
	ORDER BY
		[D]