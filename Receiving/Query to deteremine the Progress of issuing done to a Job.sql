DECLARE @sd DATETIME = '2025-09-18';
DECLARE @tlo BIT = 1;
DECLARE @op INT = 5;
DECLARE @j NVARCHAR(MAX) = '10017648';
DECLARE @sc NVARCHAR(MAX) = '544325048';

SELECT
	*
FROM 
	[BWSdb].[dbo].[fn_PartOrNoneIssued](@sd, @tlo, 0.01) [SRC]
WHERE
	([SRC].[Job] = @j)
	AND ([SRC].[Operation] = @op)

SELECT
	*
FROM 
	[SysproCompanyA].[dbo].[v_PROD_JobMaterialStatus] [JMS]
WHERE
	([JMS].[Job] = @j)
	AND ([JMS].[Operation] = @op)
	--AND ([JMS].[StockCode] = @sc)


-- 2025-09-30 - Query to deteremine the 'Progress' of issuing done to a Job
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
ORDER BY
	[JMS].[Job]
	,[JMS].[Operation]
;

SELECT
	[JMS].[Job]
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
ORDER BY
	[JMS].[Job]

	
SELECT
	*
FROM
	[BWSdb].[dbo].[v_PROD_JobIssueStatus]
SELECT
	*
FROM
	[BWSdb].[dbo].[v_PROD_JobOpIssueStatus]
SELECT
	*
FROM
	[BWSdb].[dbo].[ITR Customers]
WHERE
	[Active] = 1
