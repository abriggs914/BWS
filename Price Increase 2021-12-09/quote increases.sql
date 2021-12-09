DECLARE @inc AS FLOAT;
SET @inc = 1.05;

DECLARE @quotes AS TABLE ([Quote#] BIGINT);

INSERT INTO @quotes ([Quote#]) VALUES
(26297),
(26290),
(26291),
(26292),
(26944),
(26923),
(26933),
(26934),
(26932),
(26928),
(26929),
(26930),
(26931)
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