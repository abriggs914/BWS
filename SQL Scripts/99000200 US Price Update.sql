USE BWSdb
GO

BEGIN TRAN;

SELECT
	*
FROM
	[Options]
WHERE
	[Draw/Part#] = '99000200'

UPDATE
	[Options]
SET
	[Price] = 404.62
	,[US Price] = 331.66
WHERE
	[Draw/Part#] = '99000200'
	
SELECT
	*
FROM
	[Options]
WHERE
	[Draw/Part#] = '99000200'

ROLLBACK;
COMMIT;
	
--SELECT
--	*
--FROM
--	[Budget Options]
--WHERE
--	[Price] IS NULL