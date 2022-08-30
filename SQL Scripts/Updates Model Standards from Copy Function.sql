


DECLARE @quote AS INT;
SET @quote = 26492; -- broken


BEGIN TRAN;

SELECT [IDOS] FROM (
SELECT 
	ROW_NUMBER() OVER(
		PARTITION BY [Standard No]
		ORDER BY [IDOS] DESC
	) AS [RN],
	'Order Standards' AS [Table],
	[Order Standards].*
FROM [Order Standards] INNER JOIN [Orders] ON [Order Standards].[Quote#] = [Orders].[Quote#] WHERE [Orders].[Quote#] = @quote
) AS [Src]
WHERE 
	[RN] = 2
ORDER BY [Standard No] 

DELETE FROM
	[Order Standards]
	WHERE [IDOS] IN (
SELECT [IDOS] FROM (
SELECT 
	ROW_NUMBER() OVER(
		PARTITION BY [Standard No]
		ORDER BY [IDOS] DESC
	) AS [RN],
	'Order Standards' AS [Table],
	[Order Standards].*
FROM [Order Standards] INNER JOIN [Orders] ON [Order Standards].[Quote#] = [Orders].[Quote#] WHERE [Orders].[Quote#] = @quote
) AS [Src]
WHERE 
	[RN] = 2
) --AS [Src2]
--ORDER BY [Standard No] 

SELECT [IDOS] FROM (
SELECT 
	ROW_NUMBER() OVER(
		PARTITION BY [Standard No]
		ORDER BY [IDOS] DESC
	) AS [RN],
	'Order Standards' AS [Table],
	[Order Standards].*
FROM [Order Standards] INNER JOIN [Orders] ON [Order Standards].[Quote#] = [Orders].[Quote#] WHERE [Orders].[Quote#] = @quote
) AS [Src]
WHERE 
	[RN] = 2
ORDER BY [Standard No] 



SELECT [IDOS] FROM (
SELECT 
	ROW_NUMBER() OVER(
		PARTITION BY [Standard No]
		ORDER BY [IDOS] DESC
	) AS [RN],
	'Order Standards' AS [Table],
	[Order Standards].*
FROM [Order Standards] INNER JOIN [Orders] ON [Order Standards].[Quote#] = [Orders].[Quote#] WHERE [Orders].[Quote#] = @quote
) AS [Src]
WHERE 
	[RN] = 1
ORDER BY [Standard No] 

ROLLBACK;
COMMIT;
