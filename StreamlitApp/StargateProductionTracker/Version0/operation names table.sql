SELECT 
	[L].[Operation]
	,[L].[WorkCentre]
	,[L].[WorkCentreDesc]
FROM
	[SysproCompanyA].[dbo].[WipJobAllLab] [L]
GROUP BY
	[L].[Operation]
	,[L].[WorkCentre]
	,[L].[WorkCentreDesc]
;

SELECT 
	*
FROM
	[SysproCompanyA].[dbo].[v_TLWRAllOperations]


SELECT 
	*
FROM
	[BWSdb].[dbo].[ProductionOperations] 
WHERE
	([CompanyID] = 0)
	AND ([Active] = 1) 
ORDER BY
	(CASE WHEN [OperationNum] = 0 THEN 1 ELSE 0 END),
	[OperationNum]
;