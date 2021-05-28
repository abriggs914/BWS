
-- Quotes that I have worked on.
SELECT * FROM [Orders] AS A WITH (NOLOCK)
	WHERE A.[Sale PersonID] IN
		(SELECT [ID-SaleStaff] FROM [Sales Staff] AS B WITH (NOLOCK)
			WHERE B.[Sales Person] LIKE '%avery%'
		)
	ORDER BY A.[Quote#]