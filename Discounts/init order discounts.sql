
BEGIN TRAN
--INSERT INTO [Order Discounts]
--([Active], [Quote], [DefaultDiscount], [UseDefaultDiscount])
UPDATE
	[Orders]
SET
	[DiscountID] = [Order Discounts].[ID]
	, [DiscountSetBy] = 'Avery Briggs'
	, [DiscountSetDate] = GETDATE()
FROM
	[Orders]
INNER JOIN
	[Order Discounts]
ON
	[Orders].[Quote#] = [Order Discounts].[Quote]
	--AND [Orders].[DealerID] = [Discounts].[DealerID]

SELECT * FROM [Orders]

ROLLBACK;
COMMIT;