
-- text to length
-- '40 ft. 10 in.' => 40.833
-- 40' 10" => 40.833
-- 40 in. => 3.333
-- 40" => 3.333

DECLARE @s_oals AS TABLE ([ID] INT IDENTITY(0, 1), [OAL] NVARCHAR(MAX));
INSERT INTO @s_oals ([OAL]) VALUES
	('40 ft. 1 in.')
	, ('40 ft 1 in')
	, ('40'' 10"')
	, ('40''')
	, ('40"')
	, ('40 ft.')
	, ('40 ft')
	, ('40 in.')
	, ('40 in')

DECLARE @result AS TABLE (
		[Input] NVARCHAR(MAX)
		, [Ft Part] INTEGER
		, [In Part] INTEGER
		, [Ft Tot] DECIMAL(14, 7)
		, [In Tot] INTEGER
	);
	
DECLARE @s_oal AS NVARCHAR(MAX);
DECLARE @i AS INT = 0;
DECLARE @c AS INT;
SELECT @c = COUNT(*) FROM @s_oals;

WHILE @i < @c BEGIN
	SELECT @s_oal = [OAL] FROM @s_oals WHERE [ID] = @i
	INSERT INTO @result ([Input], [Ft Part], [In Part], [Ft Tot], [In Tot])
	EXEC [sp_FeetInchesDecimal] @s_oal=@s_oal
	SELECT @i = @i + 1;
END

SELECT * FROM @result