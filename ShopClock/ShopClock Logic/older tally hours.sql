USE SysproCompanyA
GO

DECLARE @empNum AS BIGINT;
DECLARE @sd AS DATETIME, @ed AS DATETIME;
SET @sd = '2021-11-01';
SET @ed = '2021-11-05';
SET @empNum = 200102;

DECLARE @Src TABLE ([EmployeeNumber] BIGINT, [EmployeeName] NVARCHAR(200), [StartDate] DATETIME, [EndDate] DATETIME, [HrsWorked] FLOAT);
INSERT INTO @Src
EXEC [dbo].[sp_ClkTallyHours] @empNum=@empNum, @sd=@sd, @ed=@ed;

SELECT * FROM @Src

SELECT 
	[TransactionID],
	[JobNumber],
	[ClkTransaction].[EmployeeNumber],
	[ClkTransaction].[EmployeeName],
	[LoggedOn],
	[InTimeFromShopClk],
	[LoggedOff],
	[OutTimeFromShopClk],
	(CASE WHEN [LoggedOff] IS NULL THEN 0 ELSE 1 END) AS [PlaceHolder],
	[@Src].[HrsWorked]
FROM
	[ClkTransaction]
INNER JOIN
	@Src
ON
	[@Src].[EmployeeNumber] = [ClkTransaction].[EmployeeNumber]
WHERE
	[ClkTransaction].[EmployeeNumber] = CAST(@empNum AS NVARCHAR(10))
	AND [InTimeFromShopClk] BETWEEN @sd AND @ed
ORDER BY
	[PlaceHolder], [LoggedOn], [LoggedOff]