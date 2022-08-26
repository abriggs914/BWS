
DECLARE @year AS INT;
SELECT @year = 2022;

SELECT
	MAX(CAST([BWSdb].[dbo].[TrailingDigits](RIGHT([Serial Number], 6)) AS INTEGER)) AS [X]
	from Orders with (nolock)
	cross join [SNC Year] with (nolock)
	where [Year] = @year AND LEN([Serial Number]) = 17
	AND CHARINDEX(' ', [Serial Number]) = 0
	and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A%'
	--ORDER BY [Serial Number] DESC


SELECT
	CAST([BWSdb].[dbo].[TrailingDigits](RIGHT([Serial Number], 6)) AS INTEGER) AS [X]
	,[Serial Number]
	, [Year]
	, [Order Date]
	, [Delivery Date]
	from Orders with (nolock)
	cross join [SNC Year] with (nolock)
	where [Year] = @year AND LEN([Serial Number]) = 17
	AND CHARINDEX(' ', [Serial Number]) = 0
	and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A%'
	ORDER BY CAST([BWSdb].[dbo].[TrailingDigits](RIGHT([Serial Number], 6)) AS INTEGER)