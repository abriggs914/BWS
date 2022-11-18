
BEGIN TRAN
INSERT INTO [Order Discounts]
([Active], [Quote], [DefaultDiscount], [UseDefaultDiscount])
SELECT
	1
	, [Orders].[Quote#]
	, [Discounts].[ID]
	, 1
FROM
	[Orders]
LEFT JOIN
	[Discounts]
ON
	[Orders].[DealerID] = [Discounts].[DealerID]
	AND [Orders].[ProductID] = [Discounts].[ProductID]

ROLLBACK;
COMMIT;