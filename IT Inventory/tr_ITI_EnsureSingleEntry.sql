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
CREATE TRIGGER [dbo].[tr_ITI_EnsureSingleEntry]
   ON  [dbo].[ITI InvMaster]
   INSTEAD OF INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF TRIGGER_NESTLEVEL() <= 1 BEGIN

		-- Insert statements for trigger here
		DECLARE @user NVARCHAR(20);
		DECLARE @activity NVARCHAR(20);
	
		DECLARE @itemId AS BIGINT;
		DECLARE @quantityA AS INT;
		DECLARE @quantityB AS INT;

		IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
			BEGIN
				SET @activity = 'UPDATE';
				SET @user = SYSTEM_USER;
			
				SELECT @itemId =	[ID] FROM inserted i
				SELECT @quantityA = [Quantity] FROM inserted i;
				SELECT @quantityB = [Quantity] FROM deleted d;

				UPDATE
					[ITI InvMaster]
				SET
					[Quantity] = 

			END
		IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
			BEGIN
				SET @activity = 'INSERT';
				SET @user = SYSTEM_USER;
			END
		IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
			BEGIN
				SET @activity = 'DELETE';
				SET @user = SYSTEM_USER;
			END
	END
END
GO
