USE SysproCompanyS
GO

DECLARE @sd AS DATETIME;
DECLARE @ed AS DATETIME;
DECLARE @en AS NVARCHAR(200);
DECLARE @bt AS BIT;
SET @sd = '2022-03-01';
SET @ed = '2022-03-02 23:59:59';
SET @en = '300023';
SET @bt = 1;

DECLARE @emps AS TABLE([idx] INT, [EmpNum] NVARCHAR(MAX));
INSERT INTO @emps SELECT * FROM [BWSdb].[dbo].[split_string_idx](@en, ';');
DECLARE @Src TABLE ([EmployeeNumber] BIGINT, [EmployeeName] NVARCHAR(200), [StartDate] DATETIME, [EndDate] DATETIME, [HrsWorked] FLOAT);
DELETE FROM @Src
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
					--[EmployeeNumber] = CAST(@empNum AS NVARCHAR)
					[EmployeeNumber] IN (SELECT [EmpNum] FROM @emps)
					AND [InTimeFromShopClk] BETWEEN @sd AND @ed
					AND [OutTimeFromShopClk] BETWEEN @sd AND @ed
				GROUP BY
					[EmployeeNumber], [EmployeeName], CAST(CAST([InTimeFromShopClk] AS DATETIME) AS NVARCHAR(12))
				ORDER BY
					[EmployeeNumber];
SELECT 
						'C' AS [QueryID],
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
						--[ClkTransaction].[EmployeeNumber] = @empNum
						[@Src].[EmployeeNumber] IN (SELECT [EmpNum] FROM @emps)
						AND [InTimeFromShopClk] BETWEEN  @sd AND @ed
						AND [OutTimeFromShopClk] BETWEEN @sd AND @ed
					GROUP BY
						[ClkTransaction].[EmployeeNumber], [ClkTransaction].[EmployeeName], [@Src].[HrsWorked], CAST(CAST([@Src].[StartDate] AS DATETIME) AS NVARCHAR(12))









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
					[EmployeeNumber], [EmployeeName], CAST(CAST([InTimeFromShopClk] AS DATETIME) AS NVARCHAR(12))
				ORDER BY
					[EmployeeNumber];






USE SysproCompanyS
GO
DECLARE @sd AS DATETIME;
DECLARE @ed AS DATETIME;
DECLARE @en AS NVARCHAR(200);
DECLARE @bt AS BIT;
DECLARE @empNum NVARCHAR(MAX) = NULL, @by_transaction BIT = 1, @by_date BIT = 0
SET @sd = '2022-03-11';
SET @ed = '2022-03-17 23:59:59';
SET @by_transaction = 0;
SET @by_date = 1;
--EXEC [dbo].[sp_ClkLabourOverride] @sd=@sd, @ed=@ed

-- All calls are prioritized by P = (sd=ed) > empNum > transaction > date

EXEC [sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=1  -- D
EXEC [sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=0  -- E


EXEC [sp_ClkTallyHours] @sd=@sd, @ed=@ed, @empNum=@en, @by_transaction=1  -- A -- empnum > transaction
EXEC [sp_ClkTallyHours] @sd=@sd, @ed=@ed, @empNum=@en, @by_transaction=0  -- B


EXEC [sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=0, @by_date=1  -- F

EXEC [sp_ClkTallyHours] @sd=@sd, @ed=@ed, @empNum=@en, @by_transaction=0, @by_date=1  -- C


USE Stargatedb
GO


DECLARE @sd AS DATETIME;
DECLARE @ed AS DATETIME;
DECLARE @en AS NVARCHAR(200);
DECLARE @bt AS BIT;
SET @sd = '2022-03-01';
SET @ed = '2022-03-02 23:59:59';
SET @en = '300023';
SET @bt = 1;

EXEC [sp_ClkTallyWeeklyReport] @sd=@sd, @ed=@ed, @empNum=@en


-- this is the same as : EXEC [sp_ClkTallyHours] @sd=@sd, @ed=@ed, @empNum=@en, @by_transaction=1  -- A -- empnum > transaction
-- EXEC [sp_ClkTallyHours] @sd=@sd, @ed=@ed, @empNum=@en, @by_transaction=1, @by_date=1  -- A -- emp_num > transaction > date

-- this is the same as : EXEC [sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=1  -- D
-- EXEC [sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=1, @by_date=1  -- D -- transaction overrides