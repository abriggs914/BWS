USE BWSdb
GO

DECLARE @Quotes TABLE ([Q#] INT);
INSERT INTO @Quotes VALUES
	(26451),
	(26452),
	(26453),
	(26437)
;
 SELECT * FROM [Order Hours] WHERE [Quote#] IN (SELECT [Q#] FROM @Quotes)
BEGIN TRAN;
SELECT * FROM [Order Hours] WHERE [Quote#] IN (SELECT [Q#] FROM @Quotes)

UPDATE
	[Order Hours]
SET
	[Machine Shop] = 11,
	[Step 1] = 41,
	[Paint] = 6,
	[Blast] = 5,
	[Final Assembly] = 42
WHERE
	[Quote#] IN (SELECT [Q#] FROM @Quotes)

SELECT * FROM [Order Hours] WHERE [Quote#] IN (SELECT [Q#] FROM @Quotes)

ROLLBACK;
COMMIT;


DECLARE @Quotes TABLE ([Q#] INT);
INSERT INTO @Quotes VALUES
	(26451),
	(26452),
	(26453),
	(26437)
;
BEGIN TRAN;

SELECT * FROM [Order Hours] WHERE [Quote#] IN (SELECT [Q#] FROM @Quotes)
UPDATE
	[Order Hours]
SET
	[Line] = 52
WHERE
	[Quote#] = 26437
	
SELECT * FROM [Order Hours] WHERE [Quote#] IN (SELECT [Q#] FROM @Quotes)
ROLLBACK;
COMMIT;