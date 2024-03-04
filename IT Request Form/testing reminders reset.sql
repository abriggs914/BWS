USE BWSdb
GO

DECLARE @tID1 INT = 2567;
DECLARE @tID2 INT = 2568;

BEGIN TRAN;

-- Reset reminders
UPDATE
	[ITR Request Reminders]
SET
	[NumRemindersSent] = 0,
	[LastReminder] = NULL
;

-- Set old reminder
UPDATE
	[ITR Request Reminders]
SET
	[Starting] = '2024-03-01 12:00',
	[Ending] = '2024-03-04 14:47'
WHERE
	[ITRequestID] = @tID1
;

-- Set frequent reminder
UPDATE
	[ITR Request Reminders]
SET
	[Starting] = '2024-03-01 12:00',
	[Ending] = '2024-03-09 14:47',
	[Periodically] = 180
WHERE
	[ITRequestID] = @tID2
;

ROLLBACK;
COMMIT;