USE BWSdb
GO

SELECT
	*
FROM
	[Orders]
WHERE
	[Quote#] IN (
		26601,
		27480
	)

SELECT
	*
FROM
	[Order Standards]
WHERE
	[Quote#] IN (
		26601,
		27480
	)
ORDER BY
	[Quote#]
	,[Standard No] 

SELECT 
	*
FROM
	[Order Standards]
WHERE
	[Quote#] IN (
		26601
	)

SELECT 
	*
FROM
	[Order Standards]
WHERE
	[Quote#] IN (
		27480
	)

BEGIN TRAN;

SELECT 
	*
FROM
	[Order Standards]
WHERE
	[Quote#] IN (
		27480
	)

DELETE FROM 
	[Order Standards]
WHERE
	[Quote#] = 27480
	AND LEFT([Standard No], 6) = '53ET3X'

SELECT 
	*
FROM
	[Order Standards]
WHERE
	[Quote#] IN (
		27480
	)

ROLLBACK;
COMMIT;