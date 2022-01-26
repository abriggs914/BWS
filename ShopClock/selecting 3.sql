USE SysproCompanyA
GO

SELECT * FROM [ClkFrmConfirm]
EXEC [dbo].[sp_ClkLabourOverride] @sd='2022-01-24', @ed='2022-01-24 23:59'
EXEC [sp_ClkTallyHours] @sd='2022-01-24', @ed='2022-01-24 23:59', @by_transaction=0

SELECT ROUND(((60 * (SUM(DATEPART(HOUR, [OutTimeFromShopClk] - [InTimeFromShopClk])))) + SUM(DATEPART(MINUTE, [OutTimeFromShopClk] - [InTimeFromShopClk]))) / 60.0, 2) AS [HrsWorked] FROM [ClkTransaction]
		WHERE
			[InTimeFromShopClk] BETWEEN '2022-01-24' AND '2022-01-24 23:29'

			
DECLARE @sd AS DATETIME;
DECLARE @ed AS DATETIME;
SET @sd = '2022-01-24 7:00'
SET @ed = '2022-01-24 17:00'
SELECT
	ROUND(
		(
			
				60 * (
					SUM(
						DATEPART(
							HOUR,
							@ed - @sd
						)
					)
				)
			
		
		+ SUM(
			DATEPART(
				MINUTE,
				@ed - @sd
			)
		)
	
 / 60.0), 2) AS [HrsWorked] FROM [ClkTransaction]



		SELECT 
			[EmployeeNumber],
			[EmployeeName],
			@sd AS [StartDate],
			@ed AS [EndDate],
			ROUND(((60 * (SUM(DATEPART(HOUR, [OutTimeFromShopClk] - [InTimeFromShopClk])))) + SUM(DATEPART(MINUTE, [OutTimeFromShopClk] - [InTimeFromShopClk]))) / 60.0, 2) AS [HrsWorked]
		FROM
			[ClkTransaction]
		WHERE
			[InTimeFromShopClk] BETWEEN @sd AND @ed
		GROUP BY
			[EmployeeNumber], [EmployeeName]
		ORDER BY
			[EmployeeNumber];


EXEC [sp_ClkTallyHours] @sd=@sd, @ed=@ed, @empNum=200299, @by_transaction=0
SELECT * FROM [ClkTransaction] WHERE [EmployeeNumber] = 200299 AND YEAR([LoggedOn]) = 2022 ORDER BY [LoggedOn]