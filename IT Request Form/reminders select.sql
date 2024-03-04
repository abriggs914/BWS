USE BWSdb
GO

DECLARE @currID INT;
DECLARE @reminderExists BIT;
SELECT @currID = 1515;


SELECT
	*
FROM
	[ITR Request Reminders] [IR]
WHERE
	[IR].[ITRequestID] = @currID


SELECT
	@reminderExists = 1 
FROM 
	[ITR Request Reminders] [IR]
WHERE EXISTS(
	SELECT
		*
	FROM
		[ITR Request Reminders] [IR]
	WHERE
		[IR].[ITRequestID] = @currID
)

SELECT @reminderExists AS [RE]



DECLARE @periodicallyT TABLE (
	[RN] INT,
	[DebugCode] NVARCHAR(MAX),
	[StartDate] DATETIME,
	[EndDate] DATETIME,
	[MaxReminders] INT,
	[Periodically] INT,
	[PeriodCode] INT
)
INSERT INTO @periodicallyT ([DebugCode], [StartDate], [EndDate], [MaxReminders], [Periodically], [PeriodCode])
EXEC [sp_ITRRequestReminderCalcFreq]
;

UPDATE
	@periodicallyT 
SET
	[RN] = 0
;

SELECT * FROM @periodicallyT