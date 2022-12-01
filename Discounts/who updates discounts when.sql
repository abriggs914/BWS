
-- Who updates discounts when

SELECT
[COMPANY NAME]
,	*
FROM
	[Discounts]
INNER JOIN
	[Products]
ON
	[Discounts].[ProductID] = [Products].[IDTrailer]
LEFT JOIN
	[Dealers]ON
	 [Discounts].[DealerID] = [Dealers].[ID]
ORDER BY
 [LastUpdated] DESC
--WHERE
	--[Discounts].[Slot] <> 1 OR [Market] <> 1
	--[Active] = 1