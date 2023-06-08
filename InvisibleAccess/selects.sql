USE BWSdb
GO

-- Selects for Access Database Glossary (ADG).

SELECT
	*
FROM
	[ADG Databases]
;

SELECT
	*
FROM
	[ADG DB Elements]
;

SELECT
	*
FROM
	[ADG Events]
;

SELECT
	*
FROM
	[v_ADG Latest Accessors]
ORDER BY
	[When] DESC
;

SELECT
	*
FROM
	[v_ADG User Access Log]
ORDER BY
	[Date],
	[WindowsUser],
	[AccessDB]
;

SELECT
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
	MAX([ID]) AS [LastID]
	, [WindowsUser]
FROM
	[ADG Events]
GROUP BY
	[WindowsUser]
;

SELECT
	*
FROM
	[ADG Events]
;
	
