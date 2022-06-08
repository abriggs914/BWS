USE SysproCompanyS
GO

--USE [SysproCompanyA]
--GO
--/****** Object:  StoredProcedure [dbo].[sp_ClkTallyHours]    Script Date: 2022-06-08 11:02:03 AM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

---- All calls are prioritized by P = (sd=ed) > empNum > transaction# > date
---- i.e. iff @by_transaction = 1 then ignore @by_date else apply @by_date iff applicable

--ALTER PROCEDURE [dbo].[sp_ClkTallyHours]
DECLARE
	@sd DATETIME, @ed DATETIME, @empNum NVARCHAR(MAX) = NULL, @by_transaction BIT = 1, @by_date BIT = 0

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------


---- Test A
--SET @sd = '2022-03-11';
--SET @ed = '2022-03-17 23:59:59';
--SET @by_transaction = 1;
--SET @by_date = 0;
--SET @empNum = '300003'

---- Test B
--SET @sd = '2022-03-11';
--SET @ed = '2022-03-17 23:59:59';
--SET @by_transaction = 0;
--SET @by_date = 0;
--SET @empNum = '300003';

---- Test C
--SET @sd = '2022-03-11';
--SET @ed = '2022-03-17 23:59:59';
--SET @by_transaction = 0;
--SET @by_date = 1;
--SET @empNum = '300003';

---- Test D
--SET @sd = '2022-03-11';
--SET @ed = '2022-03-17 23:59:59';
--SET @by_transaction = 1;
--SET @by_date = NULL;

---- Test E
--SET @sd = '2022-03-11';
--SET @ed = '2022-03-17 23:59:59';
--SET @by_transaction = 0;
--SET @by_date = 0;

---- Test F
--SET @sd = '2022-03-11';
--SET @ed = '2022-03-17 23:59:59';
--SET @by_transaction = 0;
--SET @by_date = 1;

-- Test F
SET @sd = '2022-06-06';
SET @ed = '2022-06-06 23:59:59';
SET @empNum = '300036';
SET @by_transaction = 0;
--SET @by_date = 1;

SELECT (CASE WHEN DATEDIFF(DAY, @sd, @ed) < 1 THEN 'A' ELSE 'B' END) AS [DATEDIFF(DAY, @sd, @ed) < 1]

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

--AS 
--BEGIN 
	
	DECLARE @emps AS TABLE([idx] INT, [EmpNum] NVARCHAR(MAX));
	INSERT INTO @emps SELECT * FROM [BWSdb].[dbo].[split_string_idx](@empNum, ';');

	SELECT * FROM @emps

	DECLARE @Src TABLE ([TransactionID] BIGINT, [EmployeeNumber] NVARCHAR(MAX), [EmployeeName] NVARCHAR(200), [StartDate] DATETIME, [EndDate] DATETIME, [HrsWorked] FLOAT);
	IF @empNum IS NOT NULL BEGIN
		PRINT 'A'

		INSERT INTO @Src
		SELECT 
			[TransactionID],
			[EmployeeNumber],
			[EmployeeName],
			MIN([InTimeFromShopClk]) AS [StartDate],
			MAX([OutTimeFromShopClk]) AS [EndDate],
			
					SUM(DATEDIFF(SECOND, [InTimeFromShopClk], (
						CASE WHEN DATEPART(DAY, [OutTimeFromShopClk]) = DATEPART(DAY, [InTimeFromShopClk]) THEN
							[OutTimeFromShopClk]
						ELSE DATEADD(HOUR, 23 - DATEPART(HOUR, [InTimeFromShopClk]), DATEADD(MINUTE, 59 - DATEPART(MINUTE, [InTimeFromShopClk]), DATEADD(SECOND, 59 - DATEPART(SECOND, [InTimeFromShopClk]), [InTimeFromShopClk]))) END))
					) / 60 / 60 AS [HrsWorked]
			--ROUND(DATEDIFF(hh, MIN([InTimeFromShopClk]), MAX([OutTimeFromShopClk])) + ((DATEDIFF(mi, MIN([InTimeFromShopClk]), MAX([OutTimeFromShopClk])) / 60.0) - DATEDIFF(hh, MIN([InTimeFromShopClk]), MAX([OutTimeFromShopClk]))), 2)
			--ROUND(((60 * ((DATEPART(HOUR, MAX([OutTimeFromShopClk]) - MIN([InTimeFromShopClk]))))) + DATEPART(MINUTE, MAX([OutTimeFromShopClk]) - MIN([InTimeFromShopClk]))) / 60.0, 2) AS [HrsWorked]
			--ROUND(((60 * (SUM(DATEPART(HOUR, [OutTimeFromShopClk] - [InTimeFromShopClk])))) + SUM(DATEPART(MINUTE, [OutTimeFromShopClk] - [InTimeFromShopClk]))) / 60.0, 2) AS [HrsWorked]
		FROM
			[ClkTransaction]
		WHERE
			--[EmployeeNumber] = CAST(@empNum AS NVARCHAR)
			(CAST([EmployeeNumber] AS NVARCHAR(MAX)) IN (SELECT [EmpNum] FROM @emps)
			AND [InTimeFromShopClk] BETWEEN @sd AND @ed
			AND [OutTimeFromShopClk] BETWEEN @sd AND @ed)
			OR (DATEDIFF(DAY, @sd, @ed) < 1 
				AND CAST([EmployeeNumber] AS NVARCHAR(MAX)) IN (SELECT [EmpNum] FROM @emps) 
				AND (
					[InTimeFromShopClk] BETWEEN @sd AND @ed
					OR [OutTimeFromShopClk] BETWEEN @sd AND @ed
				)
			)
		GROUP BY
			[EmployeeNumber], [EmployeeName], [TransactionID]
		ORDER BY
			[EmployeeNumber];






		SELECT 'SRC' AS [Table], * FROM @Src
		UNION
		SELECT 'SRC', NULL, NULL, NULL, NULL, NULL, NULL
		





		IF @by_transaction = 1 BEGIN
		PRINT 'B'
			-- A
			SELECT 
				'A' AS [QueryID],
				[ClkTransaction].[TransactionID],
				[JobNumber],
				[ClkTransaction].[EmployeeNumber],
				[ClkTransaction].[EmployeeName],
				[LoggedOn],
				[InTimeFromShopClk],
				[LoggedOff],
				[OutTimeFromShopClk],
				(CASE WHEN [LoggedOff] IS NULL THEN 0 ELSE 1 END) AS [PlaceHolder],
				[@Src].[HrsWorked],
				@sd AS [StartDate],
				@ed AS [EndDate]
			FROM
				[ClkTransaction]
			INNER JOIN
				@Src
			ON
				[@Src].[EmployeeNumber] = CAST([ClkTransaction].[EmployeeNumber] AS NVARCHAR(MAX))
				AND YEAR([InTimeFromShopClk]) = YEAR([StartDate])
				AND MONTH([InTimeFromShopClk]) = MONTH([StartDate])
				AND DAY([InTimeFromShopClk]) = DAY([StartDate])
				AND [ClkTransaction].[TransactionID] = [@Src].TransactionID
			WHERE
				--[ClkTransaction].[EmployeeNumber] = @empNum
				[@Src].[EmployeeNumber] IN (SELECT [EmpNum] FROM @emps)
				AND [InTimeFromShopClk] BETWEEN  @sd AND @ed
				AND [OutTimeFromShopClk] BETWEEN @sd AND @ed
			ORDER BY
				[PlaceHolder], [LoggedOn], [LoggedOff];
		END

		ELSE BEGIN
		PRINT 'C'
			IF @by_date = 0 BEGIN
		PRINT 'D'
				-- B
				SELECT 
					'B' AS [QueryID],
					[ClkTransaction].[EmployeeNumber],
					[ClkTransaction].[EmployeeName],
					[@Src].[HrsWorked],
					([InTimeFromShopClk]) AS [StartDate],
					([OutTimeFromShopClk]) AS [EndDate]
					--@sd AS [StartDate],
					--@ed AS [EndDate]
				FROM
					[ClkTransaction]
				INNER JOIN
					@Src
				ON
					[@Src].[EmployeeNumber] = [ClkTransaction].[EmployeeNumber]
					AND [ClkTransaction].[TransactionID] = [@Src].[TransactionID]
				WHERE
					[ClkTransaction].[EmployeeNumber] = @empNum
					AND [InTimeFromShopClk] BETWEEN  @sd AND @ed
					AND [OutTimeFromShopClk] BETWEEN @sd AND @ed
				GROUP BY
					[ClkTransaction].[EmployeeNumber], [ClkTransaction].[EmployeeName], [@Src].[HrsWorked], [InTimeFromShopClk], [OutTimeFromShopClk]
				ORDER BY
					[ClkTransaction].[EmployeeNumber]
			END
			ELSE BEGIN
		PRINT 'E'

				-- Re-pop @Src to add groups by date
				DELETE FROM @Src
				INSERT INTO @Src
				SELECT 
					0,
					[EmployeeNumber],
					[EmployeeName],
					MIN([InTimeFromShopClk]) AS [StartDate],
					MAX([OutTimeFromShopClk]) AS [EndDate],
					
					SUM(DATEDIFF(SECOND, [InTimeFromShopClk], (
						CASE WHEN DATEPART(DAY, [OutTimeFromShopClk]) = DATEPART(DAY, [InTimeFromShopClk]) THEN
							[OutTimeFromShopClk]
						ELSE DATEADD(HOUR, 23 - DATEPART(HOUR, [InTimeFromShopClk]), DATEADD(MINUTE, 59 - DATEPART(MINUTE, [InTimeFromShopClk]), DATEADD(SECOND, 59 - DATEPART(SECOND, [InTimeFromShopClk]), [InTimeFromShopClk]))) END))
					) / 60 / 60 AS [HrsWorked]
					--ROUND(DATEDIFF(hh, MIN([InTimeFromShopClk]), MAX([OutTimeFromShopClk])) + ((DATEDIFF(mi, MIN([InTimeFromShopClk]), MAX([OutTimeFromShopClk])) / 60.0) - DATEDIFF(hh, MIN([InTimeFromShopClk]), MAX([OutTimeFromShopClk]))), 2)
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
					[EmployeeNumber], [EmployeeName], YEAR([InTimeFromShopClk]), MONTH([InTimeFromShopClk]), DAY([InTimeFromShopClk])
					--CAST(CAST([InTimeFromShopClk] AS DATETIME) AS NVARCHAR(12)), [TransactionID]
				ORDER BY
					[EmployeeNumber];
				-- C
				SELECT
					[QueryID],
					[EmployeeNumber],
					[EmployeeName],
					[HrsWorked],
					--CONVERT(DATETIME, [Date], 'Mon  dd, yyyy') AS [Date]
					CONVERT(DATETIME, [Date], 107) AS [Date]
				FROM (
					SELECT 
						'C' AS [QueryID],
						[ClkTransaction].[EmployeeNumber],
						[ClkTransaction].[EmployeeName],
						[@Src].[HrsWorked],
						--CAST(CAST(MIN([@Src].[StartDate]) AS DATETIME) AS NVARCHAR(12)) AS [Date]
						CAST(CAST(YEAR([StartDate]) AS NVARCHAR(4)) + '-' + CAST(MONTH([StartDate]) AS NVARCHAR(2)) + '-' + CAST(DAY([StartDate]) AS NVARCHAR(4)) AS DATETIME) AS [Date]
					FROM
						[ClkTransaction]
					INNER JOIN
						@Src
					ON
						[@Src].[EmployeeNumber] = [ClkTransaction].[EmployeeNumber]
						AND YEAR([InTimeFromShopClk]) = YEAR([StartDate])
						AND MONTH([InTimeFromShopClk]) = MONTH([StartDate])
						AND DAY([InTimeFromShopClk]) = DAY([StartDate])
					WHERE
						--[ClkTransaction].[EmployeeNumber] = @empNum
						[@Src].[EmployeeNumber] IN (SELECT [EmpNum] FROM @emps)
						AND [InTimeFromShopClk] BETWEEN  @sd AND @ed
						AND [OutTimeFromShopClk] BETWEEN @sd AND @ed
					GROUP BY
						[ClkTransaction].[EmployeeNumber], [ClkTransaction].[EmployeeName], [@Src].[HrsWorked]
						, YEAR([StartDate]), MONTH([StartDate]), DAY([StartDate])
						--, CAST(CAST([@Src].[StartDate] AS DATETIME) AS NVARCHAR(12))
				) AS [SubSrc]
				ORDER BY
					[EmployeeNumber]
			END
		END

	END
	ELSE BEGIN
		INSERT INTO @Src
		SELECT
			[TransactionID],
			[EmployeeNumber],
			[EmployeeName],
			MIN([InTimeFromShopClk]) AS [StartDate],
			MAX([OutTimeFromShopClk]) AS [EndDate],
			(CASE WHEN 
				DAY(MIN([InTimeFromShopClk])) <> DAY(MAX([OutTimeFromShopClk])) OR MONTH(MIN([InTimeFromShopClk])) <> MONTH(MAX([OutTimeFromShopClk])) OR YEAR(MIN([InTimeFromShopClk])) <> YEAR(MAX([OutTimeFromShopClk])) THEN (
					CASE WHEN 
						MIN([InTimeFromShopClk]) BETWEEN @sd AND @ed THEN 
							DATEDIFF(SECOND, MIN([InTimeFromShopClk]), CAST(CAST(YEAR(MIN([InTimeFromShopClk])) AS NVARCHAR(4)) + '-' + RIGHT('00' + CAST(MONTH(MIN([InTimeFromShopClk])) AS NVARCHAR(2)), 2) + '-' + RIGHT('00' + CAST(DAY(MIN([InTimeFromShopClk])) AS NVARCHAR(2)), 2) + ' 23:59:59' AS DATETIME))
						ELSE
							DATEDIFF(SECOND, CAST(CAST(YEAR(MAX([OutTimeFromShopClk])) AS NVARCHAR(4)) + '-' + RIGHT('00' + CAST(MONTH(MAX([OutTimeFromShopClk])) AS NVARCHAR(2)), 2) + '-' + RIGHT('00' + CAST(DAY(MAX([OutTimeFromShopClk])) AS NVARCHAR(2)), 2) AS DATETIME), MAX([OutTimeFromShopClk]))
					END)
				ELSE
					SUM(DATEDIFF(SECOND, [InTimeFromShopClk], (
						CASE WHEN DATEPART(DAY, [OutTimeFromShopClk]) = DATEPART(DAY, [InTimeFromShopClk]) THEN
							[OutTimeFromShopClk]
						ELSE DATEADD(HOUR, 23 - DATEPART(HOUR, [InTimeFromShopClk]), DATEADD(MINUTE, 59 - DATEPART(MINUTE, [InTimeFromShopClk]), DATEADD(SECOND, 59 - DATEPART(SECOND, [InTimeFromShopClk]), [InTimeFromShopClk]))) END))
					)
			END) / 60 / 60 AS [HrsWorked]

			--ROUND(DATEDIFF(hh, MIN([InTimeFromShopClk]), MAX([OutTimeFromShopClk])) + ((DATEDIFF(mi, MIN([InTimeFromShopClk]), MAX([OutTimeFromShopClk])) / 60.0) - DATEDIFF(hh, MIN([InTimeFromShopClk]), MAX([OutTimeFromShopClk]))), 2)
			--ROUND(((60 * ((DATEPART(HOUR, MAX([OutTimeFromShopClk]) - MIN([InTimeFromShopClk]))))) + DATEPART(MINUTE, MAX([OutTimeFromShopClk]) - MIN([InTimeFromShopClk]))) / 60.0, 2) AS [HrsWorked]
			--ROUND(((60 * (SUM(DATEPART(HOUR, [OutTimeFromShopClk] - [InTimeFromShopClk])))) + SUM(DATEPART(MINUTE, [OutTimeFromShopClk] - [InTimeFromShopClk]))) / 60.0, 2) AS [HrsWorked]
		FROM
			[ClkTransaction]
		WHERE
			([InTimeFromShopClk] BETWEEN @sd AND @ed
			OR [OutTimeFromShopClk] BETWEEN @sd AND @ed)
			AND [OutTimeFromShopClk] IS NOT NULL
		GROUP BY
			[EmployeeNumber], [EmployeeName], [TransactionID] --, [InTimeFromShopClk], [OutTimeFromShopClk]
		ORDER BY
			[EmployeeNumber];

		IF @by_transaction = 1 BEGIN
			-- D
			SELECT 
				'D' AS [QueryID],
				[ClkTransaction].[TransactionID],
				[JobNumber],
				[ClkTransaction].[EmployeeNumber],
				[ClkTransaction].[EmployeeName],
				[LoggedOn],
				[InTimeFromShopClk],
				[LoggedOff],
				[OutTimeFromShopClk],
				(CASE WHEN [LoggedOff] IS NULL THEN 0 ELSE 1 END) AS [PlaceHolder],
				[@Src].[HrsWorked],
				[StartDate] AS [StartDate],
				[EndDate] AS [EndDate]
			FROM
				[ClkTransaction]
			INNER JOIN
				@Src
			ON
				[@Src].[EmployeeNumber] = [ClkTransaction].[EmployeeNumber]
				AND [@Src].TransactionID = [ClkTransaction].[TransactionID] 
			WHERE
				[InTimeFromShopClk] BETWEEN  @sd AND @ed
				AND [OutTimeFromShopClk] BETWEEN @sd AND @ed
			ORDER BY
				[PlaceHolder], [LoggedOn], [LoggedOff];
		END
		ELSE BEGIN
			IF @by_date = 0 BEGIN
				-- E
				SELECT 
					'E' AS [QueryID],
					[EmployeeNumber],
					[EmployeeName],
					SUM([@Src].[HrsWorked]) AS [HrsWorked],
					--CAST(CAST(YEAR([StartDate]) AS NVARCHAR(4)) + '-' + CAST(MONTH([StartDate]) AS NVARCHAR(2)) + '-' + CAST(DAY([StartDate]) AS NVARCHAR(4)) AS DATETIME) AS [Date]
					MIN([StartDate]) AS [StartDate],
					MAX([EndDate]) AS [EndDate]
				FROM
					@Src
				WHERE
					([StartDate] BETWEEN @sd AND @ed
					OR [EndDate] BETWEEN @sd AND @ed)
				GROUP BY
					[EmployeeNumber], [EmployeeName]
				ORDER BY
					[EmployeeNumber]
			END
			ELSE BEGIN
			
				-- Re-pop @Src to add groups by date
				DELETE FROM @Src
				INSERT INTO @Src
				SELECT
					[TransactionID],
					[EmployeeNumber],
					[EmployeeName],
					MIN([InTimeFromShopClk]) AS [StartDate],
					MAX([OutTimeFromShopClk]) AS [EndDate],
					SUM(DATEDIFF(SECOND, [InTimeFromShopClk], (
						CASE WHEN DATEPART(DAY, [OutTimeFromShopClk]) = DATEPART(DAY, [InTimeFromShopClk]) THEN
							[OutTimeFromShopClk]
						ELSE DATEADD(HOUR, 23 - DATEPART(HOUR, [InTimeFromShopClk]), DATEADD(MINUTE, 59 - DATEPART(MINUTE, [InTimeFromShopClk]), DATEADD(SECOND, 59 - DATEPART(SECOND, [InTimeFromShopClk]), [InTimeFromShopClk]))) END))
					) / 60 / 60 AS [HrsWorked]
					--DATEADD(HOUR, 23 - DATEPART(HOUR, [InTimeFromShopClk]), DATEADD(MINUTE, 59 - DATEPART(MINUTE, [InTimeFromShopClk]), DATEADD(SECOND, 59 - DATEPART(SECOND, [InTimeFromShopClk]), [InTimeFromShopClk])))
					--ROUND(DATEDIFF(hh, MIN([InTimeFromShopClk]), MAX([OutTimeFromShopClk])) + ((DATEDIFF(mi, MIN([InTimeFromShopClk]), MAX([OutTimeFromShopClk])) / 60.0) - DATEDIFF(hh, MIN([InTimeFromShopClk]), MAX([OutTimeFromShopClk]))), 2)
					--ROUND(((60 * ((DATEPART(HOUR, MAX([OutTimeFromShopClk]) - MIN([InTimeFromShopClk]))))) + DATEPART(MINUTE, MAX([OutTimeFromShopClk]) - MIN([InTimeFromShopClk]))) / 60.0, 2) AS [HrsWorked]
					--ROUND(((60 * (SUM(DATEPART(HOUR, [OutTimeFromShopClk] - [InTimeFromShopClk])))) + SUM(DATEPART(MINUTE, [OutTimeFromShopClk] - [InTimeFromShopClk]))) / 60.0, 2) AS [HrsWorked]
				FROM
					[ClkTransaction]
				WHERE
					[InTimeFromShopClk] BETWEEN @sd AND @ed
					AND [OutTimeFromShopClk] BETWEEN @sd AND @ed
				GROUP BY
					[EmployeeNumber], [EmployeeName], CAST(CAST([InTimeFromShopClk] AS DATETIME) AS NVARCHAR(12)), [TransactionID]
				ORDER BY
					[EmployeeNumber];

				SELECT
					[QueryID],
					[EmployeeNumber],
					[EmployeeName],
					[HrsWorked],
					CONVERT(DATETIME, [Date], 107) AS [Date]
				FROM (
					SELECT 
						'F' AS [QueryID],
						[ClkTransaction].[EmployeeNumber],
						[ClkTransaction].[EmployeeName],
						SUM([@Src].[HrsWorked]) AS [HrsWorked],
						CAST(CAST(YEAR([StartDate]) AS NVARCHAR(4)) + '-' + CAST(MONTH([StartDate]) AS NVARCHAR(2)) + '-' + CAST(DAY([StartDate]) AS NVARCHAR(4)) AS DATETIME) AS [Date]
						--CAST(CAST([@Src].[StartDate] AS DATETIME) AS NVARCHAR(12)) AS [Date]
					FROM
						[ClkTransaction]
					INNER JOIN
						@Src
					ON
						[@Src].[EmployeeNumber] = [ClkTransaction].[EmployeeNumber]
						AND YEAR([InTimeFromShopClk]) = YEAR([StartDate])
						AND MONTH([InTimeFromShopClk]) = MONTH([StartDate])
						AND DAY([InTimeFromShopClk]) = DAY([StartDate])
						AND [ClkTransaction].[TransactionID] = [@Src].[TransactionID]
					WHERE
						[InTimeFromShopClk] BETWEEN  @sd AND @ed
						AND [OutTimeFromShopClk] BETWEEN @sd AND @ed
					GROUP BY
						[ClkTransaction].[EmployeeNumber], [ClkTransaction].[EmployeeName]
						, YEAR([StartDate]), MONTH([StartDate]), DAY([StartDate])
						--, [@Src].[HrsWorked]
						--[ClkTransaction].[EmployeeNumber], [ClkTransaction].[EmployeeName], [@Src].[HrsWorked], CAST(CAST([@Src].[StartDate] AS DATETIME) AS NVARCHAR(12))
				) AS [SubSrc]
				ORDER BY
					[EmployeeNumber], [Date]
			END
		END
	END
--END