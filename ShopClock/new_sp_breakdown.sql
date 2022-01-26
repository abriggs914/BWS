USE [SysproCompanyA]
GO
--/****** Object:  Trigger [dbo].[tr_ShopClkRounding]    Script Date: 2022-01-24 3:55:06 PM ******/
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
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		--SET NOCOUNT ON;


		DECLARE @tid as BIGINT;
		SET @tid = 1459357;


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
		DECLARE @empNum AS BIGINT;
	
		SELECT @inTime = (SELECT [LoggedOn] FROM [ClkTransaction] WHERE [TransactionID] = @tid)
		SELECT @outTime = (SELECT [LoggedOff] FROM [ClkTransaction] WHERE [TransactionID] = @tid)
		SELECT @transactionID = (SELECT [TransactionID] FROM [ClkTransaction] WHERE [TransactionID] = @tid)
		SELECT @shiftID = (SELECT [ShiftID] FROM [ClkTransaction] WHERE [TransactionID] = @tid)
		SELECT @transactionDate = (SELECT [LoggedOn] FROM [ClkTransaction] WHERE [TransactionID] = @tid)
		SELECT @empNum = (SELECT [EmployeeNumber] FROM [ClkTransaction] WHERE [TransactionID] = @tid)
		SET @shiftID = (SELECT [ShiftID] FROM [ClkShiftEmpAssign] WHERE [Emp#] = @empNum);

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

		-- THis operation assumes that all shifts start and end on the same calendar day. (NOT TRUE for night shifts)
		SET @shift_start_date = CAST((CAST((CAST(DATEPART(YEAR, @transactionDate) AS VARCHAR(4)) + '-' + CAST(DATEPART(MONTH, @transactionDate) AS VARCHAR(2)) + '-' + CAST(DATEPART(DAY, @transactionDate) AS VARCHAR(2))) AS VARCHAR(30)) + ' ' + CAST(DATEPART(HOUR, @st) AS VARCHAR(30)) + ':' + CAST(DATEPART(MINUTE, @st) AS VARCHAR(30))) AS DATETIME)
		SET @shift_end_date = CAST((CAST((CAST(DATEPART(YEAR, @transactionDate) AS VARCHAR(4)) + '-' + CAST(DATEPART(MONTH, @transactionDate) AS VARCHAR(2)) + '-' + CAST(DATEPART(DAY, @transactionDate) AS VARCHAR(2))) AS VARCHAR(30)) + ' ' + CAST(DATEPART(HOUR, @et) AS VARCHAR(30)) + ':' + CAST(DATEPART(MINUTE, @et) AS VARCHAR(30))) AS DATETIME)

		DECLARE @signed_in_today AS BIT;
		--SET @signed_in_today = (CASE WHEN 
		--	((	SELECT 
		--			[SignedInToday]
		--		FROM 
		--			[ClkTransaction] WITH (NOLOCK)
		--		WHERE 
		--			[EmployeeNumber] = @empNum 
		--			AND ([LoggedOn] BETWEEN DATEADD(HOUR, -2, @shift_start_date) 
		--				AND DATEADD(HOUR, 2, @shift_start_date))) = 1)
		--			OR ((	SELECT
		--						COUNT(*)
		--					FROM
		--						[ClkTransaction] WITH (NOLOCK)
		--					WHERE
		--						[EmployeeNumber] = @empNum 
		--						AND ([LoggedOn] BETWEEN DATEADD(HOUR, -2, @shift_start_date) 
		--							AND DATEADD(HOUR, 2, @shift_start_date))) > 0) THEN 1 ELSE 0 END);
		SET @signed_in_today = (CASE WHEN 
			(
				SELECT 
					COUNT(*)
				FROM 
					[ClkTransaction] WITH (NOLOCK)
				WHERE 
					[EmployeeNumber] = @empNum 
					AND DATEPART(YEAR, [LoggedOn]) = DATEPART(YEAR, @shift_start_date)
					AND DATEPART(MONTH, [LoggedOn]) = DATEPART(MONTH, @shift_start_date)
					AND DATEPART(DAY, [LoggedOn]) = DATEPART(DAY, @shift_start_date)
			) > 0 THEN 1 ELSE 0 END) 


			--((	SELECT 
			--		[SignedInToday]
			--	FROM 
			--		[ClkTransaction] WITH (NOLOCK)
			--	WHERE 
			--		[EmployeeNumber] = @empNum 
			--		AND ([LoggedOn] BETWEEN DATEADD(HOUR, -2, @shift_start_date) 
			--			AND DATEADD(HOUR, 2, @shift_start_date))) = 1)
			--		OR ((	SELECT
			--					COUNT(*)
			--				FROM
			--					[ClkTransaction] WITH (NOLOCK)
			--				WHERE
			--					[EmployeeNumber] = @empNum 
			--					AND ([LoggedOn] BETWEEN DATEADD(HOUR, -2, @shift_start_date) 
			--						AND DATEADD(HOUR, 2, @shift_start_date))) > 0) THEN 1 ELSE 0 END);



		DECLARE @rounded TABLE ([In / Out] VARCHAR(3), [Start Date] DATETIME, [End Date] DATETIME, [InTime] DATETIME, [RoundedTime] DATETIME, [Threshold] INT, [Interval] INT);

		IF @outTime IS NULL BEGIN
			-- Sign-In
			PRINT 'Sign-in'
			IF @signed_in_today = 0 BEGIN
				INSERT INTO @rounded EXEC [dbo].[sp_RoundTime] @time = @inTime, @interval = @interval, @in_out = 1, @threshold = @threshold, @start_date = @shift_start_date, @end_date = @shift_end_date
			END
		
			--UPDATE
			--	[ClkTransaction]
			--SET
			--	[InTimeFromShopClk] = (CASE WHEN @signed_in_today = 0 THEN (SELECT TOP 1 [RoundedTime] FROM @rounded) ELSE [LoggedOn] END),
			--	[SignedInToday] = 1
			--WHERE
			--	[TransactionID] = @transactionID

		END
		ELSE BEGIN
			-- Sign-Out
			PRINT 'Sign-out'

			INSERT INTO @rounded EXEC [dbo].[sp_RoundTime] @time = @outTime, @interval = @interval, @in_out = 0, @threshold = @threshold, @start_date = @shift_start_date, @end_date = @shift_end_date
			--UPDATE
			--	[ClkTransaction]
			--SET
			--	[OutTimeFromShopClk] = (CASE WHEN [LoggedOff] < @shift_end_date THEN (CASE WHEN [LoggedOff] < [InTimeFromShopClk] THEN [InTimeFromShopClk] ELSE [LoggedOff] END) ELSE @shift_end_date END)  --(SELECT TOP 1 [RoundedTime] FROM @rounded)
			--WHERE
			--	[TransactionID] = @transactionID

		END

SELECT * FROM @rounded
SELECT
	@inTime AS [@inTime],
	@outTime AS [@outTime],
	@interval AS [@interval],
	@threshold AS [@threshold],
	@shift_start_date AS [@shift_start_date],
	@shift_end_date AS [@shift_end_date],
	@st AS [@st],
	@et AS [@et],
	@transactionDate AS [@transactionDate],
	@signed_in_today AS [@signed_in_today],
	@today AS [@today],
	@transactionID AS [@transactionID],
	@shiftID AS [@shiftID],
	@empNum AS [@empNum]
	;

EXEC [dbo].[sp_RoundTime] @time = @inTime, @interval = @interval, @in_out = 1, @threshold = @threshold, @start_date = @shift_start_date, @end_date = @shift_end_date
EXEC [dbo].[sp_RoundTime] @time = @outTime, @interval = @interval, @in_out = 0, @threshold = @threshold, @start_date = @shift_start_date, @end_date = @shift_end_date


