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
CREATE TRIGGER [tr_ITFFlagTypesUpdateActive]
   ON  [ITF FlagTypes]
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

    -- Insert statements for trigger hereSET NOCOUNT ON;

	-- In vars
	DECLARE @in_id AS INT;
	DECLARE @in_dateCreated AS DATETIME;
	DECLARE @in_active AS BIT;

	-- Out vars
	DECLARE @out_active AS BIT;

	-- working vars
	DECLARE @new_activity AS BIT;

	SELECT 
		@in_id = i.[ID]
		, @in_dateCreated = i.[DateCreated]
		, @in_active = ISNULL(i.[Active], 1)
	FROM
		inserted i
	;

	SELECT 
		@out_active = d.[Active]
	FROM
		deleted d
	;

	SELECT @new_activity = (CASE WHEN @in_active = @out_active THEN 0 ELSE 1 END);

	IF TRIGGER_NESTLEVEL() < 2 BEGIN
	
		DECLARE @user NVARCHAR(20);
		DECLARE @activity NVARCHAR(20);

		-- Insert statements for trigger here
		IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) BEGIN
			SET @activity = 'UPDATE';
			SET @user = SYSTEM_USER;

			IF @in_dateCreated IS NULL BEGIN
				UPDATE
					[ITF FlagTypes]
				SET
					[DateCreated] = GETDATE()
				WHERE
					[ID] = @in_id
				;
			END

			IF @new_activity = 1 BEGIN
				
				UPDATE
					[ITF FlagTypes]
				SET
					[Active] = @in_active
					, [DateActive] = (CASE WHEN @in_active = 1 THEN GETDATE() ELSE [DateActive] END)
					, [DateInactive] = (CASE WHEN @in_active = 0 THEN GETDATE() ELSE [DateInactive] END)
				WHERE
					[ID] = @in_id
				;

			END

		END
		IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) BEGIN
			SET @activity = 'INSERT';
			SET @user = SYSTEM_USER;

			UPDATE
				[ITF FlagTypes]
			SET
				[Active] = @in_active
				, [DateActive] = GETDATE()
				, [dateInactive] = (CASE WHEN @in_active = 0 THEN GETDATE() ELSE NULL END)
			WHERE
				[ID] = @in_id
			;

		END
		IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted) BEGIN 
			SET @activity = 'DELETE';
			SET @user = SYSTEM_USER;
		END

	END

END
GO
