/*

USE BWSdb
GO

select * from [Budget Options] with (nolock)
inner join Options with (nolock) on Options.[Model No] = [Budget Options].[Model No]
									and Options.[Option No] = [Budget Options].[Option No]
where [Draw/Part#] like '99%'


use SysproCompanyA
go
select WorkCentre, IMachine, * from BomOperations with (nolock)
where StockCode like '99%'
*/


USE BWSdb
GO

DECLARE @JOBS TABLE ([ID] INT PRIMARY KEY, [Quote#] INT);
INSERT INTO @JOBS VALUES
	(1, 26525),
	(2, 26526),
	(3, 26527),
	(4, 26528),
	(5, 26529),
	(6, 26530),
	(7, 26531),
	(8, 26532),
	(9, 26533),
	(10, 26534),
	(11, 26535),
	(12, 26536),
	(13, 26537),
	(14, 26538),
	(15, 26539),
	(16, 26540),
	(17, 26541),
	(18, 26542),
	(19, 26543),
	(20, 26544),
	(21, 26578),
	(22, 26579),
	(23, 26580),
	(24, 26581),
	(25, 26582),
	(26, 26583),
	(27, 26584),
	(28, 26585),
	(29, 26586),
	(30, 26587)
;

/*
SELECT * FROM [Order Hours] WHERE [Quote#] IN (
		SELECT
			[Quote#]
		FROM @JOBS
	)
;


SELECT * FROM @JOBS

DECLARE @N INT;
DECLARE @I INT = 1;
SET @N = (SELECT COUNT(*) FROM @JOBS)

WHILE @I <= @N BEGIN
	SELECT [Quote#] FROM @JOBS WHERE [ID] = @I;
	SET @I = @I + 1;
END;

*/

BEGIN TRAN;

SELECT * FROM [Order Hours] WHERE [Quote#] IN (
		SELECT
			[Quote#]
		FROM @JOBS
	)
;

UPDATE
	[Order Hours]
SET
	[Step 1] = 52,
	[Axles] = 3,
	[Final Assembly] = 42
WHERE 
	[Quote#] IN (
		SELECT
			[Quote#]
		FROM @JOBS
	)
;


SELECT * FROM [Order Hours] WHERE [Quote#] IN (
		SELECT
			[Quote#]
		FROM @JOBS
	)
;

ROLLBACK;
COMMIT;