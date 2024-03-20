

DECLARE @quote int, @year int, @mode INT=NULL, @startSeq INT=NULL
SELECT @quote=30140, @year=2025, @mode=1, @startSeq=428
SELECT @quote=29928, @year=2025, @mode=1, @startSeq=428


SELECT
	*
FROM 
	[Orders] [O]
INNER JOIN (
	select 
		RIGHT([Serial Number], 6) AS [SN6]
		, RIGHT(LEFT([Serial Number], 10), 1) AS [SrcY]
	--select @maxsn2 = COUNT(*) + 2
	from Orders with (nolock)
	cross join [SNC Year] with (nolock)
	where [Year] = @year
	and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
	AND LEFT([Serial Number], 3) IN ('2XB', '2B9')
	AND [Date Declined] IS NULL
	GROUP BY
		RIGHT([Serial Number], 6)
		, RIGHT(LEFT([Serial Number], 10), 1)
	HAVING
		COUNT(*) > 1
) AS [Src]
ON
	RIGHT([O].[Serial Number], 6) = [Src].[SN6]
	AND (RIGHT(LEFT([Serial Number], 10), 1)) = [Src].[SrcY]
ORDER BY
	[SN6]