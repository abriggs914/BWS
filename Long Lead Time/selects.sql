USE Stargatedb
GO


SELECT
	*
FROM
	[LongLeadQuoteDetails] AS [A]
INNER JOIN
	[LongLeadQuoteMaster] AS [B]
ON
	[A].[LongLeadQuoteID#] = [B].[LongLeadQuoteID#]
INNER JOIN
	[LongLeadQuotePartClass] AS [C]
ON
	[A].[PartClassID] = [C].[PartClassID]
ORDER BY
	[A].[LastUpdated] DESC


SELECT
	InvMaster.StockCode,
	InvMaster.Description,
	InvMaster.[LongDesc]
FROM
	[SysproCompanyS].[dbo].[InvMaster]
ORDER BY
	InvMaster.StockCode; 