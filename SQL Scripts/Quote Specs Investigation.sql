USE BWSdb
GO

DECLARE @quotes TABLE([Quote#] INT)
INSERT INTO @quotes VALUES
	(26632),
	(26700)
;

SELECT
	*
FROM
	[Orders]
WHERE
	[Quote#] IN (SELECT [Quote#] FROM @quotes)


SELECT
	*
FROM
	[Order Options]
WHERE
	[Quote#] IN (SELECT [Quote#] FROM @quotes)
ORDER BY 
	[Quote#]


SELECT
	*
FROM
	[Options_SpecLines]
WHERE
	[Quote#] IN (SELECT [Quote#] FROM @quotes)
ORDER BY 
	[Quote#]


