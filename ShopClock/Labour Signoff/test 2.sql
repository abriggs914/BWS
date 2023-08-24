


-- Gather employees who did not make clktransactions between 2 dates.
-- "Who wasn't here between these days?"

DECLARE @d1 AS DATETIME = '2023-08-23';
DECLARE @d2 AS DATETIME = '2023-08-23';

SELECT
	[Cal].[Date]
	,[Emp].[Employee]
	,[Emp].[Name]
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
	AS DATETIME) = [Cal].[Date]						-- Same date
	AND [Emp].[Employee] = [Clk].[EmployeeNumber]	-- Same Employee
WHERE
	[Cal].[Date] BETWEEN @d1 AND @d2		-- Must be between desired dates
	AND LEFT([Emp].[Employee], 1) = '2'		-- Must be non-machine, non-salary emp #s
	AND [Emp].[IsEnabled] = 1				-- Must be active employee
	AND [Clk].[TransactionID] IS NULL		-- Must not exist in [ClkTransaction] for today

	AND [Emp].[GroupID] NOT IN (12)			-- Remove Salary employees
	--AND LOWER([Emp].[Name]) LIKE '%ekpe%'
	--AND LOWER([Emp].[Name]) LIKE '%%'
GROUP BY
	[Cal].[Date]
	,[Emp].[Employee]
	,[Emp].[Name]
ORDER BY
	[Cal].[Date]
	, [Emp].[Employee]


SELECT
	*
FROM
	[BWSdb].[dbo].[Hours Worked]
WHERE
	[DateWorked] BETWEEn @d1 AND @d2
ORDER BY
	[Emp#]