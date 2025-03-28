DECLARE @j NVARCHAR(25) = '10011625'
--SELECT @j = '10016235'
SELECT @j = '10016285'
--SELECT @j = '10016724'
--SELECT @j = '10017134'


--SELECT @j = '10017349'
--SELECT @j = '10017228'


SELECT
  ISNULL([PR].[Prod Date], [PR].[Prod Date2]) AS [DateProduction],
  [O].[WO#],
  [O].[Quote#],
  [P].[Model No],
  [D].[COMPANY NAME],
  [JM].[StockCode],
  [JM].[StockDescription],
  [JM].[OperationOffset],
  [JM].[QtyIssued],
  [JM].[UnitCost],
  [JM].[ValueIssued],
  [JM].[ValueBilled],
  (CASE WHEN ISNULL([JM].[AllocCompleted], 'N') = 'Y' THEN 1 ELSE 0 END) AS [Complete],
  [IM].[WarehouseToUse],
  [IW].[DefaultBin],
  [JL].[PlannedStartDate],
  *
 FROM
  [BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
 INNER JOIN
  [SysproCompanyA].[dbo].[WipJobAllMat] [JM] WITH (NOLOCK)
 ON
  CAST([O].[WO#] AS NVARCHAR(250)) = [JM].[Job]
 INNER JOIN
  [BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
 ON
  [O].[ProductID] = [P].[IDTrailer]
 INNER JOIN
  [BWSdb].[dbo].[Dealers] [D] WITH (NOLOCK)
 ON
  [O].[DealerID] = [D].[ID]
 LEFT JOIN
  [BWSdb].[dbo].[Production] [PR] WITH (NOLOCK)
 ON
  [O].[WO#] = [PR].[WO#]
 LEFT JOIN
  [SysproCompanyA].[dbo].[InvMaster] [IM] WITH (NOLOCK)
 ON
  [JM].[StockCode] = [IM].[StockCode]
 LEFT JOIN
  [SysproCompanyA].[dbo].[InvWarehouse] [IW] WITH (NOLOCK)
 ON
  ([IM].StockCode = [IW].StockCode)
  AND ([IM].[WarehouseToUse] = [IW].[Warehouse])
    LEFT JOIN
        [SysproCompanyA].[dbo].[WipJobAllLab] [JL] WITH (NOLOCK)
    ON
        [JM].Job = [JL].Job
        and [JM].OperationOffset = [JL].Operation
 WHERE
  ([O].[WO#] IS NOT NULL)
  AND ([O].[Decline/Rejected] = 4)
	AND (CAST([O].[WO#] AS NVARCHAR(25)) = @j)
;

-- SUBS
SELECT
 [Src].*,
 [JM].[Job],
 [JM].[StockCode] AS [SubStockCode],
 [JM].[StockDescription] AS [SubStockDescription],
 [JM].[Warehouse] AS [SubWareHouse],
 [JM].[QtyIssued] AS [SubQtyIssued],
 [JM].[UnitCost] AS [SubUnitCost],
 [JM].[ValueIssued] AS [SubValueIssued],
 [JM].[ValueBilled] AS [SubValueBilled],
 [JM].[AllocCompleted] AS [SubAllocCompleted],
 [JP].[TrnDate],
 [IM].[WarehouseToUse] AS [SubWarehouseToUse],
 [IW].[DefaultBin] AS [SubDefaultBin],
    [Src].[PlannedStartDate],
    [WM].[JobDeliveryDate] as [SubJobDelivery/FinishDate],
    DATEDIFF(DAY, [Src].[PlannedStartDate], [WM].[JobDeliveryDate]) as [NumDaysDiff],
 *
FROM (
 SELECT
  ISNULL([PR].[Prod Date], [PR].[Prod Date2]) AS [DateProduction],
  [O].[WO#],
  [O].[Quote#],
  [P].[Model No],
  [D].[COMPANY NAME],
  [JM].[StockCode],
  [JM].[StockDescription],
  [JM].[OperationOffset],
  [JM].[QtyIssued],
  [JM].[UnitCost],
  [JM].[ValueIssued],
  [JM].[ValueBilled],
  (CASE WHEN ISNULL([JM].[AllocCompleted], 'N') = 'Y' THEN 1 ELSE 0 END) AS [Complete],
  [IM].[WarehouseToUse],
  [IW].[DefaultBin],
  [JL].[PlannedStartDate]
 FROM
  [BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
 INNER JOIN
  [SysproCompanyA].[dbo].[WipJobAllMat] [JM] WITH (NOLOCK)
 ON
  CAST([O].[WO#] AS NVARCHAR(250)) = [JM].[Job]
 INNER JOIN
  [BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
 ON
  [O].[ProductID] = [P].[IDTrailer]
 INNER JOIN
  [BWSdb].[dbo].[Dealers] [D] WITH (NOLOCK)
 ON
  [O].[DealerID] = [D].[ID]
 LEFT JOIN
  [BWSdb].[dbo].[Production] [PR] WITH (NOLOCK)
 ON
  [O].[WO#] = [PR].[WO#]
 LEFT JOIN
  [SysproCompanyA].[dbo].[InvMaster] [IM] WITH (NOLOCK)
 ON
  [JM].[StockCode] = [IM].[StockCode]
 LEFT JOIN
  [SysproCompanyA].[dbo].[InvWarehouse] [IW] WITH (NOLOCK)
 ON
  ([IM].StockCode = [IW].StockCode)
  AND ([IM].[WarehouseToUse] = [IW].[Warehouse])
    LEFT JOIN
        [SysproCompanyA].[dbo].[WipJobAllLab] [JL] WITH (NOLOCK)
    ON
        [JM].Job = [JL].Job
        and [JM].OperationOffset = [JL].Operation
 WHERE
  ([O].[WO#] IS NOT NULL)
  AND ([O].[Decline/Rejected] = 4)
) AS [Src]
LEFT JOIN
    [SysproCompanyA].[dbo].[WipMaster] [WM]
ON
    ([Src].StockCode = [WM].StockCode)
INNER JOIN
 [SysproCompanyA].[dbo].[WipJobAllMat] [JM]
ON
    [WM].Job = [JM].Job
 -- ([Src].[StockCode] = [JM].[StockCode])
 -- AND ([Src].[OperationOffset] = [JM].[OperationOffset])
LEFT JOIN
 [SysproCompanyA].[dbo].[WipJobPost] [JP]
ON
    [WM].Job = [JP].Job
    and [WM].StockCode = [JP].MStockCode
 -- (CAST([Src].[WO#] AS NVARCHAR(250)) = [JP].[Job])
 -- AND ([JM].[StockCode] = [JP].[MStockCode])
LEFT JOIN
 [SysproCompanyA].[dbo].[InvMaster] [IM] WITH (NOLOCK)
ON
 [JM].[StockCode] = [IM].[StockCode]
LEFT JOIN
 [SysproCompanyA].[dbo].[InvWarehouse] [IW] WITH (NOLOCK)
ON
    ([IM].StockCode = [IW].StockCode)
    AND ([IM].[WarehouseToUse] = [IW].[Warehouse])
LEFT JOIN
    [SysproCompanyA].[dbo].[WipJobAllLab] [JL] WITH (NOLOCK)
ON
    [JM].Job = [JL].Job
    and [JM].OperationOffset = [JL].Operation
WHERE
    (
        [WM].JobClassification = 'SUB'
        or [WM].JobClassification is null
    )
    and [WM].[ActCompleteDate] is null
    and (
        DATEDIFF(DAY, [Src].[PlannedStartDate], [WM].[JobDeliveryDate]) between -30 and 0
        or DATEDIFF(DAY, [Src].[PlannedStartDate], [WM].[JobDeliveryDate]) is null
    )
	AND (CAST([Src].[WO#] AS NVARCHAR(25)) = @j)
;