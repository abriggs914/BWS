

-- Review the frequency of wording for options
-- 2024-12-11

SET NOCOUNT ON;

DECLARE @tq INT = NULL
DECLARE @tp NVARCHAR(MAX) = NULL
--SELECT @t6q = 26121;
--SELECT @tq = 25924
--SELECT @tp = 'mudflaps'

IF @tq IS NOT NULL BEGIN
	SELECT
		*
	FROM
		[BWSdb].[dbo].[Order Options]
	WHERE
		[Quote#] = @tq
	;

	SELECT
		*
	FROM
		[BWSdb].[dbo].[Order Options_FactoryLines]
	WHERE
		[Quote#] = @tq
	;

	SELECT
		*
	FROM
		[BWSdb].[dbo].[Order Options_SpecLines]
	WHERE
		[Quote#] = @tq
	;
END

DECLARE @descFreq AS TABLE ([ID] INT IDENTITY(0, 1), [Desc] NVARCHAR(MAX), [Freq] INT, [FirstQ] INT, [LastQ] INT);
DECLARE @wordFreq AS TABLE ([ID] INT IDENTITY(0, 1), [Word] NVARCHAR(MAX), [Freq] INT, [FirstDFID] INT, [LastDFID] INT);
DECLARE @spltFreq AS TABLE ([ID] INT IDENTITY(0, 1), [Split] NVARCHAR(MAX), [Freq] INT);
DECLARE @p NVARCHAR(MAX);
DECLARE @sI NVARCHAR(MAX) = '.-\/"';
DECLARE @pf INT;
DECLARE @dfID0 INT;
DECLARE @dfID1 INT;
DECLARE @i INT;
DECLARE @c INT;

IF @tp IS NOT NULL BEGIN
	SELECT
		LTRIM(RTRIM([BWSdb].[dbo].[fn_RemoveSpecials]([Description], @sI, DEFAULT, DEFAULT)))
		,SUM([SubFreq]) AS [Freq]
		,MIN([FirstQ]) AS [FirstQ]
		,MIN([LastQ]) AS [LastQ]
	FROM (
		SELECT
			[Description]
			,COUNT([Description]) AS [SubFreq]
			,MIN([OO].[Quote#]) AS [FirstQ]
			,MAX([OO].[Quote#]) AS [LastQ]
		FROM
			[BWSdb].[dbo].[Order Options] [OO]
		WHERE
			(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN [OO].[Description] LIKE '%' + @tp + '%' THEN 1 ELSE 0 END) END) = 1
			--(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN ([FL].[Description] LIKE '%' + @tp + '%' AND LEN([FL].[Description]) = LEN(@tp)) THEN 1 ELSE 0 END) END) = 1
		GROUP BY
			[Description]
		UNION ALL
		SELECT
			[Description]
			,COUNT([Description]) AS [SubFreq]
			,MIN([FL].[Quote#]) AS [FirstQ]
			,MAX([FL].[Quote#]) AS [LastQ]
		FROM
			[BWSdb].[dbo].[Order Options_FactoryLines] [FL]
		WHERE
			(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN [FL].[Description] LIKE '%' + @tp + '%' THEN 1 ELSE 0 END) END) = 1
			--(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN ([FL].[Description] LIKE '%' + @tp + '%' AND LEN([FL].[Description]) = LEN(@tp)) THEN 1 ELSE 0 END) END) = 1
		GROUP BY
			[Description]
		UNION ALL
		SELECT
			[SpecDescription]
			,COUNT([SpecDescription])
			,MIN([FL].[Quote#]) AS [FirstQ]
			,MAX([FL].[Quote#]) AS [LastQ]
		FROM
			[BWSdb].[dbo].[Order Options_FactoryLines] [FL]
		WHERE
			(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN [FL].[SpecDescription] LIKE '%' + @tp + '%' THEN 1 ELSE 0 END) END) = 1
			--(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN ([FL].[Description] LIKE '%' + @tp + '%' AND LEN([FL].[Description]) = LEN(@tp)) THEN 1 ELSE 0 END) END) = 1
		GROUP BY
			[SpecDescription]
		UNION ALL
		SELECT
			[Description]
			,COUNT([Description])
			,MIN([SL].[Quote#]) AS [FirstQ]
			,MAX([SL].[Quote#]) AS [LastQ]
		FROM
			[BWSdb].[dbo].[Order Options_SpecLines] [SL]
		WHERE
			(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN [SL].[Description] LIKE '%' + @tp + '%' THEN 1 ELSE 0 END) END) = 1
			--(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN ([FL].[Description] LIKE '%' + @tp + '%' AND LEN([FL].[Description]) = LEN(@tp)) THEN 1 ELSE 0 END) END) = 1
		GROUP BY
			[Description]
		UNION ALL
		SELECT
			[SpecDescription]
			,COUNT([SpecDescription])
			,MIN([SL].[Quote#]) AS [FirstQ]
			,MAX([SL].[Quote#]) AS [LastQ]
		FROM
			[BWSdb].[dbo].[Order Options_SpecLines] [SL]
		WHERE
			(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN [SL].[SpecDescription] LIKE '%' + @tp + '%' THEN 1 ELSE 0 END) END) = 1
			--(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN ([FL].[Description] LIKE '%' + @tp + '%' AND LEN([FL].[Description]) = LEN(@tp)) THEN 1 ELSE 0 END) END) = 1
		GROUP BY
			[SpecDescription]

		-- Stargate

		UNION ALL

		SELECT
			[Description]
			,COUNT([Description]) AS [SubFreq]
			,MIN(CAST(RIGHT([OO2].[SGQuote], 6) AS INT)) AS [FirstQ]
			,MAX(CAST(RIGHT([OO2].[SGQuote], 6) AS INT)) AS [LastQ]
		FROM
			[BWSdb].[dbo].[Order OptionsV2] [OO2]
		WHERE
			(CASE 
				WHEN @tp IS NULL THEN 1 
				ELSE (CASE
					WHEN [OO2].[Description] LIKE '%' + @tp + '%' THEN 1
					ELSE 0
				END)
			END) = 1
			--(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN ([FL].[Description] LIKE '%' + @tp + '%' AND LEN([FL].[Description]) = LEN(@tp)) THEN 1 ELSE 0 END) END) = 1
		GROUP BY
			[Description]
		UNION ALL
		SELECT
			[Description]
			,COUNT([Description]) AS [SubFreq]
			,MIN(CAST(RIGHT([FL].[SGQuote], 6) AS INT)) AS [FirstQ]
			,MAX(CAST(RIGHT([FL].[SGQuote], 6) AS INT)) AS [LastQ]
		FROM
			[BWSdb].[dbo].[Order OptionsV2_FactoryLines] [FL]
		WHERE
			(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN [FL].[Description] LIKE '%' + @tp + '%' THEN 1 ELSE 0 END) END) = 1
			--(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN ([FL].[Description] LIKE '%' + @tp + '%' AND LEN([FL].[Description]) = LEN(@tp)) THEN 1 ELSE 0 END) END) = 1
		GROUP BY
			[Description]
		UNION ALL
		SELECT
			[SpecDescription]
			,COUNT([SpecDescription])
			,MIN(CAST(RIGHT([FL].[SGQuote], 6) AS INT)) AS [FirstQ]
			,MAX(CAST(RIGHT([FL].[SGQuote], 6) AS INT)) AS [LastQ]
		FROM
			[BWSdb].[dbo].[Order OptionsV2_FactoryLines] [FL]
		WHERE
			(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN [FL].[SpecDescription] LIKE '%' + @tp + '%' THEN 1 ELSE 0 END) END) = 1
			--(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN ([FL].[Description] LIKE '%' + @tp + '%' AND LEN([FL].[Description]) = LEN(@tp)) THEN 1 ELSE 0 END) END) = 1
		GROUP BY
			[SpecDescription]
		UNION ALL
		SELECT
			[Description]
			,COUNT([Description])
			,MIN(CAST(RIGHT([SL].[SGQuote], 6) AS INT)) AS [FirstQ]
			,MAX(CAST(RIGHT([SL].[SGQuote], 6) AS INT)) AS [LastQ]
		FROM
			[BWSdb].[dbo].[Order OptionsV2_SpecLines] [SL]
		WHERE
			(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN [SL].[Description] LIKE '%' + @tp + '%' THEN 1 ELSE 0 END) END) = 1
			--(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN ([FL].[Description] LIKE '%' + @tp + '%' AND LEN([FL].[Description]) = LEN(@tp)) THEN 1 ELSE 0 END) END) = 1
		GROUP BY
			[Description]
		UNION ALL
		SELECT
			[SpecDescription]
			,COUNT([SpecDescription])
			,MIN(CAST(RIGHT([SL].[SGQuote], 6) AS INT)) AS [FirstQ]
			,MAX(CAST(RIGHT([SL].[SGQuote], 6) AS INT)) AS [LastQ]
		FROM
			[BWSdb].[dbo].[Order OptionsV2_SpecLines] [SL]
		WHERE
			(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN [SL].[SpecDescription] LIKE '%' + @tp + '%' THEN 1 ELSE 0 END) END) = 1
			--(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN ([FL].[Description] LIKE '%' + @tp + '%' AND LEN([FL].[Description]) = LEN(@tp)) THEN 1 ELSE 0 END) END) = 1
		GROUP BY
			[SpecDescription]

	) AS [Src]
	GROUP BY
		LTRIM(RTRIM([BWSdb].[dbo].[fn_RemoveSpecials]([Description], @sI, DEFAULT, DEFAULT)))
	;
END


INSERT INTO @descFreq ([Desc], [Freq], [FirstQ], [LastQ])
SELECT
	LTRIM(RTRIM([BWSdb].[dbo].[fn_RemoveSpecials]([Description], @sI, DEFAULT, DEFAULT)))
	,SUM([SubFreq]) AS [Freq]
	,MIN([FirstQ]) AS [FirstQ]
	,MIN([LastQ]) AS [LastQ]
FROM (
	SELECT
		[Description]
		,COUNT([Description]) AS [SubFreq]
		,MIN([FL].[Quote#]) AS [FirstQ]
		,MAX([FL].[Quote#]) AS [LastQ]
	FROM
		[BWSdb].[dbo].[Order Options_FactoryLines] [FL]
	WHERE
		(CASE WHEN @tq IS NULL THEN 1 ELSE (CASE WHEN @tq = [FL].[Quote#] THEN 1 ELSE 0 END) END) = 1
	GROUP BY
		[Description]
	UNION ALL
	SELECT
		[SpecDescription]
		,COUNT([SpecDescription])
		,MIN([FL].[Quote#]) AS [FirstQ]
		,MAX([FL].[Quote#]) AS [LastQ]
	FROM
		[BWSdb].[dbo].[Order Options_FactoryLines] [FL]
	WHERE
		(CASE WHEN @tq IS NULL THEN 1 ELSE (CASE WHEN @tq = [FL].[Quote#] THEN 1 ELSE 0 END) END) = 1
	GROUP BY
		[SpecDescription]
	UNION ALL
	SELECT
		[Description]
		,COUNT([Description])
		,MIN([SL].[Quote#]) AS [FirstQ]
		,MAX([SL].[Quote#]) AS [LastQ]
	FROM
		[BWSdb].[dbo].[Order Options_SpecLines] [SL]
	WHERE
		(CASE WHEN @tq IS NULL THEN 1 ELSE (CASE WHEN @tq = [SL].[Quote#] THEN 1 ELSE 0 END) END) = 1
	GROUP BY
		[Description]
	UNION ALL
	SELECT
		[SpecDescription]
		,COUNT([SpecDescription])
		,MIN([SL].[Quote#]) AS [FirstQ]
		,MAX([SL].[Quote#]) AS [LastQ]
	FROM
		[BWSdb].[dbo].[Order Options_SpecLines] [SL]
	WHERE
		(CASE WHEN @tq IS NULL THEN 1 ELSE (CASE WHEN @tq = [SL].[Quote#] THEN 1 ELSE 0 END) END) = 1
	GROUP BY
		[SpecDescription]
	
	-- Stargate

	UNION ALL

	SELECT
		[Description]
		,COUNT([Description]) AS [SubFreq]
		,MIN(CAST(RIGHT([OO2].[SGQuote], 6) AS INT)) AS [FirstQ]
		,MAX(CAST(RIGHT([OO2].[SGQuote], 6) AS INT)) AS [LastQ]
	FROM
		[BWSdb].[dbo].[Order OptionsV2] [OO2]
	WHERE
		(CASE 
			WHEN @tp IS NULL THEN 1 
			ELSE (CASE
				WHEN [OO2].[Description] LIKE '%' + @tp + '%' THEN 1
				ELSE 0
			END)
		END) = 1
		--(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN ([FL].[Description] LIKE '%' + @tp + '%' AND LEN([FL].[Description]) = LEN(@tp)) THEN 1 ELSE 0 END) END) = 1
	GROUP BY
		[Description]
	UNION ALL
	SELECT
		[Description]
		,COUNT([Description]) AS [SubFreq]
		,MIN(CAST(RIGHT([FL].[SGQuote], 6) AS INT)) AS [FirstQ]
		,MAX(CAST(RIGHT([FL].[SGQuote], 6) AS INT)) AS [LastQ]
	FROM
		[BWSdb].[dbo].[Order OptionsV2_FactoryLines] [FL]
	WHERE
		(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN [FL].[Description] LIKE '%' + @tp + '%' THEN 1 ELSE 0 END) END) = 1
		--(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN ([FL].[Description] LIKE '%' + @tp + '%' AND LEN([FL].[Description]) = LEN(@tp)) THEN 1 ELSE 0 END) END) = 1
	GROUP BY
		[Description]
	UNION ALL
	SELECT
		[SpecDescription]
		,COUNT([SpecDescription])
		,MIN(CAST(RIGHT([FL].[SGQuote], 6) AS INT)) AS [FirstQ]
		,MAX(CAST(RIGHT([FL].[SGQuote], 6) AS INT)) AS [LastQ]
	FROM
		[BWSdb].[dbo].[Order OptionsV2_FactoryLines] [FL]
	WHERE
		(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN [FL].[SpecDescription] LIKE '%' + @tp + '%' THEN 1 ELSE 0 END) END) = 1
		--(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN ([FL].[Description] LIKE '%' + @tp + '%' AND LEN([FL].[Description]) = LEN(@tp)) THEN 1 ELSE 0 END) END) = 1
	GROUP BY
		[SpecDescription]
	UNION ALL
	SELECT
		[Description]
		,COUNT([Description])
		,MIN(CAST(RIGHT([SL].[SGQuote], 6) AS INT)) AS [FirstQ]
		,MAX(CAST(RIGHT([SL].[SGQuote], 6) AS INT)) AS [LastQ]
	FROM
		[BWSdb].[dbo].[Order OptionsV2_SpecLines] [SL]
	WHERE
		(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN [SL].[Description] LIKE '%' + @tp + '%' THEN 1 ELSE 0 END) END) = 1
		--(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN ([FL].[Description] LIKE '%' + @tp + '%' AND LEN([FL].[Description]) = LEN(@tp)) THEN 1 ELSE 0 END) END) = 1
	GROUP BY
		[Description]
	UNION ALL
	SELECT
		[SpecDescription]
		,COUNT([SpecDescription])
		,MIN(CAST(RIGHT([SL].[SGQuote], 6) AS INT)) AS [FirstQ]
		,MAX(CAST(RIGHT([SL].[SGQuote], 6) AS INT)) AS [LastQ]
	FROM
		[BWSdb].[dbo].[Order OptionsV2_SpecLines] [SL]
	WHERE
		(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN [SL].[SpecDescription] LIKE '%' + @tp + '%' THEN 1 ELSE 0 END) END) = 1
		--(CASE WHEN @tp IS NULL THEN 1 ELSE (CASE WHEN ([FL].[Description] LIKE '%' + @tp + '%' AND LEN([FL].[Description]) = LEN(@tp)) THEN 1 ELSE 0 END) END) = 1
	GROUP BY
		[SpecDescription]
) AS [Src]
GROUP BY
	LTRIM(RTRIM([BWSdb].[dbo].[fn_RemoveSpecials]([Description], @sI, DEFAULT, DEFAULT)))
;

SELECT
	@i = 0,
	@c = COUNT(*)
FROM
	@descFreq [DF]
;

SELECT
	*
FROM
	@descFreq [DF]
ORDER BY
	[DF].[Desc]
;

WHILE @i < @c BEGIN

	SELECT
		@p = [DF].[Desc]
		,@pf = [DF].[Freq]
		,@dfID0 = [DF].[ID]
		--,@dfID1 = [DF].[ID]
	FROM
		@descFreq [DF]
	WHERE
		[DF].[ID] = @i
	;

	DELETE FROM 
		@spltFreq
	;

	IF @tq IS NOT NULL BEGIN
		SELECT 'A'
		SELECT
			*
		FROM
			@spltFreq
	END

	INSERT INTO @spltFreq ([Split], [Freq])
	SELECT
		LTRIM(RTRIM([SS].[splited_data])),
		--COUNT(*) +
		@pf
	FROM
		[BWSdb].[dbo].[split_string_idx](@p, ' ') [SS]
	WHERE
		LEN(LTRIM(RTRIM([SS].[splited_data]))) <> 0
	GROUP BY
		LTRIM(RTRIM([SS].[splited_data]))
	;
	
	IF @tq IS NOT NULL BEGIN
		SELECT 'B'
		SELECT
			*
		FROM
			@spltFreq
	END
	
	UPDATE
		@wordFreq
	SET
		--[Freq] = ISNULL([WF].[Freq], 1) + (ISNULL([SF].[Freq], 1) * @pf)
		--[Freq] = ISNULL([WF].[Freq] + 1, 1) + ISNULL([SF].[Freq], 1)
		--[Freq] = ISNULL([WF].[Freq], 0) + ISNULL([SF].[Freq], 1)
		[Freq] = ISNULL([WF].[Freq], 0) + ISNULL([SF].[Freq], 0),
		[FirstDFID] = (CASE WHEN [WF].[FirstDFID] <= @dfID0 THEN [WF].[FirstDFID] ELSE @dfID0 END),
		[LastDFID] = (CASE WHEN [WF].[LastDFID] >= @dfID0 THEN [WF].[LastDFID] ELSE @dfID0 END)
	FROM
		@wordFreq [WF]
	INNER JOIN
		@spltFreq [SF]
	ON
		LTRIM(RTRIM([WF].[Word])) = LTRIM(RTRIM([SF].[Split]))
	;

	INSERT INTO @wordFreq ([Word], [Freq], [FirstDFID], [LastDFID])
	SELECT
		LTRIM(RTRIM([SF].[Split])),
		COUNT(*) * @pf,
		@dfID0,
		@dfID0
	FROM
		@spltFreq [SF]
	LEFT JOIN
		@wordFreq [WF]
	ON
		LTRIM(RTRIM([SF].[Split])) = LTRIM(RTRIM([WF].[Word]))
	WHERE
		[WF].[Word] IS NULL
	GROUP BY
		LTRIM(RTRIM([SF].[Split]))
	;

	SELECT
		@i = @i + 1
	;

END

SELECT
	'DF' AS [T]
	,*
FROM
	@descFreq
ORDER BY
	[Desc]
;

IF @tp IS NOT NULL BEGIN
	SELECT
		'DF-' AS [T]
		,*
	FROM
		@descFreq
	WHERE
		[Desc] LIKE '%' + @tp + '%'
	ORDER BY
		[Desc]
	;
END

SELECT
	'WF' AS [T]
	,*
FROM
	@wordFreq
ORDER BY
	[Word]
;

SELECT
	'WF' AS [T]
	,[WF].[ID]
	,[WF].[Word]
	,[WF].[Freq] AS [WordFreq]
	,[WF].[FirstDFID]
	,[WF].LastDFID
	,[DF].[ID]
	,[DF].[Desc]
	,[DF].[Freq] AS [DescFreq]
	,[DF].[FirstQ]
	,[DF].[LastQ]
FROM
	@wordFreq [WF]
LEFT JOIN
	@descFreq [DF]
ON
	[WF].[FirstDFID] = [DF].[ID]
ORDER BY
	[Word]
;

IF @tp IS NOT NULL BEGIN
	SELECT
		'WF-' AS [T]
		,*
	FROM
		@wordFreq
	WHERE
		[Word] = @tp
	ORDER BY
		[Word]
	;
END

/*
SELECT
	*
FROM
	[BWSdb].[dbo].[split_string_idx]('Avery is cool', '')
*/
/*
SELECT
	*
FROM
	[SysproCompanyA].[dbo].[]('Avery is cool', '')

SELECT
	SUBSTRING('Avery is cool', 1, 1) AS [1]
	--,CAST('A' AS INT) AS [2]
	,ASCII('A') AS [2]
	
SELECT
	[BWSdb].[dbo].[fn_RemoveSpecials]('Avery is cool?', '?', DEFAULT)
	,[BWSdb].[dbo].[fn_RemoveSpecials]('Avery is _cool?', '?', '@')
*/

/*
SELECT 
	LEN('\n')
	,ASCII('\n')
	,CHAR(9)
	,LEN(CHAR(9))
	,CHAR(10)
	,LEN(CHAR(10))
	,DIFFERENCE('Avery', 'Briggs')
*/

/*
SELECT
	[SS].[idx]
	,[SS].[splited_data]
FROM		
	[BWSdb].[dbo].[split_string_idx]('4 of Bolt on sidemount 3 located at Gooseneck  Kinedyne  12004SP And 1 located by rear wheel  Kinedyne  7820 all on Driver Side', '') [SS]
WHERE
	LEN(LTRIM(RTRIM([SS].[splited_data]))) <> 0
ORDER BY
	[splited_data]
;
SELECT
	[SS].[idx]
	,[SS].[splited_data]
FROM		
	[BWSdb].[dbo].[split_string_idx]('4 of Bolt on sidemount 3 located at Gooseneck  Kinedyne  12004SP And 1 located by rear wheel  Kinedyne  7820 all on Driver Side', ' ') [SS]
WHERE
	LEN(LTRIM(RTRIM([SS].[splited_data]))) <> 0
ORDER BY
	[splited_data]


--DECLARE @tText1 NVARCHAR(MAX) = '4 of Bolt on sidemount (3 located at Gooseneck - Kinedyne # 12004SP. And 1 located by rear wheel -'
--SELECT
--	[]


SELECT
	CHAR(97)
	,CHAR(97-32)

SELECT
	(CASE WHEN ('a'  COLLATE Latin1_General_CS_AS) = ('a' COLLATE Latin1_General_CS_AS) THEN 1 ELSE 0 END)
	,(CASE WHEN ('A'  COLLATE Latin1_General_CS_AS) = ('a' COLLATE Latin1_General_CS_AS) THEN 1 ELSE 0 END)
	,(CASE WHEN ('a'  COLLATE Latin1_General_CS_AS) = ('A' COLLATE Latin1_General_CS_AS) THEN 1 ELSE 0 END)
	,(CASE WHEN ('A'  COLLATE Latin1_General_CS_AS) = ('A' COLLATE Latin1_General_CS_AS) THEN 1 ELSE 0 END)
*/
