USE BWSdb

GO

DECLARE @quote AS INT;
SET @quote = 26492; -- broken
SET @quote = 26491; -- broken
--SET @quote = 25706;



BEGIN TRAN;


SELECT 'Order Standards' AS [Table], [Order Standards].* FROM [Order Standards] INNER JOIN [Orders] ON [Order Standards].[Quote#] = [Orders].[Quote#] WHERE [Orders].[Quote#] = @quote ORDER BY [Standard No]

DELETE FROM
	[Order Standards]
WHERE
	[Quote#] = @quote
	AND [Model No] = '35ADG2X NR'

SELECT 'Order Standards' AS [Table], [Order Standards].* FROM [Order Standards] INNER JOIN [Orders] ON [Order Standards].[Quote#] = [Orders].[Quote#] WHERE [Orders].[Quote#] = @quote ORDER BY [Standard No]

ROLLBACK;
COMMIT;