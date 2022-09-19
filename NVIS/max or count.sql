
	DECLARE @quote int, @year int;
	SET @quote = 27616;
	SET @year = 2024;
	
	
	select COUNT(*) + 1 AS [New]
	from Orders with (nolock)
	cross join [SNC Year] with (nolock)
	where [Year] = @year
	and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
	AND LEFT([Serial Number], 3) IN ('2XB', '2B9')
	
	select max(RIGHT([Serial Number], 6)) AS [OG]
	from Orders with (nolock)
	cross join [SNC Year] with (nolock)
	where [Year] = @year
	and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
	AND LEFT([Serial Number], 3) IN ('2XB', '2B9')
	
	select RIGHT([Serial Number], 6)
	from Orders with (nolock)
	cross join [SNC Year] with (nolock)
	where [Year] = @year
	and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
	AND LEFT([Serial Number], 3) IN ('2XB', '2B9')


	select RIGHT([Serial Number], 6)
	, [Serial Number]
	, [Quote#]
	from Orders with (nolock)
	cross join [SNC Year] with (nolock)
	where [Year] = @year
	and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
	AND LEFT([Serial Number], 3) IN ('2XB', '2B9')

EXEC sp_SerialNumberCalc @quote=27935, @year=2024