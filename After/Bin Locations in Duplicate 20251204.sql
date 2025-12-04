DECLARE @bin NVARCHAR(MAX) = 'F36F';
DECLARE @exact BIT = 0;
DECLARE @hasNonZeroOnHand BIT = 1;

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[InvWarehouse] [IW]
WHERE
	(CASE WHEN ISNULL(@exact, 0) = 0 THEN (CASE WHEN ((LOWER([IW].[DefaultBin]) LIKE '%' + LOWER(@bin) + '%')
	OR (LOWER(@bin) LIKE '%' + LOWER([IW].[DefaultBin]) + '%')) THEN 1 ELSE 0 END) ELSE (
	CASE WHEN LOWER([IW].[DefaultBin]) = LOWER(@bin) THEN 1 ELSE 0 END) END) > 0
	AND (ISNULL([IW].[DefaultBin], '') <> '')
	AND ((CASE WHEN (@hasNonZeroOnHand = 1) THEN (CASE WHEN [IW].[QtyOnHand] > 0 THEN 1 ELSE 0 END) ELSE 1 END) > 0)


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