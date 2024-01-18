USE BWSdb
GO


DECLARE @startSeq INT=NULL
DECLARE @year INT=2025

declare @maxsn int
	select @maxsn = MAX(CAST(RIGHT([Serial Number], 6) AS INT))
	--select @maxsn2 = COUNT(*) + 2
	from [OrdersV2] with (nolock)
	cross join [SNC Year] with (nolock)
	where [Year] = @year
	and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'M' + '%'
	AND LEFT([Serial Number], 3) IN ('2SV')
	AND [Date Declined] IS NULL


--Geneate new number for serial number
	declare @newsn NVARCHAR(6)
	--select @newsn = case when @maxsn is null then 1001 else @maxsn + 1 end
	--select @newsn = case when @maxsn is null then 100001 else @maxsn + 1 end
	select @newsn = RIGHT('000000' + CAST(case when @maxsn is null then 1 else @maxsn + 1 end AS NVARCHAR(6)), 6)

	IF @startSeq IS NOT NULL BEGIN
		SELECT @newsn = RIGHT('000000' + CAST(@startSeq + 1 AS NVARCHAR(6)), 6)
	END
	
	SELECT @newsn, @maxsn