DECLARE @tid AS BIGINT;
		DECLARE @empN AS BIGINT;
		DECLARE @shiftID AS INT;
		DECLARE @inORout  AS BIT;

		

DECLARE @itfsc AS DATETIME;
--DECLARE @tid AS INT;
SELECT
	@tid = [TransactionID] 
	, @itfsc = [InTimeFromShopClk] 
FROM [ClkTransaction] WHERE [TransactionID] = 1549311;




		--SET @tid = (SELECT TOP 1 [TransactionID] FROM [ClkTransaction] WHERE [LoggedOff] IS NULL ORDER BY [TransactionID] DESC)
		--SELECT @tid = [TransactionID] FROM INSERTED i;

			--DECLARE @tDate AS DATETIME = '2022-01-25';
			--DECLARE @tDate AS DATETIME = '2022-01-26';

			--DECLARE @tDate AS DATETIME = '2022-01-28';
			--SET @empN = (SELECT TOP 1 [EmployeeNumber] FROM [ClkTransaction] WHERE [LoggedOn] BETWEEN DATEADD(HOUR, -23, @tDate) AND @tDate GROUP BY [EmployeeNumber] HAVING COUNT(*) = 1)
			--SET @tid = (SELECT MIN([TransactionID]) FROM [ClkTransaction] WHERE [LoggedOn] BETWEEN DATEADD(HOUR, -23, @tDate) AND @tDate AND [EmployeeNumber] = @empN)
			--SELECT @empN



		SET @empN = (SELECT [EmployeeNumber] FROM [ClkTransaction] WHERE [TransactionID] = @tid);
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
			[IncludeLunchSat] bit,
			[SunLunchStart] TIME,
			[SunLunchEnd] TIME,
			[MonLunchStart] TIME,
			[MonLunchEnd] TIME,
			[TueLunchStart] TIME,
			[TueLunchEnd] TIME,
			[WedLunchStart] TIME,
			[WedLunchEnd] TIME,
			[ThuLunchStart] TIME,
			[ThuLunchEnd] TIME,
			[FriLunchStart] TIME,
			[FriLunchEnd] TIME,
			[SatLunchStart] TIME,
			[SatLunchEnd] TIME,
			[Active] Bit,
			[DateActive] DATETIME,
			[DateInActive] DATETIME
		);

		INSERT INTO @rules SELECT * FROM [ClkShiftRoundRules V2] WHERE	[ShiftID] = @shiftID;



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
	-- IF this is a sign-in transaction, move the shift end date forward 1 day
	-- otherwise, move the shift start date backward 1 day
	if @inORout = 1
        begin
            SET @p_end_date = DATEADD(DAY, 1, @p_end_date);
                    
        end
    else
        begin
            SET @p_start_date = DATEADD(DAY, -1, @p_start_date);
        end
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



DELETE FROM @q_data;
SELECT @r_start_date = @itfsc;
SET @p_time = (SELECT [LoggedOff] FROM [ClkTransaction] WHERE [TransactionID]=@tid);


DECLARE @intervals TABLE ([Interval#] INT, [Interval] DATETIME, [InTime] DATETIME, [In / Out] VARCHAR(3));
	DECLARE @n_minutes AS FLOAT;
	DECLARE @t AS DATETIME;
	DECLARE @i AS INT;

	--IF @interval = 0 BEGIN
	--	SET @interval = 1;
	--END
	SET @n_minutes = CEILING(DATEDIFF(MINUTE, @p_start_date, @p_end_date) / CAST(@p_interval AS DECIMAL(14, 7)));
	SET @i = 0;

SELECT @p_time AS [PTIME], @n_minutes AS [NM], @p_start_date AS [PSD], @p_end_date [PED], DATEDIFF(MINUTE, @p_start_date, @p_end_date) AS [DD], @p_interval AS [PINT];

SET @i = @n_minutes;
		WHILE @i >= 0 BEGIN
			SET @t = DATEADD(MINUTE, @i * @p_interval, @p_start_date);
			INSERT INTO @intervals ([Interval#], [Interval], [InTime], [In / Out]) VALUES (@i, @t, @p_time, (CASE WHEN @p_in_out=1 THEN 'In' ELSE 'Out' END));
			--IF DATEADD(MINUTE, -@p_threshold_early, @t) <= @p_time BEGIN 
			IF @t <= @p_time BEGIN 
				PRINT 'B'
				BREAK;
			END
			SET @i = @i - 1;
		END

SELECT 
	'intervals' AS [T]
	, *
FROM 
	@intervals

		-- Final Select
INSERT INTO @q_data
		SELECT TOP 1 
			[In / Out],
			@p_start_date AS [Start Date],
			@p_end_date AS [End Date],
			[InTime],
			[Interval] AS [RoundedTime],
			@p_threshold_early AS [ThresholdEarly],
			@p_threshold_late AS [ThresholdLate],
			@p_interval AS [Interval]
		FROM
			@intervals
		ORDER BY [Interval#] DESC;


--EXEC [dbo].[sp_RoundTime] @time = @p_time, @interval = @p_interval, @in_out = @p_in_out, @threshold_early = @p_threshold_early, @threshold_late = @p_threshold_late, @start_date = @p_start_date, @end_date = @p_end_date;


SELECT @r_end_date = (SELECT [RoundedTime] FROM @q_data);


IF @r_start_date > @r_end_date BEGIN
	PRINT 'A'
	SET @r_end_date = @r_start_date;
END

SELECT
	'@q' AS [T],
	*
FROM
	@q_data

SELECT 
	@r_start_date AS [@r_start_date]
	, @r_end_date AS [@r_end_date]