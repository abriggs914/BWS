-- Recalcuate the Serial Tag Check Digit

DECLARE @inputVINs AS TABLE([ID] INT IDENTITY(1, 1), [KnownSN] NVARCHAR(17), [CorrectedSN] NVARCHAR(17), [NewCalcSN] NVARCHAR(17))

-- Working table for debugging. Also used to determine the check digit value sums.
DECLARE @calc_vars AS TABLE([ID] INT IDENTITY(1, 1), [@i] INT, [@c] INT, [@p] INT, [@q] INT, [@l] NVARCHAR(1), [Number] INT, [WEIGHT] INT, [KSN] NVARCHAR(17), [CSN] NVARCHAR(17), [@t] INT, [@ct] INT, [@rs] BIT, [Sequence] INT, [@seq] NVARCHAR(6));

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

INSERT INTO @inputVINs ([knownSN], [CorrectedSN]) VALUES
('2XBB6EY31PA000952', '2XBB6EY3 RA000952'),
('2XBB2TR3XPA000950', '2XBB2TR3 RA000950'),
('2XBB2TR33PA000949', '2XBB2TR3 RA000949'),
('2XBB2TR31PA000951', '2XBB2TR3 RA000951')

DECLARE @updater AS NVARCHAR(100) = 'ABRIGGS';
DECLARE @updatePrefix AS NVARCHAR(MAX) = '2022-12-16 12 PM -';
DECLARE @updateSuffix AS NVARCHAR(MAX) = 'to match 2024 Production Year.';

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
DECLARE @k_vin_in AS NVARCHAR(17);  -- Current known vin DO NOT EDIT
DECLARE @vin_in AS NVARCHAR(17);  -- Current vin to edit
DECLARE @recalcSequence AS BIT = 0;  -- only if the unit changes prod year. ensures that the maximum function that calculates the next available number is not pushed too quickly.

DECLARE @seq AS NVARCHAR(6);

SELECT @p = 1;
SELECT @q = COUNT(*) FROM @inputVINs;


-- Begin processing
WHILE @p <= @q BEGIN
	SELECT @p = @p + 1;
	SELECT @ct = 0;
	SELECT @i = 1;
	SELECT @vin_in = [CorrectedSN], @k_vin_in = [KnownSN] FROM @inputVINs WHERE [ID] = @p - 1;

	IF SUBSTRING(@vin_in, 10, 1) <> SUBSTRING(@k_vin_in, 10, 1) BEGIN
		-- Year Change
		SELECT @recalcSequence = 1;
		SELECT @seq = RIGHT('000000' + CAST(
		
		(SELECT
		 MAX(CAST(RIGHT([Serial Number], 6) AS INT)) + 1
		--select @maxsn2 = COUNT(*) + 2
		from Orders with (nolock)
		cross join [SNC Year] with (nolock)
		where [SN Yr] = SUBSTRING(@vin_in, 10, 1)
		and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
		AND LEFT([Serial Number], 3) IN ('2XB', '2B9')
		AND [Date Declined] IS NULL
		) + @p - 2	AS NVARCHAR(6)), 6)
	END
	ELSE BEGIN
		SELECT @recalcSequence = 0;
		SELECT @seq = RIGHT(@vin_in, 6)
	END

	WHILE @i <= @c BEGIN
		SELECT @i = @i + 1;
		IF @i = 10 BEGIN
			CONTINUE
		END
		SELECT @l = (CASE WHEN @i > 12 THEN SUBSTRING(@seq, @i - 12, 1) ELSE SUBSTRING(@vin_in, @i - 1, 1) END)
		SELECT @t = [Number] FROM @charToNum WHERE [Character] = UPPER(@l)
		SELECT @t = @t * [Weight] FROM @weights WHERE [ID] = @i - 1;
		SELECT @ct = @ct + @t
		--SELECT @l AS [@l], @t AS [@t], @i AS [@i], @c AS [@c], @ct AS [@ct], [Weight] FROM @weights WHERE [ID] = @i - 1
		INSERT INTO @calc_vars ([@i], [@c], [@p], [@q], [@l], [Number], [Weight], [KSN], [CSN], [@t], [@ct], [@rs], [Sequence], [@seq]) SELECT @i, @c, @p, @q, @l, [Number], [Weight], [KnownSN], [CorrectedSN], @t, @ct, @recalcSequence,
		(CASE WHEN @recalcSequence = 0 THEN CAST(RIGHT([CorrectedSN], 6) AS INT) ELSE 
			
	
		--Grab last used serial number for selected model year
	((
	SELECT
	 MAX(CAST(RIGHT([Serial Number], 6) AS INT)) + 1
	--select @maxsn2 = COUNT(*) + 2
	from Orders with (nolock)
	cross join [SNC Year] with (nolock)
	where [SN Yr] = SUBSTRING(@vin_in, 10, 1)
	and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
	AND LEFT([Serial Number], 3) IN ('2XB', '2B9')
	AND [Date Declined] IS NULL
	) + @p - 2)

	----Geneate new number for serial number
	--declare @newsn NVARCHAR(6)
	----select @newsn = case when @maxsn is null then 1001 else @maxsn + 1 end
	----select @newsn = case when @maxsn is null then 100001 else @maxsn + 1 end
	--select @newsn = RIGHT('000000' + CAST(case when @maxsn is null then 1 else @maxsn + 1 end AS NVARCHAR(6)), 6)



		END), @seq
		FROM @charToNum CROSS JOIN @weights CROSS JOIN @inputVINs WHERE [Character] = UPPER(@l) AND [@weights].[ID] = @i - 1 AND [CorrectedSN] = @vin_in;
	END

	SELECT TOP 1 @checkDigit = [@ct] FROM @calc_vars WHERE [CSN] = @vin_in ORDER BY [ID] DESC

	SELECT @newSN = 
	LEFT(@vin_in, 8) 
	+ (CASE WHEN @checkDigit % 11 = 10 THEN 'X' ELSE CAST(@checkDigit % 11 AS NVARCHAR(1)) END) 
	+ (CASE WHEN [@rs] = 1 THEN (SUBSTRING(@vin_in, 10, 2) + RIGHT(('000000' + CAST([Sequence] AS NVARCHAR(6))), 6)) ELSE RIGHT(@vin_in, 8) END)
	FROM
		@calc_vars
	WHERE
		[@calc_vars].[KSN] = @k_vin_in
		AND [@i] = 18

	UPDATE 
		@inputVINs
	SET
		[NewCalcSN] = @newSN
	WHERE
		[@inputVINs].[ID] = @p - 1

END

--SELECT * FROM @charToNum
--SELECT * FROM @weights
--SELECT * FROM @calc_vars
SELECT * FROM @inputVINs


SELECT * FROM @inputVINs INNER JOIN [Orders] ON [Serial Number] = [KnownSN]

IF (SELECT COUNT(*) FROM @inputVINs INNER JOIN [Orders] ON [Serial Number] = [KnownSN]) > 0 BEGIN


	PRINT 'BEGIN UPDATES'

	BEGIN TRAN;


	SELECT 'BEFORE' AS [TABLE], * FROM [Orders] INNER JOIN @inputVINs ON [Serial Number] = [KnownSN]

	--SELECT
	--	[Orders].[Quote#]
	--	, [Orders].[WO#]
	--	, ISNULL([Prod Date 1], [Prod Date 2]) AS [Prod Date]
	--	, [Orders].[Serial Number] AS [Serial Before]
	--	, [NewCalcSN] AS [New Serial]
	--	, [Model No] AS [Model Name]
	--	, [COMPANY NAME] AS [Dealer]
	--	, (CASE
	--		WHEN
	--			LEN([Orders].[Serial Number]) > 4
	--		THEN
	--			[Special Instructions] + ' ' + @updatePrefix + ' ' + @updater + ' - VIN CHANGE ''' + [Orders].[Serial Number] + ''' to ''' + [NewCalcSN] + ''' ' + @updateSuffix
	--		ELSE
	--			[Orders].[Special Instructions]
	--		END) AS [Special Instructions]
	--FROM
	--	[Orders]
	--INNER JOIN
	--	@inputVINs
	--ON
	--	[Serial Number] = [KnownSN]
	--INNER JOIN
	--	[dtProductionSchedule]
	--ON
	--	[Orders].[Quote#] = [dtProductionSchedule].[Quote#]
	--INNER JOIN
	--	[Dealers]
	--ON
	--	[Orders].[DealerID] = [Dealers].[ID]
	--ORDER BY
	--	ISNULL([Prod Date 1], [Prod Date 2])
	--;

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


	SELECT 'AFTER' AS [TABLE], * FROM [Orders] INNER JOIN @inputVINs ON [Serial Number] = [NewCalcSN]

	--SELECT [Serial Number] FROM [Orders]
	----WHERE
	----	([Serial Number] LIKE '%2B9%' OR [Serial Number] LIKE '%2XB%') AND ([Serial Number] LIKE '%RA%' OR [Serial Number] LIKE '%PA%')
	--GROUP BY
	--	[Serial Number]
	--HAVING COUNT(*) > 1
	--ORDER BY
	--	[Orders].[Serial Number]


END
ELSE BEGIN 
	PRINT 'NO UPDATES'
END



	ROLLBACK;
	COMMIT;