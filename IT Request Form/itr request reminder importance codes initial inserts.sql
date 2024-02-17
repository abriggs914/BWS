USE BWSdb
GO

-- Initial inserts 2024-02-15 1846

BEGIN TRAN;

INSERT INTO [ITR Request Reminder Importance Codes] (
	[Code]
	,[Period]
	,[MaxReminders]
	,[StartOfDayHour]
	,[StartOfDayMinute]
	,[EndOfDayHour]
	,[EndOfDayMinute]
) VALUES
('None', 0, 0, NULL, NULL, NULL, NULL),
('High', 60*60*3, 16, 8, 0, 18, 0),
('Medium', 60*60*6, 8, 8, 0, 18, 0),
('Low', 60*60*24, 1, 8, 0, 18, 0)
;

ROLLBACK;
COMMIT;