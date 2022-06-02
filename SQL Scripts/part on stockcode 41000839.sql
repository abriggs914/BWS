USE SysproCompanyA
GO

--SELECT 
--	*
--FROM
--	[InvMastAmendJnl] 
--WHERE
--	[StockCode] = '41000839'

SELECT 
	*
FROM
	[WipLabJnl] 
WHERE
	[StockCode] = '41000839'
	OR [Job] = '10015571'

SELECT 
	*
FROM
	[WipJobAmendJnl]
WHERE
	[StockCode] = '41000839'