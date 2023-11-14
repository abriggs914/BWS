USE BWSdb
GO

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
CREATE TRIGGER  [dbo].[tr_OrdersV2UpdateProductID]
   ON [OrdersV2]
   --BEFORE
   AFTER
   --INSTEAD OF
   INSERT
   , DELETE
   , UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF TRIGGER_NESTLEVEL() < 2 BEGIN
	
		DECLARE @user NVARCHAR(20);
		DECLARE @activity NVARCHAR(20);

		DECLARE @quote NVARCHAR(MAX);
		DECLARE @oModelNo NVARCHAR(MAX);

		DECLARE @productID INT;
		SELECT @productID = -2;
		
		SELECT
			@quote = [I].[SGQuote]
			,@oModelNo = [I].[Model No]
		FROM
			INSERTED [I]
		;

		SELECT
			@productID = [IDTrailer]
		FROM
			[ProductsV2]
		WHERE
			[Model No] = @oModelNo

		-- Insert statements for trigger here
		IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) BEGIN
			SET @activity = 'UPDATE';
			SET @user = SYSTEM_USER;

			-- Check ID for newly updated record
			DECLARE @oldProductID INT;
			DECLARE @oldModelNo NVARCHAR(MAX);
			SELECT 
				@oldProductID = [ProductID]
				,@oldModelNo = [Model No]
			FROM
				[INSERTED] [I]
			;

			IF @productID <> ISNULL(@oldProductID, -1) BEGIN
				-- Update the quote with the correct productID
				UPDATE
					[OrdersV2]
				SET
					[ProductID] = @productID
				WHERE
					[SGQuote] = @quote
				;

				-- Notify me that the model look up caused a failure.
				DECLARE 
					@quoteS NVARCHAR(MAX)
					,@oldProductIDS NVARCHAR(MAX)
					,@productIDS NVARCHAR(MAX)
					,@body NVARCHAR(MAX);

				SELECT
					@quoteS = ISNULL(CAST(@quote AS NVARCHAR(MAX)), 'NULL')
					,@oldProductIDS = ISNULL(CAST(@oldProductID AS NVARCHAR(MAX)), 'NULL')
					,@productIDS = ISNULL(CAST(@productID AS NVARCHAR(MAX)), 'NULL')
				SELECT @body = '@quote=' + @quoteS + ' has had it''s [ProductID] value changed from (' + @oldProductIDS + ' -> ' + @productIDS + ').'

				-- Send Email
				EXEC msdb.dbo.sp_send_dbmail 
					@recipients = 'avery.briggs@bwstrailers.com',
					@profile_name = 'SQL Agent',
					@subject = 'ProductID Update Alert', 
					@body = @body,
					@body_format='TEXT'
					--@body_format='HTML'
					;
			END

		END
		IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) BEGIN
			SET @activity = 'INSERT';
			SET @user = SYSTEM_USER;
			
			-- Add ID for newly inserted record
			UPDATE
				[OrdersV2]
			SET
				[ProductID] = @productID
			WHERE
				[SGQuote] = @quote
			;
		END
		IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted) BEGIN 
			SET @activity = 'DELETE';
			SET @user = SYSTEM_USER;

			-- Do nothing
		END

	END
END
GO
