

	DECLARE @quote AS INT;
	SET @quote = 28070;
	--SET @quote = 26645;
	--SET @quote = 27008;

	
declare @modelno nvarchar(255) = (select [Model No] from Orders with (nolock) where Quote# = @quote)
declare @nops INT = (select COUNT(*) from [Order Options] with (nolock) where Quote# = @quote)

SELECT
	@quote AS [Q]
	, @nops AS [N]
	, @modelno AS [M]


DECLARE @t AS TABLE ([ID] INT IDENTITY(1, 1), [Quote] INT, [WO] NVARCHAR(MAX), [QuoteDate] DATETIME, [ProdDate] DATETIME, [CNOPS] INT)
INSERT INTO @t ([Quote], [WO], [QuoteDate], [ProdDate], [CNOPS]) 
SELECT
	[Orders].[Quote#]
	, [Orders].[WO#]
	, [Orders].[Quote Date]
	, [Prod Date]
	, COUNT([Order Options].[Option No])
FROM
	[Orders]
INNER JOIN
	[Order Options]
ON
	[Orders].[Quote#] = [Order Options].[Quote#]
INNER JOIN
	[Production]
ON
	[Orders].[Quote#] = [Production].[Quote#]
WHERE
	--[Quote#] = @quote
	--AND 
	[Orders].[Model No] = @modelno
GROUP BY
	[Orders].[Quote#]
	, [Orders].[WO#]
	, [Orders].[Quote Date]
	, [Prod Date]
HAVING
	COUNT([Order Options].[Option No]) = @nops
--	(SELECT COUNT(*) FROM [Order Options]) = @nops

SELECT
	[T].*
	, [Order Options].*
FROM
	@t AS [T]
INNER JOIN
	[Order Options]
ON
	[T].[Quote] = [Order Options].[Quote#]
ORDER BY
	(CASE WHEN [Quote] = 28070 THEN 0 ELSE 1 END)
	,[Quote]
	,[Option No]