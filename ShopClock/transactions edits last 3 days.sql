/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [UserID]
		,[EmployeeName]
      ,[EditLocalDateTime]
      ,[EditType]
      ,[EditDescription]
      ,[ClkTransaction].[TransactionID]
      ,[TimeStamp]
      ,[Job]
      ,[Employee]
      ,[EditField]
      ,[PreviousValue]
      ,[UpdatedValue]
      ,[ReversalID]
  FROM [SysproCompanyA].[dbo].[ClkTransactionEdits]
  INNER JOIN
	[ClkTransaction]
ON	[ClkTransactionEdits].[TransactionID] = [ClkTransaction].[TransactionID]
WHERE
	[ClkTransaction].[LoggedOn] BETWEEN DATEADD(DAY, -3, GETDATE()) AND GETDATE()
ORDER BY
	[EditLocalDateTime] DESC