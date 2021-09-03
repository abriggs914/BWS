USE SysproCompanyA
GO

BEGIN TRAN;
-- View shift IDs
SELECT * FROM [ClkShiftMaster] WHERE [ShiftID] IN (9, 34, 33);

SELECT * FROM [ClkEmployee] WHERE [ShiftID] IN (33, 34);

UPDATE 
	[ClkEmployee]
SET
	[ShiftID] = 37
WHERE
	[ShiftID] IN (33, 34);

-- Should be 0
SELECT Count(*) AS [Should be 0] FROM [ClkEmployee] WHERE [ShiftID] IN (33, 34);
SELECT * FROM [ClkEmployee] WHERE [ShiftID] IN (37);

ROLLBACK;
COMMIT;