-- group employees based on the individual calendar days that they were here

USE SysproCompanyA
GO


DECLARE
	@t
AS TABLE 
(
	[ID] INT IDENTITY(1, 1)
	, [DateCreated] DATETIME DEFAULT GETDATE()
	, [Active] BIT
	, [DateActive] DATETIME
	, [DateInActive] DATETIME
)


SELECT
	[SrcB].[min(TiD)]
	, [SrcB].[max(TiD)]
	, [SrcB].[EmployeeNumber]
	, [SrcB].[EmployeeName]
	, [SrcB].[LoggedOn]
	, [SrcB].[min(LoggedOn)]
	, [SrcB].[max(LoggedOff)]
	, [SrcB].[DD(s)]
	, [SrcB].[Hrs]
	, [v_ClkTransaction ShiftsOverNight].*
FROM 
(
	SELECT
		[min(TiD)]
		, [max(TiD)]
		, [EmployeeNumber]
		, [EmployeeName]
		, [BWSdb].[dbo].[Datify]([Year], [Month], [Day], [Hour], [Minute], DEFAULT) AS [LoggedOn]
		, [BWSdb].[dbo].[Datify]([Y(min(LN))], [M(min(LN))], [D(min(LN))], [HR(min(LN))], [MN(min(LN))], DEFAULT) AS [min(LoggedOn)]
		, [BWSdb].[dbo].[Datify]([Y(max(LF))], [M(max(LF))], [D(max(LF))], [HR(max(LF))], [MN(max(LF))], DEFAULT) AS [max(LoggedOff)]
		, [DD(s)]
		, [DD(s)] / (60.0 * 60) AS [Hrs]
	FROM 
	(
		SELECT
			MIN([TransactionID]) AS [min(TiD)]
			, MAX([TransactionID]) AS [max(TiD)]
			, [EmployeeNumber]
			, [EmployeeName]
			, YEAR([LoggedOn]) AS [Year]
			, MONTH([LoggedOn]) AS [Month]
			, DAY([LoggedOn]) AS [Day]
			--, DATEPART(HOUR, [LoggedOn]) AS [Hour]
			--, DATEPART(MINUTE, [LoggedOn]) AS [Minute]
			, 0 AS [Hour]
			, 0 AS [Minute]

			, DATEPART(YEAR, MIN([LoggedOn])) AS [Y(min(LN))]
			, DATEPART(MONTH, MIN([LoggedOn])) AS [M(min(LN))]
			, DATEPART(DAY, MIN([LoggedOn])) AS [D(min(LN))]
			, DATEPART(HOUR, MIN([LoggedOn])) AS [HR(min(LN))]
			, DATEPART(MINUTE, MIN([LoggedOn])) AS [MN(min(LN))]

			, DATEPART(YEAR, MAX([LoggedOff])) AS [Y(max(LF))]
			, DATEPART(MONTH, MAX([LoggedOff])) AS [M(max(LF))]
			, DATEPART(DAY, MAX([LoggedOff])) AS [D(max(LF))]
			, DATEPART(HOUR, MAX([LoggedOff])) AS [HR(max(LF))]
			, DATEPART(MINUTE, MAX([LoggedOff])) AS [MN(max(LF))]

			, DATEDIFF(SECOND, MIN([LoggedOn]), MAX([LoggedOff])) AS [DD(s)]
		FROM
			[ClkTransaction]
		GROUP BY
			[EmployeeNumber]
			, [EmployeeName]
			, YEAR([LoggedOn])
			, MONTH([LoggedOn])
			, DAY([LoggedOn])
	) AS [SrcA]
) AS [SrcB]
LEFT JOIN
	[v_ClkTransaction ShiftsOverNight]
ON
	--([v_ClkTransaction ShiftsOverNight].[TransactionID] BETWEEN [min(TiD)] AND [max(TiD)])
	--AND [SrcB].[EmployeeNumber] = [v_ClkTransaction ShiftsOverNight].[EmployeeNumber]
	[SrcB].[LoggedOn] = [BWSdb].[dbo].[Datify](YEAR([v_ClkTransaction ShiftsOverNight].[LoggedOn]), MONTH([v_ClkTransaction ShiftsOverNight].[LoggedOn]), DAY([v_ClkTransaction ShiftsOverNight].[LoggedOn]), DEFAULT, DEFAULT, DEFAULT)
	AND [SrcB].[EmployeeNumber] = [v_ClkTransaction ShiftsOverNight].[EmployeeNumber]
WHERE
	[Hrs] >= 24 
	AND LEFT(CAST([SrcB].[EmployeeNumber] AS NVARCHAR(6)), 3) <> '100'
	AND YEAR([SrcB].[LoggedOn]) >= 2021
ORDER BY
	--[EmployeeName]
	--,
	[SrcB].[LoggedOn] DESC
--ORDER BY
--	[EmployeeName]
--	, [Year]
--	, [Month]
--	, [Day]