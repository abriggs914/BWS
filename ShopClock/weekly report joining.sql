USE BWSdb
GO



--DECLARE @sd AS DATETIME;
--DECLARE @ed AS DATETIME;
--SET @sd = 'October 11 2021';
--SET @ed = 'October 15 2021';
--SET @sd = '2022-02-11';
--SET @ed = '2022-02-15';

ALTER PROCEDURE [dbo].[sp_ClkTallyWeeklyReport]
	@sd DATETIME, @ed DATETIME
AS BEGIN

DECLARE @ed2 AS DATETIME; -- used for sp_clkTallyHours since the @ed param is exclusive
SET @ed2 = DATEADD(DAY, 1, @ed);

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
EXEC sp_WeeklyRpt @sd, @ed

INSERT INTO @clkTally
EXEC [SysproCompanyA].[dbo].[sp_ClkTallyHours] @sd=@sd, @ed=@ed2, @by_transaction=0, @by_date=1

--SELECT
--	[ID],
--	[StaffID#],
--	[Emp#],
--	[2nd Name],
--	[1st Name],
--	[Hours Work],
--	[Net Hours Work],
--	[V],
--	[A],
--	[ABQ],
--	[SL],
--	[L],
--	[E],
--	[S],
--	[Comments],
--	[Terminated],
--	[EntryDate]
--FROM
--	@weeklyRpt
--;
--SELECT
--	[ID],
--	[QueryID],
--	[EmployeeNumber],
--	[EmployeeName],
--	[HrsWorked],
--	[Date]
--FROM
--	@clkTally


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
	[CT].[EmployeeNumber] = 
		(CASE
			WHEN LEFT([CT].[EmployeeNumber], 3) = '100' THEN
				'100' + RIGHT('000' + CAST([WR].[Emp#] AS NVARCHAR(MAX)), 3)
			ELSE
				'200' + RIGHT('000' + CAST([WR].[Emp#] AS NVARCHAR(MAX)), 3)
		END)
ORDER BY
	[2nd Name]
	,[1st Name]
	,[EntryDate]
END
