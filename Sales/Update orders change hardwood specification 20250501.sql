

/*

	Script to scan Ordered quotes to change the wood used in [Standards], [Options], and [Custom Work]
	The script starts at WO 10017446 and gathers all WOs in Production after it's [Prod Date].
	The units must be TAGS (matches class of WO10017446), and use '1 3/4 Hardwood'.
	The wood is changed to '1 1/2 Hardwood'.

	Change @execute to allow this script to update [Orders], otherwise it will perform a select.
	
*/

DECLARE @notesMsg AS NVARCHAR(MAX) = CHAR(10) + '2025-05-02 - Avery Briggs - Due to supply contsraints, replaced "1 3/4 in. Hardwood" with "1 1/2 in Hardwood".'
DECLARE @out0 AS NVARCHAR(MAX) = '1-3/4 in. Hardwood'
DECLARE @out1 AS NVARCHAR(MAX) = '1 3/4 in. Hardwood'
DECLARE @in AS NVARCHAR(MAX) = '1 1/2 in. Hardwood'

DECLARE @execute AS BIT = 0;
DECLARE @j AS INT = 10017446;
DECLARE @jClass NVARCHAR(250);
DECLARE @jOrderDate DATE;
DECLARE @jProdDate DATE;

SELECT
	@jClass = [Pr].[Class],
	@jOrderDate = [O].[Order Date],
	@jProdDate = ISNULL([P].[Prod Date 1], [P].[Prod Date 2])
FROM
	[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
INNER JOIN
	[BWSdb].[dbo].[Products] [Pr] WITH (NOLOCK)
ON
	[O].[ProductID] = [Pr].[IDTrailer]
INNER JOIN
	[BWSdb].[dbo].[dtProductionSchedule] [P] WITH (NOLOCK)
ON
	[O].[WO#] = [P].[WO#]
WHERE
	[O].[WO#] = @j
;

SELECT
	@j AS [Last Allowed WO],
	@jClass AS [ProdClass],
	@jOrderDate AS [OrderDate],
	@jProdDate AS [ProdDate],
	'Find Quotes that use "' + @out0 + '" or "' + @out1 + '" and replace them with "' + @in + '" AFTER wo "' + CAST(@j AS NVARCHAR(250)) + '"' AS [Action]


DECLARE @quotesToChange TABLE (
	[ID] INT IDENTITY(0, 1)
	,[Action] NVARCHAR(MAX)
	,[Table] NVARCHAR(MAX)
	,[ProdDate] DATE
	,[WO] INT
	,[Quote] INT
	,[StandardNo] NVARCHAR(MAX)
	,[Description] NVARCHAR(MAX)
	,[OOFL_Desc] NVARCHAR(MAX)
	,[OOSL_Desc] NVARCHAR(MAX)
	,[CWFL_Desc] NVARCHAR(MAX)
	,[CWSL_Desc] NVARCHAR(MAX)
)

-- IF USING ORDER DATE NEED TO COPY INSERT BLOCK HERE
-- OTHERWISE USING PROD DATES
/*

----------------------------------------------------------------------------------------
-- Past Order Date
SELECT
	'After Order Date "' + CAST(@jOrderDate AS NVARCHAR(250)) + '"' AS [Action],
	'Standards' AS [Table],
	[OPSrc].[Order Date],
	[OS].[WO#] AS [WO],
	[OS].[Quote#] AS [Quote],
	[OS].[Standard No],
	[OS].[Description],
	NULL AS [OOFL_Desc],
	NULL AS [OOSL_Desc],
	NULL AS [CWFL_Desc],
	NULL AS [CWSL_Desc]
FROM (
	SELECT
		[O].*,
		[P].[Class]
	FROM
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	INNER JOIN
		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
	ON
		[O].[ProductID] = [P].[IDTrailer]
	WHERE
		(@jOrderDate < [O].[Order Date])
		AND ([P].[Class] = @jClass)
) AS [OPSrc]
INNER JOIN
	[BWSdb].[dbo].[Order Standards] [OS] WITH (NOLOCK)
ON
	[OPSrc].[WO#] = [OS].[WO#]
WHERE 
	(([OS].[Description] LIKE '%3/4%') AND ([OS].[Description] LIKE '%Hardwood%') OR ([OS].[Description] LIKE '%1 3/4 in. Hardwood%')) 

	UNION

SELECT
	'After Order Date "' + CAST(@jOrderDate AS NVARCHAR(250)) + '"',
	'Order Options FL' AS [T],
	[OPSrc].[Order Date],
	[OOFL].[WO#],
	[OOFL].[Quote#],
	NULL,
	NULL,
	[OOFL].[Description] AS [OOFL_Desc],
	NULL AS [OOSL_Desc],
	NULL AS [CWFL_Desc],
	NULL AS [CWSL_Desc]
FROM (
	SELECT
		[O].*,
		[P].[Class]
	FROM
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	INNER JOIN
		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
	ON
		[O].[ProductID] = [P].[IDTrailer]
	WHERE
		(@jOrderDate < [O].[Order Date])
		AND ([P].[Class] = @jClass)
) AS [OPSrc]
LEFT JOIN
	[BWSdb].[dbo].[Order Options_FactoryLines] [OOFL] WITH (NOLOCK)
ON
	[OPSrc].[WO#] = [OOFL].[WO#]
WHERE 
	(([OOFL].[Description] LIKE '%3/4%') AND ([OOFL].[Description] LIKE '%Hardwood%') OR ([OOFL].[Description] LIKE '%1 3/4 in. Hardwood%'))

	UNION

SELECT
	'After Order Date "' + CAST(@jOrderDate AS NVARCHAR(250)) + '"',
	'Order Options SL' AS [T],
	[OPSrc].[Order Date],
	[OOSL].[WO#],
	[OOSL].[Quote#],
	NULL,
	NULL,
	NULL AS [OOFL_Desc],
	[OOSL].[Description] AS [OOSL_Desc],
	NULL AS [CWFL_Desc],
	NULL AS [CWSL_Desc]
FROM (
	SELECT
		[O].*,
		[P].[Class]
	FROM
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	INNER JOIN
		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
	ON
		[O].[ProductID] = [P].[IDTrailer]
	WHERE
		(@jOrderDate < [O].[Order Date])
		AND ([P].[Class] = @jClass)
) AS [OPSrc]
LEFT JOIN
	[BWSdb].[dbo].[Order Options_SpecLines] [OOSL] WITH (NOLOCK)
ON
	[OPSrc].[WO#] = [OOSL].[WO#]
WHERE 
	(([OOSL].[Description] LIKE '%3/4%') AND ([OOSL].[Description] LIKE '%Hardwood%') OR ([OOSL].[Description] LIKE '%1 3/4 in. Hardwood%'))

	UNION

SELECT
	'After Order Date "' + CAST(@jOrderDate AS NVARCHAR(250)) + '"',
	'Custom Work FL' AS [T],
	[OPSrc].[Order Date],
	[CWFL].[WO#],
	[CWFL].[Quote#],
	NULL,
	NULL,
	NULL AS [OOFL_Desc],
	NULL AS [OOSL_Desc],
	[CWFL].[Description] AS [CWFL_DESC],
	NULL AS [CWSL_DESC]
FROM (
	SELECT
		[O].*,
		[P].[Class]
	FROM
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	INNER JOIN
		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
	ON
		[O].[ProductID] = [P].[IDTrailer]
	WHERE
		(@jOrderDate < [O].[Order Date])
		AND ([P].[Class] = @jClass)
) AS [OPSrc]
LEFT JOIN
	[BWSdb].[dbo].[Custom Work] [CWFL] WITH (NOLOCK)
ON
	[OPSrc].[WO#] = [CWFL].[WO#]
WHERE 
	(([CWFL].[Description] LIKE '%3/4%') AND ([CWFL].[Description] LIKE '%Hardwood%') OR ([CWFL].[Description] LIKE '%1 3/4 in. Hardwood%'))

	UNION

SELECT
	'After Order Date "' + CAST(@jOrderDate AS NVARCHAR(250)) + '"',
	'Custom Work SL' AS [T],
	[OPSrc].[Order Date],
	[CWSL].[WO#],
	[CWSL].[Quote#],
	NULL,
	NULL,
	NULL AS [OOFL_Desc],
	NULL AS [OOSL_Desc],
	NULL AS [CWFL_DESC],
	[CWSL].[Description] AS [CWSL_DESC]
FROM (
	SELECT
		[O].*,
		[P].[Class]
	FROM
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	INNER JOIN
		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
	ON
		[O].[ProductID] = [P].[IDTrailer]
	WHERE
		(@jOrderDate < [O].[Order Date])
		AND ([P].[Class] = @jClass)
) AS [OPSrc]
LEFT JOIN
	[BWSdb].[dbo].[Custom Work_SpecLines] [CWSL] WITH (NOLOCK)
ON
	[OPSrc].[WO#] = [CWSL].[WO#]
WHERE 
	(([CWSL].[Description] LIKE '%3/4%') AND ([CWSL].[Description] LIKE '%Hardwood%') OR ([CWSL].[Description] LIKE '%1 3/4 in. Hardwood%'))
ORDER BY
	[Quote]
;
*/

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

-- Past Prod Date

INSERT INTO @quotesToChange (
	[Action]
	,[Table]
	,[ProdDate]
	,[WO]
	,[Quote]
	,[StandardNo]
	,[Description]
	,[OOFL_Desc]
	,[OOSL_Desc]
	,[CWFL_Desc]
	,[CWSL_Desc]
)
SELECT
	'After Prod Date "' + CAST(@jprodDate AS NVARCHAR(250)) + '"' AS [Action],
	'Standards' AS [Table],
	[OPSrc].[ProdDate],
	[OS].[WO#] AS [WO],
	[OS].[Quote#] AS [Quote],
	[OS].[Standard No],
	[OS].[Description],
	NULL AS [OOFL_Desc],
	NULL AS [OOSL_Desc],
	NULL AS [CWFL_Desc],
	NULL AS [CWSL_Desc]
FROM (
	SELECT
		[O].*,
		[P].[Class],
		ISNULL([Pr].[Prod Date 1], [Pr].[Prod Date 2]) AS [ProdDate]
	FROM
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	INNER JOIN
		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
	ON
		[O].[ProductID] = [P].[IDTrailer]
	INNER JOIN
		[BWSdb].[dbo].[dtProductionSchedule] [Pr] WITH (NOLOCK)
	ON
		[O].[Quote#] = [Pr].[Quote#]
	WHERE
		(@jProdDate < ISNULL([Pr].[Prod Date 1], [Pr].[Prod Date 2]))
		AND ([P].[Class] = @jClass)
) AS [OPSrc]
INNER JOIN
	[BWSdb].[dbo].[Order Standards] [OS] WITH (NOLOCK)
ON
	[OPSrc].[WO#] = [OS].[WO#]
WHERE 
	(([OS].[Description] LIKE '%3/4%') AND ([OS].[Description] LIKE '%Hardwood%') OR ([OS].[Description] LIKE '%1 3/4 in. Hardwood%')) 

	UNION

SELECT
	'After Prod Date "' + CAST(@jprodDate AS NVARCHAR(250)) + '"',
	'Order Options FL' AS [T],
	[OPSrc].[ProdDate],
	[OOFL].[WO#],
	[OOFL].[Quote#],
	NULL,
	NULL,
	[OOFL].[Description] AS [OOFL_Desc],
	NULL AS [OOSL_Desc],
	NULL AS [CWFL_Desc],
	NULL AS [CWSL_Desc]
FROM (
	SELECT
		[O].*,
		[P].[Class],
		ISNULL([Pr].[Prod Date 1], [Pr].[Prod Date 2]) AS [ProdDate]
	FROM
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	INNER JOIN
		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
	ON
		[O].[ProductID] = [P].[IDTrailer]
	INNER JOIN
		[BWSdb].[dbo].[dtProductionSchedule] [Pr] WITH (NOLOCK)
	ON
		[O].[Quote#] = [Pr].[Quote#]
	WHERE
		(@jProdDate < ISNULL([Pr].[Prod Date 1], [Pr].[Prod Date 2]))
		AND ([P].[Class] = @jClass)
) AS [OPSrc]
LEFT JOIN
	[BWSdb].[dbo].[Order Options_FactoryLines] [OOFL] WITH (NOLOCK)
ON
	[OPSrc].[WO#] = [OOFL].[WO#]
WHERE 
	(([OOFL].[Description] LIKE '%3/4%') AND ([OOFL].[Description] LIKE '%Hardwood%') OR ([OOFL].[Description] LIKE '%1 3/4 in. Hardwood%'))

	UNION

SELECT
	'After Prod Date "' + CAST(@jprodDate AS NVARCHAR(250)) + '"',
	'Order Options SL' AS [T],
	[OPSrc].[ProdDate],
	[OOSL].[WO#],
	[OOSL].[Quote#],
	NULL,
	NULL,
	NULL AS [OOFL_Desc],
	[OOSL].[Description] AS [OOSL_Desc],
	NULL AS [CWFL_Desc],
	NULL AS [CWSL_Desc]
FROM (
	SELECT
		[O].*,
		[P].[Class],
		ISNULL([Pr].[Prod Date 1], [Pr].[Prod Date 2]) AS [ProdDate]
	FROM
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	INNER JOIN
		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
	ON
		[O].[ProductID] = [P].[IDTrailer]
	INNER JOIN
		[BWSdb].[dbo].[dtProductionSchedule] [Pr] WITH (NOLOCK)
	ON
		[O].[Quote#] = [Pr].[Quote#]
	WHERE
		(@jProdDate < ISNULL([Pr].[Prod Date 1], [Pr].[Prod Date 2]))
		AND ([P].[Class] = @jClass)
) AS [OPSrc]
LEFT JOIN
	[BWSdb].[dbo].[Order Options_SpecLines] [OOSL] WITH (NOLOCK)
ON
	[OPSrc].[WO#] = [OOSL].[WO#]
WHERE 
	(([OOSL].[Description] LIKE '%3/4%') AND ([OOSL].[Description] LIKE '%Hardwood%') OR ([OOSL].[Description] LIKE '%1 3/4 in. Hardwood%'))

	UNION

SELECT
	'After Prod Date "' + CAST(@jprodDate AS NVARCHAR(250)) + '"',
	'Custom Work FL' AS [T],
	[OPSrc].[ProdDate],
	[CWFL].[WO#],
	[CWFL].[Quote#],
	NULL,
	NULL,
	NULL AS [OOFL_Desc],
	NULL AS [OOSL_Desc],
	[CWFL].[Description] AS [CWFL_DESC],
	NULL AS [CWSL_DESC]
FROM (
	SELECT
		[O].*,
		[P].[Class],
		ISNULL([Pr].[Prod Date 1], [Pr].[Prod Date 2]) AS [ProdDate]
	FROM
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	INNER JOIN
		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
	ON
		[O].[ProductID] = [P].[IDTrailer]
	INNER JOIN
		[BWSdb].[dbo].[dtProductionSchedule] [Pr] WITH (NOLOCK)
	ON
		[O].[Quote#] = [Pr].[Quote#]
	WHERE
		(@jProdDate < ISNULL([Pr].[Prod Date 1], [Pr].[Prod Date 2]))
		AND ([P].[Class] = @jClass)
) AS [OPSrc]
LEFT JOIN
	[BWSdb].[dbo].[Custom Work] [CWFL] WITH (NOLOCK)
ON
	[OPSrc].[WO#] = [CWFL].[WO#]
WHERE 
	(([CWFL].[Description] LIKE '%3/4%') AND ([CWFL].[Description] LIKE '%Hardwood%') OR ([CWFL].[Description] LIKE '%1 3/4 in. Hardwood%'))

	UNION

SELECT
	'After Prod Date "' + CAST(@jprodDate AS NVARCHAR(250)) + '"',
	'Custom Work SL' AS [T],
	[OPSrc].[ProdDate],
	[CWSL].[WO#],
	[CWSL].[Quote#],
	NULL,
	NULL,
	NULL AS [OOFL_Desc],
	NULL AS [OOSL_Desc],
	NULL AS [CWFL_DESC],
	[CWSL].[Description] AS [CWSL_DESC]
FROM (
	SELECT
		[O].*,
		[P].[Class],
		ISNULL([Pr].[Prod Date 1], [Pr].[Prod Date 2]) AS [ProdDate]
	FROM
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	INNER JOIN
		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
	ON
		[O].[ProductID] = [P].[IDTrailer]
	INNER JOIN
		[BWSdb].[dbo].[dtProductionSchedule] [Pr] WITH (NOLOCK)
	ON
		[O].[Quote#] = [Pr].[Quote#]
	WHERE
		(@jProdDate < ISNULL([Pr].[Prod Date 1], [Pr].[Prod Date 2]))
		AND ([P].[Class] = @jClass)
) AS [OPSrc]
LEFT JOIN
	[BWSdb].[dbo].[Custom Work_SpecLines] [CWSL] WITH (NOLOCK)
ON
	[OPSrc].[WO#] = [CWSL].[WO#]
WHERE 
	(([CWSL].[Description] LIKE '%3/4%') AND ([CWSL].[Description] LIKE '%Hardwood%') OR ([CWSL].[Description] LIKE '%1 3/4 in. Hardwood%'))
ORDER BY
	[Quote]
;


--  Begin Updates
IF @execute = 1 BEGIN
	BEGIN TRAN;

		SELECT
			'Before OS' AS [T],
			*
		FROM
			[BWSdb].[dbo].[Order Standards] [OS]
		INNER JOIN
			@quotesToChange [qtc]
		ON
			([OS].[Quote#] = [qtc].[Quote])
			AND ([OS].[Standard No] = [qtc].[StandardNo])
		WHERE
			[Table] = 'Standards'
		;

		SELECT
			'Before O' AS [T],
			*
		FROM
			[BWSdb].[dbo].[Orders] [O]
		INNER JOIN
			@quotesToChange [qtc]
		ON
			([O].[Quote#] = [qtc].[Quote])
		WHERE
			[Table] = 'Standards'
		;

		UPDATE
			[BWSdb].[dbo].[Order Standards]
		SET
			[Description] = REPLACE(REPLACE([OS].[Description], @out0, @in), @out1, @in)
		FROM
			[BWSdb].[dbo].[Order Standards] [OS]
		INNER JOIN
			@quotesToChange [qtc]
		ON
			([OS].[Quote#] = [qtc].[Quote])
			AND ([OS].[Standard No] = [qtc].[StandardNo])
		WHERE
			[Table] = 'Standards'
		;

		UPDATE
			[BWSdb].[dbo].[Orders]
		SET
			[Notes] = ISNULL([Notes], '') + @notesMsg
		FROM
			[BWSdb].[dbo].[Orders] [O]
		INNER JOIN
			@quotesToChange [qtc]
		ON
			([O].[Quote#] = [qtc].[Quote])
		;

		SELECT
			'After OS' AS [T],
			*
		FROM
			[BWSdb].[dbo].[Order Standards] [OS]
		INNER JOIN
			@quotesToChange [qtc]
		ON
			([OS].[Quote#] = [qtc].[Quote])
			AND ([OS].[Standard No] = [qtc].[StandardNo])
		WHERE
			[Table] = 'Standards'
		;

		SELECT
			'After O' AS [T],
			*
		FROM
			[BWSdb].[dbo].[Orders] [O]
		INNER JOIN
			@quotesToChange [qtc]
		ON
			([O].[Quote#] = [qtc].[Quote])
		WHERE
			[Table] = 'Standards'
		;

END
ELSE BEGIN 
	
	SELECT
		'RECORDS TO UPDATE' AS [T],
		[qtc].*,
		[O].[Notes],
		ISNULL([Notes], '') + @notesMsg
	FROM
		[BWSdb].[dbo].[Order Standards] [OS]
	INNER JOIN
		@quotesToChange [qtc]
	ON
		([OS].[Quote#] = [qtc].[Quote])
		AND ([OS].[Standard No] = [qtc].[StandardNo])
	INNER JOIN
		[BWSdb].[dbo].[Orders] [O]
	ON
		[O].[Quote#] = [qtc].[Quote]
	WHERE
		[Table] = 'Standards'
	;

	SELECT 'EXECUTION NOT ENABLED' AS [T]
END


	ROLLBACK;
	COMMIT;