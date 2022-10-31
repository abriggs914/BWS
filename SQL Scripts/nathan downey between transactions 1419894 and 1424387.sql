USE SysproCompanyA
GO

SELECT 
	* 
FROM 
	[ClkTransaction]
WHERE
	[EmployeeNumber] = 200434
	AND	[TransactionID] BETWEEN 1419894 AND 1424387
ORDER BY
	[LoggedOn] DESC