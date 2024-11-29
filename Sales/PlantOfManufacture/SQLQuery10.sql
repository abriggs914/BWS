EXEC [sp_CheckUpcomingHolidays] @sd='2024-11-28', @d=14


SELECT DISTINCT
	[Date]
	, [HolidayName]
FROM
	[Calendar]
WHERE
	[HolidayName] IS NOT NULL
	AND [Date] BETWEEN '2024-11-28' AND DATEADD(DAY, 14, '2024-11-28')
	--[Date] BETWEEN @sd AND DATEADD(DAY, @d, @sd)
	
SELECT
	[QuoteAsStargate],
	[PlantOfManufactureCode],
	*
FROM
	[BWSdb].[dbo].[Orders]
;
SELECT
	*
FROM
	[BWSdb].[dbo].[Companies]
;
SELECT
	*
FROM
	[BWSdb].[dbo].[CompanySNInfo]
;
SELECT
	*
FROM
	[BWSdb].[dbo].[Products]
ORDER BY
	[IDTrailer] DESC
/*WHERE
	[Model No] LIKE '%aed4x%'*/

SELECT
	[Position4]
FROM
	[BWSdb].[dbo].[SN Type]
GROUP BY
	[Position4]

SELECT
	*
FROM
	[BWSdb].[dbo].[SN Type]
WHERE
	[Model No] LIKE '%aed4x%'

SELECT
	*
FROM
	[BWSdb].[dbo].[SN Type V2]
WHERE
	[Model No] LIKE '%aed4x%'


EXEC [sp_SerialNumberCalc] @quote=30920, @year=2025

DECLARE @p NVARCHAR(3);
DECLARE @m NVARCHAR(1);
DECLARE @q INT = 30920;
SELECT @q = 30922
/*
SELECT
	@p = [CVMA_Prefix],
	@m = [CSNI].[PlantOfManufacture]
*/
SELECT
	/*@p = [CVMA_Prefix],
	@m = [CSNI].[PlantOfManufacture]*/
	*
FROM 
	[BWSdb].[dbo].[Orders] [O]
CROSS JOIN (
	SELECT
		[CompanyID],
		[PlantOfManufacture],
		[CVMA_Prefix],
		ROW_NUMBER() OVER(
			--PARTITION BY
				--[CompanyID]
			ORDER BY
				[ID]
		) AS [RN]
	FROM
		[BWSdb].[dbo].[CompanySNInfo]
) AS [CSNI]
WHERE
	[Quote#] = @q
	AND (
		(
			(CASE WHEN ISNULL([QuoteAsStargate], 0) = 1 THEN 1 ELSE 0 END) = [CSNI].[CompanyID]
			AND [O].[PlantOfManufactureCode] = [CSNI].[PlantOfManufacture]
		)
		OR ([RN] = 1)
	)
/*ORDER BY
	(CASE WHEN [O].[PlantOfManufactureCode] = [CSNI].[PlantOfManufacture] THEN 0 ELSE 1 END),
	[RN]
*/


SELECT
	@p AS [P],
	@m AS [M]

/*
BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[SN Type]
SET
	[Position4] = 'S',
	[Position5] = 1,
	[Position6] = 5,
	[Position7] = 4,
	[Position8] = 4
WHERE
	[Model No] = 'AED4X'

ROLLBACK;
COMMIT;
*/


SELECT
	[Serial Number] AS [SN],
	*
FROM
	[OrdersV2]
WHERE
	 RIGHT([Serial Number], 8) like '%' + 'S' + 'M' + '%'
	AND [Decline/Rejected] = 4
ORDER BY
	[SN]