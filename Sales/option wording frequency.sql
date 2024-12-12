

-- Review the frequency of wording for options
-- 2024-12-11


DECLARE @tq INT = NULL
--SELECT @tq = 26121;


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


DECLARE @descFreq AS TABLE ([ID] INT IDENTITY(0, 1), [Desc] NVARCHAR(MAX), [Freq] INT, [FirstQ] INT, [LastQ] INT);
DECLARE @wordFreq AS TABLE ([ID] INT IDENTITY(0, 1), [Word] NVARCHAR(60), [Freq] INT);
DECLARE @spltFreq AS TABLE ([ID] INT IDENTITY(0, 1), [Split] NVARCHAR(60), [Freq] INT);
DECLARE @p NVARCHAR(MAX);
DECLARE @i INT;
DECLARE @c INT;


INSERT INTO @descFreq ([Desc], [Freq], [FirstQ], [LastQ])
SELECT
	LTRIM(RTRIM([BWSdb].[dbo].[fn_RemoveSpecials]([Description], DEFAULT, DEFAULT, DEFAULT)))
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
) AS [Src]
GROUP BY
	LTRIM(RTRIM([BWSdb].[dbo].[fn_RemoveSpecials]([Description], DEFAULT, DEFAULT, DEFAULT)))
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
		COUNT(*)
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
		[Freq] = ISNULL([WF].[Freq], 0) + ISNULL([SF].[Freq], 1)
	FROM
		@wordFreq [WF]
	INNER JOIN
		@spltFreq [SF]
	ON
		LTRIM(RTRIM([WF].[Word])) = LTRIM(RTRIM([SF].[Split]))
	;

	INSERT INTO @wordFreq ([Word], [Freq])
	SELECT
		LTRIM(RTRIM([SF].[Split])),
		COUNT(*)
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

SELECT
	'DF-' AS [T]
	,*
FROM
	@descFreq
WHERE
	[Desc] LIKE '% Kinedyne%'
ORDER BY
	[Desc]
;

SELECT
	'WF' AS [T]
	,*
FROM
	@wordFreq
ORDER BY
	[Word]
;
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