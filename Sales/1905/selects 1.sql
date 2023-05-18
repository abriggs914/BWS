USE Stargatedb
GO

--SELECT
--	*
--FROM
--	[]

EXEC [sp_DealerStatusReportV2_Stargate] @dealerid=142830

select * from BWSdb.dbo.[v_Dealer Status Report 2_Stargate]

SELECT 
	LEFT(RIGHT(CAST([PO Date] AS NVARCHAR(MAX)), 12), 4),
	* 
FROM
	[BWSdb].[dbo].[OrdersV2]
WHERE
	[SGQuote] IN ('SG100035', 'SG100838', 'SG100818', 'SG100819')
;
SELECT
	*
FROM
	[BWSdb].[dbo].[OrdersV2]
WHERE
	LEFT(RIGHT(CAST([PO Date] AS NVARCHAR(MAX)), 12), 2) <> '20'
;