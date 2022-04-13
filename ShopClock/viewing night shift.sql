USE SysproCompanyS
GO

DECLARE
	@sd DATETIME, @ed DATETIME, @empNum NVARCHAR(MAX) = NULL, @by_transaction BIT = 1, @by_date BIT = 0
SET @sd = '2022-03-03';
SET @ed = '2022-03-21 23:59:59';
SET @by_transaction = 0;
SET @by_date = 1;
--AS 
--BEGIN 

	
	DECLARE @emps AS TABLE([idx] INT, [EmpNum] NVARCHAR(MAX));
	INSERT INTO @emps SELECT * FROM [BWSdb].[dbo].[split_string_idx](@empNum, ';');

	DECLARE @Src TABLE ([EmployeeNumber] NVARCHAR(MAX), [EmployeeName] NVARCHAR(200), [StartDate] DATETIME, [EndDate] DATETIME, [HrsWorked] FLOAT);

INSERT INTO @Src
				SELECT
					[EmployeeNumber],
					[EmployeeName],
					MIN([InTimeFromShopClk]) AS [StartDate],
					MAX([OutTimeFromShopClk]) AS [EndDate],
					ROUND(DATEDIFF(hh, MIN([InTimeFromShopClk]), MAX([OutTimeFromShopClk])) + ((DATEDIFF(mi, MIN([InTimeFromShopClk]), MAX([OutTimeFromShopClk])) / 60.0) - DATEDIFF(hh, MIN([InTimeFromShopClk]), MAX([OutTimeFromShopClk]))), 2)
					--ROUND(((60 * ((DATEPART(HOUR, MAX([OutTimeFromShopClk]) - MIN([InTimeFromShopClk]))))) + DATEPART(MINUTE, MAX([OutTimeFromShopClk]) - MIN([InTimeFromShopClk]))) / 60.0, 2) AS [HrsWorked]
					--ROUND(((60 * (SUM(DATEPART(HOUR, [OutTimeFromShopClk] - [InTimeFromShopClk])))) + SUM(DATEPART(MINUTE, [OutTimeFromShopClk] - [InTimeFromShopClk]))) / 60.0, 2) AS [HrsWorked]
				FROM
					[ClkTransaction]
				WHERE
					[InTimeFromShopClk] BETWEEN @sd AND @ed
					AND [OutTimeFromShopClk] BETWEEN @sd AND @ed
				GROUP BY
					[EmployeeNumber], [EmployeeName], TransactionID
				ORDER BY
					[EmployeeNumber];



SELECT 
						'F' AS [QueryID],
						[ClkTransaction].[EmployeeNumber],
						[ClkTransaction].[EmployeeName],
						[@Src].[HrsWorked],
						CAST(CAST([@Src].[StartDate] AS DATETIME) AS NVARCHAR(12)) AS [Date]
					FROM
						[ClkTransaction]
					INNER JOIN
						@Src
					ON
						[@Src].[EmployeeNumber] = [ClkTransaction].[EmployeeNumber]
					WHERE
						[InTimeFromShopClk] BETWEEN  @sd AND @ed
						AND [OutTimeFromShopClk] BETWEEN @sd AND @ed
					GROUP BY
						[ClkTransaction].[EmployeeNumber], [ClkTransaction].[EmployeeName], [@Src].[HrsWorked], CAST(CAST([@Src].[StartDate] AS DATETIME) AS NVARCHAR(12))

SELECT
					[QueryID],
					[EmployeeNumber],
					[EmployeeName],
					SUM([HrsWorked]) AS [HrsWorked],
					CONVERT(DATETIME, [Date], 107) AS [Date]
				FROM (
					
SELECT 
						'F' AS [QueryID],
						[ClkTransaction].[EmployeeNumber],
						[ClkTransaction].[EmployeeName],
						[@Src].[HrsWorked],
						CAST(CAST([@Src].[StartDate] AS DATETIME) AS NVARCHAR(12)) AS [Date]
					FROM
						[ClkTransaction]
					INNER JOIN
						@Src
					ON
						[@Src].[EmployeeNumber] = [ClkTransaction].[EmployeeNumber]
					WHERE
						[InTimeFromShopClk] BETWEEN  @sd AND @ed
						AND [OutTimeFromShopClk] BETWEEN @sd AND @ed
					GROUP BY
						[ClkTransaction].[EmployeeNumber], [ClkTransaction].[EmployeeName], [@Src].[HrsWorked], CAST(CAST([@Src].[StartDate] AS DATETIME) AS NVARCHAR(12))
				) AS [SubSrc]
				GROUP BY
					[QueryID],
					[EmployeeNumber],
					[EmployeeName],
					CONVERT(DATETIME, [Date], 107)
				ORDER BY
					[EmployeeNumber], [Date]