USE BWSdb
GO

-- 2023-09-06 ADG Options

SELECT
	[B].[ID#] AS [bID]
	,[O].[ID#] AS [oID]
	,[O].[Start Date]
	,[O].[End Date]
	,[B].[Option No]
	,[B].[Model No]
	,[B].[Obsolete]
	,[B].[Description]
	,[B].[Sections]
	,[B].[SortSe]
	,[O].[Draw/Part#]
	,[O].[Price]
	,[O].[US Price]
FROM
	[Budget Options] AS [B]
FULL OUTER JOIN
	[Options] AS [O]
ON
	[B].[Option No] = [O].[Option No]
	AND [B].[Model No] = [O].[Model No]
WHERE
	LOWER([B].[Model No]) LIKE '%adg%'