USE [BWSdb]
GO
/****** Object:  Trigger [dbo].[tr_SendEmailNewITRequest]    Script Date: 2022-05-10 10:23:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_ITRSendEmailUpdateDBs]
	@dbStr AS NVARCHAR(MAX),
	@commentStr AS NVARCHAR(MAX),
	@user AS NVARCHAR(MAX)
AS 
BEGIN        

	SET NOCOUNT ON;
	
	DECLARE @dbs AS TABLE([idx] INT, [DB] NVARCHAR(MAX));
	INSERT INTO @dbs SELECT * FROM [BWSdb].[dbo].[split_string_idx](@dbStr, ';');
	DECLARE @comments AS TABLE([idx] INT, [Comment] NVARCHAR(MAX));
	INSERT INTO @comments SELECT * FROM [BWSdb].[dbo].[split_string_idx](@commentStr, ';');
	DECLARE @lenA AS INT;
	DECLARE @lenB AS INT;
	DECLARE @i AS INT;
	
	SELECT @lenA = COUNT(*) FROM @dbs;
	SELECT @lenB = COUNT(*) FROM @comments;

	DECLARE @ws AS NVARCHAR(MAX) = '                                           ';
	DECLARE @persons AS NVARCHAR(MAX);
	DECLARE @subject AS NVARCHAR(255);
	DECLARE @body AS NVARCHAR(MAX);
	DECLARE @fmtDate AS NVARCHAR(MAX);
	DECLARE @fmtTime AS NVARCHAR(MAX);

	DECLARE @today AS DATETIME
	SET @today = GETDATE()

	SET @fmtDate = LEFT(DATENAME(WEEKDAY, @today), 3) + (CASE WHEN LEN(LEFT(DATENAME(WEEKDAY, @today), 3)) = LEN(DATENAME(WEEKDAY, @today)) THEN '' ELSE '.' END) + ' ' + DATENAME(MONTH, @today) + ' ' + DATENAME(DAY, @today) + (
		CASE WHEN
			RIGHT(DATENAME(DAY, @today), 1) = '1' THEN
				(CASE WHEN
					LEFT(RIGHT('00' + DATENAME(DAY, @today), 2), 1) = '1' THEN
						'th' 
					ELSE
						'st'
				END)
			WHEN 
				RIGHT(DATENAME(DAY, @today), 1) = '2' THEN
				(CASE WHEN
					LEFT(RIGHT('00' + DATENAME(DAY, @today), 2), 1) = '1' THEN
						'th' 
					ELSE
						'nd'
				END)
			WHEN 
				RIGHT(DATENAME(DAY, @today), 1) = '3' THEN
				(CASE WHEN
					LEFT(RIGHT('00' + DATENAME(DAY, @today), 2), 1) = '1' THEN
						'th' 
					ELSE
						'rd'
				END)
			ELSE 'th' 
		END) + ' ' + DATENAME(YEAR, @today);
	SET @fmtTime = (CASE WHEN DATENAME(HOUR, @today) = '0' THEN '12' ELSE DATENAME(HOUR, @today) END) + ':' + RIGHT('00' + DATENAME(MINUTE, @today), 2) + ' ' + CASE WHEN DATEPART(HOUR, @today) > 11 THEN 'PM' ELSE 'AM' END

	SET @subject = 'New Access DB changes to review!';

	-- Enter Recipients Slackbot
	SET @persons = 'q0y9o8w7x8v5o6b0@bwsmanufacturingltd.slack.com'; -- Avery
	SET @persons = @persons + ';' + 'v6l2a8z0e8u7x0k9@bwsmanufacturingltd.slack.com'; -- James
	--SET @persons = @persons + ';' + 'o8u2z7g5f5h2z5o0@bwsmanufacturingltd.slack.com'; -- Jamie
	--SET @persons = @persons + ';' + 's1p7r9u7n8b9a9z5@bwsmanufacturingltd.slack.com'; -- Caleb

	-- BWS Email
	SET @persons = @persons + ';' + 'avery.briggs@bwstrailers.com'; -- Avery
	SET @persons = @persons + ';' + 'james.crawford@bwstrailers.com'; -- James
	--SET @persons = @persons + ';' + 'jamie.merrithew@bwstrailers.com'; -- Jamie
	--SET @persons = @persons + ';' + 'caleb.robinson@bwstrailers.com'; -- Caleb

	SET @body = '<!DOCTYPE html><html><head><title>Database Update Notification</title></head><body><h2>New Access Datebase Updates!</h2><p>'
	SET @body = @body + @user 
	SET @body = @body + ' has new updates queued for production for the following databases.</p><table border="1" cellpadding = "5" cellspacing = "5"><thead><th colspan="2">Database Changes:</th></thead><tr><td>Date</td><td>'
	SET @body = @body + @fmtDate
	SET @body = @body + '</td></tr><tr><td>Time</td><td>'
	SET @body = @body + @fmtTime
	SET @body = @body + '</td></tr>'

	SET @i = 0;
	WHILE @i < @lenA BEGIN
		SET @body = @body + '<tr><td>'
		SET @body = @body + (SELECT [DB] FROM @dbs WHERE [idx] = @i)
		SET @body = @body + '</td><td>'
		IF @i < @lenB BEGIN
			SET @body = @body + (SELECT (CASE WHEN [Comment] IS NULL OR LEN([Comment]) = 0 THEN '-' ELSE [Comment] END) FROM @comments WHERE [idx] = @i)
		END
		ELSE BEGIN
			SET @body = @body + '-'
		END
		SET @body = @body + '</td></tr>'
		SET @i = @i + 1;
	END

	SET @body = @body + '</table><p>Please let '
	SET @body = @body + @user
	SET @body = @body + ' know <b>IMMEDIATELY</b> if there is any reason that these updates cannot be pushed to production!</p></body></html>'

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