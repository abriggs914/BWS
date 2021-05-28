USE BWSdb
GO
-- 2021-05-28
-- Investigate 10 in. plank prices to ensure price
-- is still competitive with changing lumber prices.

SELECT * FROM [Options] AS A WITH (NOLOCK)
	WHERE [Description] LIKE '%plank%'
		AND [Description] LIKE '%10%'
	ORDER BY [Draw/Part#]

SELECT [Model No], [Option No], [Price], [US Price], [Draw/Part#], [obsolete] FROM [Options] AS A WITH (NOLOCK)
	WHERE [Description] LIKE '%plank%'
		AND [Description] LIKE '%10%'
	ORDER BY [Draw/Part#]

SELECT DISTINCT [Draw/Part#] FROM [Options]
	WHERE [Description] LIKE '%plank%'
		AND [Description] LIKE '%10%'
--AND DISTINCT [Draw/Part#]