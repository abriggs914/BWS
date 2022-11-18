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
CREATE TRIGGER [dbo].[tr_UpdateOrderDiscounts]
   ON  [Orders]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	
	DECLARE @newDiscountID AS INT;
	DECLARE @oldDiscountID AS INT;
	DECLARE @editor AS NVARCHAR(255);
	DECLARE @quote INT;
	DECLARE @defaultDiscount AS INT;
	DECLARE @productID AS INT;
	DECLARE @dealerID AS INT;
	DECLARE @modelName AS NVARCHAR(255);
	
	DECLARE @user NVARCHAR(20);
	DECLARE @activity NVARCHAR(20);

	-- Insert statements for trigger here
	IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) BEGIN
		SET @activity = 'UPDATE';
		SET @user = SYSTEM_USER;
		
		SELECT @newDiscountID = [DiscountID] FROM inserted i
		SELECT @oldDiscountID = [DiscountID] FROM deleted d
		SELECT @editor = DataEntryUser FROM inserted i

		IF @newDiscountID <> @oldDiscountID BEGIN
			
			UPDATE
				[Orders]
			SET
				[DiscountSetDate] = GETDATE()
				, [DiscountSetBy] = @editor

		END

	END
	IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) BEGIN
		SET @activity = 'INSERT';
		SET @user = SYSTEM_USER;
		
		SELECT @newDiscountID = [DiscountID] FROM inserted i
		SELECT @editor = [DataEntryUser] FROM inserted i
		SELECT @modelName = [Model No] FROM inserted i
		SELECT @dealerID = [DealerID] FROM inserted i
		
		SELECT @productID = [IDTrailer] FROM [Products] WHERE [Non-Current] = 0 AND [Proposed] = 0 AND [Model No] = @modelName
		SELECT @defaultDiscount = [ID] FROM [Discounts] WHERE [ProductID] = @productID AND [DealerID] = @dealerID

			
		IF @newDiscountID IS NOT NULL BEGIN
			
			UPDATE
				[Orders]
			SET
				[DiscountSetDate] = GETDATE()
				, [DiscountSetBy] = @editor

			SELECT @quote = [Quote#] FROM inserted i

			INSERT INTO
				[Order Discounts]
			([Active], [UseDefaultDiscount], [DefaultDiscount], [Quote])
			VALUES
				(1, 1, @defaultDiscount, @quote)
		
		END

	END
	IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted) BEGIN 
		SET @activity = 'DELETE';
		SET @user = SYSTEM_USER;
	END

END
GO
