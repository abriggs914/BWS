USE BWSdb
GO

--select * from [dtQEOrderOptions] as B where B.[Quote#] in (select [Quote#] from [Orders] as A where A.[DealerID] in (select [ID] from Dealers where [COMPANY NAME] like '%redhead%') and [Model No] like '%xp%')

-- All options ordered on redhead units that change 'track' options of the 'load securement' spec line, on units that contain 'xp' in their name.
SELECT * FROM [Order Options_SpecLines] AS A
	WHERE [SpecSection] LIKE '%load%' 
		AND [SpecDescription] LIKE '%track%' 
		AND [Option No] LIKE '%xp%' 
		AND A.[Quote#] IN (
			SELECT [Quote#] FROM [Orders] AS B
				WHERE B.[DealerID] IN (
					SELECT [ID] FROM Dealers
						WHERE [COMPANY NAME] LIKE '%redhead%'
					)
			)

-- All options ordered on redhead units.
SELECT * FROM [Order Options_SpecLines] AS B
	WHERE B.[Quote#] IN (
		SELECT [Quote#] FROM [Orders] AS A
			WHERE A.[DealerID] IN (
				SELECT [ID] FROM Dealers
					WHERE [COMPANY NAME] LIKE '%redhead%'
				)
				AND [Model No] LIKE '%xp%'
		)
	ORDER BY [SpecSection]

 select * from [Order Options_FactoryLines] AS B
	 WHERE B.[Quote#] IN
			(SELECT [Quote#] FROM [Orders] AS A
				WHERE A.[DealerID] IN
					(SELECT [ID] FROM Dealers
						WHERE [COMPANY NAME] LIKE '%redhead%'
					)
					AND [Model No] LIKE '%xp%'
			)
		AND [Description] LIKE '%track%'

SELECT * FROM [Orders] AS A
	WHERE A.[DealerID] IN
		(SELECT [ID] FROM Dealers
			WHERE [COMPANY NAME] LIKE '%redhead%'
		)
		AND [Model No] LIKE '%xp%'
	ORDER BY [Quote Date]
		
		--and [SpecSection] like '%load securement%'
		--and [SpecDescription] like '%ring%'