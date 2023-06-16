USE BWSdb
GO

SELECT
	'Options_FactoryLines' AS [T]
	, [SpecGroup]
	, [SpecSortG]
	, [SpecSection]
	, [SpecSortSe]
	--, *
FROM
	[Options_FactoryLines]
GROUP BY
	[SpecGroup]
	, [SpecSortG]
	, [SpecSection]
	, [SpecSortSe]
ORDER BY
	[SpecSortG]
	, [SpecSortSe]
;

DECLARE @t AS TABLE ([ID] INT IDENTITY(0, 1), [T] NVARCHAR(MAX), [SpecGroup] NVARCHAR(MAX), [SpecSortG] INT, [SpecSection] NVARCHAR(MAX), [SpecSortSe] INT, [C] INT);
INSERT INTO @t
SELECT
	'Options_FactoryLines' AS [T]
	, [SpecGroup]
	, [SpecSortG]
	, [SpecSection]
	, [SpecSortSe]
	, COUNT(*) AS [C]
	--, *
FROM
	[Options_FactoryLines]
GROUP BY
	[SpecGroup]
	, [SpecSortG]
	, [SpecSection]
	, [SpecSortSe]
--HAVING
	--COUNT(*) > 1
ORDER BY
	[SpecSortG]
	, [SpecSortSe]
;

SELECT * FROM @t;
SELECT
	'>1' AS [T]
	, [SpecSortG]
	, [SpecSortSe]
	, COUNT(*) AS [NumUses]
FROM 
	@t
GROUP BY
	[SpecSortG]
	, [SpecSortSe]
HAVING
	COUNT(*) > 1
ORDER BY
	[SpecSortG]
	, [SpecSortSe]
;

SELECT 
	*
FROM (
	SELECT
		'Result1' AS [T]
		, [A].[SpecGroup]
		, [A].[SpecSortG]
		, [A].[SpecSection]
		, [A].[SpecSortSe]
		--, [C]
		, COUNT(*) AS [NumberUses]
		, ROW_NUMBER() OVER(
			PARTITION BY
				[A].[SpecGroup]
				, [A].[SpecSortG]
				, [A].[SpecSortSe]
			ORDER BY
				[A].[SpecGroup]
				, [A].[SpecSortG]
				, [A].[SpecSortSe]
				, COUNT(*) DESC
		--		, [C]
		) AS [RowIdx]
		--, [@t].*
		--, [A].*
	FROM
		[Options_FactoryLines] AS [A]
	INNER JOIN
		@t
	ON
		[@t].[SpecSortG] = [A].[SpecSortG]
		AND [@t].[SpecSortSe] = [A].[SpecSortSe]
	--WHERE [C] <> 1
	GROUP BY
		[A].[SpecGroup]
		, [A].[SpecSortG]
		, [A].[SpecSection]
		, [A].[SpecSortSe]
		--, [C]
)  AS [B]
ORDER BY
	[B].[SpecSortG]
	, [B].[SpecSortSe]
	, [RowIdx]


SELECT
	'Result2' AS [T]
	, [A].[SpecGroup]
	, [A].[SpecSortG]
	, COUNT(*) AS [C]
FROM
	[Options_FactoryLines] AS [A]
GROUP BY
	[A].[SpecGroup]
	, [A].[SpecSortG]
ORDER BY
	[A].[SpecSortG]


--

SELECT
	'=1' AS  [T]
	, [SpecSortG]
	, [SpecSortSe]
	, COUNT(*) AS [NumUses]
FROM 
	@t
GROUP BY
	[SpecSortG]
	, [SpecSortSe]
HAVING
	COUNT(*) = 1
ORDER BY
	[SpecSortG]
	, [SpecSortSe]
;


--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

SELECT
	'Options_SpecLines' AS [T]
	, [SpecGroup]
	, [SpecSortG]
	, [SpecSection]
	, [SpecSortSe]
	--, [SpecDescription]
	--, *
FROM
	[Options_SpecLines]
GROUP BY
	[SpecGroup]
	, [SpecSortG]
	, [SpecSection]
	, [SpecSortSe]
HAVING
	COUNT(*) > 1
ORDER BY
	[SpecSortG]
	, [SpecSortSe]
;

------------------------------------------

SELECT
	'Options_SpecLines' AS [T]
	, [SpecGroup]
	, [SpecSortG]
	--, [SpecSection]
	, [SpecSortSe]
	--, [SpecDescription]
	--, *
FROM
	[Options_SpecLines]
GROUP BY
	[SpecGroup]
	, [SpecSortG]
	--, [SpecSection]
	, [SpecSortSe]
HAVING
	COUNT(*) > 1
ORDER BY
	[SpecSortG]
	, [SpecSortSe]
;