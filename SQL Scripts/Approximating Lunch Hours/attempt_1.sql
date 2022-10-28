USE SysproCompanyA
GO

DECLARE @WO AS NVARCHAR(17);

DECLARE @min_n_hours AS DECIMAL(14, 2);
DECLARE @max_start_hour AS INT;
DECLARE @min_end_hour AS INT;
DECLARE @max_n_hours AS DECIMAL(14, 2);

-----------------------------------------------------------------------------------------------------------------------

SELECT @WO = '10015976'; -- Colden's wo
--SELECT @WO = '10015644';

-- A
SELECT
	@min_n_hours = 1
	,@max_start_hour = 14
	,@min_end_hour = 11
	,@max_n_hours = 5
;
-- B
SELECT
	@min_n_hours = 1.5
	,@max_start_hour = 12
	,@min_end_hour = 12
	,@max_n_hours = 5.25
;

-----------------------------------------------------------------------------------------------------------------------

SELECT
	[JobNumber]
	, (DATEDIFF(MINUTE, [LoggedOn], [LoggedOff]) / 60.0) AS [Hrs] -- Sum Hours > @min_n_hours -- 1
	, DATEPART(HOUR, [LoggedOn]) AS [dp H lon] -- Clocked on before @max_start_hour -- 2PM
	, DATEPART(HOUR, [LoggedOff]) AS [dp H lof]	 -- Clocked off after @min_end_hour -- 11AM
	, (CASE WHEN (DATEDIFF(MINUTE, [LoggedOn], [LoggedOff]) / 60.0) >= @min_n_hours THEN 'Y' ELSE 'N' END) AS [A]
	, (CASE WHEN DATEPART(HOUR, [LoggedOn]) < @max_start_hour THEN 'Y' ELSE 'N' END) AS [B]
	, (CASE WHEN DATEPART(HOUR, [LoggedOff]) > @min_end_hour THEN 'Y' ELSE 'N' END) AS [C]
	, (CASE WHEN (DATEDIFF(MINUTE, [LoggedOn], [LoggedOff]) / 60.0) >= @max_n_hours THEN 'Y' ELSE 'N' END) AS [D]
	, [LoggedOn]
	, [LoggedOff]
	, *
FROM 
	[ClkTransaction]
WHERE
	[JobNumber] = @WO
ORDER BY
	[ClkTransaction].[LoggedOn],
	[ClkTransaction].[LoggedOff]
;

SELECT
	*
FROM 
	[ClkTransaction]
WHERE
	[JobNumber] = @WO
	AND ((((DATEDIFF(MINUTE, [LoggedOn], [LoggedOff]) / 60.0) >= @min_n_hours) -- Sum Hours > @min_n_hours -- 1
	AND DATEPART(HOUR, [LoggedOn]) < @max_start_hour -- Clocked on before @max_start_hour -- 2PM
	AND DATEPART(HOUR, [LoggedOff]) > @min_end_hour	 -- Clocked off after @min_end_hour -- 11AM
	) OR ((DATEDIFF(MINUTE, [LoggedOn], [LoggedOff]) / 60.0) >= @max_n_hours))
;

---- Distinct calendar days
--SELECT DISTINCT
--	[JobNumber],
--	CAST(RIGHT('0000' + CAST(DATEPART(YEAR, [LoggedOn]) AS NVARCHAR(4)), 4)
--	+ '-' + RIGHT('00' + CAST(DATEPART(MONTH, [LoggedOn]) AS NVARCHAR(2)), 2)
--	+ '-' + RIGHT('00' + CAST(DATEPART(DAY, [LoggedOn]) AS NVARCHAR(2)), 2) AS DATETIME) AS [Date]
--FROM 
--	[ClkTransaction]
--WHERE
--	[JobNumber] = @WO
--	AND (DATEDIFF(HOUR, [LoggedOn], [LoggedOff]) + (DATEDIFF(MINUTE, [LoggedOn], [LoggedOff]) / 60.0) >= @min_n_hours) -- Sum Hours > @min_n_hours -- 1
--	AND DATEPART(HOUR, [LoggedOn]) <= @max_start_hour -- Clocked on before @max_start_hour -- 2PM
--	AND DATEPART(HOUR, [LoggedOff]) >= @min_end_hour	 -- Clocked off after @min_end_hour -- 11AM
--;


