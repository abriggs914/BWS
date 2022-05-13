USE [BWSdb]
GO

ALTER PROCEDURE [dbo].[sp_ITRSendAssignmentNotification]
	@reqID AS INT
AS BEGIN

	
	DECLARE @ws AS NVARCHAR(MAX) = '                                           ';
	DECLARE @persons AS NVARCHAR(MAX);
	DECLARE @subject AS NVARCHAR(255);
	DECLARE @body AS NVARCHAR(MAX);

	DECLARE @itr_id AS NVARCHAR(6);
	DECLARE @itr_today AS NVARCHAR(11);
	DECLARE @itr_reqdate AS NVARCHAR(11);
	DECLARE @itr_duedate AS NVARCHAR(11);
	DECLARE @itr_request AS NVARCHAR(MAX);
	DECLARE @itr_requestby AS NVARCHAR(255);
	DECLARE @itr_priority AS NVARCHAR(2);
	DECLARE @itr_subpriority AS NVARCHAR(2);
	DECLARE @itr_type AS NVARCHAR(255);
	DECLARE @itr_subtype AS NVARCHAR(255);
	DECLARE @itr_company AS NVARCHAR(25);
	DECLARE @itr_directory AS NVARCHAR(255);

	--SELECT @itr_today =			CAST(GETDATE() AS NVARCHAR(11));
	--SELECT @itr_reqdate =		CAST([DueDate] AS NVARCHAR(11)) FROM INSERTED i;
	--SELECT @itr_id =			CAST([ITRequestID#] AS NVARCHAR(6)) FROM INSERTED i;
	--SELECT @itr_duedate =		CAST([DueDate] AS NVARCHAR(11)) FROM INSERTED i;
	--SELECT @itr_request =		[Request] FROM INSERTED i;
	--SELECT @itr_requestby =		[RequestedBy] FROM INSERTED i;
	--SELECT @itr_priority =		CAST([Priority] AS NVARCHAR(2)) FROM INSERTED i;
	--SELECT @itr_subpriority =	CAST([SubPriority] AS NVARCHAR(2)) FROM INSERTED i;
	--SELECT @itr_type =			[RequestType] FROM INSERTED i;
	--SELECT @itr_subtype =		[RequestSubType] FROM INSERTED i;
	--SELECT @itr_company =		[Company] FROM INSERTED i;
	--SELECT @itr_directory =		[Directory] FROM INSERTED i;
	SELECT @itr_reqdate =		CAST([RequestDate] AS NVARCHAR(11)) FROM [IT Requests] WHERE [ITRequestID#] = @reqID;
	SELECT @itr_id =			CAST(@reqID AS NVARCHAR(6))
	SELECT @itr_duedate =		CAST([DueDate] AS NVARCHAR(11)) FROM [IT Requests] WHERE [ITRequestID#] = @reqID;
	SELECT @itr_request =		[Request] FROM [IT Requests] WHERE [ITRequestID#] = @reqID;
	SELECT @itr_requestby =		[RequestedBy] FROM [IT Requests] WHERE [ITRequestID#] = @reqID;
	SELECT @itr_priority =		CAST([Priority] AS NVARCHAR(2)) FROM [IT Requests] WHERE [ITRequestID#] = @reqID;
	SELECT @itr_subpriority =	CAST([SubPriority] AS NVARCHAR(2)) FROM [IT Requests] WHERE [ITRequestID#] = @reqID;
	SELECT @itr_type =			[RequestType] FROM [IT Requests] WHERE [ITRequestID#] = @reqID;
	SELECT @itr_subtype =		[RequestSubType] FROM [IT Requests] WHERE [ITRequestID#] = @reqID;
	SELECT @itr_company =		[Company] FROM [IT Requests] WHERE [ITRequestID#] = @reqID;
	SELECT @itr_directory =		[Directory] FROM [IT Requests] WHERE [ITRequestID#] = @reqID;

	-- Enter Recipients
	--SET @persons = 'q0y9o8w7x8v5o6b0@bwsmanufacturingltd.slack.com'; -- Avery
	--SET @persons = @persons + ';' + 'v6l2a8z0e8u7x0k9@bwsmanufacturingltd.slack.com'; -- James
	--SET @persons = @persons + ';' + 'o8u2z7g5f5h2z5o0@bwsmanufacturingltd.slack.com'; -- Jamie
	--SET @persons = @persons + ';' + 's1p7r9u7n8b9a9z5@bwsmanufacturingltd.slack.com'; -- Caleb
	--SET @persons = @persons + ';' + 'it@bwstrailers.com'; -- BWS IT Shared Inbox

	SET @persons = (
		CASE WHEN
			@itr_requestby = 'Avery Briggs' THEN
				'q0y9o8w7x8v5o6b0@bwsmanufacturingltd.slack.com;avery.briggs@bwstrailers.com'
		WHEN
			@itr_requestby = 'James Crawford' THEN
				'v6l2a8z0e8u7x0k9@bwsmanufacturingltd.slack.com'
		WHEN
			@itr_requestby = 'Jamie Merrithew' THEN
				'o8u2z7g5f5h2z5o0@bwsmanufacturingltd.slack.com'
		WHEN
			@itr_requestby = 'Caleb Robinson' THEN
				's1p7r9u7n8b9a9z5@bwsmanufacturingltd.slack.com;caleb.robinson@bwstrailers.com'
	ELSE 'it@bwstrailers.com'
	END)

	--SET @persons = 'avery.briggs@bwstrailers.com'

	-- Set Subject and Body
	SET @subject = 'IT Request Assignment #' + RIGHT('000000' + @itr_id, 6);

	SET @body = '<!DOCTYPE html><html><body><div class="ITR Body" id="ITR Body ID 001"><h4>You have been assigned to an IT Request. Please see below:</h4><Table class="ITR Table" border="1" cellpadding = "5" cellspacing = "5"><thead><th colspan="2"><b>Request Assignment</b></th></thead><tbody><tr><td><b>Company:</b></td><td>'
	SET @body = @body + ISNULL(@itr_company, '-')
	SET @body = @body + '</td></tr><tr><td><b>Request Date:</b></td><td>'
	SET @body = @body + ISNULL(@itr_reqdate, '-')
	SET @body = @body + '</td></tr><tr><td><b>Requested / Assigned By:</b></td><td>'
	SET @body = @body + ISNULL(@itr_requestby, '-')
	SET @body = @body + '</td></tr><tr><td><b>Due Date:</b></td><td>'
	SET @body = @body + ISNULL(@itr_duedate, '-')
	SET @body = @body + '</td></tr><tr><td><b>Priority:</b></td><td>'
	SET @body = @body + ISNULL(@itr_priority, '-')
	SET @body = @body + '</td></tr><tr><td><b>Sub-Priority:</b></td><td>'
	SET @body = @body + ISNULL(@itr_subpriority, '-')
	SET @body = @body + '</td></tr><tr><td><b>Type:</b></td><td>'
	SET @body = @body + ISNULL(@itr_type, '-')
	SET @body = @body + '</td></tr><tr><td><b>Sub-Type:</b></td><td>'
	SET @body = @body + ISNULL(@itr_subtype, '-')
	SET @body = @body + '</td></tr><tr><td><b>Text:</b></td><td>'
	SET @body = @body + ISNULL(@itr_request, '-')
	SET @body = @body + '</td></tr><tr><td><b>Link:</b></td><td><a href="'
	SET @body = @body + ISNULL(@itr_directory, '-')
	SET @body = @body + '">Attachments</a></td></tr></tbody></Table></div></body><footer><h6>Note: Request attachments will be included in future emails once BWS has transitioned to Office 365.</h6></footer></html>'

	-- Send Email
	EXEC msdb.dbo.sp_send_dbmail 
		@recipients = @persons,
		@profile_name = 'SQL Agent',
		@subject = @subject, 
		@body = @body,
		@body_format='HTML'
		;
	SELECT 1 AS [Success];

END