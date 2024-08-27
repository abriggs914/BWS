DECLARE @sd DATETIME = '2024-08-01'
DECLARE @ed DATETIME = '2025-08-31'


EXEC [BWSdb].[dbo].[sp_ProductionSchedule V4_Slots] @sd, @ed

SELECT
    *
FROM
    [BWSdb].[dbo].[Orders]
WHERE
    ([Order Date] BETWEEN @sd AND @ed)
    OR ([Quote Date] BETWEEN @sd AND @ed) 
    OR ([Available Date] BETWEEN @sd AND @ed) 
    OR ([Delivery Date] BETWEEN @sd AND @ed) 
    OR ([Finish Date] BETWEEN @sd AND @ed) 
    OR ([PO Date] BETWEEN @sd AND @ed) 
    OR ([Est Pro Date] BETWEEN @sd AND @ed) 
    OR ([Date Registered] BETWEEN @sd AND @ed)
    OR ([Date In Service] BETWEEN @sd AND @ed)  
    OR ([Invoice Date] BETWEEN @sd AND @ed) 
    OR ([Shipped Date] BETWEEN @sd AND @ed)
    OR ([Date Requested] BETWEEN @sd AND @ed)
    OR ([BWSPaidDate] BETWEEN @sd AND @ed)   
    OR ([CommPaidDate] BETWEEN @sd AND @ed)   
    OR ([Lead Date] BETWEEN @sd AND @ed)   
    OR ([DateLastQuoteReport] BETWEEN @sd AND @ed)
    OR ([JobAvailableScheduled] BETWEEN @sd AND @ed)   
;

SELECT
    *
FROM
    [BWSdb].[dbo].[dtProductionSchedule]
WHERE
    ([Beam Date] BETWEEN @sd AND @ed)
    OR ([Prod Date 1] BETWEEN @sd AND @ed)
    OR ([Prod Date 2] BETWEEN @sd AND @ed)
    OR ([Other Date] BETWEEN @sd AND @ed)
    OR ([Prod On] BETWEEN @sd AND @ed)
    OR ([Prod Off] BETWEEN @sd AND @ed)
    OR ([Prod2 On] BETWEEN @sd AND @ed)
    OR ([Prod2 Off] BETWEEN @sd AND @ed)
    OR ([Beam On] BETWEEN @sd AND @ed)
    OR ([Beam Off] BETWEEN @sd AND @ed)
    OR ([GN On] BETWEEN @sd AND @ed)
    OR ([GN Off] BETWEEN @sd AND @ed)
    OR ([Axle On] BETWEEN @sd AND @ed)
    OR ([Axle Off] BETWEEN @sd AND @ed)
    OR ([Other On] BETWEEN @sd AND @ed)
    OR ([Other Off] BETWEEN @sd AND @ed)
;


SELECT
	*
FROM
	[Stargatedb].[dbo].[PDS Updates]

SELECT
	*
FROM
	[Stargatedb].[dbo].[PDS Valid Updaters]

SELECT
	CAST('08/27/24 13:52:28' AS DATETIME) [D]


UPDATE [Stargate].[dbo].[PDS Valid Updaters] SET [LastAccess] = '08/27/24 14:02:22' WHERE [UserName] = 'abriggs';