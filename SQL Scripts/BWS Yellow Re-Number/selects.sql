USE BWSdb
GO

DECLARE @oldNum AS VARCHAR(12);
SET @oldNum = '%PPG#920612%'

DECLARE @testDesc AS VARCHAR(120);
SET @testDesc = 'BWS Yellow - PPG#920612 with text afterwards to test'



SELECT
    LEFT([Description], PATINDEX(@oldNum, [Description]) - 1) + 'PPG#911699' AS [Part A],
	LEN([Description]) AS [Part B],
	PATINDEX(@oldNum, [Description]) AS [Part C],
	LEN(@oldNum) - 2 AS [Part D],
	(PATINDEX(@oldNum, [Description]) - 1) + (LEN(@oldNum) - 2) AS [Part E],
	RIGHT([Description], LEN([Description]) - ((PATINDEX(@oldNum, [Description]) - 1) + (LEN(@oldNum) - 2))) AS [Part F],
	LEFT([Description], PATINDEX(@oldNum, [Description]) - 1) + 'PPG#911699' + RIGHT([Description], LEN([Description]) - ((PATINDEX(@oldNum, [Description]) - 1) + (LEN(@oldNum) - 2))) AS [Part G],
	LEFT(@testDesc, PATINDEX(@oldNum, @testDesc) - 1) + 'PPG#911699' + RIGHT(@testDesc, LEN(@testDesc) - ((PATINDEX(@oldNum, @testDesc) - 1) + (LEN(@oldNum) - 2))) AS [Part H],
	REPLACE([Description], @oldNum, 'PPG#911699') AS [Part I],
	REPLACE([Description], 'PPG#911699', @oldNum) AS [Part J],
	*
FROM
	[Options]
WHERE
	[Description] LIKE @oldNum



--SELECT
--    LEFT([Description], PATINDEX(@oldNum, [Description]) - 1) + 'PPG#911699' + RIGHT([Description], LEN([Description]) - (PATINDEX(@oldNum, [Description]) + LEN(@oldNum))) AS [NewDesc],
--	*
--FROM
--	[Options]
--WHERE
--	[Description] LIKE @oldNum
