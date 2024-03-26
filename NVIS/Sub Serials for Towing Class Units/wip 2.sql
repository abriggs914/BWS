

SELECT
	[Serial Number]
	,[Quote#]
	,[Quote Date] 
	,[O].[Model No]
FROM 
	[Orders] [O]
INNER JOIN
	[Products] [P]
ON
	[O].[ProductID] = [P].[IDTrailer]
WHERE
	--[P].[Class] = 'Snow & Ice Control'
	[P].[Class] = 'Towing'
ORDER BY
	[Order Date] DESC
;
/*
BEGIN TRAN;

	UPDATE
		[Orders]
	SET
		--[Serial Number] = '260001'
		[Serial Number] = NULL
	WHERE
		[Quote#] IN (30181, 30182, 30184)
		--[Quote#] IN (30181)
	
ROLLBACK;
COMMIT;
*/



DECLARE @quote int, @year int, @mode INT = NULL, @startSeq INT=NULL
SET @quote = 30182;
SET @year = 2025
	
DECLARE @modelName AS NVARCHAR(MAX);
DECLARE @className AS NVARCHAR(MAX);
DECLARE @pid AS INT;
DECLARE @scm AS INT;

SELECT
	@modelName = [Model No]
	,@pid = [ProductID]
FROM
	[Orders] [O]
WHERE
	[Quote#] = @quote
;

SELECT
	@scm = [SerialCalcMethod]
	,@className = [Class]
FROM
	[Products]
WHERE
	[IDTrailer] = @pid


SELECT
	CAST(ISNULL(MAX([Serial Number]) + 1, 260001) AS NVARCHAR(MAX)) AS [NewSN]
FROM
	[Orders]
INNER JOIN
	[Products]
ON
	[Orders].[Model No] = [Products].[Model No]
WHERE
	[Class] = @className
	AND [Products].[Model No] NOT LIKE '%SPUD KIT%'
	AND ISNUMERIC([Serial Number]) = 1