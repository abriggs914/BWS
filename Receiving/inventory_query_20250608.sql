SELECT TOP 8000

	*
FROM
	[SysproCompanyA].[dbo].[InvMaster] [IM]
INNER JOIN
	[SysproCompanyA].[dbo].[InvWarehouse] [IW]
ON
	[IM].[StockCode] = [IW].[StockCode]

WHERE
	[IM].[StockCode] = '07128'