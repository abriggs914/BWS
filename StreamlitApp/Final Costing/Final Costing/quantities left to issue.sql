DECLARE @wo NVARCHAR(MAX) = '10017258';


SELECT
	[Src].[StockCode]
	,[Src].[UnitCost]
	,[Src].[UnitQtyReqd]
	,[Src].[ValueIssued]
	,[Src].[ValueRequired] - [Src].[ValueIssued] AS [ValueLeftToIssue]
	,([Src].[ValueRequired] - [Src].[ValueIssued]) / (CASE WHEN [QtyLeftToIssue] = 0 THEN 1 ELSE [QtyLeftToIssue] END) AS [ValueLeftToIssuePerPart]
	,[Src].*
FROM (
	SELECT
		([Mat].[UnitCost] * [Mat].[UnitQtyReqd]) AS [ValueRequired]
		,([Mat].[UnitQtyReqd] - [Mat].[QtyIssued]) AS [QtyLeftToIssue]
		,*
	FROM
		[SysproCompanyA].[dbo].[WipJobAllMat] [Mat] WITH (NOLOCK)
	/*WHERE
		(ISNULL([Mat].[QtyIssued], 0) = 0)
		AND ([Job] = @wo)*/
) AS [Src]
ORDER BY
	[ValueLeftToIssue] DESC

SELECT
	[Src].[ValueRequired] - [Src].[ValueIssued] AS [ValueLeftToIssue]
	,([Src].[ValueRequired] - [Src].[ValueIssued]) / (CASE WHEN [QtyLeftToIssue] = 0 THEN 1 ELSE [QtyLeftToIssue] END) AS [ValueLeftToIssuePerPart]
	,[Src].*
FROM (
	SELECT
		([Mat].[UnitCost] * [Mat].[UnitQtyReqd]) AS [ValueRequired]
		,([Mat].[UnitQtyReqd] - [Mat].[QtyIssued]) AS [QtyLeftToIssue]
		,*
	FROM
		[SysproCompanyA].[dbo].[WipJobAllMat] [Mat] WITH (NOLOCK)
	WHERE
		LEFT([Job], 1) = '1'
		AND (LEN([Job]) = 8)
		AND (([Mat].[Warehouse] = '01')
		OR ([Mat].[Warehouse] = '02'))
) AS [Src]