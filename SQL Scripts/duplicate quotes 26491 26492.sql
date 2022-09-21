USE BWSdb
GO


SELECT * FROM [Orders] WHERE [Quote#] IN (26491, 26492)


SELECT * FROM [Dealers] WHERE [COMPANY NAME] LIKE '%nuss%'


SELECT
	*
FROM
	[Orders]
LEFT JOIN
	[Standards]
ON
	[Orders].[Model No] = [Standards].[Model No] 
WHERE
	[Orders].[Quote#] IN (26491, 26491) 

SELECT
	*
FROM
	[Options]
LEFT JOIN
	[Standards]
ON
	[Options].[Model No] = [Standards].[Model No] 
INNER JOIN
	[Orders]
ON
	[Options].[Model No] = [Orders].[Model No]
WHERE
	[Orders].[Quote#] IN (26491, 26491) 