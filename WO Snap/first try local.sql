USE SysproCompanyA
GO

DECLARE @t AS TABLE ([ID] INT IDENTITY(1, 1), [TransactionIDIn] BIGINT, [TransactionIDLast] BIGINT, [IsNewShift] BIT)
DECLARE @knownTs AS TABLE ([ID] INT IDENTITY(1, 1), [TransactionIDIn] BIGINT)

-- Grab all missing records from [ClkTransactionNewShifts]
INSERT INTO @knownTs ([TransactionIDIn])
SELECT
	[A].[TransactionID]
FROM
	[ClkTransaction] AS [A] WITH (NOLOCK) 
LEFT JOIN
	[ClkTransactionNewShifts] AS [B] WITH (NOLOCK)
ON
	[A].[TransactionID] = [B].[ClkTransactionIDIn]
WHERE
	[B].[ClkTransactionIDIn] IS NULL
	AND LEFT([A].[EmployeeNumber], 1) <> '1'
;


DECLARE @tID AS BIGINT;
--SELECT @tID = MAX([TransactionID]) FROM [ClkTransaction]
--SELECT @tID = 1518787;
--SELECT @tID = 1518757;
--SELECT @tID = 1518726;
--SELECT @tID = 1518723;
--SELECT @tID = 1518544;
--SELECT @tID = 1518502;

SELECT '[ClkTransaction]' AS [Table], * FROM [ClkTransaction] WHERE [TransactionID] IN (1518787, 1518757, 1518726, 1518723, 1518544, 1518502)



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
SELECT @i = 0, @c = COUNT(*) FROM @knownTs

WHILE @i < @c BEGIN

	SELECT @tID = [TransactionIDIn] FROM @knownTs WHERE [ID] = @i + 1;

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

	INSERT INTO @t ([TransactionIDIn], [IsNewShift], [TransactionIDLast]) SELECT @tID, @isNewShift, @lastTID

	SELECT @i = @i + 1;

END

SELECT '@t' AS [Table], * FROM @t

BEGIN TRAN;

INSERT INTO
	[ClkTransactionNewShifts]
([ClkTransactionIDIn], [ClkTransactionIDLast], [IsNewShift], [Parsed], [Alteration])
SELECT [TransactionIDIn], [TransactionIDLast], [IsNewShift], 1, 'INSERT' FROM @t

ROLLBACK;
COMMIT;