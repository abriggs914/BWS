USE [BWSdb]
GO

ALTER PROCEDURE [dbo].[sp_ITRNewRequestHTML]
	@tid AS BIGINT
AS BEGIN

SET NOCOUNT ON;

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

SELECT @itr_today =			CAST(GETDATE() AS NVARCHAR(11));
SELECT @itr_id =			CAST(@tid AS NVARCHAR(6));
SELECT @itr_duedate =		CAST([DueDate] AS NVARCHAR(11)) FROM [IT Requests] WHERE [ITRequestID#] = @tid;
SELECT @itr_request =		[Request] FROM [IT Requests] WHERE [ITRequestID#] = @tid;
SELECT @itr_requestby =		[RequestedBy] FROM [IT Requests] WHERE [ITRequestID#] = @tid;
SELECT @itr_priority =		[Priority] FROM [IT Requests] WHERE [ITRequestID#] = @tid;
SELECT @itr_subpriority =	[SubPriority] FROM [IT Requests] WHERE [ITRequestID#] = @tid;
SELECT @itr_type =			[RequestType] FROM [IT Requests] WHERE [ITRequestID#] = @tid;
SELECT @itr_subtype =		[RequestSubType] FROM [IT Requests] WHERE [ITRequestID#] = @tid;
SELECT @itr_company =		[Company] FROM [IT Requests] WHERE [ITRequestID#] = @tid;
SELECT @itr_directory =		[Directory] FROM [IT Requests] WHERE [ITRequestID#] = @tid;


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
SET @body = @body + '</td></tr><tr><td><b>Type:</b></td><td>'
SET @body = @body + @itr_type
SET @body = @body + '</td></tr><tr><td><b>Sub-Type:</b></td><td>'
SET @body = @body + @itr_subtype
SET @body = @body + '</td></tr><tr><td><b>Text:</b></td><td>'
SET @body = @body + @itr_request
SET @body = @body + '</td></tr><tr><td><b>Link:</b></td><td><a href="'
SET @body = @body + @itr_directory
SET @body = @body + '">Attachments</a></td></tr></tbody></Table></div></body><footer><h6>Note: Request attachments will be included in future emails once BWS has transitioned to Office 365.</h6></footer></html>'


--EXEC msdb.dbo.sp_send_dbmail
--	--@recipients = 'avery.briggs@bwstrailers.com; james.crawford@bwstrailers.com', 
--	@recipients = @persons,
--	@profile_name = 'SQL Agent',
--	@subject = @subject, 
--	@body = @body,@body_format='HTML';
--END

SELECT 
	@body AS [Body]

END