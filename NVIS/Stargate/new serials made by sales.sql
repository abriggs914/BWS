USE BWSdb
GO

SELECT
	*
FROM
	[OrdersV2]
WHERE
	LEFT([Serial Number], 3) = '2SV'
	AND [Notes] NOT LIKE '%ABRIGGS - Ser%'