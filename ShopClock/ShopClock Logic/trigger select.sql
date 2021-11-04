USE SysproCompanyA
GO



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
	
		--SELECT @inTime = [LoggedOn] FROM inserted i
		--SELECT @outTime = [LoggedOff] FROM inserted i
		--SELECT @transactionID = [TransactionID] FROM inserted i
		--SELECT @shiftID = [ShiftID] FROM inserted i
		--SELECT @transactionDate = [LoggedOn] FROM inserted i

	SET @inTime = '2021-11-02 6:30:00.00'
	SET @outTime = '2021-11-02 6:30:00.00'
	SET @transactionID = 1000006
	SET @shiftID = 39
	SET @transactionDate = '2021-11-02 6:30:00.00'

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
		SET @shift_start_date = CAST((CAST((CAST(DATEPART(YEAR, @transactionDate) AS VARCHAR(4)) + '-' + CAST(DATEPART(MONTH, @transactionDate) AS VARCHAR(2)) + '-' + CAST(DATEPART(DAY, @transactionDate) AS VARCHAR(2))) AS VARCHAR(30)) + ' ' + CAST(DATEPART(HOUR, @st) AS VARCHAR(30)) + ':' + CAST(DATEPART(MINUTE, @st) AS VARCHAR(30))) AS DATETIME)
		SET @shift_end_date = CAST((CAST((CAST(DATEPART(YEAR, @transactionDate) AS VARCHAR(4)) + '-' + CAST(DATEPART(MONTH, @transactionDate) AS VARCHAR(2)) + '-' + CAST(DATEPART(DAY, @transactionDate) AS VARCHAR(2))) AS VARCHAR(30)) + ' ' + CAST(DATEPART(HOUR, @et) AS VARCHAR(30)) + ':' + CAST(DATEPART(MINUTE, @et) AS VARCHAR(30))) AS DATETIME)
		
		DECLARE @rounded TABLE ([In / Out] VARCHAR(3), [Start Date] DATETIME, [End Date] DATETIME, [InTime] DATETIME, [RoundedTime] DATETIME, [Threshold] INT, [Interval] INT);
		DECLARE @results TABLE ([In / Out] VARCHAR(3), [Start Date] DATETIME, [End Date] DATETIME, [InTime] DATETIME, [RoundedTime] DATETIME, [Threshold] INT, [Interval] INT);

		IF @outTime IS NULL BEGIN
			-- Sign-In
			INSERT INTO @rounded EXEC [dbo].[sp_RoundTime] @time = @inTime, @interval = @interval, @in_out = 1, @threshold = @threshold, @start_date = @shift_start_date, @end_date = @shift_end_date
			INSERT INTO @results SELECT * FROM @rounded
		
			--UPDATE
			--	[ClkTransaction]
			--SET
			--	[InTimeFromShopClk] = (SELECT TOP 1 [RoundedTime] FROM @rounded)
			--WHERE
			--	[TransactionID] = @transactionID

		END
		ELSE BEGIN
			-- Sign-Out
			INSERT INTO @rounded EXEC [dbo].[sp_RoundTime] @time = @inTime, @interval = @interval, @in_out = 1, @threshold = @threshold, @start_date = @shift_start_date, @end_date = @shift_end_date
			INSERT INTO @results SELECT * FROM @rounded
			--UPDATE
			--	[ClkTransaction]
			--SET
			--	[InTimeFromShopClk] = (SELECT TOP 1 [RoundedTime] FROM @rounded)
			--WHERE
			--	[TransactionID] = @transactionID

			DELETE FROM @rounded WHERE 1=1;
			--SELECT @transactionDate = [LoggedOff] FROM inserted i
			SET @transactionDate = '2021-11-02 16:36'

			INSERT INTO @rounded EXEC [dbo].[sp_RoundTime] @time = @outTime, @interval = @interval, @in_out = 0, @threshold = @threshold, @start_date = @shift_start_date, @end_date = @shift_end_date
			INSERT INTO @results SELECT * FROM @rounded
			--UPDATE
			--	[ClkTransaction]
			--SET
			--	[OutTimeFromShopClk] = (SELECT TOP 1 [RoundedTime] FROM @rounded)
			--WHERE
			--	[TransactionID] = @transactionID

		END

		SELECT * FROM @results
































 --SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;

 --    Insert statements for trigger here
	
	--DECLARE @today AS DATETIME;
	-- Actual recorded values from Shopclock [ClkTransaction]
	--DECLARE @inTime AS DATETIME, @outTime AS DATETIME; 
	--DECLARE @transactionDate DATETIME;
	--DECLARE @transactionID INT;
	--DECLARE @shiftID INT;

	--DECLARE @shift_start_date AS DATETIME, @shift_end_date AS DATETIME; -- Values calculated from [ClkShiftRoundRules] and transactionDate
	--DECLARE @st AS DATETIME, @et AS DATETIME; -- Values from [ClkShiftRoundRules]
	--DECLARE @interval INT;
	--DECLARE @threshold INT;
	
	--SELECT @inTime = [LoggedOn] FROM inserted i
	--SELECT @outTime = [LoggedOff] FROM inserted i
	--SELECT @transactionID = [TransactionID] FROM inserted i
	--SELECT @shiftID = [ShiftID] FROM inserted i
	--SELECT @transactionDate = [LoggedOn] FROM inserted i
	
	--SET @inTime = '2021-11-02 6:30:00.00'
	--SET @outTime = '2021-11-02 16:30:00.00'
	--SET @transactionID = 1000006
	--SET @shiftID = 39
	--SET @transactionDate = '2021-11-02 6:30:00.00'

	-- These vars will change based on the shift passed. These values can be found on ShopClk tables
	--SET @interval = (SELECT [Interval] FROM [ClkShiftRoundRules] WHERE [ShiftID] = @shiftID);
	--SET @threshold = (SELECT [Threshold] FROM [ClkShiftRoundRules] WHERE [ShiftID] = @shiftID);
	--SET @st = (SELECT [StartTime] FROM [ClkShiftRoundRules] WHERE [ShiftID] = @shiftID);
	--SET @et = (SELECT [EndTime] FROM [ClkShiftRoundRules] WHERE [ShiftID] = @shiftID);
	--SET @today = GETDATE()
	--SET @shift_start_date = CAST((DATEPART(YEAR, @today) + '-' + DATEPART(MONTH, @today) + '-' + DATEPART(DAY, @today) + ' 07:00:00') AS DATETIME)
	--SET @shift_end_date = CAST((DATEPART(YEAR, @today) + '-' + DATEPART(MONTH, @today) + '-' + DATEPART(DAY, @today) + ' 16:30:00') AS DATETIME)
	--SELECT @transactionDate AS [TDate], @st AS [Start]
	--SELECT (CAST(DATEPART(HOUR, @st) AS VARCHAR(2)) + ':' + CAST(DATEPART(MINUTE, @st) AS VARCHAR(2))) AS [Y]
	--SELECT DATEPART(YEAR, @transactionDate) AS [KDFLSKDH]
	--SELECT CAST(DATEPART(YEAR, @transactionDate) AS VARCHAR(4)) + '-' + CAST(DATEPART(MONTH, @st) AS VARCHAR(2)) + '-' + CAST(DATEPART(DAY, @st) AS VARCHAR(2)) AS [W]
	--SELECT (CAST((CAST(DATEPART(YEAR, @transactionDate) AS VARCHAR(4)) + '-' + CAST(DATEPART(MONTH, @transactionDate) AS VARCHAR(2)) + '-' + CAST(DATEPART(DAY, @transactionDate) AS VARCHAR(2))) AS VARCHAR(30)) + ' ' + CAST(DATEPART(HOUR, @st) AS VARCHAR(30)) + ':' + CAST(DATEPART(MINUTE, @st) AS VARCHAR(30))) AS [X]
	--SELECT CAST((CAST((CAST(DATEPART(YEAR, @transactionDate) AS VARCHAR(4)) + '-' + CAST(DATEPART(MONTH, @transactionDate) AS VARCHAR(2)) + '-' + CAST(DATEPART(DAY, @transactionDate) AS VARCHAR(2))) AS VARCHAR(30)) + ' ' + CAST(DATEPART(HOUR, @st) AS VARCHAR(30)) + ':' + CAST(DATEPART(MINUTE, @st) AS VARCHAR(30))) AS DATETIME) AS [X]







	--SET @shift_start_date = CAST((CAST((CAST(DATEPART(YEAR, @transactionDate) AS VARCHAR(4)) + '-' + CAST(DATEPART(MONTH, @transactionDate) AS VARCHAR(2)) + '-' + CAST(DATEPART(DAY, @transactionDate) AS VARCHAR(2))) AS VARCHAR(30)) + ' ' + CAST(DATEPART(HOUR, @st) AS VARCHAR(30)) + ':' + CAST(DATEPART(MINUTE, @st) AS VARCHAR(30))) AS DATETIME)
	--SET @shift_end_date = CAST((CAST((CAST(DATEPART(YEAR, @transactionDate) AS VARCHAR(4)) + '-' + CAST(DATEPART(MONTH, @transactionDate) AS VARCHAR(2)) + '-' + CAST(DATEPART(DAY, @transactionDate) AS VARCHAR(2))) AS VARCHAR(30)) + ' ' + CAST(DATEPART(HOUR, @et) AS VARCHAR(30)) + ':' + CAST(DATEPART(MINUTE, @et) AS VARCHAR(30))) AS DATETIME)

	--SELECT @shift_start_date AS [STARTDATE], @shift_end_date AS [ENDDATE]

	--DECLARE @rounded TABLE ([In / Out] VARCHAR(3), [Start Date] DATETIME, [End Date] DATETIME, [InTime] DATETIME, [RoundedTime] DATETIME, [Threshold] INT, [Interval] INT);

	--IF @outTime IS NULL BEGIN
	--	 Sign-In
	--	INSERT INTO @rounded EXEC [dbo].[sp_RoundTime] @time = @inTime, @interval = @interval, @in_out = 1, @threshold = @threshold, @start_date = @shift_start_date, @end_date = @shift_end_date
		
	--	UPDATE
	--		[ClkTransaction]
	--	SET
	--		[InTimeFromShopClk] = (SELECT [RoundedTime] FROM @rounded)
	--	WHERE
	--		[TransactionID] = @transactionID

	--END
	--ELSE BEGIN
	--	 Sign-Out
	--	INSERT INTO @rounded EXEC [dbo].[sp_RoundTime] @time = @inTime, @interval = @interval, @in_out = 1, @threshold = @threshold, @start_date = @shift_start_date, @end_date = @shift_end_date
	--	UPDATE
	--		[ClkTransaction]
	--	SET
	--		[InTimeFromShopClk] = (SELECT [RoundedTime] FROM @rounded)
	--	WHERE
	--		[TransactionID] = @transactionID

	--	DELETE FROM @rounded WHERE 1=1;
	--	SELECT @transactionDate = [LoggedOff] FROM inserted i

	--	SELECT @transactionDate = '2021-11-02 16:36'

	--	INSERT INTO @rounded EXEC [dbo].[sp_RoundTime] @time = @outTime, @interval = @interval, @in_out = 0, @threshold = @threshold, @start_date = @shift_start_date, @end_date = @shift_end_date
	--	UPDATE
	--		[ClkTransaction]
	--	SET
	--		[OutTimeFromShopClk] = (SELECT [RoundedTime] FROM @rounded)
	--	WHERE
	--		[TransactionID] = @transactionID

	--END

	--SELECT * FROM @rounded


--USE SysproCompanyA
--GO

---- ================================================
---- Template generated from Template Explorer using:
---- Create Trigger (New Menu).SQL
----
---- Use the Specify Values for Template Parameters 
---- command (Ctrl-Shift-M) to fill in the parameter 
---- values below.
----
---- See additional Create Trigger templates for more
---- examples of different Trigger statements.
----
---- This block of comments will not be included in
---- the definition of the function.
---- ================================================

--	IF TRIGGER_NESTLEVEL() <= 1 BEGIN
--		-- SET NOCOUNT ON added to prevent extra result sets from
--		-- interfering with SELECT statements.
--		SET NOCOUNT ON;

--		-- Insert statements for trigger here
	
--		DECLARE @today AS DATETIME;

--		DECLARE @inTime AS DATETIME, @outTime AS DATETIME;
--		DECLARE @shift_start_date AS DATETIME, @shift_end_date AS DATETIME;
--		DECLARE @st AS DATETIME, @et AS DATETIME;
--		DECLARE @transactionDate DATETIME;
--		DECLARE @interval INT;
--		DECLARE @threshold INT;
--		DECLARE @transactionID INT;
--		DECLARE @shiftID INT;
	
	
--	SET @inTime = '2021-11-02 6:30:00.00'
--	--SET @outTime = '2021-11-02 16:30:00.00'
--	SET @transactionID = 1000006
--	SET @shiftID = 39
--	SET @transactionDate = '2021-11-02 6:30:00.00'
--		--SELECT @inTime = [LoggedOn] FROM inserted i
--		--SELECT @outTime = [LoggedOff] FROM inserted i
--		--SELECT @transactionID = [TransactionID] FROM inserted i
--		--SELECT @shiftID = [ShiftID] FROM inserted i
--		--SELECT @transactionDate = [LoggedOn] FROM inserted i

--		-- These vars will change based on the shift passed. These values can be found on ShopClk tables
--		SET @interval = (SELECT [Interval] FROM [ClkShiftRoundRules] WHERE [ShiftID] = @shiftID);
--		SET @threshold = (SELECT [Threshold] FROM [ClkShiftRoundRules] WHERE [ShiftID] = @shiftID);
--		SET @st = (SELECT [StartTime] FROM [ClkShiftRoundRules] WHERE [ShiftID] = @shiftID);
--		SET @et = (SELECT [EndTime] FROM [ClkShiftRoundRules] WHERE [ShiftID] = @shiftID);
--		SET @today = GETDATE()
--		IF @st IS NULL BEGIN
--			SET @st = @today
--		END
--		IF @et IS NULL BEGIN
--			SET @et = @today
--		END
--		--SET @shift_start_date = CAST((DATEPART(YEAR, @today) + '-' + DATEPART(MONTH, @today) + '-' + DATEPART(DAY, @today) + ' 07:00:00') AS DATETIME)
--		--SET @shift_end_date = CAST((DATEPART(YEAR, @today) + '-' + DATEPART(MONTH, @today) + '-' + DATEPART(DAY, @today) + ' 16:30:00') AS DATETIME)
--		SET @shift_start_date = CAST((CAST(@today AS VARCHAR(30)) + ' ' + (CAST(DATEPART(HOUR, @st) AS VARCHAR(2)) + ':' + CAST(DATEPART(MINUTE, @st) AS VARCHAR(2)))) AS DATETIME)
--		SET @shift_end_date = CAST((CAST(@today AS VARCHAR(30)) + ' ' + (CAST(DATEPART(HOUR, @et) AS VARCHAR(2)) + ':' + CAST(DATEPART(MINUTE, @et) AS VARCHAR(2)))) AS DATETIME)

--		DECLARE @rounded TABLE ([In / Out] VARCHAR(3), [InTime] DATETIME, [Start Date] DATETIME, [End Date] DATETIME, [RoundedTime] DATETIME, [Threshold] INT, [Interval] INT);

--		IF @outTime IS NULL BEGIN
--			-- Sign-In
--			INSERT INTO @rounded EXEC [dbo].[RoundTime] @time = @inTime, @interval = @interval, @in_out = 1, @threshold = @threshold, @start_date = @shift_start_date, @end_date = @shift_end_date
		
--			UPDATE
--				[ClkTransaction]
--			SET
--				[InTimeFromShopClk] = (SELECT TOP 1 [RoundedTime] FROM @rounded)
--			WHERE
--				[TransactionID] = @transactionID

--		END
--		ELSE BEGIN
--			-- Sign-Out
--			INSERT INTO @rounded EXEC [dbo].[RoundTime] @time = @inTime, @interval = @interval, @in_out = 1, @threshold = @threshold, @start_date = @shift_start_date, @end_date = @shift_end_date
--			UPDATE
--				[ClkTransaction]
--			SET
--				[InTimeFromShopClk] = (SELECT TOP 1 [RoundedTime] FROM @rounded)
--			WHERE
--				[TransactionID] = @transactionID

--			DELETE FROM @rounded WHERE 1=1;
--			SELECT @transactionDate = [LoggedOff] FROM inserted i

--			INSERT INTO @rounded EXEC [dbo].[RoundTime] @time = @outTime, @interval = @interval, @in_out = 0, @threshold = @threshold, @start_date = @shift_start_date, @end_date = @shift_end_date
--			UPDATE
--				[ClkTransaction]
--			SET
--				[OutTimeFromShopClk] = (SELECT TOP 1 [RoundedTime] FROM @rounded)
--			WHERE
--				[TransactionID] = @transactionID

--		END

--	END
