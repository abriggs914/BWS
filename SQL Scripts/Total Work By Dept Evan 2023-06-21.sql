/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT TOP (1000000000)
--      SUM([ActualAxle])
--      ,SUM([ActualStep1])
--      ,SUM([ActualStep2])
      
--  FROM [SysproCompanyA].[dbo].[v_JobBudget&ActualHours]




DECLARE @sd AS DATETIME = '2022-06-01';
DECLARE @ed AS DATETIME = '2023-06-01 23:59:59';
DECLARE @t AS TABLE([ID] INT IDENTITY(0 , 1), [Group] INT, [Dept] NVARCHAR(100));
INSERT INTO @t ([Group], [Dept]) VALUES
(0, 'AXLE & SUSPENSION'),
(1, 'BEAM ASSEMBLY'),
(2, 'Finish Shop'),
(3, 'Machine Shop'),
(4, 'Paint & Blast'),
(5, 'SUB ASSEMBLY'),
(6, 'trailer assembly')
;

--select 
--[LWorkCentre],
--[LWorkCentreDesc],
--[WipJobPost].[Journal],
--	  sum(LRunTimeHours)
--	  from WipJobPost with (nolock)
--	  INNER JOIN
--		@t
--	ON
--		UPPER([@t].[Dept]) = UPPER([LWorkCentreDesc])
----where 
--	--[WipJobPost].[Journal]
--and Job not in ('10015030', '10015031', '10015032')
--group by [LWorkCentre], [LWorkCentreDesc], [WipJobPost].[Journal]


SELECT
	[LWorkCentre] AS [WorkCentre]
	,[LWorkCentreDesc] AS [WorkCentreDesc]
	,SUM([X]) AS [SumRunTime]
FROM (
	select 
	[LWorkCentre],
	[LWorkCentreDesc],
	--[PostYear],
	--[PostMonth],
		  sum(LRunTimeHours) AS [X]
	  
	--,	CAST([PostYear] AS NVARCHAR(4)) + '-' + RIGHT('00' + CAST([PostMonth] AS NVARCHAR(2)), 2) + '-01' AS [X]
		  from WipJobPost with (nolock)
	INNER JOIN
			@t
		ON
			UPPER([@t].[Dept]) = UPPER([LWorkCentreDesc])
	where 
		(CASE WHEN [PostYear] = 2022 THEN (CASE WHEN [PostMonth] >= 6 THEN 1 ELSE 0 END) ELSE 1 END) = 1
		AND (CASE WHEN [PostYear] = 2023 THEN (CASE WHEN [PostMonth] <= 6 THEN 1 ELSE 0 END) ELSE 1 END) = 1
		AND [PostYear] BETWEEN 2022 AND 2023
		--PostMonth NOT BETWEEN 1 AND 12
	-- CAST(CAST([PostYear] AS NVARCHAR(4)) + '-' + RIGHT('00' + CAST([PostMonth] AS NVARCHAR(2)), 2) + '-01' AS DATETIME) BETWEEN @sd AND @ed
		--[WipJobPost].[Journal]
	--and Job not in ('10015030', '10015031', '10015032')
	GROUP BY

	[LWorkCentre],
	[LWorkCentreDesc],
	[PostYear],
	[PostMonth]
	--ORDER BY 
	--[PostYear],
	--[PostMonth]

) AS [A]
	GROUP BY

	[LWorkCentre],
	[LWorkCentreDesc]