USE [BWSdb]
GO

/****** Object:  View [dbo].[v_ProdLinesDatesModelsDealers]    Script Date: 2022-02-01 4:57:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[v_ProdLinesDatesModelsDealers]
AS 

SELECT
	(CASE WHEN [Prod Date 1] <= [Prod Date 2] or [Prod Date 2] is null THEN [WO Line 1] ELSE [WO Line 2] END) AS [Line Number],
	(CASE WHEN [Prod Date 1] <= [Prod Date 2] or [Prod Date 2] is null THEN [Prod Date 1] ELSE [Prod Date 2] END) AS [Start Date],
	[InputField1] AS [Model],
	[InputField2] AS [Dealer]
FROM
	[dtProductionSchedule]
LEFT JOIN
	[Orders]
ON
	[Orders].[WO#] = [dtProductionSchedule].[WO#]
LEFT OUTER JOIN
	[SysproCompanyA].[dbo].[WipMaster]
ON
	CAST([dtProductionSchedule].[WO#] AS NVARCHAR(MAX)) = [SysproCompanyA].[dbo].[WipMaster].[Job]
WHERE
	(CASE WHEN [Prod Date 1] <= [Prod Date 2] or [Prod Date 2] is null THEN [Prod Date 1]
		  ELSE [Prod Date 2] END) IS NOT NULL
	AND ([Prod Date 1] IS NOT NULL OR [Prod Date 2] IS NOT NULL)
	AND [ActCompleteDate] IS NULL
	AND [Date Declined] IS NULL
	AND (
		CASE WHEN 
			[dtProductionSchedule].[Quote#] IS NULL OR [dtProductionSchedule].[WO#] IS NULL THEN (
				CASE WHEN (
					[Step1SYSPROBudget] + [Step2SYSPROBudget]) = 0 THEN
					1 
				ELSE 
					0
				END) 
		ELSE
			1
		END) = 1
GO


