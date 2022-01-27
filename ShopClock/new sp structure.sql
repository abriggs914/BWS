USE SysproCompanyA
GO


DECLARE @tid AS BIGINT;
DECLARE @empN AS BIGINT;
DECLARE @shiftID AS INT;
DECLARE @inORout  AS BIT;

SET @tid = (SELECT TOP 1 [TransactionID] FROM [ClkTransaction] WHERE [LoggedOff] IS NULL ORDER BY [TransactionID] DESC)

	--DECLARE @tDate AS DATETIME = '2022-01-25';
	--DECLARE @tDate AS DATETIME = '2022-01-26';

	--DECLARE @tDate AS DATETIME = '2022-01-28';
	--SET @empN = (SELECT TOP 1 [EmployeeNumber] FROM [ClkTransaction] WHERE [LoggedOn] BETWEEN DATEADD(HOUR, -23, @tDate) AND @tDate GROUP BY [EmployeeNumber] HAVING COUNT(*) = 1)
	--SET @tid = (SELECT MIN([TransactionID]) FROM [ClkTransaction] WHERE [LoggedOn] BETWEEN DATEADD(HOUR, -23, @tDate) AND @tDate AND [EmployeeNumber] = @empN)
	--SELECT @empN



SET @empN = (SELECT [EmployeeNumber] FROM [ClkTransaction] WHERE [TransactionID] = @tid)
SET @shiftID = (SELECT [ShiftID] FROM [ClkShiftEmpAssign] WHERE [Emp#] = @empN)
SET @inORout = (CASE WHEN (SELECT [LoggedOff] FROM [ClkTransaction] WHERE [TransactionID] = @tid) IS NULL THEN 1 ELSE 0 END) -- 0 for Out, 1 for In

DECLARE @rules AS TABLE (
	[ShiftID] int,
	[Interval] int,
	[Threshold] int,
	[StartTime] time(7),
	[EndTime] time(7),
	[IncludeLunch] bit,
	[Name] nvarchar(100)
)

INSERT INTO @rules SELECT * FROM [ClkShiftRoundRules] WHERE	[ShiftID] = @shiftID

----------------------------------------------------------------------------------------------------------------------------------------

DECLARE @p_time AS DATETIME
DECLARE @p_interval AS INT
DECLARE @p_in_out AS BIT
DECLARE @p_threshold AS INT
DECLARE @p_start_date AS DATETIME
DECLARE @p_end_date AS DATETIME

DECLARE @s_start_date AS DATETIME
DECLARE @s_end_date AS DATETIME

DECLARE @r_start_date AS DATETIME
DECLARE @r_end_date AS DATETIME
--SET @p_time = 

SET @p_in_out = @inORout
SET @p_time = (SELECT (CASE WHEN @inORout=1 THEN [LoggedOn] ELSE [LoggedOff] END) FROM [ClkTransaction] WHERE [TransactionID]=@tid)
SET @p_interval = (SELECT [Interval] FROM @rules)
SET @p_threshold = (SELECT [Threshold] FROM @rules)
SET @s_start_date = (SELECT [StartTime] FROM @rules)
SET @s_end_date = (SELECT [EndTime] FROM @rules)

SET @p_end_date = @s_end_date + CAST(CAST(YEAR(@p_time) AS nvarchar(4)) + '-' + CAST(MONTH(@p_time) AS nvarchar(2)) + '-' + CAST(DAY(@p_time) AS nvarchar(2)) AS DATETIME)

SET @p_start_date = @s_start_date + CAST(CAST(YEAR(@p_time) AS nvarchar(4)) + '-' + CAST(MONTH(@p_time) AS nvarchar(2)) + '-' + CAST(DAY(@p_time) AS nvarchar(2)) AS DATETIME)

IF @s_start_date >= @s_end_date BEGIN
	-- This shift ran overnight 
	SET @p_start_date = DATEADD(DAY, -1, @p_start_date)
END


--SELECT 
--				COUNT([TransactionID])
--			FROM
--				[ClkTransaction]
--			WHERE
--				[EmployeeNumber] = @empN
--				AND [LoggedOn] BETWEEN DATEADD(HOUR, -4, @p_start_date) AND DATEADD(HOUR, 4, @p_end_date)
--			GROUP BY
--				[TransactionID]
--			HAVING
--				@p_time > MIN([LoggedOn])



DECLARE @first_of_shift AS BIT;
DECLARE @q_data AS TABLE ([In / Out] NVARCHAR(3), [Start Date] DATETIME, [End Date] DATETIME, [InTime] DATETIME, [RoundedTime] DATETIME, [Threshold] INT, [Interval] INT)

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
					AND [LoggedOn] BETWEEN DATEADD(HOUR, -4, @p_start_date) AND DATEADD(HOUR, 4, @p_end_date)
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
	)

	IF @first_of_shift = 1 BEGIN
		INSERT INTO @q_data
		EXEC [dbo].[sp_RoundTime] @time = @p_time, @interval = @p_interval, @in_out = @p_in_out, @threshold = @p_threshold, @start_date = @p_start_date, @end_date = @p_end_date
		
		SELECT @r_start_date = (SELECT [RoundedTime] FROM @q_data)
	END
	ELSE BEGIN
		SELECT @r_start_date = (SELECT [LoggedOn] FROM [ClkTransaction] WHERE [TransactionID] = @tid)
	END

END
ELSE BEGIN
	-- Sign Out
	-- Round all entries
	PRINT 'NOPE'
	
	DELETE FROM @q_data;
	SET @p_time = (SELECT [LoggedOff] FROM [ClkTransaction] WHERE [TransactionID]=@tid)
	INSERT INTO @q_data
	EXEC [dbo].[sp_RoundTime] @time = @p_time, @interval = @p_interval, @in_out = @p_in_out, @threshold = @p_threshold, @start_date = @p_start_date, @end_date = @p_end_date
	SELECT @r_end_date = (SELECT [RoundedTime] FROM @q_data)

END

-------------------------------------------------------------------------------------------------------------------------------
-- Final Selects

--SELECT
--	@tid AS [@tid],
--	@empN AS [@empN],
--	@shiftID AS [@shiftID],
--	@inORout AS [@inORout],
--	@p_in_out AS [@p_in_out],
--	@p_time AS [@p_time],
--	@p_interval AS [@p_interval],
--	@p_threshold AS [@p_threshold],
--	@s_start_date AS [@s_start_date],
--	@s_end_date AS [@s_end_date],
--	@p_start_date AS [@p_start_date],
--	@p_end_date AS [@p_end_date],
--	@first_of_shift AS [@first_of_shift]

--SELECT * FROM [ClkTransaction] WHERE ([LoggedOn] BETWEEN @p_start_date AND @p_end_date OR [LoggedOff] BETWEEN @p_start_date AND @p_end_date) AND [EmployeeNumber] = @empN 

--SELECT * FROM @rules
--SELECT * FROM [ClkTransaction] WHERE [TransactionID] = @tid

----EXEC [dbo].[sp_RoundTime] @time = @p_time, @interval = @p_interval, @in_out = @p_in_out, @threshold = @p_threshold, @start_date = @p_start_date, @end_date = @p_end_date
--SELECT * FROM @q_data
SELECT [LoggedOn], @r_start_date AS [ClkInRounded], [LoggedOff], @r_end_date AS [ClkOutRounded] FROM [ClkTransaction] WHERE [TransactionID] = @tid