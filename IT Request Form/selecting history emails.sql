DECLARE @user NVARCHAR(20);
		DECLARE @activity NVARCHAR(20);

		DECLARE @t_to_update AS TABLE 
		(
			[ID] INT IDENTITY(1, 1),
			[column] NVARCHAR(255),
			[value_before] NVARCHAR(MAX),
			[value_after] NVARCHAR(MAX)
		);
		
		-- Inserted values
		DECLARE @it_i_ITRequestID AS INT;
		DECLARE @it_i_RequestDate AS DATETIME;
		DECLARE @it_i_StartDate AS DATETIME;
		DECLARE @it_i_DueDate AS DATETIME;
		DECLARE @it_i_Request AS NVARCHAR(MAX);
		DECLARE @it_i_Priority AS INT;
		DECLARE @it_i_SubPriority AS INT;
		DECLARE @it_i_RequestedBy AS NVARCHAR(255);
		DECLARE @it_i_Department AS INT;
		DECLARE @it_i_RequestFollowUpPerson AS NVARCHAR(MAX);
		DECLARE @it_i_RequestType AS NVARCHAR(255);
		DECLARE @it_i_RequestSubType AS NVARCHAR(255);
		DECLARE @it_i_Comments AS NVARCHAR(MAX);
		DECLARE @it_i_Company AS NVARCHAR(255);
		DECLARE @it_i_Status AS NVARCHAR(255);
		DECLARE @it_i_Directory AS NVARCHAR(MAX);
		DECLARE @it_i_ITPersonAssignedID AS INT;
		DECLARE @it_i_CompletionDate AS DATETIME;
		DECLARE @it_i_LastStatusUpdate AS DATETIME;
		DECLARE @it_i_LabourEstimate AS FLOAT;
		DECLARE @it_i_LabourActual AS FLOAT;
		DECLARE @it_i_TimerStart AS DATETIME;
		DECLARE @it_i_TimerStop AS DATETIME;
		DECLARE @it_i_Timer AS BIGINT;
		DECLARE @it_i_OpenCounter AS INT;
		DECLARE @it_i_IsOpened AS BIT;
		DECLARE @it_i_RequestDateOriginal AS DATETIME;
		DECLARE @it_i_LinkNext AS INT;
		DECLARE @it_i_LinkPrev AS INT;
		DECLARE @it_i_RequesterLocked AS BIT;
		DECLARE @it_i_RequesterLockedDate AS DATETIME;
		DECLARE @it_i_AssignedEmailDate AS DATETIME;
		
		-- Deleted values
		DECLARE @it_d_ITRequestID AS INT;
		DECLARE @it_d_RequestDate AS DATETIME;
		DECLARE @it_d_StartDate AS DATETIME;
		DECLARE @it_d_DueDate AS DATETIME;
		DECLARE @it_d_Request AS NVARCHAR(MAX);
		DECLARE @it_d_Priority AS INT;
		DECLARE @it_d_SubPriority AS INT;
		DECLARE @it_d_RequestedBy AS NVARCHAR(255);
		DECLARE @it_d_Department AS INT;
		DECLARE @it_d_RequestFollowUpPerson AS NVARCHAR(MAX);
		DECLARE @it_d_RequestType AS NVARCHAR(255);
		DECLARE @it_d_RequestSubType AS NVARCHAR(255);
		DECLARE @it_d_Comments AS NVARCHAR(MAX);
		DECLARE @it_d_Company AS NVARCHAR(255);
		DECLARE @it_d_Status AS NVARCHAR(255);
		DECLARE @it_d_Directory AS NVARCHAR(MAX);
		DECLARE @it_d_ITPersonAssignedID AS INT;
		DECLARE @it_d_CompletionDate AS DATETIME;
		DECLARE @it_d_LastStatusUpdate AS DATETIME;
		DECLARE @it_d_LabourEstimate AS FLOAT;
		DECLARE @it_d_LabourActual AS FLOAT;
		DECLARE @it_d_TimerStart AS DATETIME;
		DECLARE @it_d_TimerStop AS DATETIME;
		DECLARE @it_d_Timer AS BIGINT;
		DECLARE @it_d_OpenCounter AS INT;
		DECLARE @it_d_IsOpened AS BIT;
		DECLARE @it_d_RequestDateOriginal AS DATETIME;
		DECLARE @it_d_LinkNext AS INT;
		DECLARE @it_d_LinkPrev AS INT;
		DECLARE @it_d_RequesterLocked AS BIT;
		DECLARE @it_d_RequesterLockedDate AS DATETIME;
		DECLARE @it_d_AssignedEmailDate AS DATETIME;
		
		-- String values before
		DECLARE @it_sb_ITRequestID AS NVARCHAR(MAX);
		DECLARE @it_sb_RequestDate AS NVARCHAR(MAX);
		DECLARE @it_sb_StartDate AS NVARCHAR(MAX);
		DECLARE @it_sb_DueDate AS NVARCHAR(MAX);
		DECLARE @it_sb_Request AS NVARCHAR(MAX);
		DECLARE @it_sb_Priority AS NVARCHAR(MAX);
		DECLARE @it_sb_SubPriority AS NVARCHAR(MAX);
		DECLARE @it_sb_RequestedBy AS NVARCHAR(MAX);
		DECLARE @it_sb_Department AS NVARCHAR(MAX);
		DECLARE @it_sb_RequestFollowUpPerson AS NVARCHAR(MAX);
		DECLARE @it_sb_RequestType AS NVARCHAR(MAX);
		DECLARE @it_sb_RequestSubType AS NVARCHAR(MAX);
		DECLARE @it_sb_Comments AS NVARCHAR(MAX);
		DECLARE @it_sb_Company AS NVARCHAR(MAX);
		DECLARE @it_sb_Status AS NVARCHAR(MAX);
		DECLARE @it_sb_Directory AS NVARCHAR(MAX);
		DECLARE @it_sb_ITPersonAssignedID AS NVARCHAR(MAX);
		DECLARE @it_sb_CompletionDate AS NVARCHAR(MAX);
		DECLARE @it_sb_LastStatusUpdate AS NVARCHAR(MAX);
		DECLARE @it_sb_LabourEstimate AS NVARCHAR(MAX);
		DECLARE @it_sb_LabourActual AS NVARCHAR(MAX);
		DECLARE @it_sb_TimerStart AS NVARCHAR(MAX);
		DECLARE @it_sb_TimerStop AS NVARCHAR(MAX);
		DECLARE @it_sb_Timer AS NVARCHAR(MAX);
		DECLARE @it_sb_OpenCounter AS NVARCHAR(MAX);
		DECLARE @it_sb_IsOpened AS NVARCHAR(MAX);
		DECLARE @it_sb_RequestDateOriginal AS NVARCHAR(MAX);
		DECLARE @it_sb_LinkNext AS NVARCHAR(MAX);
		DECLARE @it_sb_LinkPrev AS NVARCHAR(MAX);
		DECLARE @it_sb_RequesterLocked AS NVARCHAR(MAX);
		DECLARE @it_sb_RequesterLockedDate AS NVARCHAR(MAX);
		DECLARE @it_sb_AssignedEmailDate AS NVARCHAR(MAX);
		
		-- String values After
		DECLARE @it_sa_ITRequestID AS NVARCHAR(MAX);
		DECLARE @it_sa_RequestDate AS NVARCHAR(MAX);
		DECLARE @it_sa_StartDate AS NVARCHAR(MAX);
		DECLARE @it_sa_DueDate AS NVARCHAR(MAX);
		DECLARE @it_sa_Request AS NVARCHAR(MAX);
		DECLARE @it_sa_Priority AS NVARCHAR(MAX);
		DECLARE @it_sa_SubPriority AS NVARCHAR(MAX);
		DECLARE @it_sa_RequestedBy AS NVARCHAR(MAX);
		DECLARE @it_sa_Department AS NVARCHAR(MAX);
		DECLARE @it_sa_RequestFollowUpPerson AS NVARCHAR(MAX);
		DECLARE @it_sa_RequestType AS NVARCHAR(MAX);
		DECLARE @it_sa_RequestSubType AS NVARCHAR(MAX);
		DECLARE @it_sa_Comments AS NVARCHAR(MAX);
		DECLARE @it_sa_Company AS NVARCHAR(MAX);
		DECLARE @it_sa_Status AS NVARCHAR(MAX);
		DECLARE @it_sa_Directory AS NVARCHAR(MAX);
		DECLARE @it_sa_ITPersonAssignedID AS NVARCHAR(MAX);
		DECLARE @it_sa_CompletionDate AS NVARCHAR(MAX);
		DECLARE @it_sa_LastStatusUpdate AS NVARCHAR(MAX);
		DECLARE @it_sa_LabourEstimate AS NVARCHAR(MAX);
		DECLARE @it_sa_LabourActual AS NVARCHAR(MAX);
		DECLARE @it_sa_TimerStart AS NVARCHAR(MAX);
		DECLARE @it_sa_TimerStop AS NVARCHAR(MAX);
		DECLARE @it_sa_Timer AS NVARCHAR(MAX);
		DECLARE @it_sa_OpenCounter AS NVARCHAR(MAX);
		DECLARE @it_sa_IsOpened AS NVARCHAR(MAX);
		DECLARE @it_sa_RequestDateOriginal AS NVARCHAR(MAX);
		DECLARE @it_sa_LinkNext AS NVARCHAR(MAX);
		DECLARE @it_sa_LinkPrev AS NVARCHAR(MAX);
		DECLARE @it_sa_RequesterLocked AS NVARCHAR(MAX);
		DECLARE @it_sa_RequesterLockedDate AS NVARCHAR(MAX);
		DECLARE @it_sa_AssignedEmailDate AS NVARCHAR(MAX);
		
		--SELECT @it_sb_Status = 'Queued';
		--SELECT @it_sa_Status = 'In Progress';

	-- ITRequestID#
		IF @it_sa_ITRequestID <> @it_sb_ITRequestID BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'ITRequestID#', @it_sb_ITRequestID, @it_sa_ITRequestID;
		END
		-- RequestDate
		IF @it_sa_RequestDate <> @it_sb_RequestDate BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'RequestDate', @it_sb_RequestDate, @it_sa_RequestDate;
		END
		-- StartDate
		IF @it_sa_StartDate <> @it_sb_StartDate BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'StartDate', @it_sb_StartDate, @it_sa_StartDate;
		END
		-- DueDate
		IF @it_sa_DueDate <> @it_sb_DueDate BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'DueDate', @it_sb_DueDate, @it_sa_DueDate;
		END
		-- Request 
		IF @it_sa_Request <> @it_sb_Request BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'Request', @it_sb_Request, @it_sa_Request;
		END
		-- Priority
		IF @it_sa_Priority <> @it_sb_Priority BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'Priority', @it_sb_Priority, @it_sa_Priority;
		END
		-- SubPriority
		IF @it_sa_SubPriority <> @it_sb_SubPriority BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'SubPriority', @it_sb_SubPriority, @it_sa_SubPriority;
		END
		-- RequestedBy
		IF @it_sa_RequestedBy <> @it_sb_RequestedBy BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'RequestedBy', @it_sb_RequestedBy, @it_sa_RequestedBy;
		END
		-- Department
		IF @it_sa_Department <> @it_sb_Department BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'Department', @it_sb_Department, @it_sa_Department;
		END
		-- RequestFollowUpPerson
		IF @it_sa_RequestFollowUpPerson <> @it_sb_RequestFollowUpPerson BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'RequestFollowUpPerson', @it_sb_RequestFollowUpPerson, @it_sa_RequestFollowUpPerson;
		END
		-- RequestType
		IF @it_sa_RequestType <> @it_sb_RequestType BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'RequestType', @it_sb_RequestType, @it_sa_RequestType;
		END
		-- RequestSubType
		IF @it_sa_RequestSubType <> @it_sb_RequestSubType BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'RequestSubType', @it_sb_RequestSubType, @it_sa_RequestSubType;
		END
		-- Comments
		IF @it_sa_Comments <> @it_sb_Comments BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'Comments', @it_sb_Comments, @it_sa_Comments;
		END
		-- Status
		IF @it_sa_Status <> @it_sb_Status BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'Status', @it_sb_Status, @it_sa_Status;
		END
		-- Directory
		IF @it_sa_Directory <> @it_sb_Directory BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'Directory', @it_sb_Directory, @it_sa_Directory;
		END
		-- ITPersonAssignedID
		IF @it_sa_ITPersonAssignedID <> @it_sb_ITPersonAssignedID BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'ITPersonAssignedID', @it_sb_ITPersonAssignedID, @it_sa_ITPersonAssignedID;
		END
		-- CompletionDate
		IF @it_sa_CompletionDate <> @it_sb_CompletionDate BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'CompletionDate', @it_sb_CompletionDate, @it_sa_CompletionDate;
		END
		-- LastStatusUpdate
		IF @it_sa_LastStatusUpdate <> @it_sb_LastStatusUpdate BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'LastStatusUpdate', @it_sb_LastStatusUpdate, @it_sa_LastStatusUpdate;
		END
		-- LabourEstimate
		IF @it_sa_LabourEstimate <> @it_sb_LabourEstimate BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'LabourEstimate', @it_sb_LabourEstimate, @it_sa_LabourEstimate;
		END
		-- LabourActual
		IF @it_sa_LabourActual <> @it_sb_LabourActual BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'LabourActual', @it_sb_LabourActual, @it_sa_LabourActual;
		END
		-- TimerStart
		IF @it_sa_TimerStart <> @it_sb_TimerStart BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'TimerStart', @it_sb_TimerStart, @it_sa_TimerStart;
		END
		-- TimerStop
		IF @it_sa_TimerStop <> @it_sb_TimerStop BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'TimerStop', @it_sb_TimerStop, @it_sa_TimerStop;
		END
		-- Timer
		IF @it_sa_Timer <> @it_sb_Timer BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'Timer', @it_sb_Timer, @it_sa_Timer;
		END
		-- OpenCounter
		IF @it_sa_OpenCounter <> @it_sb_OpenCounter BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'OpenCounter', @it_sb_OpenCounter, @it_sa_OpenCounter;
		END
		-- IsOpened
		IF @it_sa_IsOpened <> @it_sb_IsOpened BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'IsOpened', @it_sb_IsOpened, @it_sa_IsOpened;
		END
		-- RequestDateOriginal
		IF @it_sa_RequestDateOriginal <> @it_sb_RequestDateOriginal BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'RequestDateOriginal', @it_sb_RequestDateOriginal, @it_sa_RequestDateOriginal;
		END
		-- LinkNext
		IF @it_sa_LinkNext <> @it_sb_LinkNext BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'LinkNext', @it_sb_LinkNext, @it_sa_LinkNext;
		END
		-- LinkPrev
		IF @it_sa_LinkPrev <> @it_sb_LinkPrev BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'LinkPrev', @it_sb_LinkPrev, @it_sa_LinkPrev;
		END
		-- RequesterLocked
		IF @it_sa_RequesterLocked <> @it_sb_RequesterLocked BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'RequesterLocked', @it_sb_RequesterLocked, @it_sa_RequesterLocked;
		END
		-- RequesterLockedDate
		IF @it_sa_RequesterLockedDate <> @it_sb_RequesterLockedDate BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'RequesterLockedDate', @it_sb_RequesterLockedDate, @it_sa_RequesterLockedDate;
		END
		-- AssignedEmailDate
		IF @it_sa_AssignedEmailDate <> @it_sb_AssignedEmailDate BEGIN
			INSERT INTO	@t_to_update ([column], [value_before], [value_after])
			SELECT 'AssignedEmailDate', @it_sb_AssignedEmailDate, @it_sa_AssignedEmailDate;
		END


		
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
			
			-- Use this to send test data in email form
			
DECLARE @itrid AS INT;
DECLARE @requestedBy AS NVARCHAR(MAX);

--SELECT @itrid = i.[ITRequestID#] FROM inserted i;
--SELECT @requestedBy = i.[RequestedBy] FROM inserted i;
SELECT @itrid = [ITRequestID#] FROM [IT Requests] WHERE [ITRequestID#] = 1000;
SELECT @requestedBy = [RequestedBy] FROM [IT Requests] WHERE [ITRequestID#] = 1000;

	DECLARE @v1 AS NVARCHAR(MAX);
	DECLARE @v2 AS NVARCHAR(MAX);
	DECLARE @v3 AS NVARCHAR(MAX);
	DECLARE @j AS INT;
	DECLARE @d AS INT;
	DECLARE @s AS NVARCHAR(MAX);
	SELECT @d = COUNT(*) FROM @t_to_update
	IF @d > 0 BEGIN
		SELECT @s = '<div><Table class="ITR Table" border="1" cellpadding = "5" cellspacing = "5"><thead><th colspan="3"><b>Request Update Date</b></th></thead><tbody><tr><td>Column</td><td>Before</td><td>After</td></tr>'
	END

	SELECT @j = 0;
	WHILE @j < @d BEGIN
		SELECT @j = @j + 1;
		SELECT @v1 = [column], @v2 = [value_before], @v3 = [value_after] FROM @t_to_update
		SELECT @s = @s + '<tr><td>' + ISNULL(@v1, 'NA') + '</td><td>' + ISNULL(@v2, 'NA') + '</td><td>' + ISNULL(@v3, 'NA') + '</td></tr>';
	END

	IF @s IS NOT NULL AND LEN(@s) > 0 BEGIN
		SELECT @s = @s + '</tbody></Table></div>'
	END

DECLARE @persons AS NVARCHAR(MAX);
DECLARE @subject AS NVARCHAR(MAX);
DECLARE @body AS NVARCHAR(MAX);
SELECT @persons = 'avery.briggs@bwstrailers.com';
SELECT @subject = 'TEST UPDATE';
SELECT @body = '<!DOCTYPE html><html><body><div class="ITR Body" id="ITR Body ID 001" ><p>@ID= "' +
		CAST(ISNULL(@itrid, 'N/A') AS NVARCHAR(MAX)) +
		'", @requestBy="' + CAST(ISNULL(@requestedBy, -1) AS NVARCHAR(MAX)) + '"</p>' +
		ISNULL(@s, '')
		+ ', </div></body><footer></footer></html>';

SELECT @body AS [@body], @s AS [@s], @d AS [@d], @j AS [@j]
SELECT * FROM @t_to_update

-- Send Email
EXEC msdb.dbo.sp_send_dbmail 
	@recipients = @persons,
	@profile_name = 'SQL Agent',
	@subject = @subject, 
	@body = @body,
	--@body_format='TEXT'
	@body_format='HTML'
	;
