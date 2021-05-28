USE BWSdb
GO

/*
-- Which options are used to add 22.5 tires to TAG trailers.
SELECT [Quote Date], [Order Date], [Option No], [Quote#], [Price], [Description], [draw/part#] FROM [Order Options] AS A WITH (NOLOCK)
	WHERE A.[Quote#] IN
		(SELECT [Quote#] FROM Orders AS B WITH (NOLOCK)
			WHERE [Model No] LIKE '%anr%'
				OR [Model No] LIKE '%art%'
				OR [Model No] LIKE '%fdnt%'
				OR [Model No] LIKE '%ntt%')
		AND [Description] LIKE '%22.5%'
		AND [Draw/Part#] IS NOT NULL
	ORDER BY [Quote Date]
*/

-- Load bearing rear fenders on 55Ton HDGs.
SELECT [Quote Date], [Order Date], [Option No], [Quote#], [WO#], [Price], [Description], [draw/part#] FROM [Order Options] AS A WITH (NOLOCK)
	WHERE [Description] LIKE '%load%'
		AND [Description] LIKE '%rear%'
		AND [Description] NOT LIKE '%led wide load%'
		AND [Description] NOT LIKE '%non load%'
	ORDER BY [Option No], [Quote Date]

-- Load bearing rear fenders on 55Ton HDGs.
SELECT * FROM [Options] AS A WITH (NOLOCK)
	WHERE [Description] LIKE '%load%'
		AND [Description] LIKE '%rear%'
		AND [Description] NOT LIKE '%led wide load%'
		AND [Description] NOT LIKE '%non load%'
	ORDER BY [Model No]


SELECT * FROM [Class Sales Summary]
	
-- Check coding on under deck storage for ETs
SELECT * FROM [Options] AS A WITH (NOLOCK)
	WHERE [Description] LIKE '%under%'
		AND [Description] LIKE '%storage%'
		AND [Option No] LIKE '%et%'
	ORDER BY [Description]
	
-- Shovel holders for Dump trailers
SELECT * FROM [Options] AS A WITH (NOLOCK)
	WHERE [Description] LIKE '%shovel%'
	ORDER BY [Description]

-- Investigate 10 in. plank pricing for Dump class
SELECT * FROM [Options] AS A WITH (NOLOCK)
	WHERE [Description] LIKE '%planks%'
	ORDER BY [Description]

