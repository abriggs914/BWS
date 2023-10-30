USE BWSdb
GO


-- Deleting duplicates for a model in [Options]

DECLARE @mn AS NVARCHAR(MAX) = '53PC2X';
SELECT
	*
FROM
	[Options]
WHERE 
	[Model No] = @mn
ORDER BY
	[Description]
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
--		[Options]
--	WHERE
--		[Model No] = @mn

BEGIN TRAN;

SELECT
	*
FROM
	[Options]
WHERE 
	[Model No] = @mn
ORDER BY
	[Description]
;

DECLARE @t AS TABLE ([ID] INT IDENTITY(0, 1), [iID] INT);
INSERT INTO @t ([iID])
SELECT 
	[ID#]
FROM (
	SELECT
		[ID#]
		,ROW_NUMBER() OVER(
			PARTITION BY
				[Description]
			ORDER BY
				[ID#]
		) AS [RN]
	FROM
		[Options]
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
	[O]
FROM
	[Options] AS [O]
INNER JOIN (
	SELECT
		[iID]
	FROM
		@t
) AS [A]
ON
	[O].[ID#] = [A].[iID]
--WHERE 
--	[Model No] = @mn
;

SELECT
	*
FROM
	[Options]
WHERE 
	[Model No] = @mn
ORDER BY
	[Description]
;

ROLLBACK;
COMMIT;