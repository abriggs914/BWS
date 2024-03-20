USE BWSdb
GO

EXEC sp_SerialNumberCalc @quote=30140, @year=2025


DECLARE @calc_pos_7 NVARCHAR(MAX);
DECLARE @mn NVARCHAR(MAX);
DECLARE @quote INT = 30140;

	SELECT
		[SN].[Position7]
	FROM
		[SN Type] [SN]
	INNER JOIN
		[Orders] [O]
	ON
		[SN].[Model No] = [O].[Model No]
	WHERE
		([O].[Quote#] = @quote)
		AND ([SN].[Model No] = [O].[Model No])

	SELECT
		@calc_pos_7 = [SN].[Position7],
		@mn = [O].[Model No]
	FROM
		[SN Type] [SN]
	INNER JOIN
		[Orders] [O]
	ON
		[SN].[Model No] = [O].[Model No]
	WHERE
		([O].[Quote#] = @quote)
		AND ([SN].[Model No] = [O].[Model No])

SELECT @calc_pos_7, @mn

SELECT
	*
FROM
	[SN Type]
WHERE
	[Model No] = @mn


	DECLARE @quote int, @year int, @mode INT=NULL, @startSeq INT=NULL
	SELECT @quote=30140, @year=2025, @mode=1, @startSeq=428
	SELECT @quote=29928, @year=2025, @mode=1, @startSeq=428
	
--declare @maxsn int
--select @maxsn = MAX(CAST(RIGHT([Serial Number], 6) AS INT)) + 1
----select @maxsn2 = COUNT(*) + 2
--from Orders with (nolock)
--cross join [SNC Year] with (nolock)
--where [Year] = @year
--and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
--AND LEFT([Serial Number], 3) IN ('2XB', '2B9')
--AND [Date Declined] IS NULL

--SELECT 
--	@maxsn

	
--select MAX(CAST(RIGHT([Serial Number], 6) AS INT)) + 1
----select @maxsn2 = COUNT(*) + 2
--from Orders with (nolock)
--cross join [SNC Year] with (nolock)
--where [Year] = @year
--and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
--AND LEFT([Serial Number], 3) IN ('2XB', '2B9')
--AND [Date Declined] IS NULL


--select COUNT([Serial Number])
----select @maxsn2 = COUNT(*) + 2
--from Orders with (nolock)
--cross join [SNC Year] with (nolock)
--where [Year] = @year
--and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
--AND LEFT([Serial Number], 3) IN ('2XB', '2B9')
--AND [Date Declined] IS NULL


select 
	RIGHT([Serial Number], 6)
	, RIGHT(LEFT([Serial Number], 10), 1)
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
ORDER BY
	RIGHT([Serial Number], 6)