DECLARE @q AS NVARCHAR(MAX) = 'SG101135';


SELECT Class, Model, [Model No], Price FROM ProductsV2 
WHERE Class='B-Trains' AND CompanyID=1
;

SELECT Class, Model, [ProductsV2].[Model No], [ProductsV2].[Price] FROM ProductsV2 
INNER JOIN [OrdersV2] ON [ProductsV2].[Model No] = [OrdersV2].[Model No]
WHERE Class='B-Trains' AND [ProductsV2].[CompanyID]=1
;

SELECT
	* 
FROM (
	SELECT
		[OrdersV2].[Model No]
		, [Class]
	FROM
		[OrdersV2]
	INNER JOIN
		[ProductsV2]
	ON
		[OrdersV2].[Model No] = [ProductsV2].[Model No]
	WHERE
		[SGQuote] = @q
) AS [SubA]
INNER JOIN
	[ProductsV2]
ON
	[SubA].[Class] = [ProductsV2].[Class]
;

SELECT
	* 
FROM (
	SELECT
		[OrdersV2].[Model No]
		, [Class]
	FROM
		[OrdersV2]
	INNER JOIN
		[ProductsV2]
	ON
		[OrdersV2].[Model No] = [ProductsV2].[Model No]
	WHERE
		[SGQuote] = @q
) AS [SubA]
INNER JOIN
	[ProductsV2]
ON
	[SubA].[Class] = [ProductsV2].[Class]
;


SELECT
	[ProductsV2].Class,
	[ProductsV2].Model,
	[ProductsV2].[Model No],
	[ProductsV2].Price
FROM
	[ProductsV2]
CROSS JOIN
	[OrdersV2]
WHERE
	[OrdersV2].[SGQuote] = @q
	--AND [OrdersV2].[Model No] = [ProductsV2].[Model No]
;


SELECT
	[ProductsV2].Class,
	[ProductsV2].Model,
	[ProductsV2].[Model No],
	[ProductsV2].Price
	,[IDTrailer]
FROM
	[ProductsV2]
INNER JOIN (
	SELECT
		[ProductsV2].Class
		, [OrdersV2].[ProductID]
	FROM 
		[OrdersV2]
	INNER JOIN
		[ProductsV2]
	ON
		[OrdersV2].[ProductID] = [ProductsV2].[IDTrailer]
	WHERE
		[SGQuote] = 'SG101135'
) AS [SrcA]
ON
	[ProductsV2].[Class] = [SrcA].[Class]
;


--SELECT
--	* 
--FROM
--	[ProductsV2]
--WHERE
--	[Class] = 