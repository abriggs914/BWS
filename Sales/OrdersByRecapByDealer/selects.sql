USE BWSdb
GO


SELECT * FROM [BWSdb].[dbo].[v_Quote Raw Pricing V2]
ORDER BY [COMPANY NAME]

SELECT * FROM [DealersV2] WHERE [COMPANY NAME] LIKE '%r.r%' ORDER BY [COMPANY NAME] 
SELECT * FROM [DealersV2] WHERE [COMPANY NAME] LIKE '%r.r%' ORDER BY [COMPANY NAME] 
SELECT * FROM [DealersV2] WHERE [COMPANY NAME] = 'R.R. Charlesbois Inc'

SELECT * FROM [SysproCompanyS].[dbo].[GenControl]
SELECT * FROM [v_Quote Raw Pricing]
SELECT * FROM [BWSdb].[dbo].[v_Quote Raw Pricing]
SELECT * FROM [BWSdb].[dbo].[v_Quote Raw Pricing V2]
SELECT * FROM [Stargatedb].[dbo].[v_Quote Raw Pricing V2]
SELECT * FROM [BWSdb].[dbo].[Budget Forecast V2]
SELECT * FROM [SysproCompanyA].[dbo].[v_Quote Raw Pricing V2]
SELECT * FROM [SysproCompanyS].[dbo].[v_Quote Raw Pricing V2]

DECLARE @True AS BIT = 1;
DECLARE @False AS BIT = 0;

SELECT * FROM [BWSdb].[dbo].[ProductsV2] WHERE [CompanyID] = 1
SELECT [Grouping] FROM [BWSdb].[dbo].[ProductsV2] WHERE [CompanyID] = 1 GROUP BY [Grouping] ORDER BY [Grouping]
SELECT [Grouping], [Class], [Model No] FROM [BWSdb].[dbo].[ProductsV2] WHERE [CompanyID] = 1 GROUP BY [Grouping], [Class], [Model No] ORDER BY [Model No]
SELECT * FROM [BWSdb].[dbo].[ProductsV2] WHERE [Model No] LIKE 'PB17'

SELECT TOP 25 * FROM [Products]
USE BWSdb
GO
SELECT * FROM [Dealers] WHERE [COMPANY NAME] LIKE '%arkel%' ORDER BY [COMPANY NAME] 
SELECT * FROM [DealersV2] WHERE [COMPANY NAME] LIKE '%arkel%' ORDER BY [COMPANY NAME] 
SELECT * FROM [Products] WHERE [Model No] LIKE '20%'
SELECT * FROM [BWSdb].[dbo].[ProductsV2] WHERE [Model No] LIKE 'PB17'
SELECT * FROM [StandardsV2] WHERE [Model No] LIKE 'PB17'



SELECT 
	Products.Class,
	Products.[Model No]
From
	Products
where (
	((Products.Class) = 'Tags')
	And ((Products.CompanyID) = 0)
	And ((Products.[Non-Current]) = 0)
	And ((Products.Proposed) = 0)
	And ((Products.Customer) = 0))
ORDER BY
	Products.[Model No];


SELECT 
	[Products].[Class],
	[Products].[Model No]
FROM
	[Products] 
WHERE
	(
		(([Products].[Class]) = 'Tags')
		AND (([Products].[CompanyID]) = 0)
		AND (([Products].[Non-Current]) = @True)
		AND (([Products].[Proposed]) = @True)
		AND (([Products].[Customer]) = @True)
	)
ORDER BY
	[Products].[Model No];


SELECT 
	[Products].[Class],
	[Products].[Model No]
FROM
	[Products]
WHERE (
	(([Products].[Class]) = 'Tags')
	AND (([Products].[CompanyID]) = 0)
	AND (([Products].[Non-Current]) = @False)
	AND (([Products].[Proposed]) = @False)
	AND (([Products].[Customer]) = @False)
)
ORDER BY
	[Products].[Model No];



SELECT
	[Products].[Class],
	[Products].[Model No]
FROM 
	[Products] 
WHERE (
	(([Products].[Class]) = 'Tags')
	AND (([Products].[CompanyID]) = 0)
	
	)
	ORDER BY [Products].[Model No];