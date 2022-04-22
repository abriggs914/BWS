
USE BWSdb
GO

-- Non-obsolete options we have where the CDN price is less than the US price
-- 2022-04-22

SELECT
	[Draw/Part#],
	[Model No],
	[Option No],
	[Price],
	[US Price],
	[Description]
FROM
	[Options] 
WHERE
	0 < (CASE WHEN [Price] >= 0 THEN (CASE WHEN [Price] < [US Price] THEN 1 ELSE 0 END) ELSE (CASE WHEN [Price] > [US Price] THEN 1 ELSE 0 END) END)
	AND [Obsolete] = 0
ORDER BY
	[Draw/Part#],
	[Option No],
	[Price] DESC