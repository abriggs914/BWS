USE BWSdb
GO

/*
SELECT * FROM [Options]
	WHERE [Description] LIKE '%5820%'
	ORDER BY [Model No], [Draw/Part#]
*/

SELECT * FROM [Order Hours] AS A WITH (NOLOCK)
	WHERE A.[Quote#] IN
		(SELECT [Quote#] FROM [Orders] WITH (NOLOCK)
			WHERE [Model No] LIKE '%42et%')
		AND [Step 1] != 28
		AND [Step 2] != 28
	ORDER BY [Quote#]
	
SELECT * FROM [Order Hours] AS A WITH (NOLOCK)
	WHERE A.[Quote#] IN
		(SELECT [Quote#] FROM [Orders] WITH (NOLOCK)
			WHERE [Model No] LIKE '%48et%')
		AND [Step 1] != 28
		AND [Step 2] != 28
	ORDER BY [Quote#]

	

	--WHERE []

SELECT * FROM [Orders] WITH (NOLOCK)