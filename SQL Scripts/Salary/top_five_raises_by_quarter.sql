USE BWSdb
GO


-- Top 5 raises by quarter.


DECLARE @quarters AS TABLE (
	[ID] INT IDENTITY(1, 1)
	, [MonthName] NVARCHAR(9)
	, [Quarter] INT
	, [Semi] INT
);

INSERT INTO @quarters ([MonthName], [Quarter], [Semi]) VALUES
('January', 0, 0),
('February', 0, 0),
('March', 0, 0),
('April', 1, 0),
('May', 1, 0),
('June', 1, 0),
('July', 2, 1),
('August', 2, 1),
('September', 2, 1),
('October', 3, 1),
('November', 3, 1),
('December', 3, 1)
;


SELECT
	*
FROM (
	SELECT
		[SubB].*
		, [MonthName]
		, [Quarter]
		, YEAR([Date]) AS [Year]
		, ROW_NUMBER() OVER (
			PARTITION BY
				YEAR([Date])
				, [Quarter]
			ORDER BY
				YEAR([Date])
				, MONTH([Date])
				, [S @ 2000 Hrs] DESC
		) AS [QuarterOrder]
	FROM (
		SELECT
			*
			, '$ ' + CAST(CAST((CASE WHEN [Hourly/Salary] = 1 THEN
					[Hourly] * 1000
				ELSE
					[Annual]
				END) AS DECIMAL(14, 2)) AS NVARCHAR(MAX)) AS [S @ 1000 Hrs]
			, '$ ' + CAST(CAST((CASE WHEN [Hourly/Salary] = 1 THEN
					[Hourly] * 1100
				ELSE
					[Annual]
				END) AS DECIMAL(14, 2)) AS NVARCHAR(MAX)) AS [S @ 1100 Hrs]
			, '$ ' + CAST(CAST((CASE WHEN [Hourly/Salary] = 1 THEN
					[Hourly] * 1200
				ELSE
					[Annual]
				END) AS DECIMAL(14, 2)) AS NVARCHAR(MAX)) AS [S @ 1200 Hrs]
			, '$ ' + CAST(CAST((CASE WHEN [Hourly/Salary] = 1 THEN
					[Hourly] * 1300
				ELSE
					[Annual]
				END) AS DECIMAL(14, 2)) AS NVARCHAR(MAX)) AS [S @ 1300 Hrs]
			, '$ ' + CAST(CAST((CASE WHEN [Hourly/Salary] = 1 THEN
					[Hourly] * 1400
				ELSE
					[Annual]
				END) AS DECIMAL(14, 2)) AS NVARCHAR(MAX)) AS [S @ 1400 Hrs]
			, '$ ' + CAST(CAST((CASE WHEN [Hourly/Salary] = 1 THEN
					[Hourly] * 1500
				ELSE
					[Annual]
				END) AS DECIMAL(14, 2)) AS NVARCHAR(MAX)) AS [S @ 1500 Hrs]
			, '$ ' + CAST(CAST((CASE WHEN [Hourly/Salary] = 1 THEN
					[Hourly] * 1600
				ELSE
					[Annual]
				END) AS DECIMAL(14, 2)) AS NVARCHAR(MAX)) AS [S @ 1600 Hrs]
			, '$ ' + CAST(CAST((CASE WHEN [Hourly/Salary] = 1 THEN
					[Hourly] * 1700
				ELSE
					[Annual]
				END) AS DECIMAL(14, 2)) AS NVARCHAR(MAX)) AS [S @ 1700 Hrs]
			, '$ ' + CAST(CAST((CASE WHEN [Hourly/Salary] = 1 THEN
					[Hourly] * 1800
				ELSE
					[Annual]
				END) AS DECIMAL(14, 2)) AS NVARCHAR(MAX)) AS [S @ 1800 Hrs]
			, '$ ' + CAST(CAST((CASE WHEN [Hourly/Salary] = 1 THEN
					[Hourly] * 1900
				ELSE
					[Annual]
				END) AS DECIMAL(14, 2)) AS NVARCHAR(MAX)) AS [S @ 1900 Hrs]
			, '$ ' + CAST(CAST((CASE WHEN [Hourly/Salary] = 1 THEN
					[Hourly] * 2000
				ELSE
					[Annual]
				END) AS DECIMAL(14, 2)) AS NVARCHAR(MAX)) AS [S @ 2000 Hrs]
			, '$ ' + CAST(CAST((CASE WHEN [Hourly/Salary] = 1 THEN
					[Hourly] * 2100
				ELSE
					[Annual]
				END) AS DECIMAL(14, 2)) AS NVARCHAR(MAX)) AS [S @ 2100 Hrs]
			, '$ ' + CAST(CAST((CASE WHEN [Hourly/Salary] = 1 THEN
					[Hourly] * 2200
				ELSE
					[Annual]
				END) AS DECIMAL(14, 2)) AS NVARCHAR(MAX)) AS [S @ 2200 Hrs]
			, '$ ' + CAST(CAST((CASE WHEN [Hourly/Salary] = 1 THEN
					[Hourly] * 2300
				ELSE
					[Annual]
				END) AS DECIMAL(14, 2)) AS NVARCHAR(MAX)) AS [S @ 2300 Hrs]
			, '$ ' + CAST(CAST((CASE WHEN [Hourly/Salary] = 1 THEN
					[Hourly] * 2400
				ELSE
					[Annual]
				END) AS DECIMAL(14, 2)) AS NVARCHAR(MAX)) AS [S @ 2400 Hrs]
			, '$ ' + CAST(CAST((CASE WHEN [Hourly/Salary] = 1 THEN
					[Hourly] * 2500
				ELSE
					[Annual]
				END) AS DECIMAL(14, 2)) AS NVARCHAR(MAX)) AS [S @ 2500 Hrs]
			, '$ ' + CAST(CAST((CASE WHEN [Hourly/Salary] = 1 THEN
					[Hourly] * 2600
				ELSE
					[Annual]
				END) AS DECIMAL(14, 2)) AS NVARCHAR(MAX)) AS [S @ 2600 Hrs]
			, '$ ' + CAST(CAST((CASE WHEN [Hourly/Salary] = 1 THEN
					[Hourly] * 2700
				ELSE
					[Annual]
				END) AS DECIMAL(14, 2)) AS NVARCHAR(MAX)) AS [S @ 2700 Hrs]
			, '$ ' + CAST(CAST((CASE WHEN [Hourly/Salary] = 1 THEN
					[Hourly] * 2800
				ELSE
					[Annual]
				END) AS DECIMAL(14, 2)) AS NVARCHAR(MAX)) AS [S @ 2800 Hrs]
			, '$ ' + CAST(CAST((CASE WHEN [Hourly/Salary] = 1 THEN
					[Hourly] * 2900
				ELSE
					[Annual]
				END) AS DECIMAL(14, 2)) AS NVARCHAR(MAX)) AS [S @ 2900 Hrs]
			, '$ ' + CAST(CAST((CASE WHEN [Hourly/Salary] = 1 THEN
					[Hourly] * 3000
				ELSE
					[Annual]
				END) AS DECIMAL(14, 2)) AS NVARCHAR(MAX)) AS [S @ 3000 Hrs]

		FROM (
			SELECT
				[Payroll].[Date]
				, ISNULL([Payroll].[2nd Name], '_') + ', ' + ISNULL([Payroll].[1st Name], '_') AS [Name]
				, [Payroll].[Annual] AS [TAnnual]
				, [Payroll].[Salary] AS [TSalary]
				, (CASE WHEN ISNULL([Payroll].[Annual], 0) = 0 THEN (CASE WHEN 
					[Payroll].[Salary] < 1000 THEN [Payroll].[Salary] * 2000 ELSE [Payroll].[Salary] END)
				ELSE
					[Payroll].[Annual]
				END) AS [Annual]
				, (CASE WHEN [Payroll].[Salary] IS NULL THEN (CASE WHEN
					[Payroll].[Annual] > 1000 THEN
						[Payroll].[Annual] / 2000.0
					ELSE
						[Payroll].[Annual]
					END)
				ELSE
					(CASE WHEN [Payroll].[Salary] > 1000 THEN [Payroll].[Salary] / 2000.0 ELSE (CASE WHEN [Payroll].[Salary] = 0 THEN [Payroll].[Annual] / 2000.0 ELSE [Payroll].[Salary] END) END)
				END) AS [Hourly]
				, CAST((CASE WHEN [Annual] IS NULL THEN 1 ELSE 0 END) AS BIT) AS [Hourly/Salary]
			FROM
				[Payroll]
		) AS [SubA]
		WHERE
			[Name] <> '_, _'
			AND [Date] IS NOT NULL
	) AS [SubB]
	INNER JOIN
		@quarters
	ON
		MONTH([Date]) = [@quarters].[ID]
) AS [SubC]
WHERE
	[QuarterOrder] < 5
ORDER BY
	[Date]
	, [S @ 2000 Hrs] DESC
;
