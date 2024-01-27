DECLARE @c INT = 0;
DECLARE @new_Quote NVARCHAR(MAX) = 'NEW_QUOTE'

DECLARE @emailMsg AS NVARCHAR(MAX) = '';
		SELECT @emailMsg = '@c = ' + CAST(ISNULL(@c, -1) AS NVARCHAR(MAX))
		SELECT @emailMsg = @emailMsg + '@newQuote = ' + CAST(ISNULL(@new_Quote, -1) AS NVARCHAR(MAX))
		SELECT @emailMsg = @emailMsg + ' When = ' + CAST(GETDATE() AS NVARCHAR(MAX))

		EXEC msdb.dbo.sp_send_dbmail
			@recipients = 'avery.briggs@bwstrailers.com',
					@profile_name = 'SQL Agent',
					@subject = 'Custom Work History Tracker', 
					@body = @emailMsg,
					@body_format='TEXT';