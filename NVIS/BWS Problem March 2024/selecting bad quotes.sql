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