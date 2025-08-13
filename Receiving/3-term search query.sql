DECLARE @st1 NVARCHAR(MAX) = '8';
DECLARE @st2 NVARCHAR(MAX) = '6';
DECLARE @st3 NVARCHAR(MAX) = 'grommet';

SELECT
	*
FROM (
	SELECT
		[IW].[StockCode],
		[IM].[Description],
		[IM].[LongDesc],
		[IW].[DefaultBin],
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
WHERE
	((CASE WHEN @st1 IS NULL THEN 1 ELSE (CASE WHEN [Desc] LIKE '%' + @st1 + '%' THEN 1 ELSE 0 END) END) * 
	(CASE WHEN @st2 IS NULL THEN 1 ELSE (CASE WHEN [Desc] LIKE '%' + @st2 + '%' THEN 1 ELSE 0 END) END) *
	(CASE WHEN @st3 IS NULL THEN 1 ELSE (CASE WHEN [Desc] LIKE '%' + @st3 + '%' THEN 1 ELSE 0 END) END)) > 0
ORDER BY
	[Src].[QtyOnHand] DESC
