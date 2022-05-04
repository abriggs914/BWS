DECLARE @sd AS DATETIME;
DECLARE @ed AS DATETIME;
SET @sd = '2022-05-03';
SET @ed = '2022-05-03 23:59:59';


	--DECLARE @emps AS TABLE([idx] INT, [EmpNum] NVARCHAR(MAX));
	--INSERT INTO @emps SELECT * FROM [BWSdb].[dbo].[split_string_idx](@empNum, ';');

	DECLARE @Src TABLE ([TransactionID] BIGINT, [EmployeeNumber] NVARCHAR(MAX), [EmployeeName] NVARCHAR(200), [StartDate] DATETIME, [EndDate] DATETIME, [HrsWorked1] FLOAT, [HrsWorked2] FLOAT);
	--DECLARE @Src TABLE ([EmployeeNumber] NVARCHAR(MAX), [EmployeeName] NVARCHAR(200), [StartDate] DATETIME, [EndDate] DATETIME, [HrsWorked1] FLOAT, [HrsWorked2] FLOAT);

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
					) / 60 / 60 AS [HrsWorked1],

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
			END) / 60 / 60 AS [HrsWorked2]

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

SELECT 'All T' AS [T], * FROM @Src

SELECT 
					'E' AS [QueryID],
					[EmployeeNumber],
					[EmployeeName],
					SUM([@Src].[HrsWorked2]) AS [HrsWorked],
					--CAST(CAST(YEAR([StartDate]) AS NVARCHAR(4)) + '-' + CAST(MONTH([StartDate]) AS NVARCHAR(2)) + '-' + CAST(DAY([StartDate]) AS NVARCHAR(4)) AS DATETIME) AS [Date]
					MIN([StartDate]) AS [StartDate],
					MAX([EndDate]) AS [EndDate]
				FROM
				--	[ClkTransaction]
				--INNER JOIN
					@Src
				--ON
				--	[@Src].[EmployeeNumber] = [ClkTransaction].[EmployeeNumber]
					--AND [@Src].[TransactionID] = [ClkTransaction].[TransactionID]
					--AND YEAR([InTimeFromShopClk]) = YEAR([StartDate])
					--AND MONTH([InTimeFromShopClk]) = MONTH([StartDate])
					--AND DAY([InTimeFromShopClk]) = DAY([StartDate])
				WHERE
					([StartDate] BETWEEN @sd AND @ed
					OR [EndDate] BETWEEN @sd AND @ed)
				GROUP BY
					[EmployeeNumber], [EmployeeName]
				ORDER BY
					[EmployeeNumber]