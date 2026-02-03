SELECT
	--[SD].[NComment],
	*
FROM

/*
	[SysproCompanyA].[dbo].[Sor] [SD] -- 1 Record / SO-Stockcode
WHERE
	[SD].[SalesOrder] = '000000000115674'
*/
/*
	[SysproCompanyA].[dbo].[SorDetail] [SD] -- 1 Record / Line on SO
WHERE
	LTRIM(RTRIM(ISNULL([SD].[NComment], ''))) <> ''
	AND ((
		LOWER([SD].[NComment]) LIKE '%96648193%'
	)
	OR  (
		(
			LOWER([SD].[NComment]) LIKE '%midland%'
		)
		OR (
			LOWER([SD].[NComment]) LIKE '%tracking%'
		)
	)
	)
*/



 [SysproCompanyA].[dbo].[SorMaster] [SD] -- 1 Record / SO
-- [SysproCompanyA].[dbo].[SorAdditions] [SD] -- 1 Record / SO-Stockcode

WHERE
	(LOWER([SD].[CustomerName]) LIKE '%remorques%')
	OR (LOWER([SD].[CustomerName]) LIKE '%services 2r%')
	--OR (LOWER(ISNULL([SD].[CustomerName], '')) +  = '%services 2r%')
ORDER BY
	[SD].[DateLastInvPrt]