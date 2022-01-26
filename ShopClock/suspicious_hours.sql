EXEC [dbo].[sp_ClkLabourOverride] @sd='2022-01-25', @ed='2022-01-25 23:59:59'

SELECT * FROM [ClkTransaction] WHERE [EmployeeNumber] = 200198 AND YEAR([LoggedOn]) = 2022 AND MONTH([LoggedOn]) = 1 AND DAY([LoggedOn]) = 25 ORDER BY [TransactionID] DESC


DECLARE @si1 AS DATETIME = '2022-01-25 6:15'
DECLARE @so1 AS DATETIME = '2022-01-25 6:15'

DECLARE @si2 AS DATETIME = '2022-01-25 12:00'
DECLARE @so2 AS DATETIME = '2022-01-25 12:30'

DECLARE @si3 AS DATETIME = '2022-01-25 12:30'
DECLARE @so3 AS DATETIME = '2022-01-25 16:30'

EXEC [dbo].[sp_ClkTallyHours] @sd=@si2, @ed=@so2;
EXEC [dbo].[sp_ClkTallyHours] @sd=@si3, @ed=@so3;
EXEC [dbo].[sp_ClkTallyHours] @sd=@si1, @ed=@so1;