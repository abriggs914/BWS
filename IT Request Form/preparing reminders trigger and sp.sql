USE [BWSdb]
GO

DECLARE @freqTable TABLE (
	[DebugCode] NVARCHAR(MAX)
	,[StartDate] DATETIME
	,[EndDate] DATETIME
	,[MaxReminders] INT
	,[Periodically] INT
	,[PeriodCode] INT
)
INSERT INTO @freqTable
EXEC [sp_ITRRequestReminderCalcFreq]
/*
SELECT
	*
FROM
	@freqTable
;
*/


INSERT INTO [dbo].[ITR Request Reminders]
           ([ITRequestID]
           ,[Starting]
           ,[Ending]
           ,[Periodically]
           ,[LastReminder]
           ,[NumRemindersSent])


