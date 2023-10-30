USE BWSdb
GO


-- Correcting the [Order Standards] with new [Standards]

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

SELECT
	*
FROM
	[Order Standards]
WHERE 
	[Model No] = @mn
ORDER BY
	[SortGv2]
	,[SortSev2]
;


BEGIN TRAN;


DELETE FROM
	[Order Standards]
WHERE
	[Model No] = @mn

INSERT INTO [Order Standards]
([Quote#]
           ,[WO#]
           ,[Model No]
           ,[Standard No]
           ,[Group]
           ,[Section]
           ,[Description]
           ,[Start Date]
           ,[End Date]
           ,[SortG]
           ,[SortSe]
           ,[SortGv2]
           ,[SortSev2])
SELECT
	29317
           ,NULL
           ,[Model No]
           ,[Standard No]
           ,[Group]
           ,[Section]
           ,[Description]
           ,[Start Date]
           ,[End Date]
           ,[SortG]
           ,[SortSe]
           ,[SortGv2]
           ,[SortSev2]
FROM
	[Standards]
WHERE
	[Standards].[Model No] = @mn

SELECT
	*
FROM
	[Order Standards]
WHERE 
	[Model No] = @mn
ORDER BY
	[SortGv2]
	,[SortSev2]
;

ROLLBACK;
COMMIT;

















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
	[Order Standards]
WHERE 
	[Model No] = @mn
ORDER BY
	[Description]
;

DECLARE @t AS TABLE ([ID] INT IDENTITY(0, 1), [IDOS] INT);
INSERT INTO @t ([IDOS])
SELECT 
	[IDOS]
FROM (
	SELECT
		[IDOS]
		,ROW_NUMBER() OVER(
			PARTITION BY
				[Description]
			ORDER BY
				[IDOS]
		) AS [RN]
	FROM
		[Order Standards]
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
	[Order Standards] AS [S]
INNER JOIN (
	SELECT
		[IDOS]
	FROM
		@t
) AS [A]
ON
	[S].[IDOS] = [A].[IDOS]
--WHERE 
--	[Model No] = @mn
;

INSERT INTO
	[Order Standards]
([Quote#]
           ,[WO#]
           ,[Model No]
           ,[Standard No]
           ,[Group]
           ,[Section]
           ,[Description]
           ,[Start Date]
           ,[End Date]
           ,[SortG]
           ,[SortSe]
           ,[SortGv2]
           ,[SortSev2])
SELECT
	([Quote#]
           ,[WO#]
           ,[Model No]
           ,[Standard No]
           ,[Group]
           ,[Section]
           ,[Description]
           ,[Start Date]
           ,[End Date]
           ,[SortG]
           ,[SortSe]
           ,[SortGv2]
           ,[SortSev2])
FROM
	[Standards]
INNER JOIN
	[]
;

SELECT
	*
FROM
	[Order Standards]
WHERE 
	[Model No] = @mn
ORDER BY
	[Description]
;

ROLLBACK;
COMMIT;