
USE SysproCompanyA
GO

ALTER PROCEDURE [sp_LSOEmployeesWithNoTransactions]

	@sd AS DATETIME,
	@ed AS DATETIME=NULL

AS
BEGIN

	IF @ed IS NULL BEGIN
		SELECT @ed = DATEADD(SECOND, 59, DATEADD(MINUTE, 59, DATEADD(HOUR, 23, @sd)));
	END

	SELECT
		[Cal].[Date]
		,[Emp].[Employee]
		,[Emp].[Name]
		--,[Clk].[EmployeeNumber]
		--,MAX([Clk].[TransactionID]) AS [LastClkID]
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
		[Cal].[Date] BETWEEN @sd AND @ed		-- Must be between desired dates
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
END