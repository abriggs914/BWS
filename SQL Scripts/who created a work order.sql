USe SysproCompanyA
GO

SELECT TOP 500 * FROM [WipMaster] WITH (NOLOCK)
SELECT TOP 500 * FROM [WipJobAllMat] WITH (NOLOCK)
SELECT TOP 500 * FROM [WipJobAmendJnl] WITH (NOLOCK)



SELECT 
	*
FROM 
	[WipJobAmendJnl] WITH (NOLOCK)
WHERE
	(LOWER([Job]) = '70004056' OR LOWER([Job]) = '70004256')
	AND [ChangeFlag] = 'A'
	AND [TableName] = 'WipMaster'