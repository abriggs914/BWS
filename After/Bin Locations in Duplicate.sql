
-- Bin Locations in Duplicate
-- 2025-12-3

WITH BinCounts AS (
SELECT
	[IW].[DefaultBin],
	COUNT(*) AS [NumItems],
	SUM([IW].[QtyOnHand] * [IW].[LastCostEntered]) AS [TtlItemValue],
	(CASE WHEN 
		LOWER([IW].[DefaultBin]) LIKE '%wh4%'
	THEN
		2 -- Montana Only
	WHEN
		LOWER([IW].[DefaultBin]) LIKE '%@%'
	THEN 
		0 -- Both
	ELSE
		1 -- Hawkins Only
	END) AS [BuildingCode],
	(CASE WHEN 
		LOWER([IW].[DefaultBin]) LIKE '%/%'
	THEN
		1 -- Slash divides bins
	WHEN
		LOWER([IW].[DefaultBin]) LIKE '%@%'
	THEN 
		1 -- @ denotes same bin in another building
	ELSE
		0 -- Only 1 noted
	END) AS [HasMultipleBins]
FROM
	[SysproCompanyA].[dbo].[InvWarehouse] [IW]
GROUP BY
	[IW].[DefaultBin]
)
	SELECT
    BC1.DefaultBin,
    BC2.DefaultBin AS BinLike,
    BC1.NumItems,
    BC1.TtlItemValue,
    BC1.BuildingCode,
    BC1.HasMultipleBins
FROM 
    BinCounts AS BC1
    LEFT JOIN BinCounts AS BC2
        ON  REPLACE(LOWER(BC1.DefaultBin), ' ', '') =
            REPLACE(LOWER(BC2.DefaultBin), ' ', '')
        AND LOWER(BC1.DefaultBin) <> LOWER(BC2.DefaultBin)
ORDER BY
    BC1.DefaultBin,
    BC2.DefaultBin;