USE [BWSdb]
GO
/****** Object:  Trigger [dbo].[tr_SendEmailNewITRequest]    Script Date: 2022-02-22 8:19:44 AM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO


--ALTER TRIGGER [dbo].[tr_SendEmailNewITRequest]  
--   ON  [dbo].[IT Requests] 
--   AFTER INSERT
--AS 

--BEGIN        
SET NOCOUNT ON;

DECLARE @ws AS NVARCHAR(MAX) = '                                           ';
DECLARE @persons AS NVARCHAR(MAX);
DECLARE @subject AS NVARCHAR(255);
DECLARE @body1 AS NVARCHAR(MAX);
DECLARE @body2 AS NVARCHAR(MAX);

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

DECLARE @itr_status_old AS NVARCHAR(255);
DECLARE @itr_status_new AS NVARCHAR(255);
DECLARE @itr_comments AS NVARCHAR(MAX);

--[IT Requests] WHERE [ITRequestID#] = 100

SELECT @itr_today =			CAST(GETDATE() AS NVARCHAR(11));
SELECT @itr_id =			CAST([ITRequestID#] AS NVARCHAR(6)) FROM [IT Requests] WHERE [ITRequestID#] = 100;
SELECT @itr_duedate =		CAST([DueDate] AS NVARCHAR(11)) FROM [IT Requests] WHERE [ITRequestID#] = 100;
SELECT @itr_request =		[Request] FROM [IT Requests] WHERE [ITRequestID#] = 100;
SELECT @itr_requestby =		[RequestedBy] FROM [IT Requests] WHERE [ITRequestID#] = 100;
SELECT @itr_priority =		[Priority] FROM [IT Requests] WHERE [ITRequestID#] = 100;
SELECT @itr_subpriority =	[SubPriority] FROM [IT Requests] WHERE [ITRequestID#] = 100;
SELECT @itr_type =			[RequestType] FROM [IT Requests] WHERE [ITRequestID#] = 100;
SELECT @itr_subtype =		[RequestSubType] FROM [IT Requests] WHERE [ITRequestID#] = 100;
SELECT @itr_company =		[Company] FROM [IT Requests] WHERE [ITRequestID#] = 100;
SELECT @itr_directory =		[Directory] FROM [IT Requests] WHERE [ITRequestID#] = 100;

SELECT @itr_status_old =	'In Progress';
SELECT @itr_status_new =	'Queued';
SELECT @itr_comments =		'No Comment';

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

SET @subject = 'New IT Request #' + RIGHT('000000' + @itr_id, 6);

SET @body1 = '<!DOCTYPE html><html><body><div class="ITR Body" id="ITR Body ID 001" ><Table class="ITR Table" border="1" cellpadding = "5" cellspacing = "5"><thead><th colspan="2"><b>Request</b></th></thead><tbody><tr><td><b>Request Date:</b></td><td>'
SET @body1 = @body1 + @itr_today
SET @body1 = @body1 + '</td></tr><tr><td><b>Requested By:</b></td><td>'
SET @body1 = @body1 + @itr_requestby
SET @body1 = @body1 + '</td></tr><tr><td><b>Due Date:</b></td><td>'
SET @body1 = @body1 + @itr_duedate
SET @body1 = @body1 + '</td></tr><tr><td><b>Priority:</b></td><td>'
SET @body1 = @body1 + @itr_priority
SET @body1 = @body1 + '</td></tr><tr><td><b>Sub-Priority:</b></td><td>'
SET @body1 = @body1 + @itr_subpriority
SET @body1 = @body1 + '</td></tr><tr><td><b>Type:</b></td><td>'
SET @body1 = @body1 + @itr_type
SET @body1 = @body1 + '</td></tr><tr><td><b>Sub-Type:</b></td><td>'
SET @body1 = @body1 + @itr_subtype
SET @body1 = @body1 + '</td></tr><tr><td><b>Text:</b></td><td>'
SET @body1 = @body1 + @itr_request
SET @body1 = @body1 + '</td></tr><tr><td><b>Link:</b></td><td><a href="'
SET @body1 = @body1 + @itr_directory
SET @body1 = @body1 + '">Attachments</a></td></tr></tbody></Table></div></body><footer><h6>Note: Request attachments will be included in future emails once BWS has transitioned to Office 365.</h6></footer></html>'

SELECT @persons = 'q0y9o8w7x8v5o6b0@bwsmanufacturingltd.slack.com'; -- Avery
SELECT @persons = @persons + ';' + 'v6l2a8z0e8u7x0k9@bwsmanufacturingltd.slack.com'; -- James
SELECT @persons = @persons + ';' + 'o8u2z7g5f5h2z5o0@bwsmanufacturingltd.slack.com'; -- Jamie



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

	SET @body2 = '<!DOCTYPE html><html><body><div class="ITR Body" id="ITR Body ID 001" ><Table class="ITR Table" border="1" cellpadding = "5" cellspacing = "5"><thead><th colspan="2"><b>Request</b></th></thead><tbody><tr><td><b>Request Date:</b></td><td>'
	SET @body2 = @body2 + @itr_today
	SET @body2 = @body2 + '</td></tr><tr><td><b>Requested By:</b></td><td>'
	SET @body2 = @body2 + @itr_requestby
	SET @body2 = @body2 + '</td></tr><tr><td><b>Due Date:</b></td><td>'
	SET @body2 = @body2 + @itr_duedate
	SET @body2 = @body2 + '</td></tr><tr><td><b>Priority:</b></td><td>'
	SET @body2 = @body2 + @itr_priority
	SET @body2 = @body2 + '</td></tr><tr><td><b>Sub-Priority:</b></td><td>'
	SET @body2 = @body2 + @itr_subpriority
	SET @body2 = @body2 + '</td></tr><tr></tr><td><b>Type:</b></td><td>'
	SET @body2 = @body2 + @itr_type
	SET @body2 = @body2 + '</td></tr><tr><td><b>Sub-Type:</b></td><td>'
	SET @body2 = @body2 + @itr_subtype
	SET @body2 = @body2 + '</td></tr><tr><td><b>Status (Old):</b></td><td>'
	SET @body2 = @body2 + @itr_status_old
	SET @body2 = @body2 + '</td></tr><tr><td><b>Status (New):</b></td><td>'
	SET @body2 = @body2 + @itr_status_new
	SET @body2 = @body2 + '</td></tr><tr><td><b>Text:</b></td><td>'
	SET @body2 = @body2 + @itr_request
	SET @body2 = @body2 + '</td></tr><tr><td><b>Comments:</b></td><td>'
	SET @body2 = @body2 + @itr_comments
	SET @body2 = @body2 + '</td></tr><tr><td><b>Link:</b></td><td><a href="'
	SET @body2 = @body2 + @itr_directory
	SET @body2 = @body2 + '">Attachments</a></td></tr></tbody></Table></div></body><footer><h6>Note: Request attachments will be included in future emails once BWS has transitioned to Office 365.</h6></footer></html>'

	SELECT @persons = 'q0y9o8w7x8v5o6b0@bwsmanufacturingltd.slack.com'; -- Avery
	SELECT @persons = @persons + ';' + 'v6l2a8z0e8u7x0k9@bwsmanufacturingltd.slack.com'; -- James
	SELECT @persons = @persons + ';' + 'o8u2z7g5f5h2z5o0@bwsmanufacturingltd.slack.com'; -- Jamie


--EXEC msdb.dbo.sp_send_dbmail
--	--@recipients = 'avery.briggs@bwstrailers.com; james.crawford@bwstrailers.com', 
--	@recipients = @persons,
--	@profile_name = 'SQL Agent',
--	@subject = @subject, 
--	@body = @body,@body_format='HTML';
----END

END

SELECT @body1 AS [Body]
SELECT @body2 AS [Body]
