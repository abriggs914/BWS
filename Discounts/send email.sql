USE BWSdb
GO


	
	DECLARE @newDiscountID AS INT;
	DECLARE @oldDiscountID AS INT;
	DECLARE @editor AS NVARCHAR(255);
	DECLARE @quote INT;
	DECLARE @defaultDiscount AS INT;
	DECLARE @productID AS INT;
	DECLARE @dealerID AS INT;
	DECLARE @modelName AS NVARCHAR(255);


	SELECT @quote = 28448;
	SELECT @modelName = [model no] FROM [Orders] WHERE [Quote#] = @quote
	SELECT @newDiscountID = [DiscountID] FROM [Orders] WHERE [Quote#] = @quote


DECLARE @s AS NVARCHAR(MAX);
		SELECT @s = '';
	
		DECLARE @persons AS NVARCHAR(MAX);
		DECLARE @subject AS NVARCHAR(MAX);
		DECLARE @body AS NVARCHAR(MAX);
		SELECT @persons = 'avery.briggs@bwstrailers.com';
		SELECT @subject = 'New Order Discount';
		SELECT @body = '<!DOCTYPE html><html><body><div class="ITR Body" id="ITR Body ID 001" ><p>@Quote= "' +
				CAST(ISNULL(@quote, -1) AS NVARCHAR(MAX)) +
				'", @ModelNo="' + CAST(ISNULL(@modelName, 'N/A') AS NVARCHAR(MAX)) + '"</p>' +
				ISNULL(@s, '')
				+ ', </div></body><footer></footer></html>';

		SELECT @body AS [@body], @s AS [@s]
		--SELECT * FROM @t_to_update

		-- Send Email
		EXEC msdb.dbo.sp_send_dbmail 
			@recipients = @persons,
			@profile_name = 'SQL Agent',
			@subject = @subject, 
			@body = @body,
			--@body_format='TEXT'
			@body_format='HTML'
			;