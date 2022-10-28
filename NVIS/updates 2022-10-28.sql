
-- USE THIS ONE 2022-10-28
-- Recalculate the serials for the list of quotes below.
-- adjust the year variable to change production year.

USE BWSdb
GO

DECLARE @year AS INT;
SELECT @year = 2024;

DECLARE @q as int

DECLARE @t AS TABLE ([ID] INT IDENTITY(1, 1), [Quote] INT)
INSERT INTO @t ([Quote]) VALUES
(27665),
(27667),
(27734),
(27629),
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
(27737),
(28122),
(28131),
(28121),
(28123),
(28132),
(28133),
(28134),
(28135),
(28030),
(28148)
;

DECLARE @i AS INT;
DECLARE @c AS INT;
SELECT @i = 1;
SELECT @c = COUNT(*) FROM @t;

DECLARE @res AS TABLE([ID] INT IDENTITY(1, 1), [Quote] INT, [NEWSN] NVARCHAR(17))

WHILE @i <= @c BEGIN

	SELECT @q = [Quote] FROM @t WHERE [ID] = @i;

	INSERT INTO @res ([NEWSN])
	EXEC [sp_SerialNumberCalc] @quote=@q, @year=@year
	
	--SELECT @i AS [@i], * FROM @res

	UPDATE
		@res
	SET
		[NEWSN] = LEFT([NEWSN], 11) + RIGHT('000000' + CAST(CAST(RIGHT([NEWSN], 6) AS INT) + @i AS NVARCHAR(6)), 6)
		, [Quote] = @q
	WHERE 
		[ID] = @i

	SELECT @i = @i + 1;

END

SELECT
	'BEFORE',
	[Quote],
	[dtProductionSchedule].[WO#],
	[Model No], 
	[Serial Number],
	[NEWSN],
	ISNULL([Prod Date 1], [Prod Date 2]) AS [Prod Date],
	[Special Instructions] = [Special Instructions] + ', 2022-10-28 1PM VIN CHANGE ''' + [Serial Number] + ''' to ''' + [NEWSN] + ''' correcting trailer type, length, and axles from previous serial.',
	[COMPANY NAME]
FROM
	[Orders] 
INNER JOIN 
	@res
ON
	[Orders].[Quote#] = [@res].[Quote] 
LEFT JOIN
	[dtProductionSchedule] 
ON
	[Orders].[Quote#] = [dtProductionSchedule].[Quote#]
LEFT JOIN
	[Dealers]
ON
	[Orders].[DealerID] = [Dealers].[ID]
;

BEGIN TRAN;

UPDATE
	[Orders]
SET
	[Serial Number] = [NEWSN]
FROM
	@res
WHERE
	[Orders].[Quote#] = [@res].[Quote]

	

SELECT
	'AFTER',
	[Quote],
	[dtProductionSchedule].[WO#],
	[Model No], 
	[Serial Number],
	[NEWSN],
	ISNULL([Prod Date 1], [Prod Date 2]) AS [Prod Date],
	[Special Instructions] = [Special Instructions] + ', 2022-10-28 1PM VIN CHANGE ''' + [Serial Number] + ''' to ''' + [NEWSN] + ''' correcting trailer type, length, and axles from previous serial.',
	[COMPANY NAME]
FROM
	[Orders] 
INNER JOIN 
	@res
ON
	[Orders].[Quote#] = [@res].[Quote] 
LEFT JOIN
	[dtProductionSchedule] 
ON
	[Orders].[Quote#] = [dtProductionSchedule].[Quote#]
LEFT JOIN
	[Dealers]
ON
	[Orders].[DealerID] = [Dealers].[ID]
;

ROLLBACK;
COMMIT;


--SELECT * FROM @res



--SELECT @q=27724

/*
SELECT * FROM [dtProductionSchedule] WHERE [Quote#] = @q
SELECT * FROM [Orders] WHERE [Quote#] = @q
SELECT * FROM [Products] WHERE [Model No] = '30NTT'

(select distinct [Model No] from Orders with (nolock) where Quote# = @q)


EXEC [sp_SerialNumberCalc] @quote=27667, @year=2024

EXEC [sp_SerialNumberCalc] @quote =28123, @year = 2024
*/