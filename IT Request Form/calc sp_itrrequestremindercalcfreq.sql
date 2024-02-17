USE BWSdb
GO

DECLARE @debugCode NVARCHAR(MAX) = '';

DECLARE @lastID INT = 2531;
DECLARE @startDate DATETIME = GETDATE();
DECLARE @endDate DATETIME = NULL;
DECLARE @maxReminders INT = NULL;
DECLARE @periodically INT = NULL;
DECLARE @periodCode INT = NULL;
DECLARE @maxPeriods INT = ROUND(60*60*24*365.25*4, 0);

DECLARE @startDateDEF DATETIME = GETDATE();
DECLARE @maxRemindersDEF INT = 3;
DECLARE @endDateDEF DATETIME = DATEADD(DAY, 2, GETDATE());
DECLARE @periodicallyDEF INT = 60*60*24;
DECLARE @periodCodeDEF INT = 3;

--SELECT @endDate = '2024-03-01'
--SELECT @periodically = 60*60*2
SELECT @periodically=60*5;
--SELECT @maxReminders=5;

SELECT
	'Pre' AS [Here]
	,@lastID AS [LastID]
	,@startDate AS [StartDate]
	,@endDate AS [EndDate]
	,@maxReminders AS [MaxReminders]
	,@periodically AS [Periodically]
	,@periodCode AS [PeriodCode]
;

DECLARE @impTable TABLE (
	[ID] INT IDENTITY(0, 1),
	[Code] INT,
	[PD] INT,
	[MR] INT
)
;
INSERT INTO @impTable ([Code], [PD], [MR]) VALUES
(0, 0, 0),
(1, 60*60*3, 16),
(2, 60*60*6, 8),
(3, 60*60*24, 1)
;

--Period Importance
-- NONE -- 0
-- HIGH -- 1  -- 1 reminder every 3 hours for 2 days maxreminders=16
-- MED -- 2  -- 1 reminder every 6 hours for 2 days maxreminders=8
-- LOW -- 3  -- 1 reminder next day maxreminders=1

-- Rules
-- If periodically is greater than 1 reminder per day, then fire the reminder for 3 days
-- default period is 1 reminder every 2 hours until complete for 2 days = 24 Reminders.

-- Sanitize @maxReminders
IF @maxReminders < 0 BEGIN
	SELECT 
		@maxReminders = @maxRemindersDEF
	;
END
-- Sanitize @periodically 4 years is too long
IF @periodically IS NOT NULL BEGIN
	IF (@periodically < 0) OR (@periodically > (@maxPeriods)) BEGIN
		SELECT 
			@periodically = @periodicallyDEF
		;
	END
END
-- Sanitize @startDate
SELECT 
	@startDate = ISNULL(@startDate, @startDateDEF)
;


IF @periodCode IS NULL BEGIN
	SELECT @debugCode = @debugCode + 'A'
	SELECT
		@periodCode = @periodCodeDEF
	;
	-- calculate the period
	IF @endDate IS NULL BEGIN
		SELECT @debugCode = @debugCode + 'B'
		IF @periodically IS NULL BEGIN
			-- No end date, no period, or periodCode, use default values for low importance
			SELECT
				@debugCode = @debugCode + 'C',
				@endDate = @endDateDEF,
				@periodically = @periodicallyDEF,
				@maxReminders = @maxRemindersDEF
			;
		END
		ELSE BEGIN
			SELECT @debugCode = @debugCode + 'D'
			-- check if periodically is greater than 1 reminder per day. 
			IF @periodically > @periodicallyDEF BEGIN
				-- if yes then send the notification maxRemindersDEF times at the period
				SELECT
					@debugCode = @debugCode + 'E',
					@endDate = DATEADD(SECOND, @periodically * ISNULL(@maxReminders, @maxRemindersDEF), @startDate),
					@maxReminders = ISNULL(@maxReminders, @maxRemindersDEF)
				;
			END
			ELSE BEGIN
				-- else send reminder for @maxRemindersDEF days at period
				SELECT
					@debugCode = @debugCode + 'F',
					@endDate = DATEADD(DAY, ISNULL(@maxReminders, @maxRemindersDEF), @startDate),
					@maxReminders = ROUND(DATEDIFF(SECOND, @startDate, DATEADD(DAY, ISNULL(@maxReminders, @maxRemindersDEF), @startDate)) / @periodically, 0)
				;
			END
		END
	END
	ELSE BEGIN
		SELECT @debugCode = @debugCode + 'G'
		-- End date specified
		IF @periodically IS NULL BEGIN
			-- No period, or periodCode, use default values for low importance, ending at given end date
			SELECT
				@debugCode = @debugCode + 'H'
				,@periodically = @periodicallyDEF
				,@maxReminders = ISNULL(@maxReminders, DATEDIFF(SECOND, @startDate, @endDate) / @periodicallyDEF)
			;
		END
		ELSE BEGIN
			-- periodically and enddate given, calculate maxReminders
			SELECT
				@debugCode = @debugCode + 'I'
				,@maxReminders = ISNULL(@maxReminders, ROUND(DATEDIFF(SECOND, @startDate, @endDate) / @periodically, 0))
		END
	END
END
ELSE BEGIN
	SELECT
		@startDate = ISNULL(ISNULL(@startDate, GETDATE()), @startDateDEF),
		@endDate = ISNULL(@endDate, DATEADD(SECOND, [MaxReminders] * [Period], GETDATE())),
		@periodically = ISNULL(@periodically, [Period]),
		@maxReminders = ISNULL(@maxReminders, [MaxReminders])
	FROM
		--@impTable [I]
		[ITR Request Reminder Importance Codes] [I]
	WHERE
		[I].[ID] = @periodCode
	;
END

/*
IF @endDate IS NULL BEGIN
	
END
ELSE BEGIN

END
*/


SELECT
	*
FROM
	[ITR Request Reminders]
;


SELECT TOP 5
	*
FROM
	[IT Requests]
ORDER BY
	[RequestDateOriginal] DESC
;




/*
INSERT INTO [ITR Request Reminders] 
	(
		[ITRequestID],
		[Starting],
		[Ending],
		[Periodically]
	)
	SELECT
		@lastID,
		@startDate,
		@endDate,
		@periodically
*/

SELECT
	'Post' AS [Here]
	,@debugCode AS [DebugCode]
	,@lastID AS [LastID]
	,@startDate AS [StartDate]
	,@endDate AS [EndDate]
	,@maxReminders AS [MaxReminders]
	,@periodically AS [Periodically]
	,@periodCode AS [PeriodCode]
;

SELECT
	[ID]
      ,[DateCreated]
      ,[Active]
      ,[DateActive]
      ,[DateInactive]
      ,[Code]
      ,[Period]
      ,[MaxReminders]
      ,[StartOfDayHour]
      ,[StartOfDayMinute]
      ,[EndOfDayHour]
      ,[EndOfDayMinute]
FROM
	[ITR Request Reminder Importance Codes]