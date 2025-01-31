/*
SELECT
	[S_OS1].[Quote#] AS [Parent]
	,[S_OS2].[Quote#] AS [SimTo]	
	,[S_OS1].[Model No]
	,[S_OS1].[Section]
	,[S_OS1].[Group]
	,[S_OS1].[Description]
FROM (
	SELECT
		[OS1].[Quote#]
		,[OS1].[Model No]
		,[OS1].[Section]
		,[OS1].[Group]
		,[OS1].[Description]
	FROM
		[BWSdb].[dbo].[Order Standards] [OS1] WITH (NOLOCK)
	WHERE
		([OS1].[Quote#] IS NOT NULL)
		AND ([OS1].[Model No] IS NOT NULL)
		AND ([OS1].[Section] IS NOT NULL)
		AND ([OS1].[Group] IS NOT NULL)
		AND ([OS1].[Description] IS NOT NULL)

) AS [S_OS1]
INNER JOIN (
	SELECT
		[OS2].[Quote#]
		,[OS2].[Model No]
		,[OS2].[Section]
		,[OS2].[Group]
		,[OS2].[Description]
	FROM
		[BWSdb].[dbo].[Order Standards] [OS2] WITH (NOLOCK)
	WHERE
		([OS2].[Quote#] IS NOT NULL)
		AND ([OS2].[Model No] IS NOT NULL)
		AND ([OS2].[Section] IS NOT NULL)
		AND ([OS2].[Group] IS NOT NULL)
		AND ([OS2].[Description] IS NOT NULL)
) AS [S_OS2]
ON
	([S_OS1].[Quote#] <> [S_OS2].[Quote#])
	AND ([S_OS1].[Model No] = [S_OS2].[Model No])
	AND ([S_OS1].[Section] = [S_OS2].[Section])
	AND ([S_OS1].[Group] = [S_OS2].[Group])
	AND ([S_OS1].[Description] = [S_OS2].[Description])



	SELECT
		[OS2].[Quote#]
		,[OS2].[Model No]
		,[OS2].[Section]
		,[OS2].[Group]
		,[OS2].[Description]
	FROM
		[BWSdb].[dbo].[Order Standards] [OS2] WITH (NOLOCK)
	WHERE
		[OS2].[Quote#] = 25373
		AND ([OS2].[Quote#] IS NOT NULL)
		AND ([OS2].[Model No] IS NOT NULL)
		AND ([OS2].[Section] IS NOT NULL)
		AND ([OS2].[Group] IS NOT NULL)
		AND ([OS2].[Description] IS NOT NULL)
*/

----------------------------------------------------------------------------

SET NOCOUNT OFF;

IF OBJECT_ID('tempdb..#SimilarQuotes') IS NOT NULL BEGIN
	DROP TABLE #SimilarQuotes;
END
CREATE TABLE #SimilarQuotes
(
	[ProductID] INT
	,[Parent] INT
	,[SimTo] INT
);

IF OBJECT_ID('tempdb..#QuotesList') IS NOT NULL BEGIN
	DROP TABLE #QuotesList;
END
CREATE TABLE #QuotesList
(
	[ID] INT IDENTITY(0, 1)
	,[Quote] INT
	,[ProductID] INT
);

IF OBJECT_ID('tempdb..#Standards') IS NOT NULL BEGIN
	DROP TABLE #Standards;
END
CREATE TABLE #Standards
(
	[Quote] INT
	,[ProductID] INT
	,[Model] NVARCHAR(MAX)
	,[Section] NVARCHAR(MAX)
	,[Group] NVARCHAR(MAX)
	,[Description] NVARCHAR(MAX)
);

IF OBJECT_ID('tempdb..#Options') IS NOT NULL BEGIN
	DROP TABLE #Options;
END
CREATE TABLE #Options
(
	[Quote] INT
	,[ProductID] INT
	,[Section] NVARCHAR(MAX)
	,[Group] NVARCHAR(MAX)
	,[Description] NVARCHAR(MAX)
	,[Qty] INT
);

IF OBJECT_ID('tempdb..#Custom') IS NOT NULL BEGIN
	DROP TABLE #Custom;
END
CREATE TABLE #Custom
(
	[Quote] INT
	,[ProductID] INT
	,[Section] NVARCHAR(MAX)
	,[Group] NVARCHAR(MAX)
	,[Description] NVARCHAR(MAX)
	,[Qty] INT
);

INSERT INTO #QuotesList ([Quote], [ProductID])
/*
SELECT
	[Quote#]
	, [ProductID]
FROM
	[BWSdb].[dbo].[Orders]
;
*/
-------
-- Test
SELECT TOP 3
	[Quote#]
	, [ProductID]
FROM
	[BWSdb].[dbo].[Orders]
ORDER BY
	[Quote#] DESC
;
---------
	
DECLARE @i INT;
DECLARE @j INT;
DECLARE @c INT;

SELECT
	@i = 0
	, @c = COUNT(*) 
FROM
	#QuotesList
;

WHILE @i < @c BEGIN

	SELECT @j = [Quote] FROM #QuotesList WHERE [ID] = @i;
	PRINT 'Quote ''' + CAST(@j AS NVARCHAR(MAX)) + '''';

	DELETE FROM #Standards;
	INSERT INTO #Standards ([Quote], [ProductID], [Model], [Section], [Group], [Description])
	SELECT [Q].[Quote], [Q].[ProductID], [S].[Model No], [S].[Section], [S].[Group], [S].[Description]
	FROM [BWSdb].[dbo].[Order Standards] [S] WITH (NOLOCK)
	LEFT JOIN #QuotesList [Q]
	ON [S].[Quote#] = [Q].[Quote]
	WHERE [Q].[ID] = @i;

	DELETE FROM #Options;
	INSERT INTO #Options ([Quote], [ProductID], [Section], [Group], [Description], [Qty])
	SELECT [Q].[Quote], [Q].[ProductID], [SL].[SpecSection], [SL].[SpecGroup], [O].[Description], [O].[Qty]
	FROM [BWSdb].[dbo].[Order Options] [O] WITH (NOLOCK)
	LEFT JOIN [BWSdb].[dbo].[Order Options_SpecLines] [SL] WITH (NOLOCK)
	ON [O].[ID] = [SL].[OrderOptionID]
	INNER JOIN #QuotesList [Q]
	ON [O].[Quote#] = [Q].[Quote]
	WHERE [Q].[ID] = @i;

	DELETE FROM #Custom;
	INSERT INTO #Custom ([Quote], [ProductID], [Section], [Group], [Description], [Qty])
	SELECT [Q].[Quote], [Q].[ProductID], [SL].[SpecSection], [SL].[SpecGroup], [C].[Description], [C].[Qty]
	FROM [BWSdb].[dbo].[Custom Work] [C] WITH (NOLOCK)
	LEFT JOIN [BWSdb].[dbo].[Custom Work_SpecLines] [SL] WITH (NOLOCK)
	ON [C].[ID] = [SL].[NPOID]
	INNER JOIN #QuotesList [Q]
	ON [C].[Quote#] = [Q].[Quote]
	WHERE [Q].[ID] = @i;

	INSERT INTO #SimilarQuotes ([ProductID], [Parent], [SimTo])
	SELECT [S].[ProductID], [S].[Quote], [S].[Quote#]
	FROM (
		SELECT [S1].[ProductID], [S1].[Quote], [S2].[Quote#]
		FROM #Standards [S1]
		INNER JOIN [BWSdb].[dbo].[Order Standards] [S2] WITH (NOLOCK)
		ON 
			([S1].[Quote] <> [S2].[Quote#])
			AND ([S1].[Model] = [S2].[Model No])
			AND ([S1].[Section] = [S2].[Section])
			AND ([S1].[Group] = [S2].[Group])
			AND ([S1].[Description] = [S2].[Description])
		GROUP BY 
			[S1].[ProductID]
			,[S1].[Quote]
			,[S2].[Quote#]
	) AS [S]
	INNER JOIN (
		SELECT [O1].[ProductID], [O1].[Quote], [O2].[Quote#]
		FROM #Options [O1]
		INNER JOIN [BWSdb].[dbo].[Order Options] [O2] WITH (NOLOCK)
		ON 
			([O1].[Quote] <> [O2].[Quote#])
			AND ([O1].[Description] = [O2].[Description])
			AND ([O1].[Qty] = [O2].[Qty])
		LEFT JOIN [BWSdb].[dbo].[Order Options_SpecLines] [SL] WITH (NOLOCK)
		ON 
			([O2].[ID] = [SL].[OrderOptionID])
			AND ([O1].[Section] = [SL].[SpecSection])
			AND ([O1].[Group] = [SL].[SpecGroup])
		GROUP BY 
			[O1].[ProductID]
			,[O1].[Quote]
			,[O2].[Quote#]
	) AS [O]
	ON
		[S].[Quote] = [O].[Quote]
	
	INNER JOIN (
		SELECT [C1].[ProductID], [C1].[Quote], [C2].[Quote#]
		FROM #Custom [C1]
		INNER JOIN [BWSdb].[dbo].[Custom Work] [C2] WITH (NOLOCK)
		ON 
			([C1].[Quote] <> [C2].[Quote#])
			AND ([C1].[Description] = [C2].[Description])
			AND ([C1].[Qty] = [C2].[Qty])
		INNER JOIN [BWSdb].[dbo].[Custom Work_SpecLines] [CL] WITH (NOLOCK)
		ON 
			([C2].[ID] = [CL].[NPOID])
			AND ([C1].[Section] = [CL].[SpecSection])
			AND ([C1].[Group] = [CL].[SpecGroup])
			AND ([C1].[Description] = [CL].[Description])
		GROUP BY 
			[C1].[ProductID]
			,[C1].[Quote]
			,[C2].[Quote#]
	) AS [C]
	ON
		[S].[Quote] = [C].[Quote]
	
	GROUP BY 
		[S].[ProductID]
		,[S].[Quote]
		,[S].[Quote#]


	SELECT @i = @i + 1;

END

SELECT
	@i AS [@i]
	, @j AS [@j]
	, @c AS [@c]

	
SELECT
	'S' AS [T]
	, *
FROM
	#Standards
;	
SELECT
	'O' AS [T]
	, *
FROM
	#Options
;	
SELECT
	'C' AS [T]
	, *
FROM
	#Custom
;
SELECT
	'QL' AS [T]
	, *
FROM
	#QuotesList
;
SELECT
	'SimQs' AS [T]
	, *
FROM
	#SimilarQuotes
;
SELECT
	'SimQs' AS [T]
	, [SQ].*
	, [P].[Model No]
FROM
	#SimilarQuotes [SQ]
INNER JOIN
	[BWSdb].[dbo].[Products] [P]
ON
	[SQ].[ProductID] = [P].[IDTrailer]
;