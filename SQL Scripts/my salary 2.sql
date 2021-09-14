USE BWSdb
GO

DECLARE @HPW AS INTEGER = 40;
DECLARE @WPY AS INTEGER = 50;
DECLARE @HPY AS INTEGER = @HPW * @WPY;

DECLARE @T TABLE (
	[row_num] INT,
	[RaiseID] INT,
	[EmpID] BIGINT,
	[Date] DATETIME,
	[STS] VARCHAR(50),
	[Salary] FLOAT,
	[Annual] MONEY,
	[Bonus%] FLOAT,
	[Dep Life] FLOAT,
	[Health] FLOAT,
	[Dental] FLOAT,
	[Vacation%] FLOAT,
	[RRSP%] FLOAT,
	[Absent] FLOAT,
	[Late] FLOAT,
	[Leave Early] FLOAT,
	[NQ] BIT,
	[Reason] NVARCHAR(MAX),
	[2nd Name] NVARCHAR(MAX),
	[1st Name] NVARCHAR(MAX),
	[Hourly/Salary] NVARCHAR(MAX),
	[Comments] NVARCHAR(MAX),
	[Hourly Wage] FLOAT
)
;

INSERT INTO @T
SELECT
	ROW_NUMBER() OVER (
		PARTITION BY [2nd Name], [1st Name]
			ORDER BY [Date] DESC
	) AS row_num, *,
	(CASE 
		WHEN [Hourly/Salary] = 'Salary' THEN [Salary]
		WHEN [Hourly/Salary] = 'Hourly' THEN [Salary]
		WHEN [Hourly/Salary] IS NULL THEN 
			(CASE
				WHEN [Salary] <> 0 THEN (CASE WHEN [Salary] > @HPY THEN [Salary] / @HPY ELSE [Salary] END)
				ELSE (CASE WHEN [Annual] > @HPY THEN [Annual] / @HPY ELSE [ANNUAL] END)
			END)
		ELSE 0
	END)
FROM 
	[Payroll]
;




---- annual wages
--SELECT * FROM (
--SELECT
--	YEAR([Date]) AS [Year],
--	SUM([Hourly Wage]) AS [Total Hourly Wage],
--	SUM([Hourly Wage]) * @HPY AS [Total Annual Wages],
--	COUNT(DISTINCT [EmpID]) AS [Number Employees],
--	AVG([Hourly Wage]) AS [Avg Wage],
--	STDEV([Hourly Wage]) AS [Hourly Wage STDev],
--	MIN([Hourly Wage]) AS [MIN Wage],
--	MAX([Hourly Wage]) AS [MAX Wage],
--	MAX([Hourly Wage]) - MIN([Hourly Wage]) AS [Range],
--	NULL AS [Median]
--FROM
--	@T
--GROUP BY
--	YEAR([Date])
--) AS [Src]
--UNION 
--(SELECT
--		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
--(
-- (SELECT MAX([Hourly/Salary]) FROM
--   (SELECT TOP 50 PERCENT [Hourly/Salary] FROM @T ORDER BY [Hourly/Salary]) AS BottomHalf)
-- +
-- (SELECT MIN([Hourly/Salary]) FROM
--   (SELECT TOP 50 PERCENT [Hourly/Salary] FROM @T ORDER BY [Hourly/Salary] DESC) AS TopHalf)
--) / 2 AS Median)
--ORDER BY
--	[Year]



-- annual wages
SELECT
	YEAR([Date]) AS [Year],
	SUM([Hourly Wage]) AS [Total Hourly Wage],
	SUM([Hourly Wage]) * @HPY AS [Total Annual Wages],
	COUNT(DISTINCT [EmpID]) AS [Number Employees],
	AVG([Hourly Wage]) AS [Avg Wage],
	STDEV([Hourly Wage]) AS [Hourly Wage STDev],
	MIN([Hourly Wage]) AS [MIN Wage],
	MAX([Hourly Wage]) AS [MAX Wage],
	MAX([Hourly Wage]) - MIN([Hourly Wage]) AS [Range],
	((SELECT 
		MAX([Hourly Wage]) 
	FROM (
		SELECT TOP 50 PERCENT
			[Hourly Wage]
		FROM
			@T
		ORDER BY
			[Hourly Wage]
	) AS BottomHalf)
	+ (
		SELECT
			MIN([Hourly Wage])
		FROM (
			SELECT TOP 50 PERCENT
				[Hourly Wage]
			FROM
				@T
			WHERE
				YEAR([Date]) = YEAR([Date])
			ORDER BY
				[Hourly Wage] DESC
		) AS TopHalf
)) / 2 AS Median
FROM
	@T
GROUP BY
	YEAR([Date])
ORDER BY
	[Year]

-- Raise percentages
SELECT
	*
FROM
	@T
ORDER BY
	[Hourly Wage]

DECLARE @tot_avg_hourly_wage FLOAT;
SET @tot_avg_hourly_wage = (SELECT AVG([Hourly Wage]) FROM @T);
PRINT 'Average of Total ' + CAST(@tot_avg_hourly_wage AS NVARCHAR(MAX))


SELECT ((SELECT 
		(CASE WHEN MAX([Hourly Wage]) IS NULL THEN 0 ELSE MAX([Hourly Wage]) END)
	FROM (
		SELECT TOP 50 PERCENT
			[Hourly Wage]
		FROM
			@T
		ORDER BY
			[Hourly Wage]
	) AS BottomHalf)
	+ (
		SELECT
			(CASE WHEN MIN([Hourly Wage]) IS NULL THEN 0 ELSE MIN([Hourly Wage]) END)
		FROM (
			SELECT TOP 50 PERCENT
				[Hourly Wage]
			FROM
				@T
			ORDER BY
				[Hourly Wage] DESC
		) AS TopHalf
)) / 2 AS Median
FROM
	@T