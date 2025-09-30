
-- 2025-09-30 - Avery Briggs - Query to deteremine the 'Progress' of issuing done to a Job - Job + Op Level

CREATE VIEW [v_PROD_JobOpIssueStatus] AS
	SELECT
		[JMS].[Job]
		,[JMS].[Operation]
		,SUM(CASE WHEN [JMS].[IsSatisfied] = 1 THEN 1 ELSE 0 END) AS [NComplete]
		,SUM(CASE WHEN [JMS].[StillMissing] = 1 THEN 1 ELSE 0 END) AS [NMissing]
		,COUNT(*) AS [NParts]
		,ISNULL(SUM([JMS].[SumQtyIssued]), 0) AS [SumIssued]
		,ISNULL(SUM([JMS].[UnitQtyReqd]), 0) AS [SumRequired]
		,CAST(SUM(CASE WHEN [JMS].[IsSatisfied] = 1 THEN 1 ELSE 0 END) AS DECIMAL(18, 8)) / (CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END) AS [PctComplete]
		,CAST(ISNULL(SUM([JMS].[SumQtyIssued]), 0) AS DECIMAL(18, 8)) / (CASE WHEN ISNULL(SUM([JMS].[UnitQtyReqd]), 0) = 0 THEN 1 ELSE ISNULL(SUM([JMS].[UnitQtyReqd]), 0) END) AS [PctIssued]
	FROM 
		[SysproCompanyA].[dbo].[v_PROD_JobMaterialStatus] [JMS]
	GROUP BY
		[JMS].[Job]
		,[JMS].[Operation]
;