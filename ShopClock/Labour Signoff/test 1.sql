




DECLARE @d1 AS DATETIME;
DECLARE @d2 AS DATETIME;
--SELECT @d = DATEADD(DAY, -1, GETDATE());
SELECT @d1 = '2023-08-24';
SELECT @d2 = '2023-08-24';


SELECT
	*
FROM
	[ClkTransaction]
WHERE
	[EmployeeNumber] IN ('200114', '200644')
	AND [LoggedOn] BETWEEN DATEADD(HOUR, -5, @d1) AND DATEADD(HOUR, 29, @d2)
;


SELECT
	[Cal].[Date]
	,[Emp].[Employee]
	,[Emp].[Name]
	,[Clk].[EmployeeNumber]
	,MAX([Clk].[TransactionID]) AS [LastClkID]
FROM
	[BWSdb].[dbo].[Calendar] AS [Cal]
CROSS JOIN
	[ClkEmployee] AS [Emp]
LEFT JOIN
	[ClkTransaction] AS [Clk]
ON
	CAST(CAST(YEAR([LoggedOn]) AS NVARCHAR(4))
	+ '-' + RIGHT('00' + CAST(MONTH([LoggedOn]) AS NVARCHAR(2)), 2)
	+ '-' + RIGHT('00' + CAST(DAY([LoggedOn]) AS NVARCHAR(2)), 2)
	AS DATETIME) = [Cal].[Date]
	AND [Emp].[Employee] = [Clk].[EmployeeNumber]
WHERE
	--[LoggedOn] BETWEEN @d1 AND @d2
	--AND
	[Cal].[Date] BETWEEN @d1 AND @d2		-- Must be between desired dates
	AND LEFT([Emp].[Employee], 1) = '2'		-- Must be non-machine, non-salary emp #s
	AND [Emp].[IsEnabled] = 1				-- Must be active employee
	AND [Emp].[GroupID] NOT IN (12)			-- Remove Salary employees
	AND [Clk].[TransactionID] IS NULL
GROUP BY
	[Cal].[Date]
	,[Clk].[EmployeeNumber]
	,[Emp].[Employee]
	,[Emp].[Name]
--HAVING
--	MAX([TransactionID]) IS NOT NULL
ORDER BY
	[Cal].[Date]
	, [Emp].[Employee]