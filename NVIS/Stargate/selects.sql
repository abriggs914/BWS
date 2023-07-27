EXEC sp_SerialNumberCalcSTG @quote='SG101111', @year=2024, @mode=NULL
EXEC sp_SerialNumberCalcSTG @quote='SG101111', @year=2024, @mode=1
EXEC sp_SerialNumberCalcSTG @quote='SG101111', @year=2024, @mode=2




EXEC sp_SerialNumberCalcSTG @quote='SG101112', @year=2024, @mode=NULL


SELECT
	*
FROM
	[SN Type V2]
WHERE
	[CompanyID] = 1
	AND [Model No] LIKE '%42FHR2X%'
ORDER BY
	[Model No]
;
SELECT
	*
FROM
	[ProductsV2]
WHERE
	[CompanyID] = 1
	AND [Model No] LIKE '%42FHR2X%'
ORDER BY
	[Model No]
;