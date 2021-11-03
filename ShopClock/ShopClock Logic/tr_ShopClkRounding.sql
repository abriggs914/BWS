USE SysproCompanyA
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
ALTER TRIGGER [dbo].[tr_ShopClkRounding] 
   ON  [dbo].[ClkTransaction]
   AFTER UPDATE, INSERT

AS 
BEGIN
	IF TRIGGER_NESTLEVEL() <= 1 BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		-- Insert statements for trigger here
	
		DECLARE @today AS DATETIME;

		DECLARE @inTime AS DATETIME, @outTime AS DATETIME;
		DECLARE @shift_start_date AS DATETIME, @shift_end_date AS DATETIME;
		DECLARE @st AS DATETIME, @et AS DATETIME;
		DECLARE @transactionDate DATETIME;
		DECLARE @interval INT;
		DECLARE @threshold INT;
		DECLARE @transactionID INT;
		DECLARE @shiftID INT;
	
		SELECT @inTime = [LoggedOn] FROM inserted i
		SELECT @outTime = [LoggedOff] FROM inserted i
		SELECT @transactionID = [TransactionID] FROM inserted i
		SELECT @shiftID = [ShiftID] FROM inserted i
		SELECT @transactionDate = [LoggedOn] FROM inserted i

		-- These vars will change based on the shift passed. These values can be found on ShopClk tables
		SET @interval = (SELECT [Interval] FROM [ClkShiftRoundRules] WHERE [ShiftID] = @shiftID);
		SET @threshold = (SELECT [Threshold] FROM [ClkShiftRoundRules] WHERE [ShiftID] = @shiftID);
		SET @st = (SELECT [StartTime] FROM [ClkShiftRoundRules] WHERE [ShiftID] = @shiftID);
		SET @et = (SELECT [EndTime] FROM [ClkShiftRoundRules] WHERE [ShiftID] = @shiftID);
		SET @today = GETDATE()
		IF @st IS NULL BEGIN
			SET @st = @today
		END
		IF @et IS NULL BEGIN
			SET @et = @today
		END
		--SET @shift_start_date = CAST((DATEPART(YEAR, @today) + '-' + DATEPART(MONTH, @today) + '-' + DATEPART(DAY, @today) + ' 07:00:00') AS DATETIME)
		--SET @shift_end_date = CAST((DATEPART(YEAR, @today) + '-' + DATEPART(MONTH, @today) + '-' + DATEPART(DAY, @today) + ' 16:30:00') AS DATETIME)
		SET @shift_start_date = CAST((CAST((CAST(DATEPART(YEAR, @transactionDate) AS VARCHAR(4)) + '-' + CAST(DATEPART(MONTH, @transactionDate) AS VARCHAR(2)) + '-' + CAST(DATEPART(DAY, @transactionDate) AS VARCHAR(2))) AS VARCHAR(30)) + ' ' + CAST(DATEPART(HOUR, @st) AS VARCHAR(30)) + ':' + CAST(DATEPART(MINUTE, @st) AS VARCHAR(30))) AS DATETIME)
		SET @shift_end_date = CAST((CAST((CAST(DATEPART(YEAR, @transactionDate) AS VARCHAR(4)) + '-' + CAST(DATEPART(MONTH, @transactionDate) AS VARCHAR(2)) + '-' + CAST(DATEPART(DAY, @transactionDate) AS VARCHAR(2))) AS VARCHAR(30)) + ' ' + CAST(DATEPART(HOUR, @et) AS VARCHAR(30)) + ':' + CAST(DATEPART(MINUTE, @et) AS VARCHAR(30))) AS DATETIME)
		--SET @shift_start_date = CAST((CAST(@today AS VARCHAR(30)) + ' ' + (CAST(DATEPART(HOUR, @st) AS VARCHAR(2)) + ':' + CAST(DATEPART(MINUTE, @st) AS VARCHAR(2)))) AS DATETIME)
		--SET @shift_end_date = CAST((CAST(@today AS VARCHAR(30)) + ' ' + (CAST(DATEPART(HOUR, @et) AS VARCHAR(2)) + ':' + CAST(DATEPART(MINUTE, @et) AS VARCHAR(2)))) AS DATETIME)

		DECLARE @rounded TABLE ([In / Out] VARCHAR(3), [Start Date] DATETIME, [End Date] DATETIME, [InTime] DATETIME, [RoundedTime] DATETIME, [Threshold] INT, [Interval] INT);

		IF @outTime IS NULL BEGIN
			-- Sign-In
			INSERT INTO @rounded EXEC [dbo].[sp_RoundTime] @time = @inTime, @interval = @interval, @in_out = 1, @threshold = @threshold, @start_date = @shift_start_date, @end_date = @shift_end_date
		
			UPDATE
				[ClkTransaction]
			SET
				[InTimeFromShopClk] = (SELECT TOP 1 [RoundedTime] FROM @rounded)
			WHERE
				[TransactionID] = @transactionID

		END
		ELSE BEGIN
			-- Sign-Out
			INSERT INTO @rounded EXEC [dbo].[sp_RoundTime] @time = @inTime, @interval = @interval, @in_out = 1, @threshold = @threshold, @start_date = @shift_start_date, @end_date = @shift_end_date
			UPDATE
				[ClkTransaction]
			SET
				[InTimeFromShopClk] = (SELECT TOP 1 [RoundedTime] FROM @rounded)
			WHERE
				[TransactionID] = @transactionID

			DELETE FROM @rounded WHERE 1=1;
			SELECT @transactionDate = [LoggedOff] FROM inserted i

			INSERT INTO @rounded EXEC [dbo].[sp_RoundTime] @time = @outTime, @interval = @interval, @in_out = 0, @threshold = @threshold, @start_date = @shift_start_date, @end_date = @shift_end_date
			UPDATE
				[ClkTransaction]
			SET
				[OutTimeFromShopClk] = (SELECT TOP 1 [RoundedTime] FROM @rounded)
			WHERE
				[TransactionID] = @transactionID

		END

	END
END
GO
