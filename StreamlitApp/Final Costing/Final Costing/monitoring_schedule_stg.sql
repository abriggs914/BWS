
SELECT
	[OrdersV2].[SGQuote]
    ,[OrdersV2].[WO#]
    ,CASE WHEN [v_CompletedJobInfo].[EntInvoiceDate] IS NOT NULL THEN 13
        WHEN [WipMaster].[ActCompleteDate] IS NOT NULL THEN 12
        WHEN [SubWiPLabourIssued].[NetLabourCharged] <> 0 THEN 10
        WHEN [SubWiPPartsIssued].[NetIssued] <> 0 THEN 9
        WHEN [DesignV2].[BOM Complete For Review] IS NOT NULL THEN 7
        WHEN [DesignV2].[Complete] = 1 THEN 6
        WHEN [OrdersV2].[Prom Drawing] = 1 THEN 5
        WHEN [WipMaster].[Job] IS NOT NULL THEN 4
        WHEN LongLeadQuoteMaster.[SGQuote] IS NOT NULL THEN 3
        WHEN [OrdersV2].[WO Reviewed] = 1 THEN 2
        WHEN [SorMaster].[SalesOrder] IS NOT NULL THEN 1
        ELSE 0
        END AS [UnitStatusID]
    ,CASE WHEN [v_CompletedJobInfo].[EntInvoiceDate] IS NOT NULL THEN 'Unit Invoiced'
        WHEN [WipMaster].[ActCompleteDate] IS NOT NULL THEN 'Work Order Closed'
        WHEN [SubWiPLabourIssued].[NetLabourCharged] <> 0 THEN 'First Labour Issued'
        WHEN [SubWiPPartsIssued].[NetIssued] <> 0 THEN 'First Parts Issued'
        WHEN [DesignV2].[BOM Complete For Review] IS NOT NULL THEN 'Bill of Material Reviewed'
        WHEN [DesignV2].[Complete] = 1 THEN 'Engineering Prints Done'
        WHEN [OrdersV2].[Prom Drawing] = 1 THEN 'Promo Drawing Approved by Customer'
        WHEN [WipMaster].[Job] IS NOT NULL THEN 'HAS a Work Order'
        WHEN [LongLeadQuoteMaster].[SGQuote] IS NOT NULL THEN 'HAS a Long Lead Quote made'
        WHEN [OrdersV2].[WO Reviewed] = 1 THEN 'Reviewed at Sales Order Meeting'
        WHEN [SorMaster].[SalesOrder] IS NOT NULL THEN 'HAS a Sales Order in Syspro'
        ELSE 'New unit/yet to be reviewed at Sales Order Meeting/Unit out of milestone scope'
        END AS [UnitStatusDesc]
FROM
    [BWSdb].[dbo].[OrdersV2] WITH (NOLOCK)
LEFT OUTER JOIN
    [SysproCompanyA].[dbo].[SorMaster] WITH (NOLOCK)
ON
    [OrdersV2].[Sales Order#] = [SorMaster].[SalesOrder]
LEFT OUTER JOIN
    [Stargatedb].[dbo].[LongLeadQuoteMaster] WITH (NOLOCK)
ON
    [OrdersV2].[SGQuote] = [LongLeadQuoteMaster].[SGQuote]
LEFT OUTER JOIN
    [SysproCompanyS].[dbo].[WipMaster] WITH (NOLOCK)
ON
    CAST([OrdersV2].[WO#] AS NVARCHAR(20)) = [WipMaster].[Job]
LEFT OUTER JOIN
    [BWSdb].[dbo].[DesignV2] WITH (NOLOCK)
ON
    [OrdersV2].[SGQuote] = [DesignV2].[SGQuote]
LEFT OUTER JOIN
    (
        SELECT
			[Job]
            ,SUM([QtyIssued]) AS [NetIssued]
        FROM
            [SysproCompanyS].[dbo].[WipJobAllMat] WITH (NOLOCK)
        GROUP BY
            [Job]
    ) AS [SubWiPPartsIssued]
ON
    [WipMaster].[Job] = [SubWiPPartsIssued].[Job]
LEFT OUTER JOIN
    (
        SELECT
			[Job]
            ,SUM([RunTimeIssued]) AS [NetLabourCharged]
        FROM
            [SysproCompanyS].[dbo].[WipJobAllLab] WITH (NOLOCK)
        GROUP BY
            [Job]
    ) AS [SubWiPLabourIssued]
ON
    [WipMaster].[Job] = [SubWiPLabourIssued].[Job]
LEFT OUTER JOIN
    [SysproCompanyS].[dbo].[v_CompletedJobInfo]
ON
    CAST([OrdersV2].[WO#] AS NVARCHAR(20)) = [v_CompletedJobInfo].[Job]
                                        