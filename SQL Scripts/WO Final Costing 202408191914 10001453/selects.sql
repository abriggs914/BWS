/*

SELECT 
	[Order HoursV2].COGS,
	[Order HoursV2].[Labour Cost],
	[Order HoursV2].[Made In Material],
	[Order HoursV2].[Bought Out Material],
	*
FROM
	[dbo_WO Rpt1 FC v2]
INNER JOIN
	[Order HoursV2] 
ON
	[dbo_WO Rpt1 FC v2].[WO#] = [Order HoursV2].[WO#]
WHERE (
	(
		([dbo_WO Rpt1 FC v2].[WO#])=[Forms]![Work Order Final Costing Parameters]![Job]
		)
);
*/

DECLARE @wo INT = 10001453

SELECT 
	[Order HoursV2].COGS,
	[Order HoursV2].[Labour Cost],
	[Order HoursV2].[Made In Material],
	[Order HoursV2].[Bought Out Material],
	*
FROM
	[Stargatedb].[dbo].[WO Rpt1 FC v2]
INNER JOIN
	[BWSdb].[dbo].[Order HoursV2] 
ON
	[WO Rpt1 FC v2].[WO#] = [Order HoursV2].[WO#]
WHERE (
	(
		([WO Rpt1 FC v2].[WO#])=@wo
		)
);


SELECT
	'Order HoursV2',
	*
FROM
	[BWSdb].[dbo].[Order HoursV2] 
WHERE
	[WO#] = @wo
;
SELECT
	'WO Rpt1 FC v2',
	*
FROM
	[Stargatedb].[dbo].[WO Rpt1 FC v2] 
WHERE
	[WO#] = @wo
;
SELECT
	'v_JobReworkHours_SG',
	*
FROM
	[SysproCompanyS].[dbo].[v_JobReworkHours_SG] 
WHERE
	[Job] = @wo
;
SELECT
	'v_JobBudget&ActualHours_SG',
	*
FROM
	[SysproCompanyS].[dbo].[v_JobBudget&ActualHours_SG] 
WHERE
	[Job] = @wo
;
SELECT
	'v_JobCosting',
	*
FROM
	[SysproCompanyS].[dbo].[v_JobCosting] 
WHERE
	[Job] = @wo
;
SELECT
	'v_CompletedJobInfo',
	*
FROM
	[SysproCompanyS].[dbo].[v_CompletedJobInfo] 
WHERE
	[Job] = @wo
;