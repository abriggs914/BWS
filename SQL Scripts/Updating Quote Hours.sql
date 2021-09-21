USE BWSdb


DECLARE @QS TABLE ([Quote#] INT);
INSERT INTO @QS VALUES 
	(26573),
	(26574)
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
	[Axles] = 9,
	[Final Assembly] = 50
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
