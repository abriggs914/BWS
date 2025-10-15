
-- 2025-10-14 
-- Criteria for Yassin to verify that Syspro stockcodes have an up-to-date [DrawOfficeNum].


SELECT
	[AS].[SupShortName],
	*
FROM (
	SELECT
		[IM].[StockCode]
		,[IM].[DrawOfficeNum]
		, COUNT(*) AS [Freq]
	FROM
		[SysproCompanyA].[dbo].[InvMaster] [IM]
	WHERE
		([IM].[StockCode] <> [IM].[DrawOfficeNum])
		--AND ([IM].[ProductClass] = '40')
		AND ([IM].[Planner] IN ('15', '14', '13','10', '7', '6', '5', '2'))
		AND (ISNULL([IM].[DrawOfficeNum], '') <> '')
		AND ([DrawOfficeNum] <> 'BF')
	GROUP BY
		[IM].[StockCode]
		,[IM].[DrawOfficeNum]
) AS [Src]
INNER JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM]
ON
	[Src].[StockCode] = [IM].[StockCode]
INNER JOIN
	[SysproCompanyA].[dbo].[ApSupplier] [AS]
ON
	[IM].[Supplier] = [AS].[Supplier]
WHERE
	[IM].[StockCode] = '402471'
ORDER BY
	[IM].[StockCode]