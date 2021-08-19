

DECLARE @JOB AS VARCHAR(20);
SET @JOB = '10014747'
SELECT TOP 1 
		[EmployeeName],[OperationComplete]
	FROM 
		[ClkTransaction]
	WHERE
		[JobNumber] LIKE @JOB
		AND [Operation] = 4
	ORDER BY
		[LoggedOff] DESC, [TransactionID] ASC