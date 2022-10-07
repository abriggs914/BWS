USE SysproCompanyA
GO

ALTER PROCEDURE [dbo].[sp_WOSnapshotEmployeesOnJob Ops 4 5]
	@WO NVARCHAR(MAX)
AS
BEGIN

SELECT
		[EmployeeNumber]
		,[EmployeeName]
		,[Operation]
		,CAST(ROUND(SUM([Hours]), 2) AS DECIMAL(14, 2)) AS [Hours]
	FROM (
		SELECT
			[EmployeeNumber]
			,[EmployeeName]
			,[Operation]
			,DATEDIFF(HOUR, [LoggedOn], [LoggedOff]) + ((DATEDIFF(MINUTE, [LoggedOn], [LoggedOff])) - (60.0 * DATEDIFF(HOUR, [LoggedOn], [LoggedOff]))) / 60.0 AS [Hours]
		FROM
			[ClkTransaction]
		WHERE
			[JobNumber] = @WO
			AND [Operation] = 4
		UNION
		SELECT
			[EmployeeNumber]
			,[EmployeeName]
			,[Operation]
			,DATEDIFF(HOUR, [LoggedOn], [LoggedOff]) + ((DATEDIFF(MINUTE, [LoggedOn], [LoggedOff])) - (60.0 * DATEDIFF(HOUR, [LoggedOn], [LoggedOff]))) / 60.0 AS [Hours]
		FROM
			[ClkTransaction]
		WHERE
			[JobNumber] = @WO
			AND [Operation] = 5
	) AS [UnionSrc]
	GROUP BY
		[EmployeeNumber]
		,[EmployeeName]
		,[Operation]
END
GO