/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
	[Model No]
	,[Position4]
	,[Position5]
	,[Position6]
	,[Position8]
FROM
	[BWSdb].[dbo].[SN Type V2]
WHERE 
	[CompanyID] = 1
AND (
	[Model No] NOT LIKE '%box%'
	AND [Model No] NOT LIKE '%dolly%'
	AND [Model No] NOT LIKE '%test%'
	AND [Model No] NOT LIKE '%working copy%'
)
AND
	ISNULL(CAST([Position4] AS NVARCHAR(MAX)), '!') + 
	ISNULL(CAST([Position5] AS NVARCHAR(MAX)), '!') + 
	ISNULL(CAST([Position6] AS NVARCHAR(MAX)), '!') + 
	ISNULL(CAST([Position8] AS NVARCHAR(MAX)), '!')
	
	LIKE '%!%'
  ORDER BY [Model No]