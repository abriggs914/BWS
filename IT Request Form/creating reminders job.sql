USE BWSdb
GO


DECLARE @RemindITOnly BIT = 1;
DECLARE @currID INT;
DECLARE @reminderExists BIT;
SELECT @currID = -1;

-- Table of output for SP Coloured Request
DECLARE @tblReqEmail TABLE (
	[ColourOldStatus] NVARCHAR(MAX),
	[ColourNewStatus] NVARCHAR(MAX),
	[Persons] NVARCHAR(MAX),
	[Body] NVARCHAR(MAX),
	[Subject] NVARCHAR(MAX)
)
;

--SELECT
--	*
--FROM
--	[ITR Request Reminders] [IR]
--;

-- Loop variables
DECLARE @i INT;
DECLARE @c INT;

-- Known variables
DECLARE @endDate DATETIME;
DECLARE @startDate DATETIME;
DECLARE @lastDate DATETIME;
DECLARE @nextDate DATETIME;
DECLARE @NumRemindersSent INT;
DECLARE @periodically INT;
DECLARE @reqStatus NVARCHAR(MAX)

-- Email variables
DECLARE @body NVARCHAR(MAX) = '';
DECLARE @currIDS NVARCHAR(MAX) = '';
DECLARE @persons AS NVARCHAR(MAX);
DECLARE @subject AS NVARCHAR(MAX);
DECLARE @sentReqNum NVARCHAR(MAX) = '';
DECLARE @needToRemind INT = 0;
DECLARE @nextDateFMT NVARCHAR(MAX) = '';
DECLARE @nextTimeFMT NVARCHAR(MAX) = '';
DECLARE @nextDateFMTS NVARCHAR(MAX) = '';
			
DECLARE @itPersonEmail NVARCHAR(MAX);
DECLARE @itFollowUpEmail NVARCHAR(MAX);
DECLARE @itEmails NVARCHAR(MAX);
DECLARE @ttlRemindersToSend INT = 0;
DECLARE @ttlRemindersToSendS NVARCHAR(MAX) = '';

-- Table for the results of calculating the reminder frequency
DECLARE @periodicallyT TABLE (
	[RN] INT,
	[DebugCode] NVARCHAR(MAX),
	[StartDate] DATETIME,
	[EndDate] DATETIME,
	[MaxReminders] INT,
	[Periodically] INT,
	[PeriodCode] INT
)

-- Table for row numbered reminders
DECLARE @tbl TABLE (
	[ID] INT IDENTITY(0, 1),
	[RN] INT,
	[ITID] INT
)
;

-- Populate Row Number table
INSERT INTO @tbl (
	[RN],
	[ITID]
)
SELECT
	ROW_NUMBER() OVER(
		ORDER BY
			[IR].[ITRequestID]
	) AS [RN],
	[IR].[ITRequestID]
FROM
	[ITR Request Reminders] [IR]
;

-- Pre while loop setup
SELECT
	@i = 1,
	@c = COUNT(*)
FROM
	[ITR Request Reminders]
;

-- Loop all reminders and decide if a new one needs sent or not
WHILE @i <= @c BEGIN

	-- Set current IT Request ID
	SELECT 
		@currID = [ITID]
	FROM
		@tbl [T]
	WHERE
		[RN] = @i
	;

	-- Set reminder known values
	SELECT 
		@startDate = [Starting]
		,@endDate = [Ending]
		,@lastDate = [LastReminder]
		,@NumRemindersSent = [NumRemindersSent]
		,@periodically = [Periodically]
	FROM
		[ITR Request Reminders] [IR]
	WHERE
		[IR].[ITRequestID] = @currID
	;

	-- Correct Null values
	IF @startDate IS NULL BEGIN
		UPDATE
			[ITR Request Reminders]
		SET
			[Starting] = GETDATE()
		WHERE
			[ITRequestID] = @currID
	END
	IF @NumRemindersSent IS NULL BEGIN
		UPDATE
			[ITR Request Reminders]
		SET
			[NumRemindersSent] = 0
		WHERE
			[ITRequestID] = @currID
		;
	END
	IF (@periodically IS NULL) OR (@endDate IS NULL) BEGIN
		
		-- Purge records, then re-insert current values
		DELETE FROM @periodicallyT;
		INSERT INTO @periodicallyT (
			[DebugCode],
			[StartDate],
			[EndDate],
			[MaxReminders],
			[Periodically],
			[PeriodCode]
		)
		EXEC [sp_ITRRequestReminderCalcFreq]
		;

		UPDATE
			@periodicallyT 
		SET
			[RN] = 1
		;

		-- Get the new calculated values
		SELECT 
			@endDate = [EndDate]
			,@periodically = [Periodically]
		FROM
			@periodicallyT [P]
		WHERE
			[P].[RN] = 1
		;

		-- Remove the NULL values and replace them with the new calculated values
		UPDATE
			[ITR Request Reminders]
		SET
			[Periodically] = @periodically,
			[Ending] = @endDate
			--,
			--[NumRemindersSent] = ISNULL(@NumRemindersSent, 0) + 1
		WHERE
			[ITRequestID] = @currID
		;

	END

	-- calculate the nextDate
	IF @lastDate IS NULL BEGIN
		SELECT
			@lastDate = DATEADD(SECOND, -@periodically, GETDATE()),
			@nextDate = GETDATE()
		;
	END
	ELSE BEGIN
		SELECT
			@nextDate = DATEADD(SECOND, @periodically, @lastDate)
		;
	END

	-- Set @needToRemind
	SELECT
		@needToRemind = (
			CASE
				WHEN GETDATE() > @endDate THEN -1		-- Too old after -> NO
				WHEN @startDate > GETDATE() THEN -2		-- Too soon before -> NO
				WHEN @lastDate IS NULL THEN 1			-- Never before -> YES
				WHEN @nextDate <= GETDATE() THEN 2		-- Time for another -> YES
				ELSE -3									-- Too soon since last
			END
		)

	-- Set num reminders sent
	SELECT 
		@NumRemindersSent = (
			CASE WHEN [NumRemindersSent] IS NULL THEN (CASE WHEN @needToRemind < 0 THEN 0 ELSE 1 END)
			ELSE [NumRemindersSent] + (CASE WHEN @needToRemind < 0 THEN 0 ELSE 1 END)
		END)
	FROM
		[ITR Request Reminders]
	WHERE
		[ITRequestID] = @currID
	;

	SELECT
		@sentReqNum = CAST(ISNULL(@NumRemindersSent, (CASE WHEN @needToRemind < 0 THEN 0 ELSE 1 END)) AS NVARCHAR(MAX))
	;


	IF @needToRemind > 0 BEGIN
	
		-- Get status
		SELECT 
			@reqStatus = [Status]
		FROM
			[IT Requests]
		WHERE
			[ITRequestID#] = @currID
		;

		-- purge request colour data and re-insert current values
		DELETE FROM @tblReqEmail;
		INSERT INTO @tblReqEmail 
		EXEC [sp_ITRSendEmailUpdatedITRequestColoured] 
			@reqID=@currID,
			@oldStatus=@reqStatus,
			@newStatus=@reqStatus,
			@force=1,
			@didUpdate=0,
			@tableOnly=1,
			@doSend=0
		;
		
		-- Update the reminder
		UPDATE
			[ITR Request Reminders]
		SET
			[NumRemindersSent] = [NumRemindersSent] + 1,
			[LastReminder] = GETDATE()
		WHERE
			[ITRequestID] = @currID
		;

		-- Choose recipients
		IF @RemindITOnly = 0 BEGIN
			-- notify IT personnel and the requester.
			SELECT
				@itEmails = COALESCE(@itEmails + ';', '') + [Email]
			FROM (

				SELECT DISTINCT
					--[R].[ITRequestID#]
					--,[RequestFollowUpPersonnel]
					--,[R].[ITPersonAssignedID]
					--,
					--'FUP'
					--,
					[C].[Email]
				FROM
					[IT Requests] [R]
				INNER JOIN
					[ITR Customers] [C]
				ON
					LOWER([R].[RequestFollowUpPersonnel]) LIKE '%' + LOWER([C].[Email]) + '%'
				INNER JOIN
					[IT Personnel] [P]
				ON
					[R].[ITPersonAssignedID] = [P].[ITPersonID#]
				WHERE
					[R].[ITRequestID#] = @currID
					AND (LEN([C].[Email]) > 0)
				UNION
					SELECT DISTINCT
						[Email]
					FROM
						[IT Requests] [R]
					INNER JOIN
						[IT Personnel] [P]
					ON
						[R].[ITPersonAssignedID] = [P].[ITPersonID#]
					INNER JOIN
						[ITR Customers] [C]
					ON
						[P].[ITRCustomerID] = [C].[CustomerID]
					WHERE
						[R].[ITRequestID#] = @currID
			) AS [Src]
		END
		ELSE BEGIN
			-- Notify the IT personnel only
			SELECT
				@itEmails = COALESCE(@itEmails + ';', '') + [Email]
			FROM (
				SELECT DISTINCT
					[Email]
				FROM
					[IT Requests] [R]
				INNER JOIN
					[IT Personnel] [P]
				ON
					[R].[ITPersonAssignedID] = [P].[ITPersonID#]
				INNER JOIN
					[ITR Customers] [C]
				ON
					[P].[ITRCustomerID] = [C].[CustomerID]
				WHERE
					[R].[ITRequestID#] = @currID
			) AS [Src]
		END

		-- Sanitize itEmails
		IF LEN(LTRIM(RTRIM(ISNULL(@itEmails, '')))) = 0 BEGIN 
			SELECT
				@itEmails = 'it@bwstrailers.com'
			;
		END

		-- Calculate the total number of reminders left to send
		SELECT
			--@ttlRemindersToSend = FLOOR((DATEDIFF(SECOND, @startDate, @endDate) + 1.0) / @periodically)
			@ttlRemindersToSend = FLOOR((DATEDIFF(SECOND, GETDATE(), @endDate) + 1.0) / @periodically)
		;

		
		-- String conversions
		SELECT
			@ttlRemindersToSendS = CAST(ISNULL(@ttlRemindersToSend, -1) AS NVARCHAR(MAX)),
			@currIDS = CAST(@currID AS NVARCHAR(MAX))
		;
	
		SELECT @nextDateFMT = '';
		SELECT @nextTimeFMT = '';
		SELECT @persons = 'avery.briggs@bwstrailers.com'; -- Avery
		SELECT @persons = @persons + ';' + @itEmails; -- Avery
		SELECT @subject = 'IT Request Reminder';

		-- Build body
		SELECT @body = '<!DOCTYPE html><html><head><title>IT Request Reminder</title></head><body>';
		SELECT @body = @body + '<h1>IT request #' + ISNULL(@currIDS, 'NULL?') + '</h1>';
		SELECT @body = @body + '<h2>Request Reminder ' + ISNULL(@sentReqNum, 'NULL?') + ' / ' + ISNULL(@ttlRemindersToSendS, 'NULL?') + '</h2>';
		
		-- Add SP Table of colour-coded request status
		SELECT
			@body = @body + [Body]
		FROM
			@tblReqEmail
		;

		-- Set Next reminder date format
		SELECT
			@nextDateFMT = LEFT(DATENAME(WEEKDAY, @nextDate), 3) + (CASE WHEN LEN(LEFT(DATENAME(WEEKDAY, @nextDate), 3)) = LEN(DATENAME(WEEKDAY, @nextDate)) THEN '' ELSE '.' END) + ' ' + DATENAME(MONTH, @nextDate) + ' ' + DATENAME(DAY, @nextDate) + (
		CASE WHEN
			RIGHT(DATENAME(DAY, @nextDate), 1) = '1' THEN
				(CASE WHEN
					LEFT(RIGHT('00' + DATENAME(DAY, @nextDate), 2), 1) = '1' THEN
						'th' 
					ELSE
						'st'
				END)
			WHEN 
				RIGHT(DATENAME(DAY, @nextDate), 1) = '2' THEN
				(CASE WHEN
					LEFT(RIGHT('00' + DATENAME(DAY, @nextDate), 2), 1) = '1' THEN
						'th' 
					ELSE
						'nd'
				END)
			WHEN 
				RIGHT(DATENAME(DAY, @nextDate), 1) = '3' THEN
				(CASE WHEN
					LEFT(RIGHT('00' + DATENAME(DAY, @nextDate), 2), 1) = '1' THEN
						'th' 
					ELSE
						'rd'
				END)
			ELSE 'th' 
		END) + ' ' + DATENAME(YEAR, @nextDate);
		
		-- Set next reminder time format
		SET @nextTimeFMT = (CASE
							WHEN DATENAME(HOUR, @nextDate) = '0' THEN '12'
							WHEN DATENAME(HOUR, @nextDate) > 12 THEN CAST(DATENAME(HOUR, @nextDate) - 12 AS NVARCHAR(2))
							ELSE DATENAME(HOUR, @nextDate) END) + ':' + RIGHT('00' + DATENAME(MINUTE, @nextDate), 2) + ' ' + 
							(CASE WHEN DATEPART(HOUR, @nextDate) > 11 THEN 'PM' ELSE 'AM' END)

		-- Concatenate the date FMT and Time FMT
		SELECT
			@nextDateFMTS = @nextDateFMT + ' ' + @nextTimeFMT

		-- Add next reminder time to body
		SELECT @body = @body + '<h4>Next reminder ' + @nextDateFMTS + '</hr>'
		SELECT @body = @body + '</body></html>'

		-- Send Email
		EXEC msdb.dbo.sp_send_dbmail 
			@recipients = @persons,
			@profile_name = 'SQL Agent',
			@subject = @subject, 
			@body = @body,
			@body_format='HTML'
			;

	END

	---- Report the results
	--SELECT 
	--	@currIDS AS [@CurrIDS],
	--	@needToRemind AS [@needToRemind],
	--	@lastDate AS [@lastDate],
	--	@nextDate AS [@nextDate],
	--	@startDate AS [@startDate],
	--	@endDate AS [@endDate],
	--	@itEmails AS [Emails],
	--	@body AS [Body],
	--	@subject AS [Sub],
	--	@NumRemindersSent AS [@NumRemindersSent],
	--	@sentReqNum AS [@sentReqNum],
	--	@i AS [@i],
	--	@c AS [@c]

	-- Increment row number
	SELECT 
		@i = @i + 1
	;

END
