
-- Was a mistake in the script used to generate serials on 2025-03-04
-- The check digit was wrong for about 30 units
-- corrected here by applying groupbys to the @cn building selects, and moving the @chartonum table outside of the loop.
-- 2025-05-09 1620



			/*SELECT * FROM
			[BWSdb].[dbo].[SN Type] with (nolock) ORDER BY [Position7]*/

--EXEC [BWSdb].[dbo].[sp_SerialNumberCalc] @quote=30929, @year=2026, @mode=1, @startSeq=61

	DECLARE @quote INT = NULL;
	DECLARE @year INT = NULL;
	DECLARE @startSeq INT = NULL
	DECLARE @mode INT = 0

	DECLARE @calc_pos_7 AS NVARCHAR(1);
	-- These are defaults for BWS, they are recalulated below.
	DECLARE @prefix AS NVARCHAR(3) = '2XB';
	DECLARE @plant AS NVARCHAR(1) = 'A';
	DECLARE @comp AS INT = 0;
	DECLARE @compChar AS NVARCHAR(1) = 'B';  -- Position4 (Company)
	
	DECLARE @modelName AS NVARCHAR(MAX);
	DECLARE @className AS NVARCHAR(MAX);
	DECLARE @pid AS INT;
	DECLARE @scm AS INT;

	DECLARE @src TABLE ([ID] INT IDENTITY(0, 1), [Quote] INT, [SerialOld] NVARCHAR(17), [Year] INT, [SerialNew] NVARCHAR(17), [Seq] INT, [Plant] NVARCHAR(1))
	INSERT INTO @src ([Quote], [SerialOld], [Year], [Seq], [Plant])
	SELECT
		[Quote#],
		[Serial Number],
		[S].[Year],
		CAST(RIGHT([Serial Number], 6) AS INT),
		[O].[PlantOfManufactureCode]
	FROM
		[BWSdb].[dbo].[Orders] [O]
	LEFT JOIN
		[BWSdb].[dbo].[SNC Year] [S]
	ON
		SUBSTRING([O].[Serial Number], 10, 1) = [S].[SN Yr]
	WHERE
		([O].[QuoteAsStargate] = 1)
		--AND (RIGHT([O].[Serial Number], 2) = '62')
	;

	
	-- Insert statements for procedure here
	--Create table variable to store character-to-number comparison for future reference
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
	
	DECLARE @i INT = 0;
	DECLARE @c INT = 0;

	SELECT @c = COUNT(*) FROM @src;

	WHILE @i < @c BEGIN

		SELECT
			@quote = [Quote],
			@year = [Year],
			@startSeq = [Seq] - 1
		FROM
			@src
		WHERE
			[@src].[ID] = @i

		SELECT
			@modelName = [Model No]
			,@pid = [ProductID]
		FROM
			[BWSdb].[dbo].[Orders] [O]
		WHERE
			[Quote#] = @quote
		;

		SELECT
			@scm = [SerialCalcMethod]
			,@className = [Class]
		FROM
			[BWSdb].[dbo].[Products]
		WHERE
			[IDTrailer] = @pid
		;

		SELECT
			@prefix = ISNULL([CVMA_Prefix], @prefix),
			@plant = ISNULL([CSNI].[PlantOfManufacture], @plant),
			@comp = ISNULL([CSNI].[CompanyID], @comp),
			-- @compChar = ISNULL((CASE WHEN ISNULL([QuoteAsStargate], 0) = 1 THEN 'S' ELSE 'B' END), @compChar) -- 2025-02-28 Using 'B' from now on
			@compChar = 'B'
		FROM 
			[BWSdb].[dbo].[Orders] [O]
		CROSS JOIN (
			SELECT
				[CompanyID],
				[PlantOfManufacture],
				[CVMA_Prefix],
				ROW_NUMBER() OVER(
					--PARTITION BY
						--[CompanyID]
					ORDER BY
						[ID]
				) AS [RN]
			FROM
				[BWSdb].[dbo].[CompanySNInfo]
		) AS [CSNI]
		WHERE
			[Quote#] = @quote
			AND (
				(
					(CASE WHEN ISNULL([QuoteAsStargate], 0) = 1 THEN 1 ELSE 0 END) = [CSNI].[CompanyID]
					AND [O].[PlantOfManufactureCode] = [CSNI].[PlantOfManufacture]
				)
				OR ([RN] = 1)
			)
		/*ORDER BY
			(CASE WHEN [O].[PlantOfManufactureCode] = [CSNI].[PlantOfManufacture] THEN 0 ELSE 1 END),
			[RN]
		*/
		;
		/*
		SELECT
			'BEGIN' AS [T],
			@prefix AS [Prefix],
			@plant AS [Plant],
			@comp AS [Comp],
			@scm AS [SCM],
			@mode AS [Mode],
			@year AS [Year],
			@quote AS [Quote]
		*/

		IF @scm = 1 BEGIN
			-- Simple serial calc method for like-class units
			-- Agriculture, Stargate, Snow & Ice Control (DOT) units
			-- 5 digits
			SELECT
				RIGHT('00000' + CAST(ISNULL(MAX([Serial Number]) + 1, 1) AS NVARCHAR(MAX)), 6) AS [NewSN]
			FROM
				[BWSdb].[dbo].[Orders]
			INNER JOIN
				[BWSdb].[dbo].[Products]
			ON
				[Orders].[Model No] = [Products].[Model No]
			WHERE
				[Class] = @className
				AND [Products].[Model No] NOT LIKE '%SPUD KIT%'
				AND ISNUMERIC([Serial Number]) = 1
				AND [Decline/Rejected] = 4
		END
		ELSE IF @scm = 2 BEGIN 
			-- Simple serial calc method for like-class units
			-- Towing units
			-- 6 digits and prefixed by '26' initially
			SELECT
				CAST(ISNULL(MAX([Serial Number]) + 1, 260001) AS NVARCHAR(MAX)) AS [NewSN]
			FROM
				[BWSdb].[dbo].[Orders]
			INNER JOIN
				[BWSdb].[dbo].[Products]
			ON
				[Orders].[Model No] = [Products].[Model No]
			WHERE
				[Class] = @className
				AND ISNUMERIC([Serial Number]) = 1
				AND [Decline/Rejected] = 4
		END
		ELSE BEGIN

			--Grab last used serial number for selected model year
			declare @maxsn int = 0;
			IF @comp = 0 BEGIN
				select @maxsn = MAX(CAST(RIGHT([Serial Number], 6) AS INT)) + 1
				--select @maxsn2 = COUNT(*) + 2
				from [BWSdb].[dbo].[Orders] with (nolock)
				cross join [BWSdb].[dbo].[SNC Year] with (nolock)
				where [Year] = @year
				and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
				AND LEFT([Serial Number], 3) IN ('2XB', '2B9')
				AND [Decline/Rejected] = 4
			END
			ELSE BEGIN

				SELECT
					@maxsn = MAX([RSN])
				FROM (
					SELECT ISNULL(CAST(RIGHT([Serial Number], 6) AS INT), 0) AS [RSN]
					FROM [BWSdb].[dbo].[Orders] with (nolock)
					cross join [BWSdb].[dbo].[SNC Year] with (nolock)
					where [Year] = @year
					and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
					AND LEFT([Serial Number], 3) IN ('2SV', '2XB', '2S9')
					AND [Decline/Rejected] = 4
					AND [QuoteAsStargate] = 1

					UNION

					SELECT ISNULL(CAST(RIGHT([Serial Number], 6) AS INT), 0) AS [RSN]
					FROM [BWSdb].[dbo].[OrdersV2] with (nolock)
					cross join [BWSdb].[dbo].[SNC Year] with (nolock)
					where [Year] = @year
					and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'M' + '%'
					AND LEFT([Serial Number], 3) IN ('2SV')
					AND [Decline/Rejected] = 4
				) AS [Src]

				/*
				SELECT @maxsn = ISNULL(MAX(CAST(RIGHT([Serial Number], 6) AS INT)), 0)
				--select @maxsn2 = COUNT(*) + 2
				FROM [Orders] with (nolock)
				cross join [SNC Year] with (nolock)
				where [Year] = @year
				and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
				AND LEFT([Serial Number], 3) IN ('2SV')
				AND [Decline/Rejected] = 4
				AND [QuoteAsStargate] = 1
			
			
				SELECT @maxsn AS [MAX A]
			
				-----
				--SELECT ISNULL(MAX(CAST(RIGHT([Serial Number], 6) AS INT)), 0)
				--select @maxsn2 = COUNT(*) + 2
				--FROM [OrdersV2] with (nolock)
				--cross join [SNC Year] with (nolock)
				--where [Year] = @year
				--and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'M' + '%'
				--AND LEFT([Serial Number], 3) IN ('2SV')
				--AND [Decline/Rejected] = 4
				-----
			

				SELECT @maxsn = @maxsn + MAX(ISNULL(CAST(RIGHT([Serial Number], 6) AS INT), 0))
				--select @maxsn2 = COUNT(*) + 2
				FROM [OrdersV2] with (nolock)
				cross join [SNC Year] with (nolock)
				where [Year] = @year
				and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'M' + '%'
				AND LEFT([Serial Number], 3) IN ('2SV')
				AND [Decline/Rejected] = 4
				*/
			
				SELECT @maxsn = ISNULL(@maxsn, 0) + 1

				--SELECT @maxsn AS [MAX B]
			END

			--Geneate new number for serial number
			declare @newsn NVARCHAR(6) = '';
			--select @newsn = case when @maxsn is null then 1001 else @maxsn + 1 end
			--select @newsn = case when @maxsn is null then 100001 else @maxsn + 1 end
			select @newsn = RIGHT('000000' + CAST(case when @maxsn is null then 1 else @maxsn end AS NVARCHAR(6)), 6)
	
			-- apply startseq if not null
			IF @startSeq IS NOT NULL BEGIN
				SELECT @newsn = RIGHT('000000' + CAST(@startSeq + 1 AS NVARCHAR(6)), 6)
			END
	
			--SET @newsn = '098765';
			--SET @newsn = '100000';

			--Generate Check Number calc for Serial Number
			DECLARE @part1 INT = 0;

			
			/*SELECT * FROM
			[BWSdb].[dbo].[SN Type] with (nolock) WHERE [Model No] = @modelName ORDER BY [Position7]*/

			SELECT
				@part1 = (CASE WHEN ISNULL([QuoteAsStargate], 0) = 1
					THEN (2 * 8) + (2 * 7) + (5 * 6) -- 2SV => Values=(2, 2, 5) Weights=(8, 7, 6)
					ELSE (2 * 8) + (7 * 7) + (2 * 6) -- 2XB => Values=(2, 7, 2) Weights=(8, 7, 6) 
				END)
			FROM 
				[BWSdb].[dbo].[Orders]
			WHERE
				[Quote#] = @quote
			;

			declare @cn int;
			--select @cn = 16 + 14 + 54 + (subCTN.Number * 5) + (Position5 * 4)
			select @cn = @part1 + (subCTN.Number * 5) + (Position5 * 4)
			from [BWSdb].[dbo].[SN Type] with (nolock)
			inner join [BWSdb].[dbo].[Products] with (nolock) on [SN Type].[Model No] = Products.[Model No]
			inner join (select distinct [Model No] from [BWSdb].[dbo].[Orders] with (nolock) where Quote# = @quote) as subA on Products.[Model No] = subA.[Model No]
			--inner join @chartonum as subCTN on [SN Type].Position4 = subCTN.Character
			inner join @chartonum as subCTN on @compChar = subCTN.Character
			cross join [BWSdb].[dbo].[SNC Year] with (nolock)
			where [Year] = @year
			GROUP BY
				[subCTN].[Number],
				[Position5]


			/*
			--select @cn = (2 * 8) + (7 * 7) + (2 * 6) + (subCTN.Number * 5) + (Position5 * 4)
			--select distinct [Model No] from Orders with (nolock) where Quote# = @quote
			SELECT * FROM @chartonum
			select * FROM [Products] with (nolock) INNER JOIN [Orders] ON [Products].[Model No] = [Orders].[Model No] where Quote# = @quote
			SELECT
				'a' AS [A],
				*
			from [SN Type] with (nolock)
			inner join Products with (nolock) on [SN Type].[Model No] = Products.[Model No]
			inner join (select distinct [Model No] from Orders with (nolock) where Quote# = @quote) as subA on Products.[Model No] = subA.[Model No]
			--inner join @chartonum as subCTN on [SN Type].Position4 = subCTN.Character
			inner join @chartonum as subCTN on @compChar = subCTN.Character
			--cross join [SNC Year] with (nolock)
			--where [Year] = @year
			*/



		
			--SELECT @cn AS [CN 1]
			select @cn = @cn + ((case when subCTN.Number is null then Position6 else subCTN.Number end) * 3)
			from [BWSdb].[dbo].[SN Type] with (nolock)
			inner join [BWSdb].[dbo].[Products] with (nolock) on [SN Type].[Model No] = Products.[Model No]
			inner join (select distinct [Model No] from [BWSdb].[dbo].[Orders] with (nolock) where Quote# = @quote) as subA on Products.[Model No] = subA.[Model No]
			left outer join @chartonum as subCTN on [SN Type].Position6 = subCTN.Character
			cross join [BWSdb].[dbo].[SNC Year] with (nolock)
			where [Year] = @year
			GROUP BY
				[subCTN].[Number],
				[Position6]




			/*
			
			select 
				@cn + (case when ISNUMERIC(Position7) = 1 then Position7 else subCTN.Number end * 2) + (Position8 * 10) AS [CN HERE],
				[Position7] AS [7],
				[Position8] AS [8],
				*
			from [BWSdb].[dbo].[SN Type] with (nolock)
			inner join [BWSdb].[dbo].[Products] with (nolock) on [SN Type].[Model No] = Products.[Model No]
			inner join (select distinct [Model No] from [BWSdb].[dbo].[Orders] with (nolock) where Quote# = @quote) as subA on Products.[Model No] = subA.[Model No]
			left join @chartonum as subCTN on ([SN Type].Position7 = subCTN.Character) --AND ([SN Type].[Model No] = [subA].[Model No]))
			cross join [BWSdb].[dbo].[SNC Year] with (nolock)
			where [Year] = @year


			SELECT 
				@cn + (case when ISNUMERIC(Position7) = 1 then Position7 else subCTN.Number end * 2) + (Position8 * 10) AS [CN HERE],
				[Position7] AS [7],
				[Position8] AS [8]
			FROM
			[BWSdb].[dbo].[SN Type] with (nolock)
			inner join [BWSdb].[dbo].[Products] with (nolock) on [SN Type].[Model No] = [Products].[Model No]
			inner join (select distinct [Model No] from [BWSdb].[dbo].[Orders] with (nolock) where Quote# = @quote) as subA on Products.[Model No] = subA.[Model No]
			cross join [BWSdb].[dbo].[SNC Year] with (nolock)
			left join @chartonum as subCTN on [SN Type].[Position7] = [subCTN].[Character]
			where [Year] = @year
			GROUP BY
				[subCTN].[Number],
				[Position7],
				[Position8]
				
				*/



		
			--SELECT @cn AS [CN 2]
			select @cn = @cn + (case when ISNUMERIC(Position7) = 1 then Position7 else subCTN.Number end * 2) + (Position8 * 10)
			from [BWSdb].[dbo].[SN Type] with (nolock)
			inner join [BWSdb].[dbo].[Products] with (nolock) on [SN Type].[Model No] = Products.[Model No]
			inner join (select distinct [Model No] from [BWSdb].[dbo].[Orders] with (nolock) where Quote# = @quote) as subA on Products.[Model No] = subA.[Model No]
			left outer join @chartonum as subCTN on [SN Type].Position7 = subCTN.Character
			cross join [BWSdb].[dbo].[SNC Year] with (nolock)
			where [Year] = @year
			GROUP BY
				[subCTN].[Number],
				[Position7],
				[Position8]
		
			--SELECT @cn AS [CN 3]
			select @cn = @cn + (subCTN.Number * 9) + (1 * 8) + ((left(right(@newsn, 6), 1)) * 7) + ((left(right(@newsn, 5), 1)) * 6) + ((left(right(@newsn, 4), 1)) * 5)
						 + ((left(right(@newsn, 3), 1)) * 4) + ((left(right(@newsn, 2), 1)) * 3)
						 + ((right(@newsn, 1)) * 2)
			from [BWSdb].[dbo].[SN Type] with (nolock)
			inner join [BWSdb].[dbo].[Products] with (nolock) on [SN Type].[Model No] = Products.[Model No]
			inner join (select distinct [Model No] from [BWSdb].[dbo].[Orders] with (nolock) where Quote# = @quote) as subA on Products.[Model No] = subA.[Model No]
			cross join [BWSdb].[dbo].[SNC Year] with (nolock)
			inner join @chartonum as subCTN on [SNC Year].[SN Yr] = subCTN.Character
			where [Year] = @year
			GROUP BY
				[subCTN].[Number]
		
			--SELECT @cn AS [CN 4]
			/*
			--Generate Serial Number
			select '2XB' + Position4 + Position5 + Position6 + Position7 + cast(Position8 as nvarchar)
				   + case when @cn % 11 = 10 then 'X' else cast(@cn % 11 as nvarchar) end + [SN Yr] + 'A' + right('000000' + cast(@newsn as nvarchar), 6)
			from [SN Type] with (nolock)
			inner join Products with (nolock) on [SN Type].[Model No] = Products.[Model No]
			inner join (select distinct [Model No] from Orders with (nolock) where Quote# = @quote) as subA on Products.[Model No] = subA.[Model No]
			cross join [SNC Year] with (nolock)
			where [Year] = @year
			*/

	

			SELECT
				@calc_pos_7 = [SN].[Position7]
			FROM
				[BWSdb].[dbo].[SN Type] [SN]
			INNER JOIN
				[BWSdb].[dbo].[Orders] [O]
			ON
				[O].[Quote#] = @quote
			WHERE
				[SN].[Model No] = [O].[Model No]

			/*
			SELECT
				@mode AS [Mode]
				,@calc_pos_7 AS [7]
				, @cn AS [CN]
				, @maxsn AS [Max]
			*/

			IF @mode = 3 BEGIN
				-- Duplicate of NULL case. Can be deleted once confirmed mode=3 is not used as a parameter from access pass-thru.
				-- 2024-03-25 1351 Abriggs
				--select @prefix + Position4 + Position5 + Position6 + @calc_pos_7 + cast(Position8 as nvarchar(1))
				select @prefix + @compChar + Position5 + Position6 + @calc_pos_7 + cast(Position8 as nvarchar(1))
						+ case when @cn % 11 = 10 then 'X' else cast(@cn % 11 as nvarchar) end + [SN Yr] + @plant + right('000000' + cast(@newsn as nvarchar), 6)
						as [NewSN]
				from [BWSdb].[dbo].[SN Type] with (nolock)
				inner join [BWSdb].[dbo].[Products] with (nolock) on [SN Type].[Model No] = [Products].[Model No]
				inner join (select distinct [Model No] from [BWSdb].[dbo].[Orders] with (nolock) where [Quote#] = @quote) as subA on [Products].[Model No] = subA.[Model No]
				cross join [BWSdb].[dbo].[SNC Year] with (nolock)
				where [Year] = @year AND [Products].[CompanyID] = 0 AND [SN Type].[CompanyID] = 0
			END
			ELSE IF @mode IS NULL BEGIN
				--Generate Serial Number, assembled
				--select @prefix + Position4 + Position5 + Position6 + @calc_pos_7 + cast(Position8 as nvarchar(1))
				select @prefix + @compChar + Position5 + Position6 + @calc_pos_7 + cast(Position8 as nvarchar(1))
						+ case when @cn % 11 = 10 then 'X' else cast(@cn % 11 as nvarchar) end + [SN Yr] + @plant + right('000000' + cast(@newsn as nvarchar), 6)
						as [NewSN]
				from [BWSdb].[dbo].[SN Type] with (nolock)
				inner join [BWSdb].[dbo].[Products] with (nolock) on [SN Type].[Model No] = [Products].[Model No]
				inner join (select distinct [Model No] from [BWSdb].[dbo].[Orders] with (nolock) where [Quote#] = @quote) as subA on [Products].[Model No] = subA.[Model No]
				cross join [BWSdb].[dbo].[SNC Year] with (nolock)
				where [Year] = @year AND [Products].[CompanyID] = 0 AND [SN Type].[CompanyID] = 0
			END
			--ELSE IF @mode = 2 BEGIN
			--	SELECT * FROM @resultT
			--END
			ELSE BEGIN
				-- Return the parts as individual columns
				select @prefix AS [Prefix]
					--, Position4 AS [4]
					, @compChar AS [4]
					, Position5 AS [5]
					, Position6 AS [6]
					, @calc_pos_7 AS [7]
					, cast(Position8 as nvarchar) AS [8]
					, case when @cn % 11 = 10 then 'X' else cast(@cn % 11 as nvarchar) end AS [CD]
					, [SN Yr] AS [10]
					, @plant AS [11]
					, right('000000' + cast(@newsn as nvarchar), 6) AS [#]
				from [BWSdb].[dbo].[SN Type] with (nolock)
				inner join [BWSdb].[dbo].[Products] with (nolock) on [SN Type].[Model No] = [Products].[Model No]
				inner join (select distinct [Model No] from [BWSdb].[dbo].[Orders] with (nolock) where [Quote#] = @quote) as subA on [Products].[Model No] = subA.[Model No]
				cross join [BWSdb].[dbo].[SNC Year] with (nolock)
				where [Year] = @year AND [Products].[CompanyID] = 0 AND [SN Type].[CompanyID] = 0
			END
		END		

		UPDATE
			@src
		SET
			[SerialNew] = 

			(select @prefix + @compChar + Position5 + Position6 + @calc_pos_7 + cast(Position8 as nvarchar(1))
						+ case when @cn % 11 = 10 then 'X' else cast(@cn % 11 as nvarchar) end + [SN Yr] + @plant + right('000000' + cast(@newsn as nvarchar), 6)
						as [NewSN]
				from [BWSdb].[dbo].[SN Type] with (nolock)
				inner join [BWSdb].[dbo].[Products] with (nolock) on [SN Type].[Model No] = [Products].[Model No]
				inner join (select distinct [Model No] from [BWSdb].[dbo].[Orders] with (nolock) where [Quote#] = @quote) as subA on [Products].[Model No] = subA.[Model No]
				cross join [BWSdb].[dbo].[SNC Year] with (nolock)
				where [Year] = @year AND [Products].[CompanyID] = 0 AND [SN Type].[CompanyID] = 0)

		WHERE
			[ID] = @i

		SELECT @i = @i + 1;

		/*
		SELECT
			'END' AS [E],
			@prefix AS [Prefix],
			@plant AS [Plant],
			@comp AS [Comp],
			@scm AS [SCM],
			@mode AS [Mode],
			@year AS [Year],
			@quote AS [Quote],
			@cn AS [CN],
			@part1 AS [Part1],
			@calc_pos_7
		;
		*/	
	END
;

SELECT
	[Quote]
	,[Model No]
	,[Year]
	,[Seq]
	,[SerialOld]
	,[SerialNew]
	,ISNULL(([Notes] + ' '), '') + (LEFT(DATENAME(MONTH, GETDATE()), 3) 
	+ ' ' + RIGHT('00' + CAST(DAY(GETDATE()) AS NVARCHAR(2)), 2)
	+ ', ' + RIGHT('0000' + CAST(YEAR(GETDATE()) AS NVARCHAR(4)), 4)
	+ ' - Avery Briggs - Serial Number Change ''' + [O].[Serial Number] + ''' to ''' + [S].[SerialNew] + '''.') AS [Notes]
FROM
	@src [S]
INNER JOIN
	[BWSdb].[dbo].[Orders] [O]
ON
	[S].[Quote] = [O].[Quote#]
WHERE
	LEN(ISNULL([SerialNew], '')) = 17
	AND ([SerialOld] <> [SerialNew])
;

SELECT
	@i = 0
	, @c = COUNT(*)
FROM
	@src
;

SELECT
	@i AS [i]
	,@c AS [c]

BEGIN TRAN;

DECLARE @oSN AS NVARCHAR(MAX);
DECLARE @nSN AS NVARCHAR(MAX);

WHILE @i < @c BEGIN

	SELECT
		@oSN = [SerialOld],
		@nSN = [SerialNew]
	FROM
		@src
	WHERE
		([ID] = @i)
		AND (LEN(ISNULL([SerialNew], '')) = 17)
	;

	IF @oSN <> @nSN BEGIN
		UPDATE
			[BWSdb].[dbo].[Orders]
		SET
			[Serial Number] = [S].[SerialNew]
			,[Notes] = ISNULL(([Notes] + ' '), '') + (LEFT(DATENAME(MONTH, GETDATE()), 3) 
		+ ' ' + RIGHT('00' + CAST(DAY(GETDATE()) AS NVARCHAR(2)), 2)
		+ ', ' + RIGHT('0000' + CAST(YEAR(GETDATE()) AS NVARCHAR(4)), 4)
		+ ' - Avery Briggs - Serial Number Change ''' + [O].[Serial Number] + ''' to ''' + [S].[SerialNew] + '''.')
		FROM
			[BWSdb].[dbo].[Orders] [O]
		INNER JOIN (
			SELECT
				*
			FROM
				@src
			WHERE
				([ID] = @i)
				AND (LEN(ISNULL([SerialNew], '')) = 17)
		) AS [S]
		ON
			[O].[Quote#] = [S].[Quote]
		;
	END
	SELECT @i = @i + 1;
	SELECT @i AS [@i]

END

SELECT
	*
FROM
	[BWSdb].[dbo].[Orders] [O]
INNER JOIN
	@src [S]
ON
	[O].[Quote#] = [S].[Quote]
WHERE
 LEN(ISNULL([SerialNew], '')) = 17

ROLLBACK;
COMMIT;

