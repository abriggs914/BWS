
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
ALTER TRIGGER [dbo].[tr_TEMP]
   ON  [dbo].[IT_TEMP]
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
		DECLARE @id AS INT;
		DECLARE @a AS INT;
		DECLARE @b AS INT;
		DECLARE @a_s AS NVARCHAR(MAX);
		DECLARE @b_s AS NVARCHAR(MAX);
		
		SELECT @id = [ID] FROM inserted i;
		SELECT @a = [A] FROM inserted i;
		SELECT @a_s = CAST(@a AS NVARCHAR(MAX));
		
		SELECT @b = 10 * @a;
		SELECT @b_s = CAST(@b AS NVARCHAR(MAX));

		-- Insert statements for trigger here
		IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) BEGIN
			SET @activity = 'UPDATE';
			SET @user = SYSTEM_USER;

			SELECT @body = 'Update on ID=' + @a_s + '.'
		END
		IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) BEGIN
			SET @activity = 'INSERT';
			SET @user = SYSTEM_USER;

			UPDATE
				[IT_TEMP]
			SET
				[B] = @b
			WHERE
				[ID] = @id

			SELECT @body = 'Insert on ID=' + @a_s + '.'

		END
		IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted) BEGIN 
			SET @activity = 'DELETE';
			SET @user = SYSTEM_USER;

			SELECT @body = 'Delete on ID=' + @a_s + '.'
		END

	END

	DECLARE @s AS NVARCHAR(MAX);
	SELECT @s = '';
	SELECT @persons = 'avery.briggs@bwstrailers.com';
	SELECT @subject = 'New Order Options';

	EXEC msdb.dbo.sp_send_dbmail 
		@recipients = 'avery.briggs@bwstrailers.com',
		@profile_name = 'SQL Agent',
		@subject = @subject, 
		@body = @body,
		@body_format='TEXT'
		--@body_format='HTML'
	;

END

