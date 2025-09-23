;WITH Issued AS (
    SELECT
        Job,
        MStockCode AS StockCode,
        LOperation AS OperationOffset,
        SUM(MQtyIssued) AS QtyIssued
    FROM SysproCompanyA.dbo.WipJobPost
    GROUP BY Job, MStockCode, LOperation
)
, RecentWO AS (
    SELECT CAST([WO#] AS nvarchar(50)) AS Job, ISNULL([Prod Date], [Prod Date2]) AS [ProdDate]
    FROM BWSdb.dbo.Production
    WHERE ISNULL([Prod Date], [Prod Date2]) > DATEADD(DAY, -800, GETDATE())
)
SELECT
    WM.Job,
    WM.OperationOffset,
    WM.StockCode,
    WM.Uom,
    WM.UnitQtyReqd,
    ISNULL(Issued.QtyIssued, 0) AS QtyIssued,
    WM.Warehouse,
    WM.StockDescription,
    WM.Bin,
	[RW].[ProdDate]
FROM SysproCompanyA.dbo.WipJobAllMat WM
LEFT JOIN Issued
    ON WM.Job = Issued.Job
   AND WM.StockCode = Issued.StockCode
   AND WM.OperationOffset = Issued.OperationOffset
LEFT JOIN RecentWO RW
    ON WM.Job = RW.Job
WHERE
    -- Only care about top-level jobs that are recent
    ((LEFT(WM.Job,1) <> '1' OR RW.Job IS NOT NULL)
    AND (
        ISNULL(WM.UnitQtyReqd, 0) > ISNULL(Issued.QtyIssued, 0)
        OR ISNULL(WM.AllocCompleted, 'N') = 'N'
    ))
	--AND ([WM].[Job] = '10017105')
ORDER BY
	[Job]
	,[OperationOffset]
	,[StockCode]
;
