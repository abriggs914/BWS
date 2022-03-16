USE [SysproCompanyA]
GO
/****** Object:  Trigger [dbo].[tr_ShopClkRounding]    Script Date: 2022-03-16 10:24:20 AM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- =============================================
---- Author:		<Author,,Name>
---- Create date: <Create Date,,>
---- Description:	<Description,,>
---- =============================================
--ALTER TRIGGER [dbo].[tr_ShopClkRounding] 
--   ON  [dbo].[ClkTransaction]
--   AFTER UPDATE, INSERT

--AS 
--BEGIN
--	IF TRIGGER_NESTLEVEL() <= 1 BEGIN
--		-- SET NOCOUNT ON added to prevent extra result sets from
--		-- interfering with SELECT statements.
--		SET NOCOUNT ON;


		DECLARE @tid AS BIGINT;
		DECLARE @empN AS BIGINT;
		DECLARE @shiftID AS INT;
		DECLARE @inORout  AS BIT;

		--SET @tid = (SELECT TOP 1 [TransactionID] FROM [ClkTransaction] WHERE [LoggedOff] IS NULL ORDER BY [TransactionID] DESC)
		--SELECT @tid = [TransactionID] FROM INSERTED i;
		SET @tid = 1471178; 

			--DECLARE @tDate AS DATETIME = '2022-01-25';
			--DECLARE @tDate AS DATETIME = '2022-01-26';

			--DECLARE @tDate AS DATETIME = '2022-01-28';
			--SET @empN = (SELECT TOP 1 [EmployeeNumber] FROM [ClkTransaction] WHERE [LoggedOn] BETWEEN DATEADD(HOUR, -23, @tDate) AND @tDate GROUP BY [EmployeeNumber] HAVING COUNT(*) = 1)
			--SET @tid = (SELECT MIN([TransactionID]) FROM [ClkTransaction] WHERE [LoggedOn] BETWEEN DATEADD(HOUR, -23, @tDate) AND @tDate AND [EmployeeNumber] = @empN)
			--SELECT @empN



		SET @empN = (SELECT [EmployeeNumber] FROM [ClkTransaction] WHERE [TransactionID] = @tid);
		SELECT @tid AS [@tid], @empN AS [@empN]
		SELECT [ShiftID] FROM [ClkShiftEmpAssign] WHERE [Emp#] = @empN
		SET @shiftID = (SELECT [ShiftID] FROM [ClkShiftEmpAssign] WHERE [Emp#] = @empN);
		SET @shiftID = ISNULL(@shiftID, 1); -- If this employee is not assigned, use the catch-all
		SET @inORout = (CASE WHEN (SELECT [LoggedOff] FROM [ClkTransaction] WHERE [TransactionID] = @tid) IS NULL THEN 1 ELSE 0 END); -- 0 for Out, 1 for In

		-- Shift rules based on the current transaction's employeeNumber
		DECLARE @rules AS TABLE (
			[ShiftID] int,
			[Name] nvarchar(100),
			[StartTime] time(7),
			[EndTime] time(7),
			[Interval] int,
			[ThresholdEarly] int,
			[ThresholdLate] int,
			[IncludeLunchSun] bit,
			[IncludeLunchMon] bit,
			[IncludeLunchTue] bit,
			[IncludeLunchWed] bit,
			[IncludeLunchThu] bit,
			[IncludeLunchFri] bit,
			[IncludeLunchSat] bit
		);

		INSERT INTO @rules SELECT * FROM [ClkShiftRoundRules V2] WHERE	[ShiftID] = @shiftID;

		----------------------------------------------------------------------------------------------------------------------------------------

		-- Parameter Vars
		DECLARE @p_time AS DATETIME;
		DECLARE @p_interval AS INT;
		DECLARE @p_in_out AS BIT;
		DECLARE @p_threshold_early AS INT;
		DECLARE @p_threshold_late AS INT;
		DECLARE @p_start_date AS DATETIME;
		DECLARE @p_end_date AS DATETIME;

		-- Shift Vars
		DECLARE @s_start_date AS DATETIME;
		DECLARE @s_end_date AS DATETIME;

		-- Result Vars
		DECLARE @r_start_date AS DATETIME;
		DECLARE @r_end_date AS DATETIME;

		SET @p_in_out = @inORout
		SET @p_time = (SELECT (CASE WHEN @inORout=1 THEN [LoggedOn] ELSE [LoggedOff] END) FROM [ClkTransaction] WHERE [TransactionID]=@tid);
		SET @p_interval = (SELECT [Interval] FROM @rules);
		SET @p_threshold_early = (SELECT [ThresholdEarly] FROM @rules);
		SET @p_threshold_late = (SELECT [ThresholdLate] FROM @rules);
		SET @s_start_date = (SELECT [StartTime] FROM @rules);
		SET @s_end_date = (SELECT [EndTime] FROM @rules);

		SET @p_end_date = @s_end_date + CAST(CAST(YEAR(@p_time) AS nvarchar(4)) + '-' + CAST(MONTH(@p_time) AS nvarchar(2)) + '-' + CAST(DAY(@p_time) AS nvarchar(2)) AS DATETIME);

		SET @p_start_date = @s_start_date + CAST(CAST(YEAR(@p_time) AS nvarchar(4)) + '-' + CAST(MONTH(@p_time) AS nvarchar(2)) + '-' + CAST(DAY(@p_time) AS nvarchar(2)) AS DATETIME);

		IF @s_start_date >= @s_end_date BEGIN
			-- This shift ran overnight 
			SET @p_start_date = DATEADD(DAY, -1, @p_start_date);
		END

		DECLARE @first_of_shift AS BIT;
		DECLARE @q_data AS TABLE (
			[In / Out] NVARCHAR(3),
			[Start Date] DATETIME,
			[End Date] DATETIME,
			[InTime] DATETIME,
			[RoundedTime] DATETIME,
			[ThresholdEarly] INT,
			[ThresholdLate] INT,
			[Interval] INT
		);

		IF @inORout = 1 BEGIN
			-- Sign In
			-- If first sign in of the shift, round.
			SET @first_of_shift = (
			CASE 
				WHEN (SELECT SUM([Cs]) AS [Cs]
					FROM (
						SELECT 
							COUNT([TransactionID]) AS [Cs]
						FROM
							[ClkTransaction]
						WHERE
							[EmployeeNumber] = @empN
							AND [LoggedOn] BETWEEN DATEADD(HOUR, -7, @p_start_date) AND DATEADD(HOUR, 7, @p_end_date) 
							-- This is a hard-coded range of -7 to +7 hours from the log-on date
							-- If ANY transactions fall within this window they will be considered as "Today's" Transactions.
							-- 7 was chosen to allow weekend shifts to start up to 7 hours late or early.
						GROUP BY
							[TransactionID]
						HAVING
							@p_time > MIN([LoggedOn])
						) AS [Src]
				) IS NULL THEN
					1
				ELSE
					0
				END
			);

			IF @first_of_shift = 1 BEGIN
				INSERT INTO @q_data
				EXEC [dbo].[sp_RoundTime] @time = @p_time, @interval = @p_interval, @in_out = @p_in_out, @threshold_early = @p_threshold_early, @threshold_late = @p_threshold_late, @start_date = @p_start_date, @end_date = @p_end_date;
		
				SELECT @r_start_date = (SELECT [RoundedTime] FROM @q_data);
			END
			ELSE BEGIN
				SELECT @r_start_date = (SELECT [LoggedOn] FROM [ClkTransaction] WHERE [TransactionID] = @tid);
			END

		END
		ELSE BEGIN
			-- Sign Out
			-- Round all entries
	
			DELETE FROM @q_data;
			--SELECT @r_start_date = [InTimeFromShopClk] FROM INSERTED i;
			SELECT @r_start_date = [InTimeFromShopClk] FROM [ClkTransaction] WHERE [TransactionID]=@tid;
			SET @p_time = (SELECT [LoggedOff] FROM [ClkTransaction] WHERE [TransactionID]=@tid);
			INSERT INTO @q_data
			EXEC [dbo].[sp_RoundTime] @time = @p_time, @interval = @p_interval, @in_out = @p_in_out, @threshold_early = @p_threshold_early, @threshold_late = @p_threshold_late, @start_date = @p_start_date, @end_date = @p_end_date;
			SELECT @r_end_date = (SELECT [RoundedTime] FROM @q_data);

			IF @r_start_date > @r_end_date BEGIN
				SET @r_end_date = @r_start_date;
			END
		END

		-------------------------------------------------------------------------------------------------------------------------------
		-- Final Select
		
		SELECT
			[LoggedOn],
			@r_start_date AS [ClkInRounded],
			[LoggedOff],
			@r_end_date AS [ClkOutRounded]
		FROM
			[ClkTransaction]
		WHERE
			[TransactionID] = @tid
		;

		SELECT
			[EmployeeName]
			,[ClkShiftEmpAssign].*
			,[ClkShiftRoundRules V2].*
		FROM
			[ClkTransaction]
		INNER JOIN
			[ClkShiftEmpAssign]
		ON
			[ClkTransaction].[EmployeeNumber] = [ClkShiftEmpAssign].[Emp#]
		INNER JOIN
			[ClkShiftRoundRules V2]
		ON
			[ClkShiftEmpAssign].[ShiftID] = [ClkShiftRoundRules V2].[ShiftID]
		WHERE
			[TransactionID] = @tid
		;

		--UPDATE 
		--	[ClkTransaction]
		--SET	
		--	[InTimeFromShopClk] = (CASE WHEN [InTimeFromShopClk] IS NULL THEN @r_start_date ELSE [InTimeFromShopClk] END),
		--	[OutTimeFromShopClk] = @r_end_date
		--WHERE
		--	[TransactionID] = @tid;


































	--	DECLARE @transactionID as BIGINT;
	--	SELECT @transactionID = [TransactionID] FROM inserted i
	--	--SET @tid = 1459357;


	--	-- Insert statements for trigger here
	
	--	DECLARE @today AS DATETIME;

	--	DECLARE @inTime AS DATETIME, @outTime AS DATETIME;
	--	DECLARE @shift_start_date AS DATETIME, @shift_end_date AS DATETIME;
	--	DECLARE @st AS DATETIME, @et AS DATETIME;
	--	DECLARE @transactionDate DATETIME;
	--	DECLARE @interval INT;
	--	DECLARE @threshold INT;
	--	DECLARE @shiftID INT;
	--	DECLARE @empNum AS BIGINT;
	
	--	SELECT @inTime = (SELECT [LoggedOn] FROM [ClkTransaction] WHERE [TransactionID] = @transactionID)
	--	SELECT @outTime = (SELECT [LoggedOff] FROM [ClkTransaction] WHERE [TransactionID] = @transactionID)
	--	SELECT @transactionID = (SELECT [TransactionID] FROM [ClkTransaction] WHERE [TransactionID] = @transactionID)
	--	SELECT @shiftID = (SELECT [ShiftID] FROM [ClkTransaction] WHERE [TransactionID] = @transactionID)
	--	SELECT @transactionDate = (SELECT [LoggedOn] FROM [ClkTransaction] WHERE [TransactionID] = @transactionID)
	--	SELECT @empNum = (SELECT [EmployeeNumber] FROM [ClkTransaction] WHERE [TransactionID] = @transactionID)
	--	SET @shiftID = (SELECT [ShiftID] FROM [ClkShiftEmpAssign] WHERE [Emp#] = @empNum);

	--	-- These vars will change based on the shift passed. These values can be found on ShopClk tables
	--	SET @interval = (SELECT [Interval] FROM [ClkShiftRoundRules] WHERE [ShiftID] = @shiftID);
	--	SET @threshold = (SELECT [Threshold] FROM [ClkShiftRoundRules] WHERE [ShiftID] = @shiftID);
	--	SET @st = (SELECT [StartTime] FROM [ClkShiftRoundRules] WHERE [ShiftID] = @shiftID);
	--	SET @et = (SELECT [EndTime] FROM [ClkShiftRoundRules] WHERE [ShiftID] = @shiftID);
	--	SET @today = GETDATE()
	--	IF @st IS NULL BEGIN
	--		SET @st = @today
	--	END
	--	IF @et IS NULL BEGIN
	--		SET @et = @today
	--	END

	--	-- THis operation assumes that all shifts start and end on the same calendar day. (NOT TRUE for night shifts)
	--	SET @shift_start_date = CAST((CAST((CAST(DATEPART(YEAR, @transactionDate) AS VARCHAR(4)) + '-' + CAST(DATEPART(MONTH, @transactionDate) AS VARCHAR(2)) + '-' + CAST(DATEPART(DAY, @transactionDate) AS VARCHAR(2))) AS VARCHAR(30)) + ' ' + CAST(DATEPART(HOUR, @st) AS VARCHAR(30)) + ':' + CAST(DATEPART(MINUTE, @st) AS VARCHAR(30))) AS DATETIME)
	--	SET @shift_end_date = CAST((CAST((CAST(DATEPART(YEAR, @transactionDate) AS VARCHAR(4)) + '-' + CAST(DATEPART(MONTH, @transactionDate) AS VARCHAR(2)) + '-' + CAST(DATEPART(DAY, @transactionDate) AS VARCHAR(2))) AS VARCHAR(30)) + ' ' + CAST(DATEPART(HOUR, @et) AS VARCHAR(30)) + ':' + CAST(DATEPART(MINUTE, @et) AS VARCHAR(30))) AS DATETIME)

	--	DECLARE @signed_in_today AS BIT;
	--	SET @signed_in_today = (CASE WHEN 
	--		(
	--			SELECT 
	--				COUNT(*)
	--			FROM 
	--				[ClkTransaction] WITH (NOLOCK)
	--			WHERE 
	--				[EmployeeNumber] = @empNum 
	--				AND DATEPART(YEAR, [LoggedOn]) = DATEPART(YEAR, @shift_start_date)
	--				AND DATEPART(MONTH, [LoggedOn]) = DATEPART(MONTH, @shift_start_date)
	--				AND DATEPART(DAY, [LoggedOn]) = DATEPART(DAY, @shift_start_date)
	--		) > 0 THEN 1 ELSE 0 END) 


	--	DECLARE @rounded TABLE ([In / Out] VARCHAR(3), [Start Date] DATETIME, [End Date] DATETIME, [InTime] DATETIME, [RoundedTime] DATETIME, [Threshold] INT, [Interval] INT);

	--	IF @outTime IS NULL BEGIN
	--		-- Sign-In
	--		--PRINT 'Sign-in'
	--		IF @signed_in_today = 0 BEGIN
	--			INSERT INTO @rounded EXEC [dbo].[sp_RoundTime] @time = @inTime, @interval = @interval, @in_out = 1, @threshold = @threshold, @start_date = @shift_start_date, @end_date = @shift_end_date
		
	--			UPDATE
	--				[ClkTransaction]
	--			SET
	--				[InTimeFromShopClk] = (CASE WHEN @signed_in_today = 0 THEN (SELECT TOP 1 [RoundedTime] FROM @rounded) ELSE [LoggedOn] END),
	--				[SignedInToday] = 1
	--			WHERE
	--				[TransactionID] = @transactionID
	--		END

	--	END
	--	ELSE BEGIN
	--		-- Sign-Out
	--		--PRINT 'Sign-out'

	--		INSERT INTO @rounded EXEC [dbo].[sp_RoundTime] @time = @outTime, @interval = @interval, @in_out = 0, @threshold = @threshold, @start_date = @shift_start_date, @end_date = @shift_end_date
	--		UPDATE
	--			[ClkTransaction]
	--		SET
	--			[OutTimeFromShopClk] = (CASE WHEN [LoggedOff] < @shift_end_date THEN (CASE WHEN [LoggedOff] < [InTimeFromShopClk] THEN [InTimeFromShopClk] ELSE [LoggedOff] END) ELSE @shift_end_date END)  --(SELECT TOP 1 [RoundedTime] FROM @rounded)
	--		WHERE
	--			[TransactionID] = @transactionID


	--	END

	--	--SELECT * FROM @rounded
	--END


--	END
--END
