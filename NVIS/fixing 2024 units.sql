USE BWSdb
GO


--SET CONCAT_NULL_YIELDS_NULL OFF;


DECLARE @t AS TABLE ([ID] INT IDENTITY(1, 1), [Quote] INT, [Known] BIT, [WO#] NVARCHAR(MAX), [Stargate WO#] NVARCHAR(MAX), [Model Name] NVARCHAR(MAX), [Dealer Name] NVARCHAR(MAX), [Prod Date] DATETIME, [Serial Number] NVARCHAR(MAX), [CN] NVARCHAR(MAX), [New SN] NVARCHAR(MAX), [New SN2] NVARCHAR(MAX), [CONT] NVARCHAR(17));
INSERT INTO @t ([Quote], [Known]) VALUES
(27735, 1),
(27924, 1),
(27740, 1),
(27939, 1),
(27942, 1),
(27628, 1),
(27739, 1),
(27738, 1),
(26982, 1),
(27743, 1),
(27766, 1),
(27821, 1),
(27901, 1),
(27672, 1),
(27013, 1),
(27933, 1),
(26139, 1),
(27893, 1),
(27699, 1),
(27941, 1),
(27981, 1),
(27987, 1),
(27108, 1),
(27015, 1),
(27925, 1),
(28025, 1),
(28024, 1),
(27537, 1),
(27710, 1),
(27314, 1),
(27529, 1),
(27020, 1),
(27564, 1),
(26662, 1),
(27704, 1),
(27947, 1),
(27857, 1),
(27932, 1),
(27014, 1),
(26915, 1),
(27456, 1),
(27085, 1),
(28018, 1),
(27895, 1),
(27896, 1),
(28020, 1),
(26797, 1),
(26947, 1),
(27882, 1),
(27627, 1),
(27626, 1),
(27107, 1),
(27883, 1),
(28026, 1),
(27885, 1),
(28027, 1),
(26255, 1),
(27290, 1),
(28015, 1),
(27700, 1),
(27886, 1),
(28012, 1),
(26798, 1),
(27967, 1),
(26782, 1),
(27898, 1),
(27905, 1),
(27791, 1),
(27934, 1),
(27938, 1),
(27789, 1),
(26491, 1),
(26423, 1),
(28017, 1),
(26492, 1),
(27741, 1),
(28019, 1),
(27705, 1),
(27734, 1),
(27726, 1),
(27629, 1),
(27724, 1),
(27706, 1),
(27669, 1),
(27712, 1),
(27771, 1),
(27653, 1),
(27670, 1),
(27940, 1),
(27538, 1),
(27894, 1),
(27466, 1),
(27969, 1),
(27703, 1),
(27376, 1),
(27702, 1),
(28010, 1),
(28014, 1),
(27701, 1),
(27897, 1),
(27935, 1),
(27848, 1),
(28011, 1),
(27301, 1),
(27723, 1),
(27884, 1),
(28022, 1),
(27616, 1),
(27731, 1),
(26496, 1),
(27948, 1),
(28013, 1)
;

INSERT INTO
	@t
([Quote], [Known], [WO#], [Stargate WO#], [Model Name], [Dealer Name], [Prod Date], [Serial Number]) 
SELECT
	[Quote#],
	0,
	ISNULL([@t].[WO#], [SrcA].[WO#])
	, ISNULL([@t].[Stargate WO#], [SrcA].[Stargate WO#])
	, ISNULL([@t].[Model Name], [SrcA].[Model Name])
	, ISNULL([@t].[Dealer Name], [SrcA].[Dealer Name])
	, ISNULL([@t].[Prod Date], [SrcA].[Prod Date])
	, ISNULL([@t].[Serial Number], [SrcA].[Serial Number])
	FROM (
	SELECT 
		[Orders].[Quote#]
		, [Orders].[WO#] AS [WO#]
		, [Stargate WO#]
		, [InputField1] AS [Model Name]
		, [InputField2] AS [Dealer Name]
		, ISNULL([Prod Date 1], [Prod Date 2]) AS [Prod Date]
		, [Serial Number]
	FROM [dtProductionSchedule]
	LEFT OUTER JOIN
		[Orders]
	ON
		[dtProductionSchedule].[Quote#] = [Orders].[Quote#]

	WHERE ISNULL([Prod Date 1], [Prod Date 2]) IS NOT NULL AND ISNULL([Prod Date 1], [Prod Date 2]) >= '2022-12-01'
	--ORDER BY
	--	[Prod Date]
	--	, [Quote#]
) AS [SrcA]
LEFT JOIN
	@t
ON
	[SrcA].[Quote#] = [@t].[Quote]
WHERE
	[@t].[Quote] IS NULL
;

UPDATE
	@t
SET
	[WO#] = [SrcA].[WO#]
	, [Stargate WO#] = [SrcA].[Stargate WO#]
	, [Model Name] = [SrcA].[Model Name]
	, [Dealer Name] = [SrcA].[Dealer Name]
	, [Prod Date] = [SrcA].[Prod Date]
	, [Serial Number] = [SrcA].[Serial Number]
FROM (
	SELECT 
			[Quote#]
			, [SrcB].[WO#]
			, [SrcB].[Stargate WO#]
			, [SrcB].[Model Name]
			, [SrcB].[Dealer Name]
			, [SrcB].[Prod Date]
			, [SrcB].[Serial Number]
	FROM  (
		SELECT 
			[Orders].[Quote#]
			, [Orders].[WO#]
			, [Stargate WO#]
			, [InputField1] AS [Model Name]
			, [InputField2] AS [Dealer Name]
			, ISNULL([Prod Date 1], [Prod Date 2]) AS [Prod Date]
			, [Serial Number]
		FROM [dtProductionSchedule]
		LEFT OUTER JOIN
			[Orders]
		ON
			[dtProductionSchedule].[Quote#] = [Orders].[Quote#]

		WHERE ISNULL([Prod Date 1], [Prod Date 2]) IS NOT NULL AND ISNULL([Prod Date 1], [Prod Date 2]) >= '2022-12-01'
	) AS [SrcB]
	INNER JOIN
		@t
	ON
		[@t].[Quote] = [SrcB].[Quote#]
) AS [SrcA]
WHERE
	[@t].[Quote] = [SrcA].[Quote#]
;

--UPDATE
--	@t
--SET
--	[WO#] = ISNULL([@t].[WO#], [SrcB].[WO#])
--	, [Stargate WO#] = ISNULL([@t].[Stargate WO#], [SrcB].[Stargate WO#])
--	, [Model Name] = ISNULL([@t].[Model Name], [SrcB].[Model Name])
--	, [Dealer Name] = ISNULL([@t].[Dealer Name], [SrcB].[Dealer Name])
--	, [Prod Date] = ISNULL([@t].[Prod Date], [SrcB].[Prod Date])
--	, [Serial Number] = ISNULL([@t].[Serial Number], [SrcB].[Serial Number])
--FROM (
--	--SELECT 

--	--	[WO#]
--	--	, [Stargate WO#]
--	--	, [Model Name]
--	--	, [Dealer Name]
--	--	, [Prod Date]
--	--	, [Serial Number]

--	--FROM (
--		SELECT
--			[Quote#] AS [Quote#]
--			, 0 AS [Known]
--			, [SrcA].[WO#] AS [WO#]
--			, [SrcA].[Stargate WO#] AS [Stargate WO#]
--			, ISNULL([@t].[Model Name], [SrcA].[Model Name]) AS [Model Name]
--			, ISNULL([@t].[Dealer Name], [SrcA].[Dealer Name]) AS [Dealer Name]
--			, ISNULL([@t].[Prod Date], [SrcA].[Prod Date]) AS [Prod Date]
--			, ISNULL([@t].[Serial Number], [SrcA].[Serial Number]) AS [Serial Number]
--			FROM (
--			SELECT 
--				[Orders].[Quote#] AS [Quote#]
--				, [Orders].[WO#] AS [WO#]
--				, [Stargate WO#] AS [Stargate WO#]
--				, [InputField1] AS [Model Name]
--				, [InputField2] AS [Dealer Name]
--				, ISNULL([Prod Date 1], [Prod Date 2]) AS [Prod Date]
--				, [Serial Number]
--			FROM [dtProductionSchedule]
--			LEFT OUTER JOIN
--				[Orders]
--			ON
--				[dtProductionSchedule].[Quote#] = [Orders].[Quote#]

--			WHERE ISNULL([Prod Date 1], [Prod Date 2]) IS NOT NULL AND ISNULL([Prod Date 1], [Prod Date 2]) >= '2022-10-01'
--			--ORDER BY
--			--	[Prod Date]
--			--	, [Quote#]
--		) AS [SrcA]
--		LEFT JOIN
--			@t
--		ON
--			[SrcA].[Quote#] = [@t].[Quote]
--	) AS [SrcB]
--;
	
SELECT '@t' AS [Table], * FROM @t;
--SELECT * FROM @t WHERE [Known] = 0 OR [Known] IS NULL;

--SELECT * FROM [SNC Year] WHERE [Year] = DATEPART(YEAR, GETDATE())
--UNION
--SELECT * FROM [SNC Year] WHERE [Year] = DATEPART(YEAR, GETDATE()) + 1
--UNION
--SELECT * FROM [SNC Year] WHERE [Year] = DATEPART(YEAR, GETDATE()) + 2


-----------------------------------------------------------------------------------------------------------------------

declare @chartonum table
	(
		[Character] char(1),
		[Number] int
	)

	insert into @chartonum
	values ('A', 1),
			('B', 2),
			('C', 3),
			('D', 4),
			('E', 5),
			('F', 6),
			('G', 7),
			('H', 8),
			('J', 1),
			('K', 2),
			('L', 3),
			('M', 4),
			('N', 5),
			('P', 7),
			('R', 9),
			('S', 2),
			('T', 3),
			('U', 4),
			('V', 5),
			('W', 6),
			('X', 7),
			('Y', 8),
			('Z', 9)


	DECLARE @quote int, @year int;
	--SET @quote = 27616;
	SET @year = 2024

--Generate Check Number calc for Serial Number
declare @cn int

DECLARE @sn AS NVARCHAR(MAX);
DECLARE @i AS INT, @c AS INT;
SELECT @i = 1;
SELECT @c = COUNT(*) FROM @t;

SELECT @c AS [@c], @i AS [@i]

	declare @newsn NVARCHAR(6)
	--select @newsn = case when @maxsn is null then 1001 else @maxsn + 1 end
	--select @newsn = case when @maxsn is null then 100001 else @maxsn + 1 end


	DECLARE @cont AS INT;
	SELECT @cont = COUNT(*) + 1
	from Orders with (nolock)
	cross join [SNC Year] with (nolock)
	where [Year] = @year
	and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
	AND LEFT([Serial Number], 3) IN ('2XB', '2B9')

SELECT @cont AS [Cont]


WHILE @i <= @c BEGIN
	
	SELECT @quote = [Quote] FROM @t WHERE [ID] = @i;
	SELECT @sn = [Serial Number] FROM @t WHERE [ID] = @i;
	IF LEN(@sn) > 5 BEGIN

		--select @newsn = RIGHT([Serial Number], 6), @quote = [Quote] FROM  @t WHERE [ID] = @i
		SELECT @newsn = RIGHT('000000' + CAST(@i + @cont AS NVARCHAR(6)), 6);
		--SELECT @newsn AS [NEWSN], @i AS [@i]


		--select @cn = 16 + 14 + 54 + (subCTN.Number * 5) + (Position5 * 4)
		-- 2XB => Values=(2, 7, 2) Weights=(8, 7, 6)
		-- 2B9 => Values=(2, 2, 9)
		select @cn = (2 * 8) + (7 * 7) + (2 * 6) + (subCTN.Number * 5) + (Position5 * 4)
		from [SN Type] with (nolock)
		inner join Products with (nolock) on [SN Type].[Model No] = Products.[Model No]
		inner join (select distinct [Model No] from Orders with (nolock) where Quote# = @quote) as subA on Products.[Model No] = subA.[Model No]
		inner join @chartonum as subCTN on [SN Type].Position4 = subCTN.Character
		cross join [SNC Year] with (nolock)
		where [Year] = @year

		select @cn = @cn + ((case when subCTN.Number is null then Position6 else subCTN.Number end) * 3)
		from [SN Type] with (nolock)
		inner join Products with (nolock) on [SN Type].[Model No] = Products.[Model No]
		inner join (select distinct [Model No] from Orders with (nolock) where Quote# = @quote) as subA on Products.[Model No] = subA.[Model No]
		left outer join @chartonum as subCTN on [SN Type].Position6 = subCTN.Character
		cross join [SNC Year] with (nolock)
		where [Year] = @year

		select @cn = @cn + (case when ISNUMERIC(Position7) = 1 then Position7 else subCTN.Number end * 2) + (Position8 * 10)
		from [SN Type] with (nolock)
		inner join Products with (nolock) on [SN Type].[Model No] = Products.[Model No]
		inner join (select distinct [Model No] from Orders with (nolock) where Quote# = @quote) as subA on Products.[Model No] = subA.[Model No]
		left outer join @chartonum as subCTN on [SN Type].Position7 = subCTN.Character
		cross join [SNC Year] with (nolock)
		where [Year] = @year

		select @cn = @cn + (subCTN.Number * 9) + (1 * 8) + ((left(right(@newsn, 6), 1)) * 7) + ((left(right(@newsn, 5), 1)) * 6) + ((left(right(@newsn, 4), 1)) * 5)
						+ ((left(right(@newsn, 3), 1)) * 4) + ((left(right(@newsn, 2), 1)) * 3)
						+ ((right(@newsn, 1)) * 2)
		from [SN Type] with (nolock)
		inner join Products with (nolock) on [SN Type].[Model No] = Products.[Model No]
		inner join (select distinct [Model No] from Orders with (nolock) where Quote# = @quote) as subA on Products.[Model No] = subA.[Model No]
		cross join [SNC Year] with (nolock)
		inner join @chartonum as subCTN on [SNC Year].[SN Yr] = subCTN.Character
		where [Year] = @year

		UPDATE
			@t
		SET
			[CN] = CAST(((@cn - 1) % 11) AS NVARCHAR(MAX)),
			[CONT] = @newsn
		WHERE
			[ID] = @i

	END

	SELECT @i = @i + 1;
END
;

UPDATE
	@t
SET 
	[New SN] = (CASE
		WHEN
			LEN([Serial Number]) > 4 
		THEN
			REPLACE(
				LEFT([Serial Number], 9)		
				+ 'R'
				+ LEFT(RIGHT([Serial Number], 7), 1) 
				--+ '000' 
				+ RIGHT([CONT], 6)
				, '2B9B', '2XBB')
		ELSE
			[Serial Number]
		END)
;


UPDATE
	@t
SET 
	[New SN2] = (CASE
		WHEN 
			LEN([Serial Number]) > 4
		THEN
			LEFT([New SN], 8)
			+ (CASE
				WHEN
					[CN] = 10 
				THEN
					'X'
				ELSE
					CAST([CN] AS NVARCHAR(1))
				END)
			+ RIGHT([New SN], 8)
		ELSE
			[New SN]
		END)


-----------------------------------------------------------------------------------------------------------------------


SELECT
	*
	, LEN([Serial Number]) AS [L1]
	, LEN([New SN]) AS [L2]
	, LEN([New SN2]) AS [L3]
FROM
	@t
ORDER BY
	(CASE WHEN [Quote] = 27830 THEN 0 ELSE 1 END),
	[Prod Date]

-----------------------------------------------------------------------------------------------------------------------

PRINT 'BEGIN UPDATES'

BEGIN TRAN;


SELECT 'BEFORE' AS [TABLE], * FROM [Orders] INNER JOIN @t ON [Orders].[Quote#] = [@t].[Quote]

SELECT
	[Quote]
	, [Orders].[WO#]
	, [Prod Date]
	, [Orders].[Serial Number] AS [Serial Before]
	, [NEW SN2] AS [New Serial]
	, [Model Name]
	, [COMPANY NAME] AS [Dealer]
	, (CASE
		WHEN
			LEN([Orders].[Serial Number]) > 4
		THEN
			[Special Instructions] + ' 2022-09-22 3PM - ABRIGGS - VIN CHANGE ''' + [Orders].[Serial Number] + ''' to ''' + [NEW SN2] + ''' to match 2024 prod year.'
		ELSE
			[Orders].[Special Instructions]
		END) AS [Special Instructions]
FROM
	[Orders]
INNER JOIN
	@t
ON
	[Orders].[Quote#] = [@t].[Quote]
INNER JOIN
	[Dealers]
ON
	[Orders].[DealerID] = [Dealers].[ID]
ORDER BY
	[Prod Date]
;

UPDATE
	[Orders]
SET
	[Special Instructions] = (CASE
		WHEN
			LEN([Orders].[Serial Number]) > 4
		THEN
			[Special Instructions] + ' 2022-09-22 3PM - ABRIGGS - VIN CHANGE ''' + [Orders].[Serial Number] + ''' to ''' + [NEW SN2] + ''' to match 2024 prod year.'
		ELSE
			[Orders].[Special Instructions]
		END)
	, [Serial Number] = [NEW SN2]
FROM
	@t
WHERE
	[Orders].[Quote#] = [@t].[Quote]


SELECT 'AFTER' AS [TABLE], * FROM [Orders] INNER JOIN @t ON [Orders].[Quote#] = [@t].[Quote]

SELECT [Serial Number] FROM [Orders]
WHERE
	([Serial Number] LIKE '%2B9%' OR [Serial Number] LIKE '%2XB%') AND ([Serial Number] LIKE '%RA%' OR [Serial Number] LIKE '%PA%')
GROUP BY
	[Serial Number]
HAVING COUNT(*) > 1
ORDER BY
	[Orders].[Serial Number]

ROLLBACK;
COMMIT;