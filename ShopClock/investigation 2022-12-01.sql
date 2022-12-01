USE SysproCompanyA
GO

DECLARE @date AS DATETIME;
SET @date = '2022-11-30';

SELECT
	*
FROM
	[ClkTransactionEdits]
FULL OUTER JOIN
	[ClkTransaction]
ON
	[ClkTransactionEdits].[TransactionID] = [ClkTransaction].[TransactionID]
FULL OUTER JOIN
	[ClkTransactionReversals]
ON
	[ClkTransactionEdits].[TransactionID] = [ClkTransaction].[TransactionID]
WHERE
	[ClkTransaction].[EmployeeNumber] IN ('100063', '100056')
	AND [ClkTransaction].[LoggedOff] BETWEEN DATEADD(DAY, -3, @date) AND @date
	AND [ClkTransactionReversals].[EmployeeNumber] IN ('100063', '100056')
	--AND [ClkTransactionReversals].[LoggedOff] BETWEEN DATEADD(DAY, -3, @date) AND @date
ORDER BY
	[ClkTransaction].[LoggedOff] DESC
;
