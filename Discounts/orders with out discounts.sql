USE BWSdb
GO


-- Orders without discounts
SELECT 
	*
FROM
	[Orders]
LEFT JOIN
	[Order Discounts]
ON
	[Orders].[Quote#] = [Order Discounts].[Quote]
WHERE
	[Order Discounts].[Quote] IS NULL
;



