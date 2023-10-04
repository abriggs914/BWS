USE BWSdb
GO

-- Select the top used words in a requests text, comments

DECLARE @specials AS TABLE ([ID] INT IDENTITY(0, 1), [Char] NVARCHAR(1));
INSERT INTO @specials ([Char]) VALUES
('!'), ('@'), ('#'), ('$'), ('%'),
('^'), ('&'), ('*'), ('('), (')'),
--('_'),
('-'), ('+'), ('='), ('`'),
('~'), ('['), (']'), ('{'), ('}'),
('\'), ('|'), (';'), (':'), (''''),
('"'), (','), ('<'), ('.'), ('>'),
('/'), ('?'), (CHAR(10))
;

DECLARE @r_text AS NVARCHAR(MAX);
DECLARE @r_comm AS NVARCHAR(MAX);

DECLARE @unknown AS NVARCHAR(MAX);
DECLARE @a AS INTEGER; -- Increment requests by
DECLARE @minWordLen AS INTEGER; -- Do not consider words of length 2 or less as a word (x < 3)
DECLARE @i AS INTEGER; -- looping requests
DECLARE @c AS INTEGER; -- upperbound requests
DECLARE @j AS INTEGER; -- looping words in a variable (r_text, r_comm)
DECLARE @d AS INTEGER; -- upper bound on record loop (r_text, r_comm)

SELECT
	@a = 1
	,@minWordLen = 3
	,@unknown = 'UNKNOWN'
	,@i = MIN([ITRequestID#])
	,@c = MAX([ITRequestID#])
FROM
	[IT Requests]
;

---- TESTING LINE
--SELECT
--	@a = 1
--  ,@minWordLen = 3
--	,@unknown = 'UNKNOWN'
--	,@i = 7
--	,@c = 14


DECLARE @splt AS TABLE([ID] INT, [Word] NVARCHAR(MAX), [Count] INT, [XCount] INT);
DECLARE @words AS TABLE([ID] INT IDENTITY(0, 1), [Word] NVARCHAR(MAX), [TtlUses] INT, [TtlRequests] INT, [Requests] NVARCHAR(MAX));

WHILE @i < @c BEGIN

	--SELECT '--------------------------------------------------------------------------------------------'

	SELECT
		@r_text = [I].[Request]
		,@r_comm = [I].[Comments]
	FROM
		[IT Requests] AS [I]
	WHERE
		[ITRequestID#] = @i
	;
	
	SELECT @j = 0, @d = COUNT(*) FROM @specials;
	WHILE @j < @d BEGIN
		-- Replace specials in r_text and r_comm
		SELECT
			@r_text = RTRIM(LTRIM(REPLACE(@r_text, [Char], '')))
			, @r_comm = RTRIM(LTRIM(REPLACE(@r_comm, [Char], '')))
		FROM
			@specials
		WHERE
			[ID] = @j
		;
		SELECT @j = @j + 1;
	END

	-- Clear split table
	DELETE FROM @splt
	WHERE 1 = 1;

	
	--SELECT
	--	'T1' AS [Y]
	--	,MIN([Idx]), RTRIM(LTRIM([splited_data])), COUNT(*)
	--FROM
	--	[dbo].[split_string_idx](RTRIM(LTRIM(@r_text)), ' ')
	--GROUP BY RTRIM(LTRIM([splited_data]))
	--SELECT
	--	'T2' AS [Y]
	--	,[Idx], RTRIM(LTRIM([splited_data]))
	--FROM
	--	[dbo].[split_string_idx](RTRIM(LTRIM(@r_text)), ' ')
	----GROUP BY RTRIM(LTRIM([splited_data]))

	-- Repop split table with request text
	INSERT INTO @splt ([ID], [Word], [Count], [XCount])
	SELECT
		MIN([Idx]), RTRIM(LTRIM([splited_data])), COUNT(*), COUNT(*)
	FROM
		[dbo].[split_string_idx](@r_text, ' ')
	WHERE
		LEN(RTRIM(LTRIM([splited_data]))) > @minWordLen
	GROUP BY
		RTRIM(LTRIM([splited_data]))
	;

	-- Pop split table with comments
	INSERT INTO @splt ([ID], [Word], [Count], [XCount])
	SELECT 
		MIN([Idx]), RTRIM(LTRIM([splited_data])), COUNT(*), COUNT(*)
	FROM 
		[dbo].[split_string_idx](@r_comm, ' ')
	WHERE
		LEN(RTRIM(LTRIM([splited_data]))) > @minWordLen
	GROUP BY
		RTRIM(LTRIM([splited_data]))
	;
	
	--SELECT
	--	'TESTsplt' AS [T]
	--	, @i AS [I]
	--	, @r_text AS [RText]
	--	, @r_comm AS [RComm]
	--	, *
	--FROM
	--	@splt
	--;

	---- Update usage counts for words on this request
	--UPDATE
	--	@splt
	--SET
	--	[Count] = COUNT(*)
	--FROM
	--	@splt AS [S]
	--GROUP BY
	--	[S].[Word]
	--;

	-- Set new word counts to 0
	UPDATE
		@splt
	SET
		[Count] = 0
	FROM
		@splt AS [S]
	LEFT JOIN
		@words AS [W]
	ON
		[S].[Word] = [W].[Word]
	WHERE
		[W].[ID] IS NULL
	--GROUP BY
	--	[S].[Word]
	--	, [S].[Count]
	;
	
	--SELECT
	--	'TESTsplt2' AS [T]
	--	, @i AS [I]
	--	, @r_text AS [RText]
	--	, @r_comm AS [RComm]
	--	, *
	--FROM
	--	@splt
	--;

	-- Add new words from split table
	INSERT INTO @words ([Word], [TtlRequests], [TtlUses], [Requests])
	SELECT
		[S].[Word]
		, 0  -- first time this word has been encountered
		, [Count]
		, ''
	FROM
		@splt AS [S]
	LEFT JOIN
		@words AS [W]
	ON
		[S].[Word] = [W].[Word]
	WHERE
		[W].[ID] IS NULL
	GROUP BY
		[S].[Word]
		, [S].[Count]
	;

	--SELECT
	--	'Words1' AS [T]
	--	, *
	--FROM
	--	@words
	--;
	
	-- Update usage counts from split table
	UPDATE
		@words
	SET
		[TtlRequests] = ISNULL([TtlRequests], 0) + 1
		,[TtlUses] = ISNULL([TtlUses], 0) + [XCount]
		,[Requests] = ISNULL([Requests], '') + CAST(@i AS NVARCHAR(MAX)) + ';'
	FROM
		@words AS [W]
	INNER JOIN
		@splt AS [S]
	ON
		[W].[Word] = [S].[Word]
	--WHERE
	--	[W].[Word] = [S].[Word]
	--GROUP BY
	--	[S].[Word]
	--;

	--SELECT
	--	'Words2' AS [T]
	--	, *
	--FROM
	--	@words
	--;

	SELECT @i = @i + @a;

END


SELECT
	'WordsFINAL' AS [T]
	, *
FROM
	@words
ORDER BY
	[Word]
;

-- Update what type of word this might be.
--	'DATE'	--	starts with 202# and has exactly 8 numeric characters, (202#####)
--	'BWSWO'	--	starts with 1 and has exactly 8 numeric characters, (1#######)
SELECT
	'WordsFINAL' AS [T]
	, *
	, (CASE 
		WHEN [Word] LIKE '%[0-9]%' THEN (
			CASE
				WHEN LEN([Word]) = 8 THEN (
					CASE
						WHEN LEFT([Word], 3) = '202' THEN
							'DATE'
						WHEN LEFT([Word], 1) = '1' THEN
							'BWSWO'
						ELSE
							@unknown + 'C'
					END
				)
				ELSE
					@unknown + 'B'
			END
		)
		ELSE
			@unknown + 'A'
	END) AS [HintType]
FROM
	@words
ORDER BY
	[Word]
;
