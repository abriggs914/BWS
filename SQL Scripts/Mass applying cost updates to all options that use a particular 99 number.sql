USE BWSdb
GO

-- 2023-11-14 1834 Mass applying cost updates to all options that use a particular 99 number.

BEGIN TRAN;

DECLARE @table AS TABLE (
	[ID] INT IDENTITY(0, 1)
	,[99] NVARCHAR(MAX)
	,[CDN] MONEY
	,[US] MONEY
	,[DESCRIPTION CHANGE] NVARCHAR(MAX)
)

INSERT INTO @table ([99], [CDN], [US], [DESCRIPTION CHANGE]) VALUES
--('99000200', 404.62, 331.66, NULL)
--,('99000014', 218.71, 189.56, NULL)
--,
('99000415', 95.93, 74.81,	'Winches Standard Weld / Bolt on #12004SP side mount (hooks not included)')
,('99000658', 92.82, 71.12, NULL)
,('99000280', 95.26, 73, NULL)
,('99000281', 95.26, 73, NULL)
,('99000018', 38.54, 29.64, NULL)
,('99000554', 21.71, 18.09, NULL)
,('99000063', 42.82, 34.26, NULL)
;

DECLARE 
	@nineNine NVARCHAR(MAX)
	,@cdnPrice MONEY
	,@usPrice MONEY
	,@desc NVARCHAR(MAX)
	,@i INT
	,@c INT
;

--SELECT	@nineNine = '99000014',	@cdnPrice = 218.71,	@usPrice = 189.56;
SELECT
	@i = 0
	,@c = COUNT(*)
FROM
	@table
;

WHILE @i < @c BEGIN
	
	SELECT
		@nineNine = [99]
		,@cdnPrice = [CDN]
		,@usPrice = [US]
		,@desc = [DESCRIPTION CHANGE]
	FROM
		@table
	WHERE
		[ID] = @i
	;

	SELECT
		'Before' AS [T],
		*
	FROM
		[Options]
	WHERE
		[Draw/Part#] = @nineNine

	UPDATE
		[Options]
	SET
		[Price] = @cdnPrice
		,[US Price] = @usPrice
		,[Description] = ISNULL(@desc, [Description])
	WHERE
		[Draw/Part#] = @nineNine
	
	SELECT
		--'After' AS [T],
		*
	FROM
		[Options]
	WHERE
		[Draw/Part#] = @nineNine

	SELECT @i = @i + 1;

END

ROLLBACK;
COMMIT;
	
--SELECT
--	*
--FROM
--	[Budget Options]
--WHERE
--	[Price] IS NULL