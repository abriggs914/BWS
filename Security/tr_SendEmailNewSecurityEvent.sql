-- ================================================
-- Template generated from Template Explorer using:
-- Create Trigger (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- See additional Create Trigger templates for more
-- examples of different Trigger statements.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[tr_SendEmailNewSecurityEvent]
   ON  [dbo].[SecurityLogV1]
   AFTER INSERT
AS 
BEGIN

DECLARE @ws AS NVARCHAR(MAX) = '                                           ';
DECLARE @persons AS NVARCHAR(MAX);
DECLARE @subject AS NVARCHAR(255);
DECLARE @body AS NVARCHAR(MAX);

DECLARE @se_id AS NVARCHAR(6);
DECLARE @se_date AS NVARCHAR(11);
DECLARE @se_reportedBy AS NVARCHAR(255);
DECLARE @se_event AS NVARCHAR(255);
DECLARE @se_log AS NVARCHAR(MAX);
DECLARE @se_followUp AS NVARCHAR(1);
DECLARE @se_followUpDate AS NVARCHAR(11);
DECLARE @se_followUpComplete AS NVARCHAR(1);

SELECT @se_id =					CAST([LogID] AS NVARCHAR(6)) FROM INSERTED i;
SELECT @se_date =				CAST([LogDate] AS NVARCHAR(11)) FROM INSERTED i;
SELECT @se_reportedBy =			[ReportedBy] FROM INSERTED i;
SELECT @se_event =				[Event] FROM [SecurityLogEventsV1] WHERE [EventID] = (SELECT [EventID] FROM INSERTED i);
SELECT @se_log =				[Log] FROM INSERTED i;
SELECT @se_followUp =			(CASE WHEN [FollowUp] IS NULL THEN '--' ELSE (CASE WHEN [FollowUp] = 1 THEN 'Y' ELSE 'N' END) END) FROM INSERTED i;
SELECT @se_followUpDate =		(CASE WHEN [FollowUpDate] IS NULL THEN '--' ELSE CAST([FollowUpDate] AS NVARCHAR(11)) END) FROM INSERTED i;
SELECT @se_followUpComplete =	(CASE WHEN [FollowUpComplete] IS NULL THEN '--' ELSE (CASE WHEN [FollowUpComplete] = 1 THEN 'Y' ELSE 'N' END) END) FROM INSERTED i;

-- Enter Recipients
--SET @persons = 'q0y9o8w7x8v5o6b0@bwsmanufacturingltd.slack.com'; -- Avery
--SET @persons = @persons + ';' + 'v6l2a8z0e8u7x0k9@bwsmanufacturingltd.slack.com'; -- James
--SET @persons = @persons + ';' + 'o8u2z7g5f5h2z5o0@bwsmanufacturingltd.slack.com'; -- Jamie

SET @persons = 'avery.briggs@bwstrailers.com'

-- Set Subject and Body
SET @subject = 'New Security Event #' + RIGHT('000000' + @se_id, 6);

SET @body = '<!DOCTYPE html><html><body><div class="Security Body" id="Security Body ID 001" ><Table class="Security Table" border="1" cellpadding = "5" cellspacing = "5"><thead><th colspan="2"><b>Event</b></th></thead><tbody><tr><td><b>Date:</b></td><td>'
SET @body = @body + ISNULL(@se_date, '-')
SET @body = @body + '</td></tr><tr><td><b>Reported By:</b></td><td>'
SET @body = @body + ISNULL(@se_reportedBy, '-')
SET @body = @body + '</td></tr><tr><td><b>Event:</b></td><td>'
SET @body = @body + ISNULL(@se_event, '-')
SET @body = @body + '</td></tr><tr><td><b>Log:</b></td><td>'
SET @body = @body + ISNULL(@se_log, '-')
SET @body = @body + '</td></tr><tr><td><b>Follow-up:</b></td><td>'
SET @body = @body + ISNULL(@se_followUp, '-')
SET @body = @body + '</td></tr><tr><td><b>Follow-up Date:</b></td><td>'
SET @body = @body + ISNULL(@se_followUpDate, '-')
SET @body = @body + '</td></tr><tr><td><b>Follow-up Complete:</b></td><td>'
SET @body = @body + ISNULL(@se_followUpComplete, '-')
SET @body = @body + '</td></tr></tbody></Table></div></body><footer><h6>Note: Event attachments will be included in future emails once BWS has transitioned to Office 365.</h6></footer></html>'

-- Send Email
EXEC msdb.dbo.sp_send_dbmail 
	@recipients = @persons,
	@profile_name = 'SQL Agent',
	@subject = @subject, 
	@body = @body,
	@body_format='HTML'
	;

END
GO
