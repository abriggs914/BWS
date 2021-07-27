USE BWSdb
GO


DECLARE @QS TABLE ([Quote#] INT);
INSERT INTO @QS VALUES 
	(25803),
	(26209),
	(26210),
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
	[Step 1] = 30
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

GO;