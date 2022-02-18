USE [BWSdb]
GO

/****** Object:  Trigger [SendEmailUpdatedITRequest]    Script Date: 2022-02-18 4:18:57 PM ******/
DROP TRIGGER [dbo].[tr_SendEmailUpdatedITRequest]
GO

/****** Object:  Trigger [dbo].[SendEmailUpdatedITRequest]    Script Date: 2022-02-18 4:18:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[tr_SendEmailUpdatedITRequest]  
   ON  [dbo].[IT Requests] 
   AFTER UPDATE
AS 

BEGIN        
SET NOCOUNT ON;

DECLARE @ws AS NVARCHAR(MAX) = '                                           ';
DECLARE @persons AS NVARCHAR(MAX);
DECLARE @subject AS NVARCHAR(255);
DECLARE @body AS NVARCHAR(MAX);

DECLARE @itr_today AS NVARCHAR(11);
DECLARE @itr_id AS NVARCHAR(6);
DECLARE @itr_duedate AS NVARCHAR(11);
DECLARE @itr_request AS NVARCHAR(MAX);
DECLARE @itr_requestby AS NVARCHAR(255);
DECLARE @itr_priority AS NVARCHAR(2);
DECLARE @itr_subpriority AS NVARCHAR(2);
DECLARE @itr_type AS NVARCHAR(255);
DECLARE @itr_subtype AS NVARCHAR(255);
DECLARE @itr_company AS NVARCHAR(25);
DECLARE @itr_directory AS NVARCHAR(255);
DECLARE @itr_comments AS NVARCHAR(MAX);

DECLARE @itr_status_old AS NVARCHAR(255);
DECLARE @itr_status_new AS NVARCHAR(255);

SELECT @itr_today =			CAST(GETDATE() AS NVARCHAR(11));
SELECT @itr_id =			CAST([ITRequestID#] AS NVARCHAR(6)) FROM INSERTED i;
SELECT @itr_duedate =		CAST([DueDate] AS NVARCHAR(11)) FROM INSERTED i;
SELECT @itr_request =		[Request] FROM INSERTED i;
SELECT @itr_requestby =		[RequestedBy] FROM INSERTED i;
SELECT @itr_priority =		[Priority] FROM INSERTED i;
SELECT @itr_subpriority =	[SubPriority] FROM INSERTED i;
SELECT @itr_type =			[RequestType] FROM INSERTED i;
SELECT @itr_subtype =		[RequestSubType] FROM INSERTED i;
SELECT @itr_company =		[Company] FROM INSERTED i;
SELECT @itr_directory =		[Directory] FROM INSERTED i;
SELECT @itr_comments =		[Comments] FROM INSERTED i;

SELECT @itr_status_old =	[Status] FROM DELETED d;
SELECT @itr_status_new =	[Status] FROM INSERTED i;

IF @itr_status_old <> @itr_status_new BEGIN

	-- ITR #
	-- Date
	-- Due Date
	-- Request
	-- Priority
	-- SubPriority
	-- Request Type
	-- Request SubType
	-- Company
	-- Directory

	SET @subject = 'Updated IT Request #' + RIGHT('000000' + @itr_id, 6);

	SET @body = '<!DOCTYPE html><html><body><div class="ITR Body" id="ITR Body ID 001" ><Table class="ITR Table" border="1" cellpadding = "5" cellspacing = "5"><thead><th colspan="2"><b>Request</b></th></thead><tbody><tr><td><b>Request Date:</b></td><td>'
	SET @body = @body + @itr_today
	SET @body = @body + '</td></tr><tr><td><b>Requested By:</b></td><td>'
	SET @body = @body + @itr_requestby
	SET @body = @body + '</td></tr><tr><td><b>Due Date:</b></td><td>'
	SET @body = @body + @itr_duedate
	SET @body = @body + '</td></tr><tr><td><b>Priority:</b></td><td>'
	SET @body = @body + @itr_priority
	SET @body = @body + '</td></tr><tr><td><b>Sub-Priority:</b></td><td>'
	SET @body = @body + @itr_subpriority
	SET @body = @body + '</td></tr><tr></tr><td><b>Type:</b></td><td>'
	SET @body = @body + @itr_type
	SET @body = @body + '</td></tr><tr><td><b>Sub-Type:</b></td><td>'
	SET @body = @body + @itr_subtype
	SET @body = @body + '</td></tr><tr><td><b>Status (Old):</b></td><td>'
	SET @body = @body + @itr_status_old
	SET @body = @body + '</td></tr><tr><td><b>Status (New):</b></td><td>'
	SET @body = @body + @itr_status_new
	SET @body = @body + '</td></tr><tr><td><b>Text:</b></td><td>'
	SET @body = @body + @itr_request
	SET @body = @body + '</td></tr><tr><td><b>Comments:</b></td><td>'
	SET @body = @body + @itr_comments
	SET @body = @body + '</td></tr><tr><td><b>Link:</b></td><td><a href="'
	SET @body = @body + @itr_directory
	SET @body = @body + '">Attachments</a></td></tr></tbody></Table></div></body><footer><h6>Note: Request attachments will be included in future emails once BWS has transitioned to Office 365.</h6></footer></html>'

	SELECT @persons = 'q0y9o8w7x8v5o6b0@bwsmanufacturingltd.slack.com'; -- Avery
	SELECT @persons = @persons + ';' + 'v6l2a8z0e8u7x0k9@bwsmanufacturingltd.slack.com'; -- James
	SELECT @persons = @persons + ';' + 'o8u2z7g5f5h2z5o0@bwsmanufacturingltd.slack.com'; -- Jamie

	EXEC msdb.dbo.sp_send_dbmail
		@recipients = @persons,
		@profile_name = 'SQL Agent',
		@subject = @subject, 
		@body = @body,@body_format='HTML';
	END
END
GO

ALTER TABLE [dbo].[IT Requests] ENABLE TRIGGER [tr_SendEmailUpdatedITRequest]
GO


