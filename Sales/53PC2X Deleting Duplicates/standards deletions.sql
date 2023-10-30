USE BWSdb
GO


-- Deleting duplicates for a model in [Standards]

DECLARE @mn AS NVARCHAR(MAX) = '53PC2X';



SELECT
	*
FROM
	[Standards]
WHERE 
	[Model No] = @mn
ORDER BY
	[SortGv2]
	,[SortSev2]
;

--SELECT
--		[ID#]
--		,ROW_NUMBER() OVER(
--			PARTITION BY
--				[Description]
--			ORDER BY
--				[ID#]
--		) AS [RN]
--	FROM
--		[Standards]
--	WHERE
--		[Model No] = @mn

BEGIN TRAN;

SELECT
	*
FROM
	[Standards]
WHERE 
	[Model No] = @mn
ORDER BY
	[Description]
;

DECLARE @t AS TABLE ([ID] INT IDENTITY(0, 1), [iID] INT);
INSERT INTO @t ([iID])
SELECT 
	[IDStd]
FROM (
	SELECT
		[IDStd]
		,ROW_NUMBER() OVER(
			PARTITION BY
				[Description]
			ORDER BY
				[IDStd]
		) AS [RN]
	FROM
		[Standards]
	WHERE
		[Model No] = @mn
) AS [S]
WHERE
	[RN] = 1
;

--SELECT
--	*
--FROM
--	@t
--;

DELETE 
	[S]
FROM
	[Standards] AS [S]
INNER JOIN (
	SELECT
		[iID]
	FROM
		@t
) AS [A]
ON
	[S].[IDStd] = [A].[iID]
--WHERE 
--	[Model No] = @mn
;

SELECT
	*
FROM
	[Standards]
WHERE 
	[Model No] = @mn
ORDER BY
	[Description]
;

ROLLBACK;
COMMIT;