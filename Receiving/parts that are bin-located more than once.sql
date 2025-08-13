
-- Finding all parts that are bin-located more than once


SELECT
	[Src].[DefaultBin],
	[Src].[Warehouse],
	COUNT(*) AS [NumOccurrences]
FROM (
	SELECT
		[IW].[StockCode],
		[IM].[Description],
		[IM].[LongDesc],
		[IW].[DefaultBin],
		[IW].[Warehouse],
		[IW].[QtyOnHand],
		[IW].[QtyAllocated],
		[IW].[QtyAllocatedToPick],
		[IW].[QtyAllocatedWip],
		[IW].[UnitCost],
		[IW].[DateLastSale]

		, LOWER(ISNULL([IM].[Description], '') + ISNULL([IM].[LongDesc], '')) AS [Desc]
	FROM
		[SysproCompanyA].[dbo].[InvWarehouse] [IW]
	INNER JOIN
		[SysproCompanyA].[dbo].[InvMaster] [IM]
	ON
		[IW].[StockCode] = [IM].[StockCode]
	/*WHERE
		LEFT(LOWER([IW].[DefaultBin]), 3) = 'f36'*/
) AS [Src]
GROUP BY
	[Src].[DefaultBin],
	[Src].[Warehouse]
HAVING
	COUNT(*) > 1
ORDER BY
	[Src].[Warehouse],
	[Src].[DefaultBin]
	