USE BWSdb
GO

---- Everything
--SELECT
--	*
--FROM
--	[Options_SpecLines]
--;
	
---- Everything - Non NULLs
--SELECT
--	*
--FROM
--	[Options_SpecLines]
--WHERE
--	[SpecGroup] IS NOT NULL
--	AND [SpecSortG] IS NOT NULL
--	AND [SpecSection] IS NOT NULL
--	AND [SpecSortSe] IS NOT NULL
--	AND [SpecSortSe] NOT LIKE ''
--;

---- Spec Groups and Line Numbers
--SELECT DISTINCT
--	[SpecGroup], [SpecSortG], [SpecSection], [SpecSortSe], [SpecSortSeLine]
--FROM
--	[Options_SpecLines]
--Order BY
--	[SpecSortG], [SpecSortSe]
--;

---- Spec Groups and Line Numbers - No NULLs
--SELECT DISTINCT
--	[SpecGroup], [SpecSortG], [SpecSection], [SpecSortSe], [SpecSortSeLine]
--FROM
--	[Options_SpecLines]
--WHERE
--	[SpecGroup] IS NOT NULL
--	AND [SpecSortG] IS NOT NULL
--	AND [SpecSection] IS NOT NULL
--	AND [SpecSortSe] IS NOT NULL
--	AND [SpecSortSe] NOT LIKE ''
--Order BY
--	[SpecSortG], [SpecSortSe]
--;

---- Groups and Group Numbers
--SELECT DISTINCT
--	[SpecGroup], [SpecSortG]
--FROM
--	[Options_SpecLines]
--Order BY
--	[SpecSortG]
--;

---- Groups and Group Numbers - No NULLs
--SELECT DISTINCT
--	[SpecGroup], [SpecSortG]
--FROM
--	[Options_SpecLines]
--WHERE
--	[SpecGroup] IS NOT NULL
--	AND [SpecSortG] IS NOT NULL
--	AND [SpecSection] IS NOT NULL
--	AND [SpecSortSe] IS NOT NULL
--	AND [SpecSortSe] NOT LIKE ''
--Order BY
--	[SpecSortG]
--;

---- Groups
--SELECT DISTINCT
--	[SpecGroup]
--FROM
--	[Options_SpecLines]
--Order BY
--	[SpecGroup]
--;

---- Groups - No NULLs
--SELECT DISTINCT
--	[SpecGroup]
--FROM
--	[Options_SpecLines]
--WHERE
--	[SpecGroup] IS NOT NULL
--	AND [SpecSortG] IS NOT NULL
--	AND [SpecSection] IS NOT NULL
--	AND [SpecSortSe] IS NOT NULL
--	AND [SpecSortSe] NOT LIKE ''
--Order BY
--	[SpecGroup]
--;

---- Groups by Class - Non NULLs
--SELECT DISTINCT
--	[Products].[Class], [Options_SpecLines].[SpecGroup], [Options_SpecLines].[SpecSortG]
--FROM
--	[Options_SpecLines]
--INNER JOIN
--	[Products]
--ON
--	[Products].[Model No] = [Options_SpecLines].[Model No]
--WHERE
--	[SpecGroup] IS NOT NULL
--	AND [SpecSortG] IS NOT NULL
--	AND [SpecSection] IS NOT NULL
--	AND [SpecSortSe] IS NOT NULL
--	AND [SpecSortSe] NOT LIKE ''
--ORDER BY [Products].[Class], [Options_SpecLines].[SpecSortG]
--;

--SELECT * FROM [Products]




---- Groups by Class - Non NULLs
SELECT
	[Products].[Class], [Options_SpecLines].[SpecGroup], [Options_SpecLines].[SpecSortG], COUNT(*) as [Number Entries]
FROM
	[Options_SpecLines]
INNER JOIN
	[Products]
ON
	[Products].[Model No] = [Options_SpecLines].[Model No]
WHERE
	[SpecGroup] IS NOT NULL
	AND [SpecSortG] IS NOT NULL
	AND [SpecSection] IS NOT NULL
	AND [SpecSortSe] IS NOT NULL
	AND [SpecSortSe] NOT LIKE ''
GROUP BY
	[Products].[Class], [Options_SpecLines].[SpecGroup], [Options_SpecLines].[SpecSortG]
ORDER BY [Products].[Class], [Options_SpecLines].[SpecGroup]
--




WITH tbl AS (
	SELECT
		[Products].[Class], [Options_SpecLines].*
	FROM
		[Options_SpecLines]
	INNER JOIN
		[Products]
	ON
		[Products].[Model No] = [Options_SpecLines].[Model No]
	WHERE
		[SpecGroup] IS NOT NULL
		AND [SpecSortG] IS NOT NULL
		AND [SpecSection] IS NOT NULL
		AND [SpecSortSe] IS NOT NULL
		AND [SpecSortSe] NOT LIKE ''
	--ORDER BY [Products].[Class], [Options_SpecLines].[SpecSortG]
)

--SELECT 
--	*
--FROM
--	[tbl]
--


SELECT DISTINCT (
	SELECT 
		COUNT(DISTINCT([]))
	FROM
		[tbl]
)
AS
	[Number Entries], [SpecGroup], [SpecSortG]
FROM
	[tbl]
;