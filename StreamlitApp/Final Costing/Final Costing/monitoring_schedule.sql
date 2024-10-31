
SELECT
	[Orders].[Quote#]
    ,[Orders].[WO#]
    ,CASE WHEN [v_CompletedJobInfo].[EntInvoiceDate] IS NOT NULL THEN 13
        WHEN [WipMaster].[ActCompleteDate] IS NOT NULL THEN 12
        WHEN [SubWiPLabourIssued].[NetLabourCharged] <> 0 THEN 10
        WHEN [SubWiPPartsIssued].[NetIssued] <> 0 THEN 9
        WHEN [Design].[BOM Complete For Review] IS NOT NULL THEN 7
        WHEN [Design].[Complete] = 1 THEN 6
        WHEN [Orders].[Prom Drawing] IS NOT NULL THEN 5
        WHEN [WipMaster].[Job] IS NOT NULL THEN 4
        --WHEN [LongLeadQuoteMaster].[Quote#] IS NOT NULL THEN 3
        WHEN [Orders].[WO Reviewed] = 1 THEN 2
        WHEN [SorMaster].[SalesOrder] IS NOT NULL THEN 1
        ELSE 0
        END AS [UnitStatusID]
    ,CASE WHEN [v_CompletedJobInfo].[EntInvoiceDate] IS NOT NULL THEN 'Unit Invoiced'
        WHEN [WipMaster].[ActCompleteDate] IS NOT NULL THEN 'Work Order Closed'
        WHEN [SubWiPLabourIssued].[NetLabourCharged] <> 0 THEN 'First Labour Issued'
        WHEN [SubWiPPartsIssued].[NetIssued] <> 0 THEN 'First Parts Issued'
        WHEN [Design].[BOM Complete For Review] IS NOT NULL THEN 'Bill of Material Reviewed'
        WHEN [Design].[Complete] = 1 THEN 'Engineering Prints Done'
        WHEN [Orders].[Prom Drawing] IS NOT NULL THEN 'Promo Drawing Approved by Customer'
        WHEN [WipMaster].[Job] IS NOT NULL THEN 'HAS a Work Order'
        --WHEN [LongLeadQuoteMaster].[Quote#] IS NOT NULL THEN 'HAS a Long Lead Quote made'
        WHEN [Orders].[WO Reviewed] = 1 THEN 'Reviewed at Sales Order Meeting'
        WHEN [SorMaster].[SalesOrder] IS NOT NULL THEN 'HAS a Sales Order in Syspro'
        ELSE 'New unit/yet to be reviewed at Sales Order Meeting/Unit out of milestone scope'
        END AS [UnitStatusDesc]
FROM
    [BWSdb].[dbo].[Orders] WITH (NOLOCK)
LEFT OUTER JOIN
    [SysproCompanyA].[dbo].[SorMaster] WITH (NOLOCK)
ON
    [Orders].[Sales Order#] = [SorMaster].[SalesOrder]
--LEFT OUTER JOIN
--    [BWSdb].[dbo].[LongLeadQuoteMaster] WITH (NOLOCK)
--ON
--    [Orders].[Quote#] = [LongLeadQuoteMaster].[Quote#]
LEFT OUTER JOIN
    [SysproCompanyA].[dbo].[WipMaster] WITH (NOLOCK)
ON
    CAST([Orders].[WO#] AS NVARCHAR(20)) = [WipMaster].[Job]
LEFT OUTER JOIN
    [BWSdb].[dbo].[Design] WITH (NOLOCK)
ON
    [Orders].[Quote#] = [Design].[Quote#]
LEFT OUTER JOIN
    (
        SELECT
			[Job]
            ,SUM([QtyIssued]) AS [NetIssued]
        FROM
            [SysproCompanyA].[dbo].[WipJobAllMat] WITH (NOLOCK)
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
            [SysproCompanyA].[dbo].[WipJobAllLab] WITH (NOLOCK)
        GROUP BY
            [Job]
    ) AS [SubWiPLabourIssued]
ON
    [WipMaster].[Job] = [SubWiPLabourIssued].[Job]
LEFT OUTER JOIN
    [SysproCompanyA].[dbo].[v_CompletedJobInfo]
ON
    CAST([Orders].[WO#] AS NVARCHAR(20)) = [v_CompletedJobInfo].[Job]
                                        