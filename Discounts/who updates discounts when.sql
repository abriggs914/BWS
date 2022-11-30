
-- Who updates discounts when

SELECT
	*
FROM
	[Discounts]
INNER JOIN
	[Products]
ON
	[Discounts].[ProductID] = [Products].[IDTrailer]
ORDER BY
 [LastUpdated] DESC
--WHERE
	--[Discounts].[Slot] <> 1 OR [Market] <> 1
	--[Active] = 1