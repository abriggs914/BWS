USE SysproCompanyA
GO

DECLARE @wo VARCHAR(20) = '10017228'

;WITH OrdersCTE AS (
    SELECT Quote#
        , WO#
        , ProductID
        , DealerID
        , [Decline/Rejected]
    FROM
        [BWSdb].[dbo].[Orders] WITH (NOLOCK)
),
WipJobAllMatCTE AS (
    SELECT Job
        , StockCode
        , StockDescription
        , [Line]
        , OperationOffset
        , QtyIssued
        , UnitCost
        , ValueIssued
        , ValueBilled
        , AllocCompleted
        , Warehouse
    FROM
        [SysproCompanyA].[dbo].[WipJobAllMat] WITH (NOLOCK)
),
WipJobPostCTE AS (
    SELECT Job
        , MStockCode
        , MAX(TrnDate) as [TrnDate]
    FROM
        [SysproCompanyA].[dbo].[WipJobPost] WITH (NOLOCK)
    GROUP BY
        Job
        , MStockCode
),
ProductsCTE AS (
    SELECT IDTrailer
        , [Model No]
    FROM
        [BWSdb].[dbo].[Products] WITH (NOLOCK)
),
DealersCTE AS (
    SELECT ID
        , [COMPANY NAME]
    FROM
        [BWSdb].[dbo].[Dealers] WITH (NOLOCK)
),
ProductionCTE AS (
    SELECT [WO#]
        , [Prod Date]
        , [Prod Date2]
    FROM
        [BWSdb].[dbo].[Production] WITH (NOLOCK)
),
InvMasterCTE AS (
    SELECT StockCode
        , WarehouseToUse
    FROM
        [SysproCompanyA].[dbo].[InvMaster] WITH (NOLOCK)
),
InvWarehouseCTE AS (
    SELECT StockCode
        , Warehouse
        , DefaultBin
        , UnitCost
    FROM
        [SysproCompanyA].[dbo].[InvWarehouse] WITH (NOLOCK)
),
WipJobAllLabCTE AS (
    SELECT Job
        , Operation
        , PlannedStartDate
    FROM
        [SysproCompanyA].[dbo].[WipJobAllLab] WITH (NOLOCK)
),
WipMasterCTE AS (
    SELECT Job
        , StockCode
        , JobDeliveryDate
        , JobClassification
    FROM
        [SysproCompanyA].[dbo].[WipMaster] WITH (NOLOCK)
),
BomStructureCTE AS (
    SELECT ParentPart
        , Component
        , OperationOffset
        , QtyPer
    FROM
        [SysproCompanyA].[dbo].[BomStructure] WITH (NOLOCK)
)
select ISNULL(PR.[Prod Date], PR.[Prod Date2]) AS [DateProduction],
    O.[WO#],
    O.[Quote#],
    P.[Model No],
    D.[COMPANY NAME],
    JM.[StockCode],
    JM.[StockDescription],
    JM.[OperationOffset],
    JM.[QtyIssued],
    JM.[UnitCost],
    JM.[ValueIssued],
    JM.[ValueBilled],
    CASE WHEN ISNULL(JM.[AllocCompleted], 'N') = 'Y' THEN 1 ELSE 0 END AS [Complete],
    JP.[TrnDate],
    IM.[WarehouseToUse],
    IW.[DefaultBin],
    JL.[PlannedStartDate],
    ISNULL(SubJobs_Level2.[SubJobClassification], 'BOM') AS [Sub/BOM_Level2Check],
    SubJobs_Level2.[SubJob] AS [SubJob_Level2],
    SubJobs_Level2.[SubJobDeliveryDate] AS [SubJobDeliveryDate_Level2],
    SubJM_Level2.[StockCode] AS [SubStockCode_Level2],
    SubJM_Level2.[StockDescription] AS [SubStockDescription_Level2],
    SubJM_Level2.[Warehouse] AS [SubWareHouse_Level2],
    SubJM_Level2.[QtyIssued] AS [SubQtyIssued_Level2],
    SubJM_Level2.[UnitCost] AS [SubUnitCost_Level2],
    SubJM_Level2.[ValueIssued] AS [SubValueIssued_Level2],
    SubJM_Level2.[ValueBilled] AS [SubValueBilled_Level2],
    CASE WHEN ISNULL(SubJM_Level2.[AllocCompleted], 'N') = 'Y' THEN 1 ELSE 0 END AS [SubAllocCompleted_Level2],
    SubIM_Level2.[WarehouseToUse] AS [SubWarehouseToUse_Level2],
    SubIW_Level2.[DefaultBin] AS [SubDefaultBin_Level2],
    SubBOM_Level2.[Component] AS [SubBOMComponent_Level2],
    SubBOM_Level2.[OperationOffset] AS [SubBOMOperationOffset_Level2],
    SubBOM_Level2.[QtyPer] AS [SubBOMQtyPer_Level2],
    SubBOMIW_Level2.[UnitCost] AS [SubBOMIW_UnitCost_Level2],
    SubBOM_Level2.[QtyPer] * SubBOMIW_Level2.[UnitCost] AS [SubBOMValueRequired_Level2],
    SubBOMIM_Level2.[WarehouseToUse] AS [SubBOMWarehouseToUse_Level2],
    SubBOMIW_Level2.[DefaultBin] AS [SubBOMDefaultBin_Level2],
    ISNULL(SubJobs_Level3.[SubJobClassification], 'BOM') AS [Sub/BOM_Level3Check],
    SubJobs_Level3.[SubJob] AS [SubJob_Level3],
    SubJobs_Level3.[SubJobDeliveryDate] AS [SubJobDeliveryDate_Level3],
    SubJM_Level3.[StockCode] AS [SubStockCode_Level3],
    SubJM_Level3.[StockDescription] AS [SubStockDescription_Level3],
    SubJM_Level3.[Warehouse] AS [SubWareHouse_Level3],
    SubJM_Level3.[QtyIssued] AS [SubQtyIssued_Level3],
    SubJM_Level3.[UnitCost] AS [SubUnitCost_Level3],
    SubJM_Level3.[ValueIssued] AS [SubValueIssued_Level3],
    SubJM_Level3.[ValueBilled] AS [SubValueBilled_Level3],
    CASE WHEN ISNULL(SubJM_Level3.[AllocCompleted], 'N') = 'Y' THEN 1 ELSE 0 END AS [SubAllocCompleted_Level3],
    SubIM_Level3.[WarehouseToUse] AS [SubWarehouseToUse_Level3],
    SubIW_Level3.[DefaultBin] AS [SubDefaultBin_Level3],
    SubBOM_Level3.[Component] AS [SubBOMComponent_Level3],
    SubBOM_Level3.[OperationOffset] AS [SubBOMOperationOffset_Level3],
    SubBOM_Level3.[QtyPer] AS [SubBOMQtyPer_Level3],
    SubBOMIW_Level3.[UnitCost] AS [SubBOMIW_UnitCost_Level3],
    SubBOM_Level3.[QtyPer] * SubBOMIW_Level3.[UnitCost] AS [SubBOMValueRequired_Level3],
    SubBOMIM_Level3.[WarehouseToUse] AS [SubBOMWarehouseToUse_Level3],
    SubBOMIW_Level3.[DefaultBin] AS [SubBOMDefaultBin_Level3]
FROM
    OrdersCTE AS O
INNER JOIN
    WipJobAllMatCTE AS JM
ON
    CAST(O.[WO#] AS NVARCHAR(250)) = JM.[Job]
LEFT JOIN
    WipJobPostCTE AS JP
ON
    JM.[Job] = JP.[Job]
    AND JM.[StockCode] = JP.[MStockCode]
INNER JOIN
    ProductsCTE AS P
ON
    O.[ProductID] = P.[IDTrailer]
INNER JOIN
    DealersCTE AS D
ON
    O.[DealerID] = D.[ID]
LEFT JOIN
    ProductionCTE AS PR
ON
    O.[WO#] = PR.[WO#]
LEFT JOIN
    InvMasterCTE AS IM
ON
    JM.[StockCode] = IM.[StockCode]
LEFT JOIN
    InvWarehouseCTE AS IW
ON
    IM.StockCode = IW.StockCode
    AND IM.[WarehouseToUse] = IW.[Warehouse]
LEFT JOIN
    WipJobAllLabCTE AS JL
ON
    JM.Job = JL.Job AND JM.OperationOffset = JL.Operation
LEFT JOIN
    (
        select *
        FROM
            (
                select WipJobAllMatCTE.Job
                    , WipJobAllMatCTE.StockCode
                    , WipJobAllMatCTE.OperationOffset
                    , SubJobs.Job as [SubJob]
                    , SubJobs.JobClassification as [SubJobClassification]
                    , SubJobs.JobDeliveryDate as [SubJobDeliveryDate]
                    , ROW_NUMBER() OVER (
                                            PARTITION BY WipJobAllMatCTE.Job, WipJobAllMatCTE.StockCode, WipJobAllMatCTE.OperationOffset
                                            ORDER BY SubJobs.JobDeliveryDate DESC
                                        ) as LastSubJobID
                from
                    WipJobAllMatCTE
                INNER JOIN
                    WipJobAllLabCTE
                ON
                    WipJobAllMatCTE.Job = WipJobAllLabCTE.Job
                    AND WipJobAllMatCTE.OperationOffset = WipJobAllLabCTE.Operation
                LEFT JOIN
                    WipMasterCTE [SubJobs]
                ON
                    WipJobAllMatCTE.StockCode = SubJobs.StockCode
                    and WipJobAllLabCTE.PlannedStartDate >= SubJobs.JobDeliveryDate
            ) as mainsub
        WHERE
            LastSubJobID = 1
    ) as SubJobs_Level2
ON
    [JM].Job = SubJobs_Level2.Job
    AND [JM].StockCode = SubJobs_Level2.StockCode
    AND [JL].Operation = SubJobs_Level2.OperationOffset
LEFT JOIN
    WipJobAllMatCTE AS SubJM_Level2
ON
    SubJobs_Level2.SubJob = SubJM_Level2.Job
LEFT JOIN
    WipJobAllLabCTE AS SubJL_Level2
ON
    SubJM_Level2.Job = SubJL_Level2.Job
    AND SubJM_Level2.OperationOffset = SubJL_Level2.Operation
LEFT JOIN
    InvMasterCTE AS SubIM_Level2
ON
    SubJM_Level2.StockCode = SubIM_Level2.StockCode
LEFT JOIN
    InvWarehouseCTE AS SubIW_Level2
ON
    SubIM_Level2.StockCode = SubIW_Level2.StockCode
    AND SubIM_Level2.[WarehouseToUse] = SubIW_Level2.[Warehouse]
LEFT JOIN
    BomStructureCTE AS SubBOM_Level2
ON
    JM.[StockCode] = SubBOM_Level2.[ParentPart]
LEFT JOIN
    InvMasterCTE AS SubBOMIM_Level2
ON
    SubBOM_Level2.[Component] = SubBOMIM_Level2.[StockCode]
LEFT JOIN
    InvWarehouseCTE AS SubBOMIW_Level2
ON
    SubBOMIM_Level2.StockCode = SubBOMIW_Level2.StockCode
    AND SubBOMIM_Level2.[WarehouseToUse] = SubBOMIW_Level2.[Warehouse]
LEFT JOIN
    (
        select *
        FROM
            (
                select WipJobAllMatCTE.Job
                    , WipJobAllMatCTE.StockCode
                    , WipJobAllMatCTE.OperationOffset
                    , SubJobs.Job as [SubJob]
                    , SubJobs.JobClassification as [SubJobClassification]
                    , SubJobs.JobDeliveryDate as [SubJobDeliveryDate]
                    , ROW_NUMBER() OVER (
                                            PARTITION BY WipJobAllMatCTE.Job, WipJobAllMatCTE.StockCode, WipJobAllMatCTE.OperationOffset
                                            ORDER BY SubJobs.JobDeliveryDate DESC
                                        ) as LastSubJobID
                from
                    WipJobAllMatCTE
                INNER JOIN
                    WipJobAllLabCTE
                ON
                    WipJobAllMatCTE.Job = WipJobAllLabCTE.Job
                    AND WipJobAllMatCTE.OperationOffset = WipJobAllLabCTE.Operation
                LEFT JOIN
                    WipMasterCTE [SubJobs]
                ON
                    WipJobAllMatCTE.StockCode = SubJobs.StockCode
                    and WipJobAllLabCTE.PlannedStartDate >= SubJobs.JobDeliveryDate
            ) as mainsub
        WHERE
            LastSubJobID = 1
    ) as SubJobs_Level3
ON
    [SubJM_Level2].Job = SubJobs_Level3.Job
    AND [SubJM_Level2].StockCode = SubJobs_Level3.StockCode
    AND [SubJL_Level2].Operation = SubJobs_Level3.OperationOffset
LEFT JOIN
    WipJobAllMatCTE AS SubJM_Level3
ON
    SubJobs_Level3.SubJob = SubJM_Level3.Job
LEFT JOIN
    WipJobAllLabCTE AS SubJL_Level3
ON
    SubJM_Level3.Job = SubJL_Level3.Job
    AND SubJM_Level3.OperationOffset = SubJL_Level3.Operation
LEFT JOIN
    InvMasterCTE AS SubIM_Level3
ON
    SubJM_Level3.StockCode = SubIM_Level3.StockCode
LEFT JOIN
    InvWarehouseCTE AS SubIW_Level3
ON
    SubIM_Level3.StockCode = SubIW_Level3.StockCode
    AND SubIM_Level3.[WarehouseToUse] = SubIW_Level3.[Warehouse]
LEFT JOIN
    BomStructureCTE AS SubBOM_Level3
ON
    SubBOM_Level2.Component = SubBOM_Level3.[ParentPart]
LEFT JOIN
    InvMasterCTE AS SubBOMIM_Level3
ON
    SubBOM_Level3.Component = SubBOMIM_Level3.StockCode
LEFT JOIN
    InvWarehouseCTE AS SubBOMIW_Level3
ON
    SubBOMIM_Level3.StockCode = SubBOMIW_Level3.StockCode
    AND SubBOMIM_Level3.[WarehouseToUse] = SubBOMIW_Level3.[Warehouse]
WHERE
    [JM].Job = @wo; 