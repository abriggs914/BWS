SELECT * FROM [GenControl]
SELECT TOP 100 * FROM [GenTransaction]
SELECT DISTINCT [Source], [GlCode], COUNT(*) AS [Cs] FROM [GenTransaction] GROUP BY [Source], [GlCode] ORDER BY [Cs], [Source]
SELECT * FROM [GenTransaction] WHERE [Source] = 'SA'
SELECT * FROM [GenTransaction] WHERE [GlCode] IN (4013, 4022, 5001)
SELECT * FROM [GenTransaction] WHERE [GlCode] IN (4013, 4022, 5001) AND [Source] <> 'SA'