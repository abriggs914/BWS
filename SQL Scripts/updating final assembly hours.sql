USE BWSdb


DECLARE @QS TABLE ([Quote#] INT);
INSERT INTO @QS VALUES 
	(26451),
	(26452),
	(26453),
	(26437)
;

SELECT
	*
FROM
	[Order Hours]
WHERE 
	[Quote#] IN (
		SELECT
			[Quote#]
		FROM @QS
	)
;

BEGIN TRAN;

UPDATE
	[Order Hours]
SET
	[Final Assembly] = 42
WHERE 
	[Quote#] IN (
		SELECT
			[Quote#]
		FROM @QS
	)
;

SELECT
	*
FROM
	[Order Hours]
WHERE 
	[Quote#] IN (
		SELECT
			[Quote#]
		FROM @QS
	)
;

ROLLBACK;
COMMIT;
