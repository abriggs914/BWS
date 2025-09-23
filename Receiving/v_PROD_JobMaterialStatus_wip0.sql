SELECT
	*
FROM
	[SysproCompanyA].[dbo].[v_PROD_JobMaterialStatus] [JMS]
WHERE
	[JMS].[Job] = '10017557'


SELECT
		[JP].[Job],
		[JP].[MStockCode],
		[JP].[LOperation],
		[JP].[MWarehouse],
		[JP].[TrnType],
		ISNULL(SUM(ISNULL([JP].[MQtyIssued], 0)), 0) AS [SumQtyIssued],
		MIN([WJP].[TrnDateTime]) AS [FirstTransaction],
		MAX([WJP].[TrnDateTime]) AS [LastTransaction]
	FROM 
		[SysproCompanyA].[dbo].[WipJobPost] [JP] WITH (NOLOCK)
	INNER JOIN
		[SysproCompanyA].[dbo].[v_PROD_WipJobPostDateTime] [WJP] WITH (NOLOCK)
	ON
		([JP].[Job] = [WJP].[Job])
		AND ([JP].[MStockCode] = [WJP].[MStockCode])
		AND ([JP].[Line] = [WJP].[Line])
	WHERE
		([JP].[TrnType] <> 'L')
		AND ([JP].[Job] = '10017557')
	GROUP BY
		[JP].[Job],
		[JP].[MStockCode],
		[JP].[LOperation],
		[JP].[MWarehouse],
		[JP].[TrnType]



-- 2025-09-23 13:20 - Avery Briggs - Script to tell which [StockCodes] have been issued to which [Job]s on which [Operation]s
-- Used this version for Python processing
SELECT
	[WM].[Job],
	[WM].[Warehouse],
	[WM].[OperationOffset],
	[WM].[StockCode],
	[WM].[StockDescription],
	[JP].[SumQtyIssued],
	[WM].[UnitQtyReqd],
	[WM].[AllocCompleted],
	(CASE WHEN ISNULL([WM].[UnitQtyReqd], 0) > ISNULL([JP].[SumQtyIssued], 0) THEN 0 ELSE 1 END) AS [Check]
	, (CASE WHEN (
			([JP].[Job] IS NOT NULL)
			AND ([JP].[MStockCode] IS NOT NULL)
			AND ([JP].[MWarehouse] IS NOT NULL)
			AND ([JP].[SumQtyIssued] IS NOT NULL)
		)
		THEN 1 ELSE 0 END) AS [IsPosted],
	[JP].[FirstTransaction],
	[JP].[LastTransaction],	
    (CASE 
        WHEN [WM].[AllocCompleted] = 'Y' THEN 1  -- SYSPRO says done
        WHEN ISNULL([WM].[UnitQtyReqd],0) <= ISNULL([JP].[SumQtyIssued],0) THEN 1
        ELSE 0
    END) AS [IsSatisfied],
    (CASE 
        WHEN ISNULL([WM].[UnitQtyReqd],0) > ISNULL([JP].[SumQtyIssued],0) THEN 1 ELSE 0 
    END) AS [StillMissing]
FROM
	[SysproCompanyA].[dbo].[WipJobAllMat] [WM] WITH (NOLOCK)
LEFT JOIN (
	SELECT
		[JP].[Job],
		[JP].[MStockCode],
		[JP].[LOperation],
		[JP].[MWarehouse],
		[JP].[TrnType],
		ISNULL(SUM(ISNULL([JP].[MQtyIssued], 0)), 0) AS [SumQtyIssued],
		MIN([WJP].[TrnDateTime]) AS [FirstTransaction],
		MAX([WJP].[TrnDateTime]) AS [LastTransaction]
	FROM 
		[SysproCompanyA].[dbo].[WipJobPost] [JP] WITH (NOLOCK)
	INNER JOIN
		[SysproCompanyA].[dbo].[v_PROD_WipJobPostDateTime] [WJP] WITH (NOLOCK)
	ON
		([JP].[Job] = [WJP].[Job])
		AND ([JP].[MStockCode] = [WJP].[MStockCode])
		AND ([JP].[Line] = [WJP].[Line])
	WHERE
		([JP].[TrnType] <> 'L')
	GROUP BY
		[JP].[Job],
		[JP].[MStockCode],
		[JP].[LOperation],
		[JP].[MWarehouse],
		[JP].[TrnType]
) AS [JP]
ON
	([WM].[Job] = [JP].[Job])
	AND ([WM].[StockCode] = [JP].[MStockCode])
	AND ([WM].[Warehouse] = [JP].[MWarehouse])
	--AND ([WM].[QtyIssued] = [JP].[SumQtyIssued])
WHERE
	(ISNUMERIC(LEFT([WM].[Job], 1)) = 1)
	AND ([WM].[Warehouse] <> '**')
	/*AND ([JP].[Job] = '10017557')*/
ORDER BY
	[WM].[Job],
	[WM].[StockCode],
	[WM].[OperationOffset]
;


;WITH Ordered AS (
    SELECT
        WM.Job,
        WM.StockCode,
        WM.OperationOffset,
        WM.UnitQtyReqd,
        JP.SumQtyIssued,
        SUM(WM.UnitQtyReqd) OVER (
			PARTITION BY
				WM.Job, WM.StockCode
			ORDER BY
				WM.OperationOffset 
			ROWS UNBOUNDED PRECEDING
		) AS CumReqd,
        ROW_NUMBER() OVER (
			PARTITION BY 
				WM.Job,
				WM.StockCode
			ORDER BY 
				WM.OperationOffset
		) AS rn
    FROM SysproCompanyA.dbo.WipJobAllMat WM
    LEFT JOIN (
        SELECT Job, MStockCode, SUM(MQtyIssued) AS SumQtyIssued
        FROM SysproCompanyA.dbo.WipJobPost
        WHERE TrnType = 'R'
        GROUP BY Job, MStockCode
    ) [JP]
        ON WM.Job = JP.Job
       AND WM.StockCode = JP.MStockCode
    /*WHERE WM.Job = '10017557'
      AND WM.StockCode = '03564'*/
)
SELECT
    Job,
    StockCode,
    OperationOffset,
    UnitQtyReqd,
    SumQtyIssued,
    CASE 
        WHEN CumReqd <= SumQtyIssued THEN UnitQtyReqd    -- fully satisfied
        WHEN CumReqd - UnitQtyReqd < SumQtyIssued THEN SumQtyIssued - (CumReqd - UnitQtyReqd) -- partial
        ELSE 0
    END AS AllocatedToOp
FROM Ordered
ORDER BY OperationOffset;
