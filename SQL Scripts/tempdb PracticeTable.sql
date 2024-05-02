USE BWSdb
GO


IF OBJECT_ID('tempdb..#PracticeTable') IS NOT NULL BEGIN
	DROP TABLE #PracticeTable
END

CREATE TABLE #PracticeTable (
	[ID] INT IDENTITY(0, 1), 
	[Created] DATETIME DEFAULT(GETDATE()),
	[X] INT,
	[Y] INT
)

INSERT INTO #PracticeTable ([X], [Y]) VALUES (0, 1)

SELECT * FROM #PracticeTable