USE BWSdb
GO

SELECT * FROM [Order Standards] WHERE [Quote#] = 26424

BEGIN TRAN;

	SELECT * FROM [Order Standards] WHERE [Quote#] = 26424

	DELETE FROM [Order Standards] WHERE [Quote#] = 26424 AND [Standard No] LIKE '%25ANR-%'

	SELECT * FROM [Order Standards] WHERE [Quote#] = 26424

ROLLBACK;
COMMIT;

SELECT * FROM [Order Options] WHERE [Quote#] = 26424

SELECT * FROM [Orders] WHERE [Quote#] = 26424