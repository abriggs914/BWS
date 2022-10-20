USE BWSdb
GO

SELECT
	* 
FROM
	[IT Requests]
;

SELECT
	SUM([LabourEstimate]) AS [SumLabEst]
	,SUM([LabourActual]) AS [SumLabAct]
	,SUM([LabourEstimate]) - SUM([LabourActual]) AS [TimeRemaining]
	,COUNT(*) AS [NReqsTotal]
	,SUM(CASE WHEN [Status] IN ('Complete', 'Incomplete', 'Incomplete') THEN 0 ELSE 1 END) AS [NReqsLeftOpen]
	,SUM(CASE WHEN [Status] IN ('Complete', 'Incomplete', 'Incomplete') THEN 1 ELSE 0 END) AS [NReqsClosed]
	,(SUM([LabourEstimate]) - SUM([LabourActual])) /
		(CASE WHEN
			SUM(CASE WHEN [Status] IN ('Complete', 'Incomplete', 'Incomplete')
				THEN 1
				ELSE 0
				END) = 0
		THEN 1
		ELSE SUM(CASE WHEN
					[Status] IN ('Complete', 'Incomplete', 'Incomplete') 
				THEN 1
				ELSE 0
				END)
		END) AS [TimePerRemainingRequest]
FROM
	[IT Requests]
;