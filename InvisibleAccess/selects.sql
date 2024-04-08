USE BWSdb
GO

-- Selects for Access Database Glossary (ADG).

SELECT
	'ADO Databases' AS [Table],
	*
FROM
	[ADO Databases]
;

SELECT
	'ADG DB Elements' AS [Table],
	*
FROM
	[ADG DB Elements]
;

SELECT
	'ADG Events' AS [Table],
	*
FROM
	[ADG Events]
;
/*
SELECT
	'ADO Databases' AS [Table],
	*
FROM
	[ADO Databases]
;
*/


SELECT
	'v_ADG Latest Accessors' AS [Table],
	'When' AS [By],
	*
FROM
	[BWSdb].[dbo].[v_ADG Latest Accessors]
ORDER BY
	[When] DESC
;


SELECT
	'v_ADG Latest Accessors' AS [Table],
	'TotalAccesses' AS [By],
	*
FROM
	[BWSdb].[dbo].[v_ADG Latest Accessors]
ORDER BY
	[TotalAccesses] DESC
;

SELECT
	'v_ADG Latest Accessors' AS [Table],
	'TotalAccesses' AS [By],
	SUM([TotalAccesses]) AS [Tot TotalAccesses]
	,COUNT([TotalAccesses]) AS [Num Accessors]
	,SUM([TotalAccesses])/COUNT([TotalAccesses]) AS [Avg Num Accesses Per Accessor]
	,MIN([When]) AS [First Access]
	,MAX([When]) AS [Last Access]
FROM
	[BWSdb].[dbo].[v_ADG Latest Accessors]
--ORDER BY
	--[TotalAccesses] DESC
;


SELECT
	'v_ADG User Access Log' AS [Table],
	*
FROM
	[v_ADG User Access Log]
ORDER BY
	[Date],
	[WindowsUser],
	[AccessDB]
;

SELECT
	'v_ADG Buttons Inventory' AS [Table],
	*
FROM
	[v_ADG Buttons Inventory]
;

--SELECT
--	[ID]
--	, [WindowsUser] AS [Latest Accessor(s)]
--	, ROW_NUMBER() OVER(
--		PARTITION BY [WindowsUser]
--		ORDER BY [DateCreated] DESC
--	) AS [RowN]
--	, [AccessDB] AS [DB]
--FROM
--	[ADG Events]
--ORDER BY
--	[DateCreated] DESC
--;

SELECT
	'ADG Events -1' AS [Table],
	MAX([ID]) AS [LastID]
	, COUNT([ID]) AS [NumAccesses]
	, [WindowsUser]
FROM
	[ADG Events]
GROUP BY
	[WindowsUser]
ORDER BY
	[NumAccesses] DESC
;

SELECT
	'ADG Events -2' AS [Table],
	MAX([ADO Databases].[ADODatabasesID]) AS [LastID]
	, COUNT([ADO Databases].[ADODatabasesID]) AS [NumAccesses]
	, [ADO Databases].[Name]
FROM
	[ADG Events]
INNER JOIN
	[ADO Databases]
ON
	[ADG Events].[AccessDBID] = [ADO Databases].[ADODatabasesID]
GROUP BY
	[ADO Databases].[Name]
ORDER BY
	[NumAccesses] DESC
;

SELECT
	'ADG Events' AS [Table],
	*
FROM
	[ADG Events]
;

SELECT
	[ADG Events].[FormAccessed]
FROM
	[ADG Events]
GROUP BY
	[ADG Events].[FormAccessed]
;

SELECT
	[ADG Events].[DestinationForm]
FROM
	[ADG Events]
GROUP BY
	[ADG Events].[DestinationForm]
;
	
