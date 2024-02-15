USE BWSdb
GO

DECLARE @itr_id AS INTEGER;
DECLARE @itr_didUpdate AS BIT;
DECLARE @doSend AS BIT;
DECLARE @itr_status_old AS NVARCHAR(255);
DECLARE @itr_status_new AS NVARCHAR(255);


/*
SELECT @itr_id =			[ITRequestID#] FROM INSERTED i;
SELECT @itr_status_old =	[Status] FROM DELETED d;
SELECT @itr_status_new =	[Status] FROM INSERTED i;
SELECT @itr_didUpdate =		(CASE WHEN @itr_status_old <> @itr_status_new THEN 1 ELSE 0 END);
*/
SELECT 
	@itr_id = 25
	,@doSend = 0
	,@itr_status_old = 'Complete'
	,@itr_status_new = 'Declined'
;
SELECT @itr_didUpdate =	(CASE WHEN @itr_status_old <> @itr_status_new THEN 1 ELSE 0 END);


--EXEC [dbo].[sp_ITRSendEmailUpdatedITRequestColoured]
--	@reqID=1522,
--	@oldStatus='Complete',
--	@newStatus='Declined',
--	@didUpdate=1,
--	@doSend=0,
--	@tableOnly=0
	
DECLARE @consumeResult TABLE (
	[ColourOldStatus] NVARCHAR(MAX)
	,[ColourNewStatus] NVARCHAR(MAX)
	,[Persons] NVARCHAR(MAX)
	,[Body] NVARCHAR(MAX)
	,[Subject] NVARCHAR(MAX)
);
--INSERT INTO @consumeResult ([Body]) VALUES ('<!DOCTYPE html><html><body><div class="ITR Body" id="ITR Body ID 001" >')
INSERT INTO @consumeResult
EXEC [dbo].[sp_ITRSendEmailUpdatedITRequestColoured]
	@reqID=@itr_id,
	@oldStatus=@itr_status_old,
	@newStatus=@itr_status_new,
	@didUpdate=@itr_didUpdate,
	@doSend=@doSend,
	@tableOnly=1

SELECT
	[Body]
FROM
	@consumeResult

/*
DECLARE @emailMsg NVARCHAR(MAX) = '';
DECLARE @emailFmt NVARCHAR(MAX) = 'HTML';
DECLARE @now DATETIME = GETDATE();
DECLARE @s_now NVARCHAR(MAX) = CAST(@now AS NVARCHAR(MAX));

SELECT @emailMsg = '<html>';
SELECT @emailMsg = @emailMsg + '<body>';
SELECT @emailMsg = @emailMsg + '<h1>IT Request Reminders</h1>';
SELECT @emailMsg = @emailMsg + '<h5>' + @s_now + '</h5>';
SELECT @emailMsg = @emailMsg + '</body>';
SELECT @emailMsg = @emailMsg + '</html>';

EXEC msdb.dbo.sp_send_dbmail
	@recipients = 'avery.briggs@bwstrailers.com',
	@profile_name = 'SQL Agent',
	@subject = 'ITR Request ' + @ITR + ' Reminder', 
	@body = @emailMsg,
	@body_format=@emailFmt;
*/