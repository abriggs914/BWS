DECLARE @quote INT;
DECLARE @oldProductID INT;
DECLARE @productID INT;

DECLARE 
	@quoteS NVARCHAR(MAX)
	,@oldProductIDS NVARCHAR(MAX)
	,@productIDS NVARCHAR(MAX)
	,@body NVARCHAR(MAX);

SELECT
	@quoteS = ISNULL(CAST(@quote AS NVARCHAR(MAX)), '__QUOTE__')
	,@oldProductIDS = ISNULL(CAST(@oldProductID AS NVARCHAR(MAX)), '__PRODUCTIDOLD__')
	,@productIDS = ISNULL(CAST(@oldProductID AS NVARCHAR(MAX)), '__PRODUCTIDNEW__')
SELECT @body = '@quote="' + @quoteS + '" Has had it''s [ProductID] value changed from (' + @oldProductIDS + ' -> ' + @productIDS + ').'

				--SELECT @body = '@quote="' + CAST(ISNULL(@quote, '__QUOTE__') AS NVARCHAR(MAX)) + '" Has had it''s [ProductID] value changed from (' + CAST(ISNULL(@oldProductID, '__PRODUCTIDOLD__') AS NVARCHAR(MAX)) + ' -> ' + CAST(ISNULL(@productID, '__PRODUCTIDNEW__') AS NVARCHAR(MAX)) + ').'
				-- Send Email

SELECT @body


				EXEC msdb.dbo.sp_send_dbmail 
					@recipients = 'avery.briggs@bwstrailers.com',
					@profile_name = 'SQL Agent',
					@subject = 'ProductID Update Alert', 
					@body = @body,
					--@body_format='TEXT'
					@body_format='HTML'
					;