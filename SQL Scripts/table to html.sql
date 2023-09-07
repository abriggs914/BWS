
EXEC [spQueryToHtmlTable]
	@query='SELECT * FROM [IT Requests]', --A query to turn into HTML format. It should not include an ORDER BY clause.
	@orderBy='ORDER BY [RequestDateOriginal]', --An optional ORDER BY clause. It should contain the words 'ORDER BY'.
	@html='C:\Access\QHTML__IT Requests 2023-09-07.html'


SELECT [RequestDateOriginal] FROM [IT Requests]