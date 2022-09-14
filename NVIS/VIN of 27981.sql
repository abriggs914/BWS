


	DECLARE @quote int, @year int;
	SET @quote = 27981;
	SET @year = 2023
	
		--select max(RIGHT([Serial Number], 6))
		select (RIGHT([Serial Number], 6))
		, [Serial Number]
		--, CAST([Year] AS NVARCHAR(MAX)) + '-09-01' AS [Lbound],
		--CAST([Year] + 1 AS NVARCHAR(MAX)) + '-08-31' AS [Hbound]
		from Orders with (nolock)
		cross join [SNC Year] with (nolock)
		where [Year] = @year
		and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
		AND LEFT([Serial Number], 3) IN ('2XB', '2B9')
		--AND [Order Date] BETWEEN CAST([Year] AS NVARCHAR(MAX)) + '-09-01' AND CAST([Year] + 1 AS NVARCHAR(MAX)) + '-08-31'
	
		--select max(RIGHT([Serial Number], 6))
		select 
		COUNT(*) + 1 AS [C]
		--, (RIGHT([Serial Number], 6))
		--, CAST([Year] - 1 AS NVARCHAR(MAX)) + '-09-01' AS [Lbound],
		--CAST([Year] AS NVARCHAR(MAX)) + '-08-31' AS [Hbound]
		from Orders with (nolock)
		cross join [SNC Year] with (nolock)
		where [Year] = @year
		and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
		AND LEFT([Serial Number], 3) IN ('2XB', '2B9')
		AND [Delivery Date] BETWEEN CAST([Year] AS NVARCHAR(MAX)) + '-09-01' AND CAST([Year] + 1 AS NVARCHAR(MAX)) + '-08-31'

		SELECT 
			[Quote#]
			, [Quote Date]
			, [Order Date]
			, [Delivery Date]
			, [Available Date]
			, [PO Date]
			, [Requested Delivery Date]
			, [Date Declined]
			, [Date Registered]
			, [Invoice Date]
			, [Date In Service]
			, *
		FROM [Orders]
		WHERE ([Order Date] BETWEEN CAST(@year AS NVARCHAR(MAX)) + '-09-01' AND CAST(@year + 1 AS NVARCHAR(MAX)) + '-08-31')
		OR ([Quote#] > (27981 - 3) AND [Quote#] < (27981 + 3))

	select *
		from Orders with (nolock)
		cross join [SNC Year] with (nolock)
		where [Year] = @year
		and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
		AND LEFT([Serial Number], 3) IN ('2XB', '2B9')