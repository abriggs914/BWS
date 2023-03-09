USE [BWSdb]
GO
/****** Object:  Trigger [dbo].[tr_UpdateOrderDiscounts]    Script Date: 2023-03-06 11:55:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[tr_AddNoneNPOV2]
   ON  [dbo].[OrdersV2]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF TRIGGER_NESTLEVEL() < 2 BEGIN
	
		DECLARE @user NVARCHAR(20);
		DECLARE @activity NVARCHAR(20);
	
		DECLARE @persons AS NVARCHAR(MAX);
		DECLARE @subject AS NVARCHAR(MAX);
		DECLARE @body AS NVARCHAR(MAX);
		DECLARE @quote AS NVARCHAR(MAX);
		DECLARE @nc AS INT;
		DECLARE @ds AS BIT;
		
		SELECT @quote = [SGQuote] FROM inserted i;
		SELECT @nc = COUNT(*) FROM [Custom WorkV2] WHERE [SGQuote] = @quote;
	
		SELECT @ds = 0;
		SELECT @body = 'N/A';

		-- Insert statements for trigger here
		IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) BEGIN
			SET @activity = 'UPDATE';
			SET @user = SYSTEM_USER;
			SELECT @body = 'Update on quote=' + @quote + '.'

			IF @nc = 0 BEGIN
				SELECT @body = @body + ' Inserted new record'
				SELECT @ds = 1;
				INSERT INTO
					[Custom WorkV2]
				(
					[Quote Date]
					,[SGQuote]
					,[Order Date]
					,[WO#]
					,[Section]
					,[SortSe]
					,[Description]
					,[Qty]
				)
				SELECT
					[i].[Quote Date]
					,[i].[SGQuote]
					,[i].[Order Date]
					,[i].[WO#]
					,NULL
					,NULL
					,'None'
					,1
				FROM
					INSERTED i
			END
			ELSE BEGIN
				SELECT @body = @body + ' nc=' + CAST(@nc AS nvarchar(MAX))
			END

		END
		IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) BEGIN
			SET @activity = 'INSERT';
			SET @user = SYSTEM_USER;

			INSERT INTO
				[Custom WorkV2]
			(
				[Quote Date]
			   ,[SGQuote]
			   ,[Order Date]
			   ,[WO#]
			   ,[Section]
			   ,[SortSe]
			   ,[Description]
			   ,[Qty]
			)
			SELECT
				[i].[Quote Date]
			   ,[i].[SGQuote]
			   ,[i].[Order Date]
			   ,[i].[WO#]
			   ,NULL
			   ,NULL
			   ,'None'
			   ,1
			FROM
				INSERTED i

			SELECT @body = 'Insert on quote=' + @quote + '.'
			SELECT @body = @body + ' Inserted new record'

		END
		IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted) BEGIN 
			SET @activity = 'DELETE';
			SET @user = SYSTEM_USER;

			SELECT @body = 'Delete on quote=' + @quote + '.'
		END

		DECLARE @s AS NVARCHAR(MAX);
		SELECT @s = '';
		SELECT @persons = 'avery.briggs@bwstrailers.com';
		SELECT @subject = 'New Order @quote="' + @quote + '"';

		IF @ds = 1 BEGIN

			EXEC msdb.dbo.sp_send_dbmail 
				@recipients = 'avery.briggs@bwstrailers.com',
				@profile_name = 'SQL Agent',
				@subject = @subject, 
				@body = @body,
				@body_format='TEXT'
				--,
				--@copy_recipients=NULL,
				--@blind_copy_recipients=NULL,
				--@importance=NULL,
				--@sensitivity=NULL,
				--@file_attachments=NULL,
				--@query=NULL,
				--@execute_query_database=NULL,
				--@attach_query_result_as_file=NULL,
				--@query_attachment_filename=NULL,
				--@query_result_header=NULL,
				--@query_result_width=NULL,
				--@query_result_separator=NULL,
				--@exclude_query_output=NULL,
				--@append_query_error=NULL,
				--@query_no_truncate=NULL,
				--@query_result_no_padding=NULL,
				--@mailitem_id=NULL,
				--@from_address=NULL,
				--@reply_to=NULL
				----@body_format='HTML'
			;
		END

	END

END
