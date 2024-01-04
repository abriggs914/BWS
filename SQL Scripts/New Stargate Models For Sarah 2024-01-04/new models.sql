


DECLARE @startID INT = 693;
DECLARE @stopID INT = 711;


--BEGIN TRAN;


--UPDATE
--	[ProductsV2]
--SET
--	[Weight] = 19472,
--	[Width] = 102,
--	[Make] = 'BWS',
--	[Days] = 0,
--	[GN] = 0,
--	[Finish] = 0
--WHERE
--	[IDTrailer] BETWEEN @startID AND @stopID;

--ROLLBACK;
--COMMIT;

SELECT 
	*
	--COUNT(*) AS [# Non-Null Model No Products] 
FROM 
	[ProductsV2] 
WHERE
	[IDTrailer] BETWEEN @startID AND @stopID;