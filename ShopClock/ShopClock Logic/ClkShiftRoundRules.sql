USE SysproCompanyA
GO

BEGIN TRAN;

INSERT INTO [ClkShiftRoundRules]
SELECT [ShiftID], 0 AS [Interval], 0 AS [Threshold]
FROM [ClkShiftMaster]

UPDATE [ClkShiftRoundRules] SET [Interval] = 15, [Threshold] = 3 WHERE [ShiftID] IN ((1), (2), (3))


--SELECT * FROM [ClkShiftMaster]
SELECT * FROM [ClkShiftRoundRules]
SELECT [EndTime] FROM [ClkShiftRoundRules] WHERE [ShiftID] = 3

ROLLBACK;
COMMIT;