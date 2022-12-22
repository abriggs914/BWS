USE BWSdb
GO

-- Recalcuate the Serial Tag Check Digit   FOR ALL 2023 and 2024 models.

-- Be weary of changes using this program. it does not take into account a change in prod year.
-- If a unit moves ahead or backward, the sequence digits should be recalculated

DECLARE @updater AS NVARCHAR(100) = 'ABRIGGS';
DECLARE @updatePrefix AS NVARCHAR(MAX) = '2022-12-22 2 PM -';
DECLARE @updateSuffix AS NVARCHAR(MAX) = 'Check Digit Correction.';


DECLARE @inputVINs AS TABLE([ID] INT IDENTITY(1, 1), [KnownSN] NVARCHAR(17), [CorrectedSN] NVARCHAR(17), [NewCalcSN] NVARCHAR(17))

-- Working table for debugging. Also used to determine the check digit value sums.
DECLARE @calc_vars AS TABLE([ID] INT IDENTITY(1, 1), [@i] INT, [@c] INT, [@l] NVARCHAR(1), [Number] INT, [WEIGHT] INT, [KSN] NVARCHAR(17), [CSN] NVARCHAR(17), [@t] INT, [@ct] INT);

-- Weights assigned to the place value for each vin letter. 9th index is null because this is the index of the calculated check digit.
DECLARE @weights AS TABLE ([ID] INT IDENTITY(1, 1), [Weight] INT)
INSERT INTO @weights ([Weight]) VALUES
(8), (7), (6), (5), (4), (3), (2), (10), (NULL), (9), (8), (7), (6), (5), (4), (3), (2);

-- Quick reference for known alphabet values.
DECLARE @charToNum AS TABLE ( [ID] INT IDENTITY(1, 1), [Character] NVARCHAR(1), [Number] INT)
INSERT INTO @charToNum VALUES 
	('A', 1), ('B', 2), ('C', 3),
	('D', 4), ('E', 5), ('F', 6),
	('G', 7), ('H', 8), ('J', 1),
	('K', 2), ('L', 3), ('M', 4),
	('N', 5), ('P', 7), ('R', 9),
	('S', 2), ('T', 3), ('U', 4),
	('V', 5), ('W', 6), ('X', 7),
	('Y', 8), ('Z', 9), ('0', 0),
	('1', 1), ('2', 2), ('3', 3),
	('4', 4), ('5', 5), ('6', 6),
	('7', 7), ('8', 8), ('9', 9)
;

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

-- Adjust inputs here

INSERT INTO @inputVINs ([knownSN], [CorrectedSN])
--VALUES
----('2XBB6FY34PA000966', '2XBB6FY2 PA000966'),
----('2XBB6FY36PA000967', '2XBB6FY2 PA000967')
----('2XBB2TR35RA000138', '2XBB2TR3 RA000138')
----('2XBB6VY23RA000290', '2XBB6VY2 RA000290')
--('2XBB6VY23RA000273', '2XBB6VY2 RA000273'),
--('2XBB6VY23RA000291', '2XBB6VY2 RA000291'),
--('2XBB6VY24RA000043', '2XBB6VY2 RA000043'),
--('2XBB6VY28RA000112',  '2XBB6VY2 RA000112'),
--('2XBB2TR32RA000573', '2XBB2TR3 RA000573'),
--('2XBB2TR32RA000573', '2XBB2TR3 RA000573'),
--('2XBB2TP32RA000134', '2XBB2TP3 RA000134')

SELECT 
	[Serial Number],
	[Serial Number]
FROM
	[Orders]
WHERE
	LEFT(RIGHT([Serial Number], 8), 2) IN ('PA', 'RA')
	AND [Serial Number] <> 'Paint' 
;
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

DECLARE @i AS INTEGER;  -- current letter index var
DECLARE @c AS INTEGER = 17;  -- total chars 17
DECLARE @l AS NVARCHAR(1);  -- letter
DECLARE @ct AS INTEGER;  -- check digit total
DECLARE @t AS INTEGER;  -- temp variable
DECLARE @checkDigit AS INTEGER;
DECLARE @newSN AS NVARCHAR(17);
DECLARE @p AS INTEGER;  -- serial index var
DECLARE @q AS INTEGER;  -- Number of serials to change
DECLARE @vin_in AS NVARCHAR(17);  -- Current vin to edit

SELECT @p = 0;
SELECT @q = COUNT(*) FROM @inputVINs;


-- Begin processing
WHILE @p <= @q BEGIN
	SELECT @p = @p + 1;
	SELECT @ct = 0;
	SELECT @i = 1;
	SELECT @vin_in = [CorrectedSN] FROM @inputVINs WHERE [ID] = @p - 1;

	WHILE @i <= @c BEGIN
		SELECT @i = @i + 1;
		IF @i = 10 BEGIN
			CONTINUE
		END
		SELECT @l = SUBSTRING(@vin_in, @i - 1, 1)
		SELECT @t = [Number] FROM @charToNum WHERE [Character] = UPPER(@l)
		SELECT @t = @t * [Weight] FROM @weights WHERE [ID] = @i - 1;
		SELECT @ct = @ct + @t
		--SELECT @l AS [@l], @t AS [@t], @i AS [@i], @c AS [@c], @ct AS [@ct], [Weight] FROM @weights WHERE [ID] = @i - 1
		INSERT INTO @calc_vars ([@i], [@c], [@l], [Number], [Weight], [KSN], [CSN], [@t], [@ct]) SELECT @i, @c, @l, [Number], [Weight], [KnownSN], [CorrectedSN], @t, @ct FROM @charToNum CROSS JOIN @weights CROSS JOIN @inputVINs WHERE [Character] = UPPER(@l) AND [@weights].[ID] = @i - 1 AND [CorrectedSN] = @vin_in;
	END

	SELECT TOP 1 @checkDigit = [@ct] FROM @calc_vars WHERE [CSN] = @vin_in ORDER BY [ID] DESC

	SELECT @newSN = LEFT(@vin_in, 8) + (CASE WHEN @checkDigit % 11 = 10 THEN 'X' ELSE CAST(@checkDigit % 11 AS NVARCHAR(1)) END) + RIGHT(@vin_in, 8)
	UPDATE 
		@inputVINs
	SET
		[NewCalcSN] = @newSN
	WHERE
		[ID] = @p - 1

END

--SELECT * FROM @charToNum
--SELECT * FROM @weights
--SELECT * FROM @calc_vars
SELECT * FROM @inputVINs

SELECT
	[KnownSN]
	, [NewCalcSN]
	, [Quote#]
	, [WO#]
	, [Serial Number] AS [CURRENT SN]
	, [Model No]
	, [Special Instructions]
FROM
	@inputVINs
INNER JOIN
	[Orders]
ON
	[Serial Number] = [KnownSN]
WHERE
	[KnownSN] <> [NewCalcSN]
ORDER BY
	[Serial Number]

	
--SELECT * FROM @inputVINs INNER JOIN [Orders] ON [Serial Number] = [KnownSN]
--SELECT * FROM @inputVINs INNER JOIN [Orders] ON [Serial Number] = [KnownSN] AND [Quote#] = 27886
IF (SELECT COUNT(*) FROM @inputVINs INNER JOIN [Orders] ON [Serial Number] = [KnownSN]) > 0 BEGIN


	PRINT 'BEGIN UPDATES'

	BEGIN TRAN;


	SELECT 
		'BEFORE' AS [TABLE]
		, *
	FROM
		[Orders]
	INNER JOIN
		@inputVINs
	ON
		[Serial Number] = [KnownSN]
	WHERE
		[KnownSN] <> [NewCalcSN]
	;

	SELECT
		[Orders].[Quote#]
		, [Orders].[WO#]
		, ISNULL([Prod Date 1], [Prod Date 2]) AS [Prod Date]
		, [Orders].[Serial Number] AS [Serial Before]
		, [NewCalcSN] AS [New Serial]
		, [Model No] AS [Model Name]
		, [COMPANY NAME] AS [Dealer]
		, (CASE
			WHEN
				LEN([Orders].[Serial Number]) > 4
			THEN
				[Special Instructions] + ' ' + @updatePrefix + ' ' + @updater + ' - VIN CHANGE ''' + [Orders].[Serial Number] + ''' to ''' + [NewCalcSN] + ''' ' + @updateSuffix
			ELSE
				[Orders].[Special Instructions]
			END) AS [Special Instructions]
	FROM
		[Orders]
	INNER JOIN
		@inputVINs
	ON
		[Serial Number] = [KnownSN]
	INNER JOIN
		[dtProductionSchedule]
	ON
		[Orders].[Quote#] = [dtProductionSchedule].[Quote#]
	INNER JOIN
		[Dealers]
	ON
		[Orders].[DealerID] = [Dealers].[ID]
	WHERE 
		[KnownSN] <> [NewCalcSN]
	ORDER BY
		ISNULL([Prod Date 1], [Prod Date 2])
	;

	UPDATE
		[Orders]
	SET
		[Special Instructions] = (CASE
			WHEN
				LEN([Orders].[Serial Number]) > 4
			THEN
				[Special Instructions] + ' ' + @updatePrefix + ' ' + @updater + ' - VIN CHANGE ''' + [Orders].[Serial Number] + ''' to ''' + [NewCalcSN] + ''' ' + @updateSuffix
			ELSE
				[Orders].[Special Instructions]
			END)
		, [Serial Number] = [NewCalcSN]
	FROM
		[Orders]
	INNER JOIN
		@inputVINs
	ON
		[Serial Number] = [KnownSN]
	WHERE 
		[KnownSN] <> [NewCalcSN]


	SELECT 
		'AFTER' AS [TABLE]
		, *
	FROM
		[Orders]
	INNER JOIN
		@inputVINs 
	ON
		[Serial Number] = [NewCalcSN]
	WHERE 
		[KnownSN] <> [NewCalcSN]

	SELECT [Serial Number] FROM [Orders]

	--WHERE
	--	([Serial Number] LIKE '%2B9%' OR [Serial Number] LIKE '%2XB%') AND ([Serial Number] LIKE '%RA%' OR [Serial Number] LIKE '%PA%')
	GROUP BY
		[Serial Number]
	HAVING COUNT(*) > 1
	ORDER BY
		[Orders].[Serial Number]


END
ELSE BEGIN 
	PRINT 'NO UPDATES'
END



	ROLLBACK;
	COMMIT;