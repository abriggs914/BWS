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
CREATE TRIGGER [dbo].[tr_ITI_UpdateInvMaster]
	ON  [dbo].[ITI Item]
	AFTER UPDATE, INSERT, DELETE
	AS
	BEGIN -- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		-- Insert statements for trigger here
		
		DECLARE @user NVARCHAR(20);
		DECLARE @activity NVARCHAR(20);
		DECLARE @id AS BIGINT;
		DECLARE @name AS NVARCHAR(MAX);
		DECLARE @description AS NVARCHAR(MAX);
		DECLARE @isActive AS BIT;
		DECLARE @condition AS INT;
		DECLARE @status AS INT;
		DECLARE @type AS INT;
		DECLARE @subType AS INT;
		DECLARE @dateAdded AS DATETIME;

		--IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
		--BEGIN
		--	SET @activity = 'UPDATE';
		--	SET @user = SYSTEM_USER;
			
		--	SELECT @id			= [ID] FROM inserted i;
		--	SELECT @name		= [Name] FROM inserted i;
		--	SELECT @description	= [Description] FROM inserted i;
		--	SELECT @isActive	= [IsActive] FROM inserted i;
		--	SELECT @condition	= [Condition] FROM inserted i;
		--	SELECT @status		= [Status] FROM inserted i;
		--	SELECT @type		= [Type] FROM inserted i;
		--	SELECT @subType		= [SubType] FROM inserted i;
		--	SELECT @dateAdded	= [DateCreated] FROM inserted i;
			
		--	DECLARE @quantity AS INT;
		--	DECLARE @uom AS INT;
		--	DECLARE @totalConsumed AS INT;
		--	DECLARE @totalAdded AS INT;
		--	DECLARE @lastDateConsumed AS INT;
			
		--	SELECT @quantity			= [Quantity] FROM [ITI InvMaster] WHERE [Item] = @id
		--	SELECT @uom					= [UOM] FROM [ITI InvMaster] WHERE [Item] = @id
		--	SELECT @totalConsumed		= [TotalConsumed] FROM [ITI InvMaster] WHERE [Item] = @id
		--	SELECT @totalAdded			= [TotalAdded] FROM [ITI InvMaster] WHERE [Item] = @id
		--	SELECT @lastDateConsumed	= [LastDateConsumed] FROM [ITI InvMaster] WHERE [Item] = @id

		--	UPDATE
		--		[ITI InvMaster]
		--	SET
		--		[Quantity] = @quantity,
		--		[UOM] = @uom,
		--		[TotalConsumed] = @totalConsumed,
		--		[TotalAdded] = @totalAdded,
		--		[LastDateConsumed] = @lastDateConsumed
		--	WHERE
		--		[Item] = @id;

		--	--SELECT @EmpID = EmployeeID FROM inserted i;
		--	--INSERT INTO Emp_Audit(EmpID,Activity, DoneBy) VALUES (@EmpID,@activity,@user);
		--END

		IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
		BEGIN
			SET @activity = 'INSERT';
			SET @user = SYSTEM_USER;
			
			SELECT @id			= [ID] FROM inserted i;
			SELECT @name		= [Name] FROM inserted i;
			SELECT @description	= [Description] FROM inserted i;
			SELECT @isActive	= [IsActive] FROM inserted i;
			SELECT @condition	= [Condition] FROM inserted i;
			SELECT @status		= [Status] FROM inserted i;
			SELECT @type		= [Type] FROM inserted i;
			SELECT @subType		= [SubType] FROM inserted i;
			SELECT @dateAdded	= [DateCreated] FROM inserted i;

			INSERT INTO [ITI InvMaster] ([Item], [Quantity], [UOM], [TotalConsumed], [TotalAdded], [LastDateConsumed], [DateAdded])
			VALUES (@id, 0, 1, 0, 0, NULL, GETDATE());
		END

		--IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
		--BEGIN 
		--	SET @activity = 'DELETE';
		--	SET @user = SYSTEM_USER;

		--	DECLARE @quantity AS INT;
		--	DECLARE @uom AS INT;
		--	DECLARE @totalConsumed AS INT;
		--	DECLARE @totalAdded AS INT;
		--	DECLARE @lastDateConsumed AS INT;
			
		--	SELECT @quantity			= 0
		--	SELECT @uom					= [UOM] FROM [ITI InvMaster] WHERE [Item] = @id
		--	SELECT @totalConsumed		= [TotalConsumed] FROM [ITI InvMaster] WHERE [Item] = @id
		--	SELECT @totalAdded			= [TotalAdded] FROM [ITI InvMaster] WHERE [Item] = @id
		--	SELECT @lastDateConsumed	= [LastDateConsumed] FROM [ITI InvMaster] WHERE [Item] = @id

		--	UPDATE
		--		[ITI InvMaster]
		--	SET
		--		[Quantity] = @quantity,
		--		[UOM] = @uom,
		--		[TotalConsumed] = @totalConsumed,
		--		[TotalAdded] = @totalAdded,
		--		[LastDateConsumed] = @lastDateConsumed
		--	WHERE
		--		[Item] = @id;
		--END
	END

GO

