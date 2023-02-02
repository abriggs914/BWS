USE BWSdb
GO


-- Top payed employees by year.
-- set window to true to limit how long ago this raise was given.
-- windowRange is the amount of years to limit the window to.


DECLARE @start_year INT = 1970;
DECLARE @end_year INT = 2050;
DECLARE @window BIT = 0;
DECLARE @windowRange INT = 3;
DECLARE @topN INT;
DECLARE @i INT;

SELECT @topN = 25;
SELECT @i = @start_year;

WHILE @i < @end_year BEGIN
	SELECT TOP (@topN)
		*
	FROM (
		SELECT 
			*
		FROM (
			SELECT
				@i AS [Year]
				, YEAR([Date]) AS [RaiseYear]
				, [Payroll].[Date]
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
					(CASE WHEN [Payroll].[Salary] > 1000 THEN
						[Payroll].[Salary] / 2000.0
					ELSE 
						(CASE WHEN [Payroll].[Salary] = 0 THEN
							[Payroll].[Annual] / 2000.0 
						ELSE
							[Payroll].[Salary] 
						END)
					END)
				END) AS [Hourly]
				, CAST((CASE WHEN [Annual] IS NULL THEN 1 ELSE 0 END) AS BIT) AS [Hourly/Salary]
				, ROW_NUMBER() OVER(
					PARTITION BY
						ISNULL([Payroll].[2nd Name], '_') + ', ' + ISNULL([Payroll].[1st Name], '_')
					ORDER BY
						(CASE WHEN [Payroll].[Salary] IS NULL THEN (CASE WHEN
						[Payroll].[Annual] > 1000 THEN
							[Payroll].[Annual] / 2000.0
						ELSE
							[Payroll].[Annual]
						END)
						ELSE
						(CASE WHEN [Payroll].[Salary] > 1000 THEN
							[Payroll].[Salary] / 2000.0
							ELSE 
								(CASE WHEN [Payroll].[Salary] = 0 THEN
									[Payroll].[Annual] / 2000.0 
								ELSE
									[Payroll].[Salary] 
								END)
							END)
						END) DESC
				) AS [RowID]
			FROM
				[Payroll]
			WHERE
				YEAR([Date]) <= @i
		) AS [SubA]
	) AS [SubB]
	WHERE
		[RowID] = 1
		AND (CASE WHEN @window = 1 THEN 
		(CASE WHEN ([Year] - [RaiseYear]) < @windowRange THEN 1 ELSE 0 END)
		ELSE 1 END) = 1
	ORDER BY
		[Hourly] DESC
	;
	SELECT @i = @i + 1;
END