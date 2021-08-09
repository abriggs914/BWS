USE BWSdb
GO

SELECT
	*
FROM
	[Order Hours]
WHERE
	[Quote#] = 26286


BEGIN TRAN;

SELECT * FROM [Order Hours] WHERE [Quote#] = 26286;

UPDATE
	[Order Hours]
SET
	[Axles] = 9,
	[Step 1] = 35,
	[Step 2] = 35,
	[Blast] = 6.5,
	[Paint] = 16.5,
	[Final Assembly] = 42,
	[Tire Assembly] = 3.2
WHERE
	[Quote#] = 26286;

SELECT * FROM [Order Hours] WHERE [Quote#] = 26286;

ROLLBACK;
COMMIT;