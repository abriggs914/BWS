SELECT * FROM [ClkTransaction] WHERE [LoggedOn] > '2022-01-27 3:36 PM'

DECLARE @sd AS DATETIME = '2022-01-26';
DECLARE @ed AS DATETIME = '2022-01-26 23:59:59';

EXEC [dbo].[sp_ClkLabourOverride] @sd=@sd, @ed=@ed

EXEC [sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=0


		SELECT 
			[EmployeeNumber],
			[EmployeeName],
			@sd AS [StartDate],
			@ed AS [EndDate],
			ROUND(((60 * ((DATEPART(HOUR, MAX([OutTimeFromShopClk]) - MIN([InTimeFromShopClk]))))) + DATEPART(MINUTE, MAX([OutTimeFromShopClk]) - MIN([InTimeFromShopClk]))) / 60.0, 2) AS [HrsWorked]
			--ROUND(((60 * (SUM(DATEPART(HOUR, [OutTimeFromShopClk] - [InTimeFromShopClk])))) + SUM(DATEPART(MINUTE, [OutTimeFromShopClk] - [InTimeFromShopClk]))) / 60.0, 2) AS [HrsWorked]
		FROM
			[ClkTransaction]
		WHERE
			[InTimeFromShopClk] BETWEEN @sd AND @ed
		GROUP BY
			[EmployeeNumber], [EmployeeName]
		ORDER BY
			[EmployeeNumber];