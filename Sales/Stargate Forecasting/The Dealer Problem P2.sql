USE BWSdb
GO

DECLARE @d1 DATETIME;
DECLARE @d2 DATETIME;
DECLARE @dID INT;
DECLARE @dID2 INT;
DECLARE @dName NVARCHAR(MAX);

SELECT
	@d2 = GETDATE()
	,@dID = 3
;

DECLARE @CompNames AS TABLE ([Name] NVARCHAR(MAX));
INSERT INTO @CompNames
SELECT [COMPANY NAME] FROM [v_SFC_BWSUnionSTGDealers] WHERE [ID] = @dID;

DECLARE @CompIDs AS TABLE ([OGTable] NVARCHAR(MAX), [ID] INT, [Name] NVARCHAR(MAX));

INSERT INTO @CompIDs
SELECT
	[D].[OGTable]
	,[ID] 
	,[C].[Name]
FROM
	[v_SFC_BWSUnionSTGDealers] AS [D]
INNER JOIN
	@CompNames AS [C]
ON 
	[D].[COMPANY NAME] = [C].[Name]

--SELECT
--	@dID AS [1],
--	@dID2 AS [2],
--	@dName AS [Name]
--;

--SELECT * FROM [v_SFC_BWSUnionSTGDealers] WHERE [ID] = @dID AND ([ID] <> (CASE WHEN ISNULL(@dID2, -1) = -1 THEN @dID ELSE @dID2 END));

SELECT * FROM @CompNames;
SELECT * FROM @CompIDs;

SELECT
	@d1 = DATEADD(YEAR, -1, @d2)
;

SELECT
	*
FROM
	[v_SFC_BWSUnionSTGOrders]
WHERE
	[Orders_DateQuote] BETWEEN @d1 AND @d2
	AND [Dealers_ID] = @dID
;

SELECT * FROM [OrdersV2] WHERE [DealerID] = @dID