--USE SysproCompanyS
--GO

--SELECT * FROM [ClkFrmConfirm]

USE Stargatedb
GO

DECLARE @sd AS DATETIME;
DECLARE @ed AS DATETIME;
SET @sd = '2022-04-11';
SET @ed = '2022-04-13 23:59:59';
EXEC [dbo].[sp_ClkTallyWeeklyReport] @sd=@sd, @ed=@ed, @empNum=NULL
EXEC [SysproCompanyS].[dbo].[sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=0, @by_date=1


DECLARE @weeklyRpt AS TABLE (
	[ID] INT IDENTITY(1,1),
	[StaffID#] INT,
	[Emp#] INT,
	[2nd Name] NVARCHAR(MAX),
	[1st Name] NVARCHAR(MAX),
	[Hours Work] FLOAT,
	[Net Hours Work] FLOAT,
	[V] BIT,
	[A] BIT,
	[ABQ] BIT,
	[SL] BIT,
	[L] BIT,
	[E] BIT,
	[S] BIT,
	[Comments] NVARCHAR(MAX),
	[Terminated] DATETIME,
	[EntryDate] DATETIME
);

DECLARE @clkTally AS TABLE (
	[ID] INT IDENTITY(1,1),
	[QueryID] NVARCHAR(1),
	[EmployeeNumber] NVARCHAR(MAX),
	[EmployeeName] NVARCHAR(MAX),
	[HrsWorked] FLOAT,
	[Date] DATETIME
);

INSERT INTO @weeklyRpt
EXEC [Stargatedb].[dbo].sp_WeeklyRpt @sd, @ed

INSERT INTO @clkTally
EXEC [SysproCompanyS].[dbo].[sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=0, @by_date=1

SELECT * FROM @clkTally
SELECT * FROM @weeklyRpt

SELECT
		[QueryID]
		,[EmployeeNumber]
		,[EmployeeName]
		,[HrsWorked]
		,[Date]
		,[StaffID#]
		,[Emp#]
		,[2nd Name]
		,[1st Name]
		,[Hours Work]
		,[Net Hours Work]
		,[V]
		,[A]
		,[ABQ]
		,[SL]
		,[L]
		,[E]
		,[S]
		,[Comments]
		,[Terminated]
		,[EntryDate]
	FROM
		@weeklyRpt AS [WR]
	LEFT JOIN
		@clkTally AS [CT]
	ON
		YEAR([CT].[Date]) = YEAR([WR].[EntryDate])
		AND MONTH([CT].[Date]) = MONTH([WR].[EntryDate])
		AND DAY([CT].[Date]) = DAY([WR].[EntryDate])
		AND 
		[CT].[EmployeeNumber] =  [WR].[Emp#]
			--(CASE
			--	WHEN LEFT([CT].[EmployeeNumber], 3) = '100' THEN
			--		'100' + RIGHT('000' + CAST([WR].[Emp#] AS NVARCHAR(MAX)), 3)
			--	ELSE
			--		'200' + RIGHT('000' + CAST([WR].[Emp#] AS NVARCHAR(MAX)), 3)
			--END)
	ORDER BY
		[2nd Name]
		,[1st Name]
		,[EntryDate]

--USE BWSdb
--GO

--EXEC [dbo].[sp_ClkTallyWeeklyReport] @sd='2022-01-26', @ed='2022-01-31 23:59:59', @empNum=NULL