--INSERT INTO [ClkShiftRoundRules] ([Name]) VALUES ('New Shift 1')

SELECT * FROM [ClkShiftRoundRules]
SELECT * FROM [ClkEmployee]
SELECT [Employee] FROM [ClkEmployee] GROUP BY [Employee] HAVING COUNT(*) > 1



--BEGIN TRAN;
--UPDATE
--	[ClkShiftRoundRules]
--SET 
--	[StartTime] = '7:00:00 AM',
--	[EndTime] = '5:00:00 PM',
--	[Interval] = 15,
--	[Threshold] = 2,
--	[IncludeLunch] = 1
--WHERE
--	[StartTime] IS NULL

--ROLLBACK;
--COMMIT;