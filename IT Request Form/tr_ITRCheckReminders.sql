USE [BWSdb]
GO
/****** Object:  Trigger [dbo].[tr_UpdateHistory]    Script Date: 2024-02-29 12:26:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Trigger to check requests to see if they are new.


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[tr_ITRCheckReminders] 
   ON  [dbo].[IT Requests]
   
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF TRIGGER_NESTLEVEL() < 2 BEGIN
	
		DECLARE @user NVARCHAR(20);
		DECLARE @activity NVARCHAR(20);

		--DECLARE @t_to_update AS TABLE 
		--(
		--	[ID] INT IDENTITY(1, 1),
		--	[column] NVARCHAR(255),
		--	[value_before] NVARCHAR(MAX),
		--	[value_after] NVARCHAR(MAX)
		--);

		DECLARE @periodicallyT TABLE (
			[RN] INT,
			[DebugCode] NVARCHAR(MAX),
			[StartDate] DATETIME,
			[EndDate] DATETIME,
			[MaxReminders] INT,
			[Periodically] INT,
			[PeriodCode] INT
		)
		INSERT INTO @periodicallyT
		EXEC [sp_ITRRequestReminderCalcFreq]
		;

		UPDATE
			@periodicallyT 
		SET
			[RN] = 0
		;

		-- Is New:
		-- seenByIT
		--		False:
		--			request date og is less than 2 days old
		--			True:
		--				=> True
		--			False:
		--				=> False
		--		True:
		--			=> False

		-- reminderExists:
		-- check if request is already in the reminders table

		DECLARE @currID INT;
		DECLARE @ttl INT;
		DECLARE @i INT;
		DECLARE @c INT;

		DECLARE @isNew BIT;
		DECLARE @reminderExists BIT;
		DECLARE @endDate DATETIME;
		DECLARE @periodically INT;
		
		SELECT
			@isNew = 0,
			@c = COUNT(*)
		FROM 
			INSERTED [I]
		;

		DECLARE @tbl TABLE (
			[ID] INT IDENTITY(0, 1),
			[RN] INT,
			[ITID] INT
		)
		;

		INSERT INTO @tbl (
			[RN],
			[ITID]
		)
		SELECT
			ROW_NUMBER() OVER(
				ORDER BY
					[I].[ITRequestID#]
			) AS [RN],
			[I].[ITRequestID#]
		FROM
			INSERTED [I]
		;

		WHILE @i < @c BEGIN

			SELECT 
				@currID = [ITID]
			FROM
				@tbl [T]
			WHERE
				[RN] = @i
			;

			SELECT 
				@isNew = (
					CASE 
						WHEN ISNULL([I].[SeenByIT], 0) = 1 THEN
							0
						WHEN ABS(DATEDIFF(SECOND, ISNULL([I].[RequestDateOriginal], GETDATE()), GETDATE())) < (60*60*24) THEN 
							1
						ELSE 
							0
					END
				) 
			FROM
				INSERTED [I]
			WHERE
				[I].[ITRequestID#] = @currID
			;

			IF @isNew = 1 BEGIN
				-- Check if reminder exists

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
				;

				IF ISNULL(@reminderExists, 0) = 0 BEGIN
					-- Create a reminder
					INSERT INTO	[ITR Request Reminders]
						([ITRequestID], [Starting], [Ending], [Periodically])
					VALUES
						(@currID, GETDATE(), @endDate, @periodically)
					;
				END
				;
			END

			SELECT 
				@i = @i + 1
			;

		END
		
--		-- Inserted values
--		DECLARE @it_i_ITRequestID AS INT;
--		DECLARE @it_i_RequestDate AS DATETIME;
--		DECLARE @it_i_StartDate AS DATETIME;
--		DECLARE @it_i_DueDate AS DATETIME;
--		DECLARE @it_i_Request AS NVARCHAR(MAX);
--		DECLARE @it_i_Priority AS INT;
--		DECLARE @it_i_SubPriority AS INT;
--		DECLARE @it_i_RequestedBy AS NVARCHAR(255);
--		DECLARE @it_i_Department AS INT;
--		DECLARE @it_i_RequestFollowUpPerson AS NVARCHAR(MAX);
--		DECLARE @it_i_RequestType AS NVARCHAR(255);
--		DECLARE @it_i_RequestSubType AS NVARCHAR(255);
--		DECLARE @it_i_Comments AS NVARCHAR(MAX);
--		DECLARE @it_i_Company AS NVARCHAR(255);
--		DECLARE @it_i_Status AS NVARCHAR(255);
--		DECLARE @it_i_Directory AS NVARCHAR(MAX);
--		DECLARE @it_i_ITPersonAssignedID AS INT;
--		DECLARE @it_i_CompletionDate AS DATETIME;
--		DECLARE @it_i_LastStatusUpdate AS DATETIME;
--		DECLARE @it_i_LabourEstimate AS FLOAT;
--		DECLARE @it_i_LabourActual AS FLOAT;
--		DECLARE @it_i_TimerStart AS DATETIME;
--		DECLARE @it_i_TimerStop AS DATETIME;
--		DECLARE @it_i_Timer AS BIGINT;
--		DECLARE @it_i_OpenCounter AS INT;
--		DECLARE @it_i_IsOpened AS BIT;
--		DECLARE @it_i_RequestDateOriginal AS DATETIME;
--		DECLARE @it_i_LinkNext AS INT;
--		DECLARE @it_i_LinkPrev AS INT;
--		DECLARE @it_i_RequesterLocked AS BIT;
--		DECLARE @it_i_RequesterLockedDate AS DATETIME;
--		DECLARE @it_i_AssignedEmailDate AS DATETIME;
		
--		-- Deleted values
--		DECLARE @it_d_ITRequestID AS INT;
--		DECLARE @it_d_RequestDate AS DATETIME;
--		DECLARE @it_d_StartDate AS DATETIME;
--		DECLARE @it_d_DueDate AS DATETIME;
--		DECLARE @it_d_Request AS NVARCHAR(MAX);
--		DECLARE @it_d_Priority AS INT;
--		DECLARE @it_d_SubPriority AS INT;
--		DECLARE @it_d_RequestedBy AS NVARCHAR(255);
--		DECLARE @it_d_Department AS INT;
--		DECLARE @it_d_RequestFollowUpPerson AS NVARCHAR(MAX);
--		DECLARE @it_d_RequestType AS NVARCHAR(255);
--		DECLARE @it_d_RequestSubType AS NVARCHAR(255);
--		DECLARE @it_d_Comments AS NVARCHAR(MAX);
--		DECLARE @it_d_Company AS NVARCHAR(255);
--		DECLARE @it_d_Status AS NVARCHAR(255);
--		DECLARE @it_d_Directory AS NVARCHAR(MAX);
--		DECLARE @it_d_ITPersonAssignedID AS INT;
--		DECLARE @it_d_CompletionDate AS DATETIME;
--		DECLARE @it_d_LastStatusUpdate AS DATETIME;
--		DECLARE @it_d_LabourEstimate AS FLOAT;
--		DECLARE @it_d_LabourActual AS FLOAT;
--		DECLARE @it_d_TimerStart AS DATETIME;
--		DECLARE @it_d_TimerStop AS DATETIME;
--		DECLARE @it_d_Timer AS BIGINT;
--		DECLARE @it_d_OpenCounter AS INT;
--		DECLARE @it_d_IsOpened AS BIT;
--		DECLARE @it_d_RequestDateOriginal AS DATETIME;
--		DECLARE @it_d_LinkNext AS INT;
--		DECLARE @it_d_LinkPrev AS INT;
--		DECLARE @it_d_RequesterLocked AS BIT;
--		DECLARE @it_d_RequesterLockedDate AS DATETIME;
--		DECLARE @it_d_AssignedEmailDate AS DATETIME;
		
--		-- String values before
--		DECLARE @it_sb_ITRequestID AS NVARCHAR(MAX);
--		DECLARE @it_sb_RequestDate AS NVARCHAR(MAX);
--		DECLARE @it_sb_StartDate AS NVARCHAR(MAX);
--		DECLARE @it_sb_DueDate AS NVARCHAR(MAX);
--		DECLARE @it_sb_Request AS NVARCHAR(MAX);
--		DECLARE @it_sb_Priority AS NVARCHAR(MAX);
--		DECLARE @it_sb_SubPriority AS NVARCHAR(MAX);
--		DECLARE @it_sb_RequestedBy AS NVARCHAR(MAX);
--		DECLARE @it_sb_Department AS NVARCHAR(MAX);
--		DECLARE @it_sb_RequestFollowUpPerson AS NVARCHAR(MAX);
--		DECLARE @it_sb_RequestType AS NVARCHAR(MAX);
--		DECLARE @it_sb_RequestSubType AS NVARCHAR(MAX);
--		DECLARE @it_sb_Comments AS NVARCHAR(MAX);
--		DECLARE @it_sb_Company AS NVARCHAR(MAX);
--		DECLARE @it_sb_Status AS NVARCHAR(MAX);
--		DECLARE @it_sb_Directory AS NVARCHAR(MAX);
--		DECLARE @it_sb_ITPersonAssignedID AS NVARCHAR(MAX);
--		DECLARE @it_sb_CompletionDate AS NVARCHAR(MAX);
--		DECLARE @it_sb_LastStatusUpdate AS NVARCHAR(MAX);
--		DECLARE @it_sb_LabourEstimate AS NVARCHAR(MAX);
--		DECLARE @it_sb_LabourActual AS NVARCHAR(MAX);
--		DECLARE @it_sb_TimerStart AS NVARCHAR(MAX);
--		DECLARE @it_sb_TimerStop AS NVARCHAR(MAX);
--		DECLARE @it_sb_Timer AS NVARCHAR(MAX);
--		DECLARE @it_sb_OpenCounter AS NVARCHAR(MAX);
--		DECLARE @it_sb_IsOpened AS NVARCHAR(MAX);
--		DECLARE @it_sb_RequestDateOriginal AS NVARCHAR(MAX);
--		DECLARE @it_sb_LinkNext AS NVARCHAR(MAX);
--		DECLARE @it_sb_LinkPrev AS NVARCHAR(MAX);
--		DECLARE @it_sb_RequesterLocked AS NVARCHAR(MAX);
--		DECLARE @it_sb_RequesterLockedDate AS NVARCHAR(MAX);
--		DECLARE @it_sb_AssignedEmailDate AS NVARCHAR(MAX);
		
--		-- String values After
--		DECLARE @it_sa_ITRequestID AS NVARCHAR(MAX);
--		DECLARE @it_sa_RequestDate AS NVARCHAR(MAX);
--		DECLARE @it_sa_StartDate AS NVARCHAR(MAX);
--		DECLARE @it_sa_DueDate AS NVARCHAR(MAX);
--		DECLARE @it_sa_Request AS NVARCHAR(MAX);
--		DECLARE @it_sa_Priority AS NVARCHAR(MAX);
--		DECLARE @it_sa_SubPriority AS NVARCHAR(MAX);
--		DECLARE @it_sa_RequestedBy AS NVARCHAR(MAX);
--		DECLARE @it_sa_Department AS NVARCHAR(MAX);
--		DECLARE @it_sa_RequestFollowUpPerson AS NVARCHAR(MAX);
--		DECLARE @it_sa_RequestType AS NVARCHAR(MAX);
--		DECLARE @it_sa_RequestSubType AS NVARCHAR(MAX);
--		DECLARE @it_sa_Comments AS NVARCHAR(MAX);
--		DECLARE @it_sa_Company AS NVARCHAR(MAX);
--		DECLARE @it_sa_Status AS NVARCHAR(MAX);
--		DECLARE @it_sa_Directory AS NVARCHAR(MAX);
--		DECLARE @it_sa_ITPersonAssignedID AS NVARCHAR(MAX);
--		DECLARE @it_sa_CompletionDate AS NVARCHAR(MAX);
--		DECLARE @it_sa_LastStatusUpdate AS NVARCHAR(MAX);
--		DECLARE @it_sa_LabourEstimate AS NVARCHAR(MAX);
--		DECLARE @it_sa_LabourActual AS NVARCHAR(MAX);
--		DECLARE @it_sa_TimerStart AS NVARCHAR(MAX);
--		DECLARE @it_sa_TimerStop AS NVARCHAR(MAX);
--		DECLARE @it_sa_Timer AS NVARCHAR(MAX);
--		DECLARE @it_sa_OpenCounter AS NVARCHAR(MAX);
--		DECLARE @it_sa_IsOpened AS NVARCHAR(MAX);
--		DECLARE @it_sa_RequestDateOriginal AS NVARCHAR(MAX);
--		DECLARE @it_sa_LinkNext AS NVARCHAR(MAX);
--		DECLARE @it_sa_LinkPrev AS NVARCHAR(MAX);
--		DECLARE @it_sa_RequesterLocked AS NVARCHAR(MAX);
--		DECLARE @it_sa_RequesterLockedDate AS NVARCHAR(MAX);
--		DECLARE @it_sa_AssignedEmailDate AS NVARCHAR(MAX);

--		-- Insert statements for trigger here
--		IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) BEGIN
--			SET @activity = 'UPDATE';
--			--SET @user = SYSTEM_USER;
		
--			-- Capture inserted values
--			SELECT
--				@it_i_ITRequestID = i.[ITRequestID#]
--				,@it_i_RequestDate = i.[RequestDate]
--				,@it_i_StartDate = i.[StartDate]
--				,@it_i_DueDate = i.[DueDate]
--				,@it_i_Request = i.[Request]
--				,@it_i_Priority = i.[Priority]
--				,@it_i_SubPriority = i.[SubPriority]
--				,@it_i_RequestedBy = i.[RequestedBy]
--				,@it_i_Department = i.[Department]
--				,@it_i_RequestFollowUpPerson = i.[RequestFollowUpPersonnel]
--				,@it_i_RequestType = i.[RequestType]
--				,@it_i_RequestSubType = i.[RequestSubType]
--				,@it_i_Comments = i.[Comments]
--				,@it_i_Company = i.[Company]
--				,@it_i_Status = i.[Status]
--				,@it_i_Directory = i.[Directory]
--				,@it_i_ITPersonAssignedID = i.[ITPersonAssignedID]
--				,@it_i_CompletionDate = i.[CompletionDate]
--				,@it_i_LastStatusUpdate = i.[LastStatusUpdate]
--				,@it_i_LabourEstimate = i.[LabourEstimate]
--				,@it_i_LabourActual = i.[LabourActual]
--				,@it_i_TimerStart = i.[TimerStart]
--				,@it_i_TimerStop = i.[TimerStop]
--				,@it_i_Timer = i.[Timer]
--				,@it_i_OpenCounter = i.[OpenCounter]
--				,@it_i_IsOpened = i.[IsOpened]
--				,@it_i_RequestDateOriginal = i.[RequestDateOriginal]
--				,@it_i_LinkNext = i.[LinkNext]
--				,@it_i_LinkPrev = i.[LinkPrev]
--				,@it_i_RequesterLocked = i.[RequesterLocked]
--				,@it_i_RequesterLockedDate = i.[RequesterLockedDate]
--				,@it_i_AssignedEmailDate = i.[AssignmentEmailDate]
--				,@user = i.[LastStatusUpdater]
--			FROM
--				inserted i
--			;
		
--			-- Capture deleted values
--			SELECT
--				@it_d_ITRequestID = d.[ITRequestID#]
--				,@it_d_RequestDate = d.[RequestDate]
--				,@it_d_StartDate = d.[StartDate]
--				,@it_d_DueDate = d.[DueDate]
--				,@it_d_Request = d.[Request]
--				,@it_d_Priority = d.[Priority]
--				,@it_d_SubPriority = d.[SubPriority]
--				,@it_d_RequestedBy = d.[RequestedBy]
--				,@it_d_Department = d.[Department]
--				,@it_d_RequestFollowUpPerson = d.[RequestFollowUpPersonnel]
--				,@it_d_RequestType = d.[RequestType]
--				,@it_d_RequestSubType = d.[RequestSubType]
--				,@it_d_Comments = d.[Comments]
--				,@it_d_Company = d.[Company]
--				,@it_d_Status = d.[Status]
--				,@it_d_Directory = d.[Directory]
--				,@it_d_ITPersonAssignedID = d.[ITPersonAssignedID]
--				,@it_d_CompletionDate = d.[CompletionDate]
--				,@it_d_LastStatusUpdate = d.[LastStatusUpdate]
--				,@it_d_LabourEstimate = d.[LabourEstimate]
--				,@it_d_LabourActual = d.[LabourActual]
--				,@it_d_TimerStart = d.[TimerStart]
--				,@it_d_TimerStop = d.[TimerStop]
--				,@it_d_Timer = d.[Timer]
--				,@it_d_OpenCounter = d.[OpenCounter]
--				,@it_d_IsOpened = d.[IsOpened]
--				,@it_d_RequestDateOriginal = d.[RequestDateOriginal]
--				,@it_d_LinkNext = d.[LinkNext]
--				,@it_d_LinkPrev = d.[LinkPrev]
--				,@it_d_RequesterLocked = d.[RequesterLocked]
--				,@it_d_RequesterLockedDate = d.[RequesterLockedDate]
--				,@it_d_AssignedEmailDate = d.[AssignmentEmailDate]
--			FROM
--				deleted d
--			;
			
--			-- Cast deleted values as before strings
--			SELECT 
--				@it_sb_ITRequestID =				CAST(@it_d_ITRequestID AS NVARCHAR(MAX))
--				,@it_sb_RequestDate =				CAST(@it_d_RequestDate AS NVARCHAR(MAX))
--				,@it_sb_StartDate =					CAST(@it_d_StartDate AS NVARCHAR(MAX))
--				,@it_sb_DueDate =					CAST(@it_d_DueDate AS NVARCHAR(MAX))
--				,@it_sb_Request =					CAST(@it_d_Request AS NVARCHAR(MAX))
--				,@it_sb_Priority =					CAST(@it_d_Priority AS NVARCHAR(MAX))
--				,@it_sb_SubPriority =				CAST(@it_d_SubPriority AS NVARCHAR(MAX))
--				,@it_sb_RequestedBy =				CAST(@it_d_RequestedBy AS NVARCHAR(MAX))
--				,@it_sb_Department =				CAST(@it_d_Department AS NVARCHAR(MAX))
--				,@it_sb_RequestFollowUpPerson =		CAST(@it_d_RequestFollowUpPerson AS NVARCHAR(MAX))
--				,@it_sb_RequestType =				CAST(@it_d_RequestType AS NVARCHAR(MAX))
--				,@it_sb_RequestSubType =			CAST(@it_d_RequestSubType AS NVARCHAR(MAX))
--				,@it_sb_Comments =					CAST(@it_d_Comments AS NVARCHAR(MAX))
--				,@it_sb_Company =					CAST(@it_d_Company AS NVARCHAR(MAX))
--				,@it_sb_Status =					CAST(@it_d_Status AS NVARCHAR(MAX))
--				,@it_sb_Directory =					CAST(@it_d_Directory AS NVARCHAR(MAX))
--				,@it_sb_ITPersonAssignedID =		CAST(@it_d_ITPersonAssignedID AS NVARCHAR(MAX))
--				,@it_sb_CompletionDate =			CAST(@it_d_CompletionDate AS NVARCHAR(MAX))
--				,@it_sb_LastStatusUpdate =			CAST(@it_d_LastStatusUpdate AS NVARCHAR(MAX))
--				,@it_sb_LabourEstimate =			CAST(@it_d_LabourEstimate AS NVARCHAR(MAX))
--				,@it_sb_LabourActual =				CAST(@it_d_LabourActual AS NVARCHAR(MAX))
--				,@it_sb_TimerStart =				CAST(@it_d_TimerStart AS NVARCHAR(MAX))
--				,@it_sb_TimerStop =					CAST(@it_d_TimerStop AS NVARCHAR(MAX))
--				,@it_sb_Timer =						CAST(@it_d_Timer AS NVARCHAR(MAX))
--				,@it_sb_OpenCounter =				CAST(@it_d_OpenCounter AS NVARCHAR(MAX))
--				,@it_sb_IsOpened =					CAST(@it_d_IsOpened AS NVARCHAR(MAX))
--				,@it_sb_RequestDateOriginal =		CAST(@it_d_RequestDateOriginal AS NVARCHAR(MAX))
--				,@it_sb_LinkNext =					CAST(@it_d_LinkNext AS NVARCHAR(MAX))
--				,@it_sb_LinkPrev =					CAST(@it_d_LinkPrev AS NVARCHAR(MAX))
--				,@it_sb_RequesterLocked =			CAST(@it_d_RequesterLocked AS NVARCHAR(MAX))
--				,@it_sb_RequesterLockedDate =		CAST(@it_d_RequesterLockedDate AS NVARCHAR(MAX))
--				,@it_sb_AssignedEmailDate =			CAST(@it_d_AssignedEmailDate AS NVARCHAR(MAX))
--			;

--			-- Cast inserted values as after strings
--			SELECT 
--				@it_sa_ITRequestID =				CAST(@it_i_ITRequestID AS NVARCHAR(MAX))
--				,@it_sa_RequestDate =				CAST(@it_i_RequestDate AS NVARCHAR(MAX))
--				,@it_sa_StartDate =					CAST(@it_i_StartDate AS NVARCHAR(MAX))
--				,@it_sa_DueDate =					CAST(@it_i_DueDate AS NVARCHAR(MAX))
--				,@it_sa_Request =					CAST(@it_i_Request AS NVARCHAR(MAX))
--				,@it_sa_Priority =					CAST(@it_i_Priority AS NVARCHAR(MAX))
--				,@it_sa_SubPriority =				CAST(@it_i_SubPriority AS NVARCHAR(MAX))
--				,@it_sa_RequestedBy =				CAST(@it_i_RequestedBy AS NVARCHAR(MAX))
--				,@it_sa_Department =				CAST(@it_i_Department AS NVARCHAR(MAX))
--				,@it_sa_RequestFollowUpPerson =		CAST(@it_i_RequestFollowUpPerson AS NVARCHAR(MAX))
--				,@it_sa_RequestType =				CAST(@it_i_RequestType AS NVARCHAR(MAX))
--				,@it_sa_RequestSubType =			CAST(@it_i_RequestSubType AS NVARCHAR(MAX))
--				,@it_sa_Comments =					CAST(@it_i_Comments AS NVARCHAR(MAX))
--				,@it_sa_Company =					CAST(@it_i_Company AS NVARCHAR(MAX))
--				,@it_sa_Status =					CAST(@it_i_Status AS NVARCHAR(MAX))
--				,@it_sa_Directory =					CAST(@it_i_Directory AS NVARCHAR(MAX))
--				,@it_sa_ITPersonAssignedID =		CAST(@it_i_ITPersonAssignedID AS NVARCHAR(MAX))
--				,@it_sa_CompletionDate =			CAST(@it_i_CompletionDate AS NVARCHAR(MAX))
--				,@it_sa_LastStatusUpdate =			CAST(@it_i_LastStatusUpdate AS NVARCHAR(MAX))
--				,@it_sa_LabourEstimate =			CAST(@it_i_LabourEstimate AS NVARCHAR(MAX))
--				,@it_sa_LabourActual =				CAST(@it_i_LabourActual AS NVARCHAR(MAX))
--				,@it_sa_TimerStart =				CAST(@it_i_TimerStart AS NVARCHAR(MAX))
--				,@it_sa_TimerStop =					CAST(@it_i_TimerStop AS NVARCHAR(MAX))
--				,@it_sa_Timer =						CAST(@it_i_Timer AS NVARCHAR(MAX))
--				,@it_sa_OpenCounter =				CAST(@it_i_OpenCounter AS NVARCHAR(MAX))
--				,@it_sa_IsOpened =					CAST(@it_i_IsOpened AS NVARCHAR(MAX))
--				,@it_sa_RequestDateOriginal =		CAST(@it_i_RequestDateOriginal AS NVARCHAR(MAX))
--				,@it_sa_LinkNext =					CAST(@it_i_LinkNext AS NVARCHAR(MAX))
--				,@it_sa_LinkPrev =					CAST(@it_i_LinkPrev AS NVARCHAR(MAX))
--				,@it_sa_RequesterLocked =			CAST(@it_i_RequesterLocked AS NVARCHAR(MAX))
--				,@it_sa_RequesterLockedDate =		CAST(@it_i_RequesterLockedDate AS NVARCHAR(MAX))
--				,@it_sa_AssignedEmailDate =			CAST(@it_i_AssignedEmailDate AS NVARCHAR(MAX))
--			;

--		END
--		IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) BEGIN
--			SET @activity = 'INSERT';
--			SET @user = SYSTEM_USER;
		
--			-- Capture inserted values
--			SELECT
--				@it_i_ITRequestID = i.[ITRequestID#]
--				,@it_i_RequestDate = i.[RequestDate]
--				,@it_i_StartDate = i.[StartDate]
--				,@it_i_DueDate = i.[DueDate]
--				,@it_i_Request = i.[Request]
--				,@it_i_Priority = i.[Priority]
--				,@it_i_SubPriority = i.[SubPriority]
--				,@it_i_RequestedBy = i.[RequestedBy]
--				,@it_i_Department = i.[Department]
--				,@it_i_RequestFollowUpPerson = i.[RequestFollowUpPersonnel]
--				,@it_i_RequestType = i.[RequestType]
--				,@it_i_RequestSubType = i.[RequestSubType]
--				,@it_i_Comments = i.[Comments]
--				,@it_i_Company = i.[Company]
--				,@it_i_Status = i.[Status]
--				,@it_i_Directory = i.[Directory]
--				,@it_i_ITPersonAssignedID = i.[ITPersonAssignedID]
--				,@it_i_CompletionDate = i.[CompletionDate]
--				,@it_i_LastStatusUpdate = i.[LastStatusUpdate]
--				,@it_i_LabourEstimate = i.[LabourEstimate]
--				,@it_i_LabourActual = i.[LabourActual]
--				,@it_i_TimerStart = i.[TimerStart]
--				,@it_i_TimerStop = i.[TimerStop]
--				,@it_i_Timer = i.[Timer]
--				,@it_i_OpenCounter = i.[OpenCounter]
--				,@it_i_IsOpened = i.[IsOpened]
--				,@it_i_RequestDateOriginal = i.[RequestDateOriginal]
--				,@it_i_LinkNext = i.[LinkNext]
--				,@it_i_LinkPrev = i.[LinkPrev]
--				,@it_i_RequesterLocked = i.[RequesterLocked]
--				,@it_i_RequesterLockedDate = i.[RequesterLockedDate]
--				,@it_i_AssignedEmailDate = i.[AssignmentEmailDate]
--				,@user = i.[LastStatusUpdater]
--			FROM
--				inserted i
--			;

--			-- Cast inserted values as after strings
--			SELECT 
--				@it_sa_ITRequestID =				CAST(@it_i_ITRequestID AS NVARCHAR(MAX))
--				,@it_sa_RequestDate =				CAST(@it_i_RequestDate AS NVARCHAR(MAX))
--				,@it_sa_StartDate =					CAST(@it_i_StartDate AS NVARCHAR(MAX))
--				,@it_sa_DueDate =					CAST(@it_i_DueDate AS NVARCHAR(MAX))
--				,@it_sa_Request =					CAST(@it_i_Request AS NVARCHAR(MAX))
--				,@it_sa_Priority =					CAST(@it_i_Priority AS NVARCHAR(MAX))
--				,@it_sa_SubPriority =				CAST(@it_i_SubPriority AS NVARCHAR(MAX))
--				,@it_sa_RequestedBy =				CAST(@it_i_RequestedBy AS NVARCHAR(MAX))
--				,@it_sa_Department =				CAST(@it_i_Department AS NVARCHAR(MAX))
--				,@it_sa_RequestFollowUpPerson =		CAST(@it_i_RequestFollowUpPerson AS NVARCHAR(MAX))
--				,@it_sa_RequestType =				CAST(@it_i_RequestType AS NVARCHAR(MAX))
--				,@it_sa_RequestSubType =			CAST(@it_i_RequestSubType AS NVARCHAR(MAX))
--				,@it_sa_Comments =					CAST(@it_i_Comments AS NVARCHAR(MAX))
--				,@it_sa_Company =					CAST(@it_i_Company AS NVARCHAR(MAX))
--				,@it_sa_Status =					CAST(@it_i_Status AS NVARCHAR(MAX))
--				,@it_sa_Directory =					CAST(@it_i_Directory AS NVARCHAR(MAX))
--				,@it_sa_ITPersonAssignedID =		CAST(@it_i_ITPersonAssignedID AS NVARCHAR(MAX))
--				,@it_sa_CompletionDate =			CAST(@it_i_CompletionDate AS NVARCHAR(MAX))
--				,@it_sa_LastStatusUpdate =			CAST(@it_i_LastStatusUpdate AS NVARCHAR(MAX))
--				,@it_sa_LabourEstimate =			CAST(@it_i_LabourEstimate AS NVARCHAR(MAX))
--				,@it_sa_LabourActual =				CAST(@it_i_LabourActual AS NVARCHAR(MAX))
--				,@it_sa_TimerStart =				CAST(@it_i_TimerStart AS NVARCHAR(MAX))
--				,@it_sa_TimerStop =					CAST(@it_i_TimerStop AS NVARCHAR(MAX))
--				,@it_sa_Timer =						CAST(@it_i_Timer AS NVARCHAR(MAX))
--				,@it_sa_OpenCounter =				CAST(@it_i_OpenCounter AS NVARCHAR(MAX))
--				,@it_sa_IsOpened =					CAST(@it_i_IsOpened AS NVARCHAR(MAX))
--				,@it_sa_RequestDateOriginal =		CAST(@it_i_RequestDateOriginal AS NVARCHAR(MAX))
--				,@it_sa_LinkNext =					CAST(@it_i_LinkNext AS NVARCHAR(MAX))
--				,@it_sa_LinkPrev =					CAST(@it_i_LinkPrev AS NVARCHAR(MAX))
--				,@it_sa_RequesterLocked =			CAST(@it_i_RequesterLocked AS NVARCHAR(MAX))
--				,@it_sa_RequesterLockedDate =		CAST(@it_i_RequesterLockedDate AS NVARCHAR(MAX))
--				,@it_sa_AssignedEmailDate =			CAST(@it_i_AssignedEmailDate AS NVARCHAR(MAX))
--			;

--		END
--		IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted) BEGIN 
--			SET @activity = 'DELETE';
--			SET @user = SYSTEM_USER;
		
--			-- Capture deleted values
--			SELECT
--				@it_d_ITRequestID = d.[ITRequestID#]
--				,@it_d_RequestDate = d.[RequestDate]
--				,@it_d_StartDate = d.[StartDate]
--				,@it_d_DueDate = d.[DueDate]
--				,@it_d_Request = d.[Request]
--				,@it_d_Priority = d.[Priority]
--				,@it_d_SubPriority = d.[SubPriority]
--				,@it_d_RequestedBy = d.[RequestedBy]
--				,@it_d_Department = d.[Department]
--				,@it_d_RequestFollowUpPerson = d.[RequestFollowUpPersonnel]
--				,@it_d_RequestType = d.[RequestType]
--				,@it_d_RequestSubType = d.[RequestSubType]
--				,@it_d_Comments = d.[Comments]
--				,@it_d_Company = d.[Company]
--				,@it_d_Status = d.[Status]
--				,@it_d_Directory = d.[Directory]
--				,@it_d_ITPersonAssignedID = d.[ITPersonAssignedID]
--				,@it_d_CompletionDate = d.[CompletionDate]
--				,@it_d_LastStatusUpdate = d.[LastStatusUpdate]
--				,@it_d_LabourEstimate = d.[LabourEstimate]
--				,@it_d_LabourActual = d.[LabourActual]
--				,@it_d_TimerStart = d.[TimerStart]
--				,@it_d_TimerStop = d.[TimerStop]
--				,@it_d_Timer = d.[Timer]
--				,@it_d_OpenCounter = d.[OpenCounter]
--				,@it_d_IsOpened = d.[IsOpened]
--				,@it_d_RequestDateOriginal = d.[RequestDateOriginal]
--				,@it_d_LinkNext = d.[LinkNext]
--				,@it_d_LinkPrev = d.[LinkPrev]
--				,@it_d_RequesterLocked = d.[RequesterLocked]
--				,@it_d_RequesterLockedDate = d.[RequesterLockedDate]
--				,@it_d_AssignedEmailDate = d.[AssignmentEmailDate]
--				,@user = d.[LastStatusUpdater]
--			FROM
--				deleted d
--			;
			
--			-- Cast deleted values as before strings
--			SELECT 
--				@it_sb_ITRequestID =				CAST(@it_d_ITRequestID AS NVARCHAR(MAX))
--				,@it_sb_RequestDate =				CAST(@it_d_RequestDate AS NVARCHAR(MAX))
--				,@it_sb_StartDate =					CAST(@it_d_StartDate AS NVARCHAR(MAX))
--				,@it_sb_DueDate =					CAST(@it_d_DueDate AS NVARCHAR(MAX))
--				,@it_sb_Request =					CAST(@it_d_Request AS NVARCHAR(MAX))
--				,@it_sb_Priority =					CAST(@it_d_Priority AS NVARCHAR(MAX))
--				,@it_sb_SubPriority =				CAST(@it_d_SubPriority AS NVARCHAR(MAX))
--				,@it_sb_RequestedBy =				CAST(@it_d_RequestedBy AS NVARCHAR(MAX))
--				,@it_sb_Department =				CAST(@it_d_Department AS NVARCHAR(MAX))
--				,@it_sb_RequestFollowUpPerson =		CAST(@it_d_RequestFollowUpPerson AS NVARCHAR(MAX))
--				,@it_sb_RequestType =				CAST(@it_d_RequestType AS NVARCHAR(MAX))
--				,@it_sb_RequestSubType =			CAST(@it_d_RequestSubType AS NVARCHAR(MAX))
--				,@it_sb_Comments =					CAST(@it_d_Comments AS NVARCHAR(MAX))
--				,@it_sb_Company =					CAST(@it_d_Company AS NVARCHAR(MAX))
--				,@it_sb_Status =					CAST(@it_d_Status AS NVARCHAR(MAX))
--				,@it_sb_Directory =					CAST(@it_d_Directory AS NVARCHAR(MAX))
--				,@it_sb_ITPersonAssignedID =		CAST(@it_d_ITPersonAssignedID AS NVARCHAR(MAX))
--				,@it_sb_CompletionDate =			CAST(@it_d_CompletionDate AS NVARCHAR(MAX))
--				,@it_sb_LastStatusUpdate =			CAST(@it_d_LastStatusUpdate AS NVARCHAR(MAX))
--				,@it_sb_LabourEstimate =			CAST(@it_d_LabourEstimate AS NVARCHAR(MAX))
--				,@it_sb_LabourActual =				CAST(@it_d_LabourActual AS NVARCHAR(MAX))
--				,@it_sb_TimerStart =				CAST(@it_d_TimerStart AS NVARCHAR(MAX))
--				,@it_sb_TimerStop =					CAST(@it_d_TimerStop AS NVARCHAR(MAX))
--				,@it_sb_Timer =						CAST(@it_d_Timer AS NVARCHAR(MAX))
--				,@it_sb_OpenCounter =				CAST(@it_d_OpenCounter AS NVARCHAR(MAX))
--				,@it_sb_IsOpened =					CAST(@it_d_IsOpened AS NVARCHAR(MAX))
--				,@it_sb_RequestDateOriginal =		CAST(@it_d_RequestDateOriginal AS NVARCHAR(MAX))
--				,@it_sb_LinkNext =					CAST(@it_d_LinkNext AS NVARCHAR(MAX))
--				,@it_sb_LinkPrev =					CAST(@it_d_LinkPrev AS NVARCHAR(MAX))
--				,@it_sb_RequesterLocked =			CAST(@it_d_RequesterLocked AS NVARCHAR(MAX))
--				,@it_sb_RequesterLockedDate =		CAST(@it_d_RequesterLockedDate AS NVARCHAR(MAX))
--				,@it_sb_AssignedEmailDate =			CAST(@it_d_AssignedEmailDate AS NVARCHAR(MAX))
--			;

--		END

--		-- Begin checkin against known columns
		
--		-- ITRequestID#
--		IF @it_sa_ITRequestID <> @it_sb_ITRequestID BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'ITRequestID#', @it_sb_ITRequestID, @it_sa_ITRequestID;
--		END
--		-- RequestDate
--		IF @it_sa_RequestDate <> @it_sb_RequestDate BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'RequestDate', @it_sb_RequestDate, @it_sa_RequestDate;
--		END
--		-- StartDate
--		IF @it_sa_StartDate <> @it_sb_StartDate BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'StartDate', @it_sb_StartDate, @it_sa_StartDate;
--		END
--		-- DueDate
--		IF @it_sa_DueDate <> @it_sb_DueDate BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'DueDate', @it_sb_DueDate, @it_sa_DueDate;
--		END
--		-- Request 
--		IF @it_sa_Request <> @it_sb_Request BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'Request', @it_sb_Request, @it_sa_Request;
--		END
--		-- Priority
--		IF @it_sa_Priority <> @it_sb_Priority BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'Priority', @it_sb_Priority, @it_sa_Priority;
--		END
--		-- SubPriority
--		IF @it_sa_SubPriority <> @it_sb_SubPriority BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'SubPriority', @it_sb_SubPriority, @it_sa_SubPriority;
--		END
--		-- RequestedBy
--		IF @it_sa_RequestedBy <> @it_sb_RequestedBy BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'RequestedBy', @it_sb_RequestedBy, @it_sa_RequestedBy;
--		END
--		-- Department
--		IF @it_sa_Department <> @it_sb_Department BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'Department', @it_sb_Department, @it_sa_Department;
--		END
--		-- RequestFollowUpPerson
--		IF @it_sa_RequestFollowUpPerson <> @it_sb_RequestFollowUpPerson BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'RequestFollowUpPerson', @it_sb_RequestFollowUpPerson, @it_sa_RequestFollowUpPerson;
--		END
--		-- RequestType
--		IF @it_sa_RequestType <> @it_sb_RequestType BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'RequestType', @it_sb_RequestType, @it_sa_RequestType;
--		END
--		-- RequestSubType
--		IF @it_sa_RequestSubType <> @it_sb_RequestSubType BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'RequestSubType', @it_sb_RequestSubType, @it_sa_RequestSubType;
--		END
--		-- Comments
--		IF @it_sa_Comments <> @it_sb_Comments BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'Comments', @it_sb_Comments, @it_sa_Comments;
--		END
--		-- Status
--		IF @it_sa_Status <> @it_sb_Status BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'Status', @it_sb_Status, @it_sa_Status;
--		END
--		-- Directory
--		IF @it_sa_Directory <> @it_sb_Directory BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'Directory', @it_sb_Directory, @it_sa_Directory;
--		END
--		-- ITPersonAssignedID
--		IF @it_sa_ITPersonAssignedID <> @it_sb_ITPersonAssignedID BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'ITPersonAssignedID', @it_sb_ITPersonAssignedID, @it_sa_ITPersonAssignedID;
--		END
--		-- CompletionDate
--		IF @it_sa_CompletionDate <> @it_sb_CompletionDate BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'CompletionDate', @it_sb_CompletionDate, @it_sa_CompletionDate;
--		END
--		-- LastStatusUpdate
--		IF @it_sa_LastStatusUpdate <> @it_sb_LastStatusUpdate BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'LastStatusUpdate', @it_sb_LastStatusUpdate, @it_sa_LastStatusUpdate;
--		END
--		-- LabourEstimate
--		IF @it_sa_LabourEstimate <> @it_sb_LabourEstimate BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'LabourEstimate', @it_sb_LabourEstimate, @it_sa_LabourEstimate;
--		END
--		-- LabourActual
--		IF @it_sa_LabourActual <> @it_sb_LabourActual BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'LabourActual', @it_sb_LabourActual, @it_sa_LabourActual;
--		END
--		-- TimerStart
--		IF @it_sa_TimerStart <> @it_sb_TimerStart BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'TimerStart', @it_sb_TimerStart, @it_sa_TimerStart;
--		END
--		-- TimerStop
--		IF @it_sa_TimerStop <> @it_sb_TimerStop BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'TimerStop', @it_sb_TimerStop, @it_sa_TimerStop;
--		END
--		-- Timer
--		IF @it_sa_Timer <> @it_sb_Timer BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'Timer', @it_sb_Timer, @it_sa_Timer;
--		END
--		-- OpenCounter
--		IF @it_sa_OpenCounter <> @it_sb_OpenCounter BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'OpenCounter', @it_sb_OpenCounter, @it_sa_OpenCounter;
--		END
--		-- IsOpened
--		IF @it_sa_IsOpened <> @it_sb_IsOpened BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'IsOpened', @it_sb_IsOpened, @it_sa_IsOpened;
--		END
--		-- RequestDateOriginal
--		IF @it_sa_RequestDateOriginal <> @it_sb_RequestDateOriginal BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'RequestDateOriginal', @it_sb_RequestDateOriginal, @it_sa_RequestDateOriginal;
--		END
--		-- LinkNext
--		IF @it_sa_LinkNext <> @it_sb_LinkNext BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'LinkNext', @it_sb_LinkNext, @it_sa_LinkNext;
--		END
--		-- LinkPrev
--		IF @it_sa_LinkPrev <> @it_sb_LinkPrev BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'LinkPrev', @it_sb_LinkPrev, @it_sa_LinkPrev;
--		END
--		-- RequesterLocked
--		IF @it_sa_RequesterLocked <> @it_sb_RequesterLocked BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'RequesterLocked', @it_sb_RequesterLocked, @it_sa_RequesterLocked;
--		END
--		-- RequesterLockedDate
--		IF @it_sa_RequesterLockedDate <> @it_sb_RequesterLockedDate BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'RequesterLockedDate', @it_sb_RequesterLockedDate, @it_sa_RequesterLockedDate;
--		END
--		-- AssignedEmailDate
--		IF @it_sa_AssignedEmailDate <> @it_sb_AssignedEmailDate BEGIN
--			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--			SELECT 'AssignedEmailDate', @it_sb_AssignedEmailDate, @it_sa_AssignedEmailDate;
--		END


---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
			
----			-- Use this to send test data in email form
			
----DECLARE @itrid AS INT;
----DECLARE @requestedBy AS NVARCHAR(MAX);

----SELECT @itrid = i.[ITRequestID#] FROM inserted i;
----SELECT @requestedBy = i.[RequestedBy] FROM inserted i;
------SELECT @itrid = [ITRequestID#] FROM [IT Requests] WHERE [ITRequestID#] = 1000;
------SELECT @requestedBy = [RequestedBy] FROM [IT Requests] WHERE [ITRequestID#] = 1000;

----	DECLARE @v1 AS NVARCHAR(MAX);
----	DECLARE @v2 AS NVARCHAR(MAX);
----	DECLARE @v3 AS NVARCHAR(MAX);
----	DECLARE @j AS INT;
----	DECLARE @d AS INT;
----	DECLARE @s AS NVARCHAR(MAX);
----	SELECT @d = COUNT(*) FROM @t_to_update
----	IF @d > 0 BEGIN
----		SELECT @s = '<div><Table class="ITR Table" border="1" cellpadding = "5" cellspacing = "5"><thead><th colspan="3"><b>Request Update Date</b></th></thead><tbody><tr><td>Column</td><td>Before</td><td>After</td></tr>'
----	END

----	SELECT @j = 0;
----	WHILE @j < @d BEGIN
----		SELECT @j = @j + 1;
----		SELECT @v1 = [column], @v2 = [value_before], @v3 = [value_after] FROM @t_to_update
----		SELECT @s = @s + '<tr><td>' + ISNULL(@v1, 'NA') + '</td><td>' + ISNULL(@v2, 'NA') + '</td><td>' + ISNULL(@v3, 'NA') + '</td></tr>';
----	END

----	IF @s IS NOT NULL AND LEN(@s) > 0 BEGIN
----		SELECT @s = @s + '</tbody></Table></div>'
----	END

----DECLARE @persons AS NVARCHAR(MAX);
----DECLARE @subject AS NVARCHAR(MAX);
----DECLARE @body AS NVARCHAR(MAX);
----SELECT @persons = 'avery.briggs@bwstrailers.com';
----SELECT @subject = 'TEST UPDATE';
----SELECT @body = '<!DOCTYPE html><html><body><div class="ITR Body" id="ITR Body ID 001" ><p>@ID= "' +
----		CAST(ISNULL(@itrid, 'N/A') AS NVARCHAR(MAX)) +
----		'", @requestBy="' + CAST(ISNULL(@requestedBy, -1) AS NVARCHAR(MAX)) + '"</p>' +
----		ISNULL(@s, '<h6>NO UPDATE DATA FOUND</h6>')
----		+ '</div></body><footer></footer></html>';

------SELECT @body AS [@body], @s AS [@s], @d AS [@d], @j AS [@j]
------SELECT * FROM @t_to_update

------ Send Email
----EXEC msdb.dbo.sp_send_dbmail 
----	@recipients = @persons,
----	@profile_name = 'SQL Agent',
----	@subject = @subject, 
----	@body = @body,
----	--@body_format='TEXT'
----	@body_format='HTML'
----	;


---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------


--		-- 
--		--IF @it_sa_ITRequestID <> @it_sb_ITRequestID BEGIN
--		--	INSERT INTO	@t_to_update ([column], [value_before], [value_after])
--		--	SELECT '', @it_sb_ITRequestID, @it_sa_ITRequestID;
--		--END

--		-- Finally iteratively update [dbo].[IT Request History] for each changed value
		
--		DECLARE @c AS INT;
--		SELECT @c = COUNT(*) FROM @t_to_update;
		
--		IF @c > 0 BEGIN

--			IF @user IS NULL BEGIN
--				SELECT @user = SYSTEM_USER;
--			END
		
--			DECLARE @i AS INT;
--			DECLARE @column AS NVARCHAR(MAX);
--			DECLARE @value_before AS NVARCHAR(MAX);
--			DECLARE @value_after AS NVARCHAR(MAX);

--			SELECT @i = 0;

--			WHILE @i < @c BEGIN

--				SELECT @i = @i + 1;
				
--				SELECT 
--					@column = [column]
--					,@value_before = [value_before]
--					,@value_after = [value_after]
--				FROM
--					@t_to_update
--				WHERE
--					[ID] = @i

--				INSERT INTO 
--					[dbo].[IT Requests History]

--				   ([UpdateType]
--				   ,[UpdatedColumn]
--				   ,[ValueBefore]
--				   ,[ValueAfter]
--				   ,[ChangedBy]

--				   ,[ITRequestID#]
--				   ,[StartDate]
--				   ,[RequestDate]
--				   ,[DueDate]
--				   ,[Request]
--				   ,[Priority]
--				   ,[SubPriority]
--				   ,[RequestedBy]
--				   ,[Department]
--				   ,[RequestFollowUpPerson]
--				   ,[RequestType]
--				   ,[RequestSubType]
--				   ,[Comments]
--				   ,[Company]
--				   ,[Status]
--				   ,[Directory]
--				   ,[ITPersonAssignedID]
--				   ,[CompletionDate]
--				   ,[LastStatusUpdate]
--				   ,[LabourEstimate]
--				   ,[LabourActual]
--				   ,[TimerStart]
--				   ,[TimerStop]
--				   ,[Timer]
--				   ,[OpenCounter]
--				   ,[IsOpened]
--				   ,[RequestDateOriginal]
--				   ,[LinkNext]
--				   ,[LinkPrev]
--				   ,[RequesterLocked]
--				   ,[RequesterLockedDate]
--				   ,[AssignmentEmailDate])
--				 SELECT
--					   @activity
--					   ,@column
--					   ,@value_before
--					   ,@value_after
--					   ,@user
--					,[ITRequestID#]
--					,[StartDate]
--					,[RequestDate]
--					,[DueDate]
--					,[Request]
--					,[Priority]
--					,[SubPriority]
--					,[RequestedBy]
--					,[Department]
--					,[RequestFollowUpPersonnel]
--					,[RequestType]
--					,[RequestSubType]
--					,[Comments]
--					,[Company]
--					,[Status]
--					,[Directory]
--					,[ITPersonAssignedID]
--					,[CompletionDate]
--					,[LastStatusUpdate]
--					,[LabourEstimate]
--					,[LabourActual]
--					,[TimerStart]
--					,[TimerStop]
--					,[Timer]
--					,[OpenCounter]
--					,[IsOpened]
--					,[RequestDateOriginal]
--					,[LinkNext]
--					,[LinkPrev]
--					,[RequesterLocked]
--					,[RequesterLockedDate]
--					,[AssignmentEmailDate]
--				FROM
--					[IT Requests]
--				WHERE 
--					[ITRequestID#] = ISNULL(@it_i_ITRequestID, @it_d_ITRequestID)

--			END
--		END

	END
END
