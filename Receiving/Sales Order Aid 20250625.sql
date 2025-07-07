

SELECT
	*
FROM (
	SELECT
		'BWS' AS [Comp],
		[IM].[StockCode],
		[IM].[Description],
		[IM].[LongDesc],
		[IW].[DefaultBin],
		[IW].[QtyAllocated],
		[IW].[QtyOnHand],
		[IW].[QtyOnOrder],
		[IW].[QtyOnBackOrder]
	FROM
		[SysproCompanyA].[dbo].[InvMaster] [IM]
	INNER JOIN
		[SysproCompanyA].[dbo].[InvWarehouse] [IW]
	ON
		[IM].[StockCode] = [IW].[StockCode]
	UNION
	SELECT
		'STG' AS [Comp],
		[IM].[StockCode],
		[IM].[Description],
		[IM].[LongDesc],
		[IW].[DefaultBin],
		[IW].[QtyAllocated],
		[IW].[QtyOnHand],
		[IW].[QtyOnOrder],
		[IW].[QtyOnBackOrder]
	FROM
		[SysproCompanyS].[dbo].[InvMaster] [IM]
	INNER JOIN
		[SysproCompanyS].[dbo].[InvWarehouse] [IW]
	ON
		[IM].[StockCode] = [IW].[StockCode]
) [Src]
WHERE
	([StockCode] LIKE '%clevis%')
	OR ([Description] LIKE '%clevis%')
	OR ([LongDesc] LIKE '%clevis%')
	;