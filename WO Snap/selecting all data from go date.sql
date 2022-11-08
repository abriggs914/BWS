USE SysproCompanyA
GO

DECLARE @go_date AS DATETIME
SELECT @go_date = '2022-11-08 10AM';


SELECT * FROM [ClkTransaction] WHERE [LoggedOn] > @go_date
SELECT
	* 
FROM
	[ClkTransaction]
INNER JOIN
	[ClkTransactionNewShifts]
ON	
	[ClkTransaction].[TransactionID] = [ClkTransactionNewShifts].[ClkTransactionIDIn]
WHERE
	[LoggedOn] > @go_date