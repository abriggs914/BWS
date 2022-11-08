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
ALTER TRIGGER [dbo].[tr_CheckNewShift]
   ON [SysproCompanyA].[dbo].[ClkTransaction]
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here

	

	DECLARE @tID AS BIGINT;
	--SELECT @tID = MAX([TransactionID]) FROM [ClkTransaction]
	--SELECT @tID = 1518787;
	--SELECT @tID = 1518757;
	--SELECT @tID = 1518726;
	--SELECT @tID = 1518723;
	--SELECT @tID = 1518544;
	--SELECT @tID = 1518502;

	--SELECT '[ClkTransaction]' AS [Table], * FROM [ClkTransaction] WHERE [TransactionID] IN (1518787, 1518757, 1518726, 1518723, 1518544, 1518502)



	DECLARE @empNum AS BIGINT;
	DECLARE @lastTID AS BIGINT;
	DECLARE @isNewShift AS BIT;

	DECLARE @newLogOn AS DATETIME;
	DECLARE @newLogOff AS DATETIME;
	DECLARE @oldLogOn AS DATETIME;
	DECLARE @oldLogOff AS DATETIME;
	DECLARE @diffS AS BIGINT;
	DECLARE @hourThreshold AS DECIMAL(14, 3);
	DECLARE @i AS INTEGER;
	DECLARE @c AS INTEGER;

	SELECT @hourThreshold = 9.5
	--SELECT @i = 0, @c = COUNT(*) FROM @knownTs

	--WHILE @i < @c BEGIN


		SELECT @tID = [TransactionID] FROM inserted i;

		SELECT @empNum = [EmployeeNumber], @newLogOn = [LoggedOn], @newLogOff = [LoggedOff] FROM [ClkTransaction] WHERE [TransactionID] = @tID
		SELECT TOP 1
			@lastTID = [TransactionID],
			@oldLogOn = [LoggedOn],
			@oldLogOff = [LoggedOff] 
		FROM 
			[ClkTransaction] 
		WHERE
			[EmployeeNumber] = @empNum 
			AND [TransactionID] < @tID
		ORDER BY
			[TransactionID] DESC

		SELECT @diffS = DATEDIFF(SECOND, @oldLogOff, @newLogOn)

		SELECT @isNewShift = (CASE WHEN @diffS >= (@hourThreshold * 60 * 60) THEN 1 ELSE 0 END)

		DECLARE @takesLunchToday AS BIT;
		DECLARE @shiftID AS INT;
		DECLARE @lunchStart AS TIME;
		DECLARE @lunchEnd AS TIME;
		DECLARE @weekday AS INT
		DECLARE @subLunchBreak BIT;

		IF DATEPART(DAY, @newLogOn) = DATEPART(DAY, @newLogOff) BEGIN
			SELECT @weekday = DATEPART(WEEKDAY, @newLogOn)
		END
		ELSE BEGIN
			DECLARE @pd1 AS DECIMAL(14, 2)
			DECLARE @pd2 AS DECIMAL(14, 2)
			SELECT @pd1 = 100 - [BWSdb].[dbo].[PercentOfDay](@newLogOn)
			SELECT @pd2 = [BWSdb].[dbo].[PercentOfDay](@newLogOff)
			IF @pd1 >= @pd2 BEGIN
				SELECT @weekday = DATEPART(WEEKDAY, @newLogOn)
			END
			ELSE BEGIN
				SELECT @weekday = DATEPART(WEEKDAY, @newLogOff)
			END
		END

		SELECT
			@shiftID = [ClkShiftEmpAssign].[ShiftID]
			,@lunchStart = (CASE WHEN @weekday = 1 THEN 
								(CASE WHEN [ClkShiftRoundRules V2].[IncludeLunchSun] = 1 THEN [SunLunchStart] ELSE NULL END)
							WHEN @weekday = 2 THEN 
								(CASE WHEN [ClkShiftRoundRules V2].[IncludeLunchMon] = 1 THEN [MonLunchStart] ELSE NULL END)
							WHEN @weekday = 3 THEN 
								(CASE WHEN [ClkShiftRoundRules V2].[IncludeLunchTue] = 1 THEN [TueLunchStart] ELSE NULL END)
							WHEN @weekday = 4 THEN 
								(CASE WHEN [ClkShiftRoundRules V2].[IncludeLunchWed] = 1 THEN [WedLunchStart] ELSE NULL END)
							WHEN @weekday = 5 THEN 
								(CASE WHEN [ClkShiftRoundRules V2].[IncludeLunchThu] = 1 THEN [ThuLunchStart] ELSE NULL END)
							WHEN @weekday = 6 THEN 
								(CASE WHEN [ClkShiftRoundRules V2].[IncludeLunchFri] = 1 THEN [FriLunchStart] ELSE NULL END)
							WHEN @weekday = 7 THEN 
								(CASE WHEN [ClkShiftRoundRules V2].[IncludeLunchSat] = 1 THEN [SatLunchStart] ELSE NULL END)
							END)
			,@lunchEnd = (CASE WHEN @weekday = 1 THEN 
								(CASE WHEN [ClkShiftRoundRules V2].[IncludeLunchSun] = 1 THEN [SunLunchEnd] ELSE NULL END)
							WHEN @weekday = 2 THEN 
								(CASE WHEN [ClkShiftRoundRules V2].[IncludeLunchMon] = 1 THEN [MonLunchEnd] ELSE NULL END)
							WHEN @weekday = 3 THEN 
								(CASE WHEN [ClkShiftRoundRules V2].[IncludeLunchTue] = 1 THEN [TueLunchEnd] ELSE NULL END)
							WHEN @weekday = 4 THEN 
								(CASE WHEN [ClkShiftRoundRules V2].[IncludeLunchWed] = 1 THEN [WedLunchEnd] ELSE NULL END)
							WHEN @weekday = 5 THEN 
								(CASE WHEN [ClkShiftRoundRules V2].[IncludeLunchThu] = 1 THEN [ThuLunchEnd] ELSE NULL END)
							WHEN @weekday = 6 THEN 
								(CASE WHEN [ClkShiftRoundRules V2].[IncludeLunchFri] = 1 THEN [FriLunchEnd] ELSE NULL END)
							WHEN @weekday = 7 THEN 
								(CASE WHEN [ClkShiftRoundRules V2].[IncludeLunchSat] = 1 THEN [SatLunchEnd] ELSE NULL END)
							END)
		FROM
			[ClkShiftEmpAssign]
		LEFT JOIN
			[ClkShiftRoundRules V2] 
		ON
			[ClkShiftEmpAssign].[ShiftID] = [ClkShiftRoundRules V2].[ShiftID]
		WHERE
			[Emp#] = @empNum

		SELECT @takesLunchToday = (CASE WHEN @lunchStart IS NOT NULL AND @lunchEnd IS NOT NULL THEN 1 ELSE 0 END)

		IF @takesLunchToday = 1 BEGIN
			SELECT @subLunchBreak = (CASE WHEN 
				[BWSdb].[dbo].[PercentOfDay](@newLogOn) <= [BWSdb].[dbo].[PercentOfDay](@lunchStart) AND [BWSdb].[dbo].[PercentOfDay](@lunchEnd) <= [BWSdb].[dbo].[PercentOfDay](@newLogOff) THEN 1 ELSE 0 END)
		END

		-- Insert statements for trigger here
		IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) BEGIN

			DECLARE @lastNewShiftID AS BIGINT;
			SELECT @lastNewShiftID = MAX([TransactionID]) FROM [ClkTransactionNewShifts] WHERE [ClkTransactionIDIn] = @tID

			UPDATE
				[ClkTransactionNewShifts]
			SET
				[ClkTransactionIDLast] = @lastTID
				, [IsNewShift] = @isNewShift
				, [Parsed] = 1
				, [Alteration] = 'UPDATE'
				, [SubtractLunchBreak] = @subLunchBreak
			FROM
				[ClkTransactionNewShifts]
			WHERE
				[ClkTransactionNewShifts].[TransactionID] = @lastNewShiftID
		END
		IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) BEGIN
			INSERT INTO [ClkTransactionNewShifts] ([ClkTransactionIDIn], [IsNewShift], [ClkTransactionIDLast], [Parsed], [Alteration], [SubtractLunchBreak]) SELECT @tID, @isNewShift, @lastTID, 1, 'INSERT', @subLunchBreak
		END



		


END
GO
