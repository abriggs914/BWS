/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000000) [TransactionID]
      ,[DateCreated]
      ,[ClkTransactionIDIn]
      ,[ClkTransactionIDLast]
      ,[IsNewShift]
      ,[Parsed]
      ,[Alteration]
  FROM [SysproCompanyA].[dbo].[ClkTransactionNewShifts] WITH (NOLOCK)