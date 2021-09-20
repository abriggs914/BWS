USE BWSdb
GO

--SELECT
--	*
--FROM
--	[Products]
--;

--SELECT 
--	*
--FROM
--	[Standards]
--;


--SELECT 
--	DATALENGTH([Options].[Option No])-CHARINDEX(REVERSE([Options].[Option No]), REVERSE([Options].[Option No]))-1 As [Last occurrence],
--	SUBSTRING(
--		[Options].[Option No],
--		LEN([Options].[Option No]) - CHARINDEX(REVERSE([Options].[Option No]), REVERSE([Options].[Option No])),
--		LEN([Options].[Option No])) AS [Sub],
		
--	RIGHT('00000' + SUBSTRING(
--		[Options].[Option No],
--		LEN([Options].[Option No]) - CHARINDEX(REVERSE([Options].[Option No]), REVERSE([Options].[Option No])),
--		LEN([Options].[Option No])), 5) AS [Sub right],
--	[Options].[Model No] + '-' + RIGHT('00000' + SUBSTRING(
--		[Options].[Option No],
--		LEN([Options].[Option No]) - CHARINDEX(REVERSE([Options].[Option No]), REVERSE([Options].[Option No])),
--		LEN([Options].[Option No])), 5) AS [New Opt. #],
--	[Options].[Option No] AS [Old Opt #],
--	*
--FROM
--	[Options]


SELECT
	DATALENGTH([Order OptionsV2].[Option No])-CHARINDEX(REVERSE([Order OptionsV2].[Option No]), REVERSE([Order OptionsV2].[Option No]))-1 As [Last occurrence],
	SUBSTRING(
		[Order OptionsV2].[Option No],
		LEN([Order OptionsV2].[Option No]) - CHARINDEX(REVERSE([Order OptionsV2].[Option No]), REVERSE([Order OptionsV2].[Option No])),
		LEN([Order OptionsV2].[Option No])) AS [Sub],
		
	RIGHT('00000' + SUBSTRING(
		[Order OptionsV2].[Option No],
		LEN([Order OptionsV2].[Option No]) - CHARINDEX(REVERSE([Order OptionsV2].[Option No]), REVERSE([Order OptionsV2].[Option No])),
		LEN([Order OptionsV2].[Option No])), 5) AS [Sub right],
	SUBSTRING(
		[Order OptionsV2].[Option No],
		0,
		LEN([Order OptionsV2].[Option No]) - CHARINDEX(REVERSE([Order OptionsV2].[Option No]), REVERSE([Order OptionsV2].[Option No])) - 1
		) + '-' + RIGHT('00000' + SUBSTRING(
		[Order OptionsV2].[Option No],
		LEN([Order OptionsV2].[Option No]) - CHARINDEX(REVERSE([Order OptionsV2].[Option No]), REVERSE([Order OptionsV2].[Option No])),
		LEN([Order OptionsV2].[Option No])), 5) AS [New Opt. #],
	[Order OptionsV2].[Option No] AS [Old Opt #],
	*
FROM
	[Order OptionsV2]



SELECT
	*
FROM
	[Order Options] WITH (NOLOCK)
	
SELECT
	*
FROM
	[Order Options] WITH (NOLOCK)
LEFT JOIN
	[Options] WITH (NOLOCK)
ON
	[Options].[Option No] = [Order Options].[Option No] 



--ON
--	[Options].[Option No] = [Budget Options].[Option No]
--WHERE
--	[Options].[Model No] LIKE '%-%'







-- Update Options
BEGIN TRAN;
SELECT 
	*
FROM
	[OptionsV2] WITH (NOLOCK)
;

UPDATE 
	[OptionsV2]
SET
	[Option No] = 
	[OptionsV2].[Model No] + '-' + RIGHT('00000' + SUBSTRING(
		[OptionsV2].[Option No],
		LEN([OptionsV2].[Option No]) - CHARINDEX(REVERSE([OptionsV2].[Option No]), REVERSE([OptionsV2].[Option No])),
		LEN([OptionsV2].[Option No])), 5)
;

SELECT 
	*
FROM
	[OptionsV2] WITH (NOLOCK)
;

ROLLBACK
COMMIT;





-- Update Budget Options
BEGIN TRAN;
SELECT 
	*
FROM
	[Budget Options V2] WITH (NOLOCK)
;

UPDATE 
	[Budget Options V2]
SET
	[Option No] = 
	[Budget Options V2].[Model No] + '-' + RIGHT('00000' + SUBSTRING(
		[Budget Options V2].[Option No],
		LEN([Budget Options V2].[Option No]) - CHARINDEX(REVERSE([Budget Options V2].[Option No]), REVERSE([Budget Options V2].[Option No])),
		LEN([Budget Options V2].[Option No])), 5)
;

SELECT 
	*
FROM
	[Budget Options V2] WITH (NOLOCK)
;

ROLLBACK
COMMIT;


-- Update Order Options
BEGIN TRAN;
SELECT 
	*
FROM
	[Order OptionsV2] WITH (NOLOCK)
;

UPDATE 
	[Order OptionsV2]
SET
	[Option No] = 
	SUBSTRING(
		[Order OptionsV2].[Option No],
		0,
		LEN([Order OptionsV2].[Option No]) - CHARINDEX(REVERSE([Order OptionsV2].[Option No]), REVERSE([Order OptionsV2].[Option No])) - 1
		) + '-' + RIGHT('00000' + SUBSTRING(
		[Order OptionsV2].[Option No],
		LEN([Order OptionsV2].[Option No]) - CHARINDEX(REVERSE([Order OptionsV2].[Option No]), REVERSE([Order OptionsV2].[Option No])),
		LEN([Order OptionsV2].[Option No])), 5)
;

SELECT 
	*
FROM
	[Order OptionsV2] WITH (NOLOCK)
;

ROLLBACK
COMMIT;