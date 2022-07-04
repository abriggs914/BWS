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
CREATE TRIGGER [dbo].[tr_ITI_UpdateInvMasterSnap]
   ON  [dbo].[ITI InvMaster]
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
	DECLARE @user NVARCHAR(20);
	DECLARE @activity NVARCHAR(20);
	DECLARE @id AS BIGINT;
	DECLARE @item AS INT;
	DECLARE @quantity AS INT;
	DECLARE @uom AS INT;
	DECLARE @totalConsumed AS INT;
	DECLARE @totalAdded AS INT;
	DECLARE @lastDateConsumed AS DATETIME;
	DECLARE @dateAdded AS DATETIME;

	--Insert statements for trigger here
	IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
	BEGIN
			SET @activity = 'UPDATE';
			SET @user = SYSTEM_USER;
			
			SELECT @id					= [ID] FROM inserted i;
			SELECT @item				= [Item] FROM inserted i;
			SELECT @quantity			= [Quantity] FROM inserted i;
			SELECT @uom					= [UOM] FROM inserted i;
			SELECT @totalConsumed		= [TotalConsumed] FROM inserted i;
			SELECT @totalAdded			= [TotalAdded] FROM inserted i;
			SELECT @lastDateConsumed	= [LastDateConsumed] FROM inserted i;
			SELECT @dateAdded			= [DateAdded] FROM inserted i;

			INSERT INTO [ITI InvMaster Snap] ([Item], [Quantity], [UOM], [TotalConsumed], [TotalAdded], [LastDateConsumed], [DateAdded], [Operation], [User])
			VALUES (@id, @quantity, @uom, @totalConsumed, @totalAdded, @lastDateConsumed, @dateAdded, @activity, @user);
			
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
	END

	IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
		BEGIN
			SET @activity = 'INSERT';
			SET @user = SYSTEM_USER;
			
			SELECT @id					= [ID] FROM inserted i;
			SELECT @item				= [Item] FROM inserted i;
			SELECT @quantity			= [Quantity] FROM inserted i;
			SELECT @uom					= [UOM] FROM inserted i;
			SELECT @totalConsumed		= [TotalConsumed] FROM inserted i;
			SELECT @totalAdded			= [TotalAdded] FROM inserted i;
			SELECT @lastDateConsumed	= [LastDateConsumed] FROM inserted i;
			SELECT @dateAdded			= [DateAdded] FROM inserted i;

			INSERT INTO [ITI InvMaster Snap] ([Item], [Quantity], [UOM], [TotalConsumed], [TotalAdded], [LastDateConsumed], [DateAdded], [Operation], [User])
			VALUES (@id, @quantity, @uom, @totalConsumed, @totalAdded, @lastDateConsumed, @dateAdded, @activity, @user);
		END

	IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
		BEGIN 
			SET @activity = 'DELETE';
			SET @user = SYSTEM_USER;
			
			SELECT @id					= [ID] FROM deleted d;
			SELECT @item				= [Item] FROM deleted d;
			SELECT @quantity			= [Quantity] FROM deleted d;
			SELECT @uom					= [UOM] FROM deleted d;
			SELECT @totalConsumed		= [TotalConsumed] FROM deleted d;
			SELECT @totalAdded			= [TotalAdded] FROM deleted d;
			SELECT @lastDateConsumed	= [LastDateConsumed] FROM deleted d;
			SELECT @dateAdded			= [DateAdded] FROM deleted d;

			INSERT INTO [ITI InvMaster Snap] ([Item], [Quantity], [UOM], [TotalConsumed], [TotalAdded], [LastDateConsumed], [DateAdded], [Operation], [User])
			VALUES (@id, @quantity, @uom, @totalConsumed, @totalAdded, @lastDateConsumed, @dateAdded, @activity, @user);
	END
END
GO
