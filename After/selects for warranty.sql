-- 2026-02-05
-- Selects for Warranty

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[WipJobAllMat] [WJM]
WHERE
	RIGHT([WJM].[Job], 4) IN ('7304', '7305')
	AND LEFT([WJM].[Job], 1) <> '1'

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[WipMaster] [WJM]
WHERE
	RIGHT([WJM].[Job], 4) IN ('7304', '7305', '2304')
	AND LEFT([WJM].[Job], 1) <> '1'

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[InvMaster] [IM]
WHERE
	[IM].[StockCode] = '40957798'

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[WipMaster] [IM]
WHERE
	[IM].[StockCode] = '40957798'


