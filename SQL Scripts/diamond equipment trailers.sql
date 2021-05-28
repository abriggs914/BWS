USE BWSdb
GO
SELECT * FROM [Order Options] AS B
	WHERE B.[Quote#] IN
		(SELECT [Quote#] FROM [Orders] AS A
			WHERE A.[DealerID] IN
				(SELECT [ID] FROM Dealers
					WHERE [COMPANY NAME] LIKE '%diamond%'
				)
		)
		AND [Option No] LIKE '%53ET%'
		AND [Sections] LIKE '%load%'
		AND [Description] LIKE '%3 bar weld on%'
	ORDER BY [Description]