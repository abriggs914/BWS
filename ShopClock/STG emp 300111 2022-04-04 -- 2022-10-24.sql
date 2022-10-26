/*
USE BWSdb
GO

exec sp_HourlyEmpDetail 'April 04 2022', 'October 24 2022'
*/

USE Stargatedb
GO

DECLARE @t AS TABLE ([ID] INT IDENTITY(1, 1), [DateCreated] DATETIME DEFAULT GETDATE(), [Emp#] INT, [EntryDate] DATETIME, [HoursWorked] FLOAT, [Vacation] INT, [ABsent] INT, [Absetn_BQ] INT, [Sick Leave] INT, [Late] INT, [Leave Early] INT, [Shortage of Work] INT, [Comments] NVARCHAR(MAX))
INSERT INTO @t ([Emp#], [EntryDate], [HoursWorked], [Vacation], [ABsent], [Absetn_BQ], [Sick Leave], [Late], [Leave Early], [Shortage of Work], [Comments])
exec sp_HourlyEmpDetail 'April 04 2022', 'October 24 2022'

SELECT * FROM @t WHERE [Emp#] = 300111 ORDER BY [EntryDate] DESC