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
	[SpecSortG]
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
	'' AS  [T]
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