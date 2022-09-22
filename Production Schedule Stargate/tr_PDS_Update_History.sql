USE Stargatedb
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
ALTER TRIGGER [dbo].[tr_PDS_Update_History]
   ON  [dbo].[PDS Updates]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	
		DECLARE @user NVARCHAR(20);
		DECLARE @activity NVARCHAR(20);
		DECLARE @id INT;
		DECLARE @SGQuote NVARCHAR(20);
		DECLARE @isTest BIT;
		DECLARE @user_name AS NVARCHAR(MAX);
		DECLARE @ad AS DATETIME;
		DECLARE @ln AS NVARCHAR(255);
		
		SELECT @user_name = [UpdaterName] FROM inserted i;
		SELECT @id = [UpdateID] FROM inserted i;
		SELECT @ad = [AvailableDate] FROM inserted i;
		SELECT @ln = [Line] FROM inserted i;
		SELECT @SGQuote = [SGQuote] FROM inserted i;
		SELECT @isTest = (CASE WHEN ISNULL([AllowPublish], 0) = 1 THEN 0 ELSE 1 END) FROM [PDS Valid Updaters] WHERE [UserName] = @user_name;

		--IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
		--BEGIN
		--	SET @activity = 'UPDATE';
		--	SET @user = SYSTEM_USER;
		--END
		IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
		BEGIN
			SET @activity = 'INSERT';
			SET @user = SYSTEM_USER;

			DECLARE @ado AS DATETIME;
			DECLARE @lno AS NVARCHAR(255);
			SELECT @ado = ISNULL([Available Date], [JobFinishDate]) FROM [BWSdb].[dbo].[OrdersV2] INNER JOIN [dtProductionScheduleV2] ON [OrdersV2].[SGQuote] = [dtProductionScheduleV2].[SGQuote] WHERE [OrdersV2].[SGQuote] = @SGQuote;
			SELECT @lno = [JobStartLine] FROM [dtProductionScheduleV2] WHERE [SGQuote] = @SGQuote;

			IF TRIGGER_NESTLEVEL() <= 1 BEGIN 
				UPDATE
					[PDS Updates]
				SET
					[AvailableDateOld] = @ado
					, [LineOld] = @lno
					, [IsTest] = @isTest
				WHERE
					[PDS Updates].[UpdateID] = @id	
			END

			IF @isTest = 0 BEGIN
				UPDATE
					[BWSdb].[dbo].[OrdersV2]
				SET
					[Available Date] = @ad
				WHERE
					[SGQuote] = @SGQuote
				;
				UPDATE
					[dtProductionScheduleV2]
				SET
					[JobFinishDate] = @ad
					, [JobStartLine] = @ln
				WHERE
					[SGQuote] = @SGQuote
				;
			END
		END

		--IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
		--BEGIN 
		--	SET @activity = 'DELETE';
		--	SET @user = SYSTEM_USER;
		--END
END
GO
