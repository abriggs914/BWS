USE SysproCompanyA
GO

DECLARE @shift_start_date DATETIME = '2021-11-08 7:00';
DECLARE @shift_end_date DATETIME = '2021-11-08 16:30';
DECLARE @empNum AS BIGINT = 200100;
DECLARE @signed_in_today AS Bit;
		SET @signed_in_today = (CASE WHEN 
			((	SELECT 
					[SignedInToday]
				FROM 
					[ClkTransaction] WITH (NOLOCK)
				WHERE 
					[EmployeeNumber] = @empNum 
					AND ([LoggedOn] BETWEEN DATEADD(HOUR, -2, @shift_start_date) 
						AND DATEADD(HOUR, 2, @shift_start_date))) = 1)
					OR ((	SELECT
								COUNT(*)
							FROM
								[ClkTransaction] WITH (NOLOCK)
							WHERE
								[EmployeeNumber] = @empNum 
								AND ([LoggedOn] BETWEEN DATEADD(HOUR, -2, @shift_start_date) 
									AND DATEADD(HOUR, 2, @shift_start_date))) > 0) THEN 1 ELSE 0 END);

	SELECT @signed_in_today AS [SignedInToday]

	SELECT * FROM [ClkTransaction] WHERE [EmployeeNumber] = @empNum

SELECT (CASE WHEN (SELECT COUNT(*) FROM [ClkTransaction] WITH (NOLOCK) WHERE [EmployeeNumber] = @empNum AND ([LoggedOn] BETWEEN DATEADD(HOUR, -2, @shift_start_date) AND DATEADD(HOUR, 2, @shift_start_date))) > 0 THEN 'YES' ELSE 'NO' END) AS [SignedInToday]