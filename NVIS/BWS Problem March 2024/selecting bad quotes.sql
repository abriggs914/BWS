USE BWSdb
GO

SELECT
	*
FROM
	[Orders]
WHERE
	[Quote#] IN (
		30139
		,30140
		,30141
		,30163
		,30146
		,30145
		,30158
		,30147
		,30148
		,30144
		,30143
		,29928
	)
ORDER BY
	RIGHT([Serial Number], 4)

SELECT
	*
FROM
	[Orders]
WHERE
	[Quote#] IN (
		28705,
		29388,
		29114,
		29846,
		29928,
		30140,
		30143,
		30146,
		30148,
		30158,
		30144,
		30163
	)
ORDER BY
	RIGHT([Serial Number], 4)

SELECT
	[Quote#]
	,[Serial Number]
FROM
	[Orders]
WHERE
	RIGHT(LEFT([Serial Number], 10), 1) = 'S'
ORDER BY
	--[Quote Date]
	RIGHT([Serial Number], 4)