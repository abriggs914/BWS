SELECT
	*
FROM
	[]

EXEC [BWSdb].[dbo].[sp_NewQuoteReport V3] 'SG101745', 0
EXEC [sp_NewWOReport V3] 'SG101745', 0
EXEC [sp_SerialNumberCalcSTG] @quote='SG101745', @year=2025, @mode=1



--UPDATE
DECLARE @Inches INT = 1
DECLARE @i INT = 0

WHILE @i < 22 BEGIN
	SELECT
	/*
					@ftandin
				SET
	*/
		@i AS [i]
		,@Inches AS [Inches]
		,CAST(@Inches / 12 AS INT) AS [F]
		,@Inches - (CAST(@Inches / 12 AS INT) * 12) AS [I]
				;
	SELECT 
		@i = @i + 1
		,@Inches = @Inches + 12
	;
END

SELECT
	*
FROM
	[BWSdb].[dbo].[Orders]
WHERE
	[Model No] LIKE '%43DD3X HD%'

SELECT
	*
FROM
	[BWSdb].[dbo].[Standards]
WHERE
	[Model No] LIKE '%43DD3X HD%'
ORDER BY
	[SortG]
	,[SortSe]
	,[SortGv2]
	,[SortSev2]

	
SELECT
	*
FROM
	[BWSdb].[dbo].[Products]
WHERE
	[IDTrailer] = 2287
;
SELECT
	*
FROM
	[BWSdb].[dbo].[ProductsV2]
;
SELECT
	*
FROM
	[BWSdb].[dbo].[Products]
WHERE
	[Model No] LIKE '%43DD3X HD%'
;
SELECT
	*
FROM
	[BWSdb].[dbo].[ProductsV2]
WHERE
	[Model No] LIKE '%43DD3X HD%'
;
/*
BEGIN TRAN;

SELECT
	*
FROM
	[BWSdb].[dbo].[Products]
;
SELECT
	*
FROM
	[BWSdb].[dbo].[ProductsV2]
;
UPDATE
	[BWSdb].[dbo].[ProductsV2]
SET
	[DateCreated] = ISNULL([DateCreated], GETDATE())
;

UPDATE
	[BWSdb].[dbo].[Products]
SET
	[DateCreated] = ISNULL([DateCreated], GETDATE())
;

SELECT
	*
FROM
	[BWSdb].[dbo].[Products]
;
SELECT
	*
FROM
	[BWSdb].[dbo].[ProductsV2]
;
ROLLBACK;
COMMIT;
*/


SELECT
	*
FROM
	[BWSdb].[dbo].[ITD Project Directory]

	
SELECT
	*
FROM
	[BWSdb].[dbo].[v_SFC_OrdersDataOptions]
SELECT
	*
FROM
	[BWSdb].[dbo].[Order Options]