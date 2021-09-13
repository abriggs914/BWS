USE BWSdb
GO

SELECT
	*
FROM
	[Orders]
WHERE
	[Quote#] = 25292


BEGIN TRAN;
SELECT * FROM [Orders] WHERE [Quote#] = 25292;
UPDATE
	[Orders]
SET
	[Quote Date] = '2021-03-11'
WHERE 
	[Quote#] = 25292;
SELECT * FROM [Orders] WHERE [Quote#] = 25292;
ROLLBACK;
COMMIT;