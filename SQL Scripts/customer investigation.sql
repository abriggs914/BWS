USE bwsdb
GO

SELECT * FROM [Customers] AS A WITH (NOLOCK)
	WHERE [Customer] LIKE '%tru green%'
		AND A.[ID#] IN 
			(SELECT [CustID] FROM [Orders])
	ORDER BY [Customer]
	
SELECT * FROM [Customers] AS A WITH (NOLOCK)
	WHERE [Customer] LIKE '%tru green%'

SELECT [ID#] FROM [Customers] AS B WITH (NOLOCK)
		WHERE [Customer] LIKE '%tru green%'

SELECT * FROM [Orders] AS A WITH (NOLOCK)
	WHERE [CustID] IS NOT NULL
	ORDER BY [CustID]
	
SELECT * FROM [Sales Staff]

SELECT * FROM [Orders] AS A WITH (NOLOCK)
	WHERE A.[CustID] IN 
		(SELECT [ID#] FROM [Customers] AS B WITH (NOLOCK)
			WHERE [Customer] LIKE '%tru green%'
		)
	ORDER BY [WO#]