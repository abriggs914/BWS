USE [BWSdb]
GO

DECLARE @WO1 INT = 10017231;
DECLARE @MaxRev INT;

SELECT
	@MaxRev = MAX([Rev#])
FROM
	[BWSdb].[dbo].[Orders_RevHistory]
WHERE
	[WO#] = @WO1
;

exec [sp_NewWOReport V2] @WO1, @MaxRev

SELECT * FROM [BWSdb].[dbo].[Orders] WHERE [WO#] = @WO1
SELECT * FROM [BWSdb].[dbo].[Order Options] WHERE [WO#] = @WO1

SELECT * FROM [Orders] INNER JOIN [Products] ON [Orders].[ProductID] = [Products].[IDTrailer]
SELECT * FROM [Orders] INNER JOIN [Products] ON [Orders].[ProductID] = [Products].[IDTrailer] WHERE ([Decline/Rejected] = 4) AND ([WO#] IS NOT NULL) ORDER BY [Quote Date] DESC

DECLARE @dt DATETIME = '2024-09-27';
DECLARE @dy INT;
DECLARE @dm INT;
DECLARE @dd INT;

SELECT
	@dy = YEAR(@dt)
	,@dm = MONTH(@dt)
	,@dd = DAY(@dt)
SELECT
	@dt
	,@dy
	,@dm
	,@dd

SELECT TOP 1 [WO#] FROM [Orders] WHERE ([WO#] IS NOT NULL) AND ([Decline/Rejected] = 4) AND ((YEAR([Quote Date]) = @dy) AND (MONTH([Quote Date]) = @dm) AND (DAY([Quote Date]) = @dd)) ORDER BY [Quote Date] DESC

SELECT TOP 10 [WO#] FROM [Orders] WHERE ([WO#] IS NOT NULL) AND ([Decline/Rejected] = 4) AND ([Quote Date] BETWEEN '2024-09-15' AND '2024-10-22 23:59:59') ORDER BY [Quote Date] DESC

--EXEC [sp_NewWOReport V2] 10017241, 1

/*
BEGIN TRAN;
SELECT * FROM [BWSdb].[dbo].[Orders] WHERE [DataEntryUser] IS NOT NULL

UPDATE
	[BWSdb].[dbo].[Orders]
SET
	[DataEntryCheck] = 0
	,[DataEntryUser] = NULL
WHERE
	[DataEntryUser] = 'Avery Briggs'
	OR [DataEntryUser] = 'Jack Johnson'
	OR [DataEntryUser] = ''

SELECT * FROM [BWSdb].[dbo].[Orders] WHERE [DataEntryUser] IS NOT NULL
ROLLBACK;
COMMIT;
*/