
DECLARE @empN AS BIGINT = 200440;
DECLARE @p_start_date AS DATETIME = '2022-01-27 05:30:00.000';
DECLARE @p_end_date AS DATETIME = '2022-01-27 19:30:00.000';

DECLARE @p_time AS DATETIME;
SET @p_time = '2022-01-27 08:54:00.000';
SET @p_time = '2022-01-27 06:16:00.000';

DECLARE @first_of_shift AS BIT;

SELECT CASE WHEN (
			SELECT
			COUNT(*) AS [C]
			FROM
				[ClkTransaction]
			WHERE
				[EmployeeNumber] = @empN
				AND [LoggedOn] BETWEEN DATEADD(HOUR, -4, @p_start_date) AND DATEADD(HOUR, 4, @p_end_date)
			GROUP BY
				[TransactionID]
			HAVING
				@p_time > MIN([LoggedOn])
			)
			IS NULL
			THEN 1 ELSE 0 END AS [A]




SELECT * FROM [ClkTransaction] WHERE ([LoggedOn] BETWEEN @p_start_date AND @p_end_date OR [LoggedOff] BETWEEN @p_start_date AND @p_end_date) AND [EmployeeNumber] = @empN 
SET @first_of_shift = (
	CASE 
		WHEN (
			SELECT 
				COUNT([TransactionID])
			FROM
				[ClkTransaction]
			WHERE
				[EmployeeNumber] = @empN
				AND [LoggedOn] BETWEEN DATEADD(HOUR, -4, @p_start_date) AND DATEADD(HOUR, 4, @p_end_date)
			GROUP BY
				[TransactionID]
			HAVING
				@p_time > MIN([LoggedOn])
		) IS NULL THEN
			1
		ELSE
			0
		END
	)
SELECT @first_of_shift AS [First?]
--SELECT [LoggedOff], [LoggedOn], DATEADD(HOUR, -6, [LoggedOff]) FROM [ClkTransaction] WHERE [EmployeeNumber] = @empN AND (@p_time BETWEEN DATEADD(HOUR, -6, [LoggedOn]) AND [LoggedOff])