DECLARE @inc AS FLOAT;
SET @inc = 1.05;

DECLARE @quotes AS TABLE ([Quote#] BIGINT);

INSERT INTO @quotes ([Quote#]) VALUES
(25964),
(25965),
(25949),
(25956),
(25957),
(25958),
(25959),
(25960),
(25950),
(25951),
(25952),
(25953),
(25954),
(25955)
;

BEGIN TRAN;

SELECT 
	[Quote#],
	[Price] AS [OriginalPrice],
	CAST([Price] * @inc AS MONEY) AS [NewPrice],
	[Notes]
FROM [Orders] WHERE [Quote#] IN (SELECT [Quote#] FROM @quotes)

UPDATE
	[Orders]
SET 
	[Price] = CAST([Price] * @inc AS MONEY),
	[Notes] = [Notes] + CHAR(10) + CHAR(13) + CAST(GETDATE() AS NVARCHAR(MAX)) + ' - 5% Price Increase Applied.'
WHERE [Quote#] IN (SELECT [Quote#] FROM @quotes)

SELECT 
	[Quote#],
	[Price],
	[Notes]
FROM [Orders] WHERE [Quote#] IN (SELECT [Quote#] FROM @quotes)

ROLLBACK;
COMMIT;