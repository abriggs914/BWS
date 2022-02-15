SELECT * FROM [BWSdb].[dbo].[Orders] WHERE [Quote#] = 26744
SELECT TOP 10 * FROM [BWSdb].[dbo].[Orders]

BEGIN TRAN;

UPDATE 
[BWSdb].[dbo].[Orders]
SET
	[Quote Date] = '2021-09-29'
WHERE
 [Quote#] = 26744
 SELECT * FROM [BWSdb].[dbo].[Orders] WHERE [Quote#] = 26744

ROLLBACK;
COMMIT;