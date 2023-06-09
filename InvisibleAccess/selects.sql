USE BWSdb
GO

-- Selects for Access Database Glossary (ADG).

SELECT
	'ADG Databases' AS [Table],
	*
FROM
	[ADG Databases]
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

SELECT
	'ADG Databases' AS [Table],
	*
FROM
	[ADG Databases]
ORDER BY
	[DateCreated] DESC
;

SELECT
	'v_ADG Latest Accessors' AS [Table],
	*
FROM
	[v_ADG Latest Accessors]
ORDER BY
	[When] DESC
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
	'ADG Events' AS [Table],
	MAX([ID]) AS [LastID]
	, [WindowsUser]
FROM
	[ADG Events]
GROUP BY
	[WindowsUser]
;

SELECT
	'ADG Events' AS [Table],
	*
FROM
	[ADG Events]
;
	
