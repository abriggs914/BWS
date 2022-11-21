SELECT * FROM [v_Dealer Status Report 2] WHERE [Quote#] = 27545


SELECT
	[Quote#]
FROM
	[v_Dealer Status Report 2]
GROUP BY
	[Quote#]
HAVING 
	COUNT(*) > 1
ORDER BY
	[Quote#]


SELECT [Invoice Date] FROM dbo.Orders with (nolock) WHERE [Quote#] = 27545
SELECT [Invoice Date] FROM dbo.[v_Orders Raw Pricing] with (nolock) WHERE [Quote#] = 27545
SELECT * FROM dbo.Customers with (nolock) WHERE [Quote#] = 27545
SELECT * FROM dbo.Production with (nolock) WHERE [Quote#] = 27545

SELECT * FROM dbo.Products with (nolock) WHERE [Quote#] = 27545
SELECT * FROM dbo.[Payment Terms] with (nolock) WHERE [Quote#] = 27545
SELECT * FROM SysproCompanyA.dbo.v_CompletedJobInfo with (nolock)  WHERE [Quote#] = 27545
SELECT * FROM dbo.BOL with (nolock) WHERE [Quote#] = 27545
SELECT * FROM OrdersV2 with (nolock) WHERE [Quote#] = 27545
SELECT * FROM ProductsV2 with (nolock) WHERE [Quote#] = 27545