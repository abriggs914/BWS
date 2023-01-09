 USE BWSdb
GO

SELECT
	[Class]
	, [Model No]
	, [IDTrailer]
FROM
	[Products]
WHERE
	[Proposed] = 0 AND [Non-Current] = 0
;

SELECT
	[Class]
	, [Model No]
	, [IDTrailer]
FROM
	[ProductsV2]
WHERE
	[Proposed] = 0 AND [Non-Current] = 0
;

SELECT
	[ID]
	, [COMPANY NAME]
FROM
	[Dealers]
WHERE
	[CURRENT DEALER] = 1
;

SELECT
	[ID]
	, [COMPANY NAME]
FROM
	[DealersV2]
WHERE
	[CURRENT DEALER] = 1
;

SELECT
	*
FROM
	[Orders]
;

SELECT
	*
FROM
	[OrdersV2]
;

SELECT
	[Class]
	, [Model No]
	, [IDTrailer]
	, [ID]
	, [COMPANY NAME]
	, 0 AS [Slot]
	, 0 AS [Market]
	, 'LastUpdatedBy' AS [LastUpdatedBy]
	, GETDATE() AS [Last Updated]
FROM
	[Products]
CROSS JOIN
	[Dealers]
WHERE
	[Proposed] = 0 
	AND [Non-Current] = 0
	AND [CURRENT DEALER] = 1
ORDER BY
	[COMPANY NAME]
	, [Class]
	, [Model No]
;

SELECT * FROM [Discounts]
SELECT * FROM [Order Discounts]


DECLARE @quote AS INT;
SELECT @quote = 28362;

SELECT
	[Orders].[Quote#]
	, [COMPANY NAME]
	, [Model No]
	, ISNULL((CASE WHEN [UseDefaultDiscount] = 1 THEN [Slot] ELSE [SlotOverride] END), 0) AS [Slot]
	, ISNULL((CASE WHEN [UseDefaultDiscount] = 1 THEN [Market] ELSE [MarketOverride] END), 0) AS [Market]
FROM
	[Orders]
INNER JOIN
	[Order Discounts]
ON
	[Orders].[DiscountID] = [Order Discounts].[ID]
INNER JOIN
	[Discounts]
ON
	[Order Discounts].[DefaultDiscount] = [Discounts].[ID]
LEFT JOIN
	[Dealers]
ON
	[Discounts].[DealerID] = [Dealers].[ID]
WHERE
	[Quote#] = @quote;


EXEC [sp_CalcDiscount] @quote=27451