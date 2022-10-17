USE BWSdb
GO

DECLARE @SNS_TO_CHANGE AS TABLE ([ID] INT IDENTITY(1, 1), [Quote] INT, [CalcSN] NVARCHAR(17))

INSERT INTO @SNS_TO_CHANGE ([Quote]) VALUES
(27734),
(27665),
(27629),
(27667),
(27999),
(28093),
(28094),
(28095),
(28096),
(28097),
(27975),
(27977),
(27974),
(28016),
(28023),
(28107),
(27984),
(28122),
(28131),
(28121),
(28123),
(28132),
(28133),
(28134),
(28135),
(27737),
(28030),
(28148);

SELECT * FROM @SNS_TO_CHANGE;
SELECT
	*
FROM
	@SNS_TO_CHANGE 
INNER JOIN
	[Orders]
ON
	[@SNS_TO_CHANGE].[Quote] = [Orders].[Quote#]
;

	DECLARE @quote int, @year int;

SET @year = 2024;

--declare @maxsn int
--	select @maxsn = MAX(CAST(RIGHT([Serial Number], 6) AS INT)) + 1
--	--select @maxsn2 = COUNT(*) + 2
--	from Orders with (nolock)
--	cross join [SNC Year] with (nolock)
--	where [Year] = @year
--	and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
--	AND LEFT([Serial Number], 3) IN ('2XB', '2B9')
--	AND [Date Declined] IS NULL

	
	DECLARE @q AS INT;
	DECLARE @i AS INT;
	DECLARE @c AS INT;
	declare @maxsn AS int
	
	SELECT @i = 0;
	SELECT @c = COUNT(*) FROM @SNS_TO_CHANGE;

	WHILE @i <= @c BEGIN

		SELECT @quote = [Quote] FROM @SNS_TO_CHANGE WHERE [ID] = @i + 1
		--SET @quote = 27616;
		--SET @year = 2024

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

		--Grab last used serial number for selected model year
		select @maxsn = MAX(CAST(RIGHT([Serial Number], 6) AS INT)) + 1 + @i
		--select @maxsn2 = COUNT(*) + 2
		from Orders with (nolock)
		cross join [SNC Year] with (nolock)
		where [Year] = @year
		and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
		AND LEFT([Serial Number], 3) IN ('2XB', '2B9')
		AND [Date Declined] IS NULL

		--Geneate new number for serial number
		declare @newsn NVARCHAR(6)
		--select @newsn = case when @maxsn is null then 1001 else @maxsn + 1 end
		--select @newsn = case when @maxsn is null then 100001 else @maxsn + 1 end
		select @newsn = RIGHT('000000' + CAST(case when @maxsn is null then 1 else @maxsn + 1 end AS NVARCHAR(6)), 6)
	
		--SET @newsn = '098765';
		--SET @newsn = '100000';

		--Generate Check Number calc for Serial Number
		declare @cn int
		--select @cn = 16 + 14 + 54 + (subCTN.Number * 5) + (Position5 * 4)
		-- 2XB => Values=(2, 7, 2) Weights=(8, 7, 6)
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

		--Generate Serial Number
		UPDATE @SNS_TO_CHANGE
		SET [CalcSN] = 
		'2XB' + Position4 + Position5 + Position6 + Position7 + cast(Position8 as nvarchar)
			   + case when @cn % 11 = 10 then 'X' else cast(@cn % 11 as nvarchar) end + [SN Yr] + 'A' + right('000000' + cast(@newsn as nvarchar), 6)
		from [SN Type] with (nolock)
		inner join Products with (nolock) on [SN Type].[Model No] = Products.[Model No]
		inner join (select distinct [Model No] from Orders with (nolock) where Quote# = @quote) as subA on Products.[Model No] = subA.[Model No]
		cross join [SNC Year] with (nolock)
		where [Year] = @year AND [@SNS_TO_CHANGE].[ID] = @i
		


		SELECT @i = @i + 1;
	END
;

SELECT
	[Quote#]
	, [Serial Number]
	, [CalcSN],
	*
FROM
	@SNS_TO_CHANGE 
INNER JOIN
	[Orders]
ON
	[@SNS_TO_CHANGE].[Quote] = [Orders].[Quote#]
;




-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

SELECT
	[@SNS_TO_CHANGE].[Quote]
	,[Orders].[WO#]
	, [Orders].[Serial Number] AS [OLD Serial]
	, [CalcSN] AS [New Serial]
	,ISNULL([Prod Date 1], [Prod Date 2]) AS [Prod Date]
	,(CASE
		WHEN
			LEN([Orders].[Serial Number]) > 4
		THEN
			ISNULL([Special Instructions], '') + ' 2022-10-17 11AM - ABRIGGS - VIN CHANGE ''' + [Orders].[Serial Number] + ''' to ''' + [CalcSN] + ''' correcting sequential suffix numbers.'
		ELSE
			[Orders].[Special Instructions]
		END) AS [Special Instructions]
	,[COMPANY NAME]
	,[Orders].[Model No]
FROM
	[Orders]
INNER JOIN
	@SNS_TO_CHANGE
ON
	[Orders].[Quote#] = [@SNS_TO_CHANGE].[Quote]
INNER JOIN
	[Dealers]
ON
	[Orders].[DealerID] = [Dealers].[ID]
INNER JOIN
	[dtProductionSchedule]
ON
	[Orders].[Quote#] = [dtProductionSchedule].[Quote#]


BEGIN TRAN;

UPDATE
	[Orders]
SET
	[Special Instructions] = (CASE
		WHEN
			LEN([Orders].[Serial Number]) > 4
		THEN
			ISNULL([Special Instructions], '') + ' 2022-10-17 11AM - ABRIGGS - VIN CHANGE ''' + [Orders].[Serial Number] + ''' to ''' + [CalcSN] + ''' correcting sequential suffix numbers.'
		ELSE
			[Orders].[Special Instructions]
		END)
	, [Serial Number] = [CalcSN]
FROM
	@SNS_TO_CHANGE
WHERE
	[Orders].[Quote#] = [@SNS_TO_CHANGE].[Quote]

ROLLBACK;
COMMIT;
	
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------