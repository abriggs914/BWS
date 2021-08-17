USE BWSdb


DECLARE @QS TABLE ([Quote#] INT);
INSERT INTO @QS VALUES 
	(26298),
	(26360)
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
	[Step 1] = 70
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
