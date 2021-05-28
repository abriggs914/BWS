USE BWSdb
GO

/*
-- Remove 10 GA plate fenders from machinery class
SELECT * FROM [Options_SpecLines]
	WHERE [SpecDescription] LIKE '%10%'
		AND [SpecDescription] LIKE '%keruing%'
*/



SELECT * FROM [Order Options_SpecLines]
	WHERE [SpecDescription] LIKE '%wall%'
	ORDER BY [WO#]