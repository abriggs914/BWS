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
ALTER TRIGGER [dbo].[tr_UpdateActiveDates]
   ON [Discounts]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	
		
	DECLARE @newActive AS BIT;
	DECLARE @oldActive AS BIT;
	
	DECLARE @user NVARCHAR(20);
	DECLARE @activity NVARCHAR(20);
	
	IF TRIGGER_NESTLEVEL() < 2 BEGIN
	
		-- Insert statements for trigger here
		IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) BEGIN
			SET @activity = 'UPDATE';
			SET @user = SYSTEM_USER;
			SELECT @newActive = [Active] FROM inserted i
			SELECT @oldActive = [Active] FROM deleted d

			IF @newActive <> @oldActive BEGIN
				UPDATE
					[Discounts]
				SET
					[DateActive] = (CASE WHEN @newActive = 1 THEN GETDATE() ELSE [DateActive] END)
					, [DateInactive] = (CASE WHEN @newActive = 0 THEN GETDATE() ELSE [DateInactive] END)
					,[LastUpdated] = GETDATE()
			END

		END

		IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) BEGIN
			SET @activity = 'INSERT';
			SET @user = SYSTEM_USER;

			SELECT @newActive = [Active] FROM inserted i
			UPDATE
				[Discounts]
			SET
				[DateActive] = (CASE WHEN @newActive = 1 THEN GETDATE() ELSE [DateActive] END)
				, [DateInactive] = (CASE WHEN @newActive = 0 THEN GETDATE() ELSE [DateInactive] END)
					,[LastUpdated] = GETDATE()
		END

		IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted) BEGIN 
			SET @activity = 'DELETE';
			SET @user = SYSTEM_USER;
		END
	END
END
GO
