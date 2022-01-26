DECLARE @tid as BIGINT;
SET @tid = 1459450;

-- Insert statements for trigger here
DECLARE @today AS DATETIME;
DECLARE @inTime AS DATETIME, @outTime AS DATETIME;
DECLARE @shift_start_date AS DATETIME, @shift_end_date AS DATETIME;
DECLARE @rounded_inTime AS DATETIME, @rounded_outTime AS DATETIME;
DECLARE @st AS DATETIME, @et AS DATETIME;
DECLARE @transactionDate DATETIME;
DECLARE @interval INT;
DECLARE @threshold INT;
DECLARE @transactionID INT;
DECLARE @shiftID INT;
DECLARE @empNum AS BIGINT;
DECLARE @signed_in_today AS BIT;
DECLARE @sign_in_out AS BIT;

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

SET @sign_in_out = (CASE WHEN @outTime IS NULL THEN 1 ELSE 0 END) -- 1 for sign in, 0 for out
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
	@sign_in_out AS [@sign_in_out],
	@today AS [@today],
	@transactionID AS [@transactionID],
	@shiftID AS [@shiftID],
	@empNum AS [@empNum]
	;


SELECT
	*
FROM 
	[ClkTransaction] WITH (NOLOCK)
WHERE 
	[EmployeeNumber] = @empNum 
	AND DATEPART(YEAR, [LoggedOn]) = DATEPART(YEAR, @shift_start_date)
	AND DATEPART(MONTH, [LoggedOn]) = DATEPART(MONTH, @shift_start_date)
	AND DATEPART(DAY, [LoggedOn]) = DATEPART(DAY, @shift_start_date)