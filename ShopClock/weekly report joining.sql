USE BWSdb
GO

DECLARE @sd AS DATETIME;
DECLARE @ed AS DATETIME;
SET @sd = 'October 11 2021';
SET @ed = 'October 15 2021';
SET @sd = '2022-02-11';
SET @ed = '2022-02-15';

DECLARE @weeklyRpt AS TABLE ([ID] INT IDENTITY(1,1), [StaffID#] INT, [Emp#] INT, [2nd Name] NVARCHAR(MAX), [1st Name] NVARCHAR(MAX), [Hours Work] FLOAT, [Net Hours Work] FLOAT, [V] BIT, [A] BIT, [ABQ] BIT, [SL] BIT, [L] BIT, [E] BIT, [S] BIT, [Comments] NVARCHAR(MAX), [Terminated] DATETIME, [EntryDate] DATETIME);
INSERT INTO @weeklyRpt
EXEC sp_WeeklyRpt @sd, @ed

EXEC [SysproCompanyA].[dbo].[sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=0, @by_date=1

SELECT * FROM @weeklyRpt