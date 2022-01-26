USE SysproCompanyA
GO

DECLARE @sd AS DATETIME;
DECLARE @ed AS DATETIME;
SET @sd = '2021-11-09 7:00'
SET @ed = '2021-11-09 17:00'

EXEC [dbo].[sp_ClkTallyHours] @empNum=200326, @sd=@sd, @ed=@ed

DECLARE @TS1 AS TABLE ([TransactionID] BIGINT, [JobNumber] BIGINT, [EmployeeNumber] BIGINT, [EmployeeName] NVARCHAR(MAX), [LoggedOn] DATETIME, [InTimeFromShopClk] DATETIME, [LoggedOff] DATETIME, [OutTimeFromShopClk] DATETIME, [PlaceHolder] INT, [HrsWorked] FLOAT, [StartDate] DATETIME, [EndDate] DATETIME)
INSERT INTO @TS1
EXEC [dbo].[sp_ClkTallyHours] @sd=@sd, @ed=@ed

--DECLARE @TS2 AS TABLE ([TransactionID] BIGINT, [JobNumber] BIGINT, [EmployeeNumber] BIGINT, [EmployeeName] NVARCHAR(MAX), [LoggedOn] DATETIME, [InTimeFromShopClk] DATETIME, [LoggedOff] DATETIME, [OutTimeFromShopClk] DATETIME, [PlaceHolder] INT, [HrsWorked] FLOAT, [StartDate] DATETIME, [EndDate] DATETIME)
--INSERT INTO @TS2
--EXEC [dbo].[sp_ClkTallyHours] @sd=@sd, @ed=@ed, @empNum=200553, @by_transaction=1

--DECLARE @TS3 AS TABLE ([TransactionID] BIGINT, [JobNumber] BIGINT, [EmployeeNumber] BIGINT, [EmployeeName] NVARCHAR(MAX), [LoggedOn] DATETIME, [InTimeFromShopClk] DATETIME, [LoggedOff] DATETIME, [OutTimeFromShopClk] DATETIME, [PlaceHolder] INT, [HrsWorked] FLOAT, [StartDate] DATETIME, [EndDate] DATETIME)
--INSERT INTO @TS3
--EXEC [dbo].[sp_ClkTallyHours] @sd=@sd, @ed=@ed, @empNum=200553, @by_transaction=0

--DECLARE @TS4 AS TABLE ([TransactionID] BIGINT, [JobNumber] BIGINT, [EmployeeNumber] BIGINT, [EmployeeName] NVARCHAR(MAX), [LoggedOn] DATETIME, [InTimeFromShopClk] DATETIME, [LoggedOff] DATETIME, [OutTimeFromShopClk] DATETIME, [PlaceHolder] INT, [HrsWorked] FLOAT, [StartDate] DATETIME, [EndDate] DATETIME)
--INSERT INTO @TS4
--EXEC [dbo].[sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=1

--DECLARE @TS5 AS TABLE ([TransactionID] BIGINT, [JobNumber] BIGINT, [EmployeeNumber] BIGINT, [EmployeeName] NVARCHAR(MAX), [LoggedOn] DATETIME, [InTimeFromShopClk] DATETIME, [LoggedOff] DATETIME, [OutTimeFromShopClk] DATETIME, [PlaceHolder] INT, [HrsWorked] FLOAT, [StartDate] DATETIME, [EndDate] DATETIME)
--INSERT INTO @TS5
--EXEC [dbo].[sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=0

DECLARE @T TABLE ([EmployeeNumber] REAL,
				[EmployeeName] NVARCHAR(200),
				[HrsWorked] FLOAT,
				[StartDate] DATETIME,
				[EndDate] DATETIME);
				
INSERT INTO @T EXEC [sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=0
--INSERT INTO @T EXEC [sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=1

SELECT * FROM @T ORDER BY [HrsWorked] DESC
SELECT * FROM @TS1 ORDER BY [HrsWorked] DESC
--SELECT * FROM @TS2 ORDER BY [HrsWorked] DESC
--SELECT * FROM @TS3 ORDER BY [HrsWorked] DESC
--SELECT * FROM @TS4 ORDER BY [HrsWorked] DESC
--SELECT * FROM @TS5 ORDER BY [HrsWorked] DESC

DECLARE @empNum AS BIGINT

SELECT
	[EmployeeNumber],
	[EmployeeName],
	@sd AS [StartDate],
	@ed AS [EndDate],
	ROUND(((60 * (SUM(DATEPART(HOUR, [OutTimeFromShopClk] - [InTimeFromShopClk])))) + SUM(DATEPART(MINUTE, [OutTimeFromShopClk] - [InTimeFromShopClk]))) / 60.0, 2) AS [HrsWorked]
	--ROUND(((60 * (SUM(DATEPART(HOUR, [OutTimeFromShopClk] - [InTimeFromShopClk])))) + SUM(DATEPART(MINUTE, [OutTimeFromShopClk] - [InTimeFromShopClk]))) / 60.0, 2) AS [HrsWorked]
FROM
	[ClkTransaction]
WHERE
	[EmployeeNumber] = CAST(@empNum AS NVARCHAR)
	AND [InTimeFromShopClk] BETWEEN @sd AND @ed
GROUP BY
	[EmployeeNumber], [EmployeeName]
ORDER BY
	[EmployeeNumber];