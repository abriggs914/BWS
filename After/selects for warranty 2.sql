
DECLARE @war_wo NVARCHAR(8) = '2304'
IF LEN(@war_wo) <> 8 BEGIN
	SET @war_wo = '3' + RIGHT('00000000' + SUBSTRING(ISNULL(@war_wo, ' '), 1, (CASE WHEN LEN(ISNULL(@war_wo, ' ')) < 5 THEN LEN(ISNULL(@war_wo, ' ')) ELSE 5 END)), 7)
END

SELECT @war_wo = '7304'

SELECT
	*
FROM
	[BWSdb].[dbo].[Warranty Claims] [WC]
WHERE
	(([Claim Number] = 7304)
	OR ([Claim Number] = 7305))
	OR (
		([WO#] = 10017287)
		OR ([WO#] = 30002304)
	)
;

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[WipMaster] [WM]
WHERE
	[WM].[Job] = @war_wo
;

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[WipJobAllMat] [WM]
WHERE
	[WM].[Job] = @war_wo
;

SELECT
	[WM].[Job],
	[WM].[JobDescription],
	--[WM].[StockCode],
	--[WM].[StockDescription],
	--[WM].[QtyToMake],
	[WJM].[StockCode],
	[WJM].[StockDescription],
	[WJM].[QtyIssued],
	[WJM].[QtyToIssue],
	[WC].[Claim Date],
	[WC].[Claim Number],
	[WC].[BWS Invoice #],
	[WC].[WO#],
	[WC].[Customer],
	[WC].[Dealer],
	[WC].[S/N]
	
	,*
FROM
	[BWSdb].[dbo].[Warranty Claims] [WC]
LEFT JOIN
	[SysproCompanyA].[dbo].[WipMaster] [WM]
ON
	LOWER([WM].[JobDescription]) LIKE '%' + LOWER([WC].[WO#]) + '%'
	--AND LOWER([WM].[JobDescription]) LIKE '%' + LOWER([WC].[Claim Number]) + '%'
LEFT JOIN
	[SysproCompanyA].[dbo].[WipJobAllMat] [WJM]
ON
	--(CAST([WC].[WO#] AS NVARCHAR(MAX)) = [WJM].[Job] COLLATE DATABASE_DEFAULT)
	--AND
	([WM].[Job] = [WJM].[Job])
WHERE
	CAST([WC].[Claim Number] AS NVARCHAR(MAX)) = @war_wo
	