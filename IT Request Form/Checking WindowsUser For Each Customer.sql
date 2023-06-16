/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [CustomerID]
      ,[Name]
      ,[ITR Customers].[WindowsUser]
      ,[Department]
      ,[Company]
      ,[Email]
      ,[WorkPhone]
      ,[WorkExtension]
      ,[CellPhone]
      ,[HomePhone]
      ,[Active]
      ,[DateAdded]
      ,[LastActive]
      ,[WorkPhoneLastActive]
      ,[WorkExtensionLastActive]
      ,[CellPhoneLastActive]
      ,[HomePhoneLastActive]
  FROM [BWSdb].[dbo].[ITR Customers]
RIGHT JOIN
	[ADG Events]
ON
	[ITR Customers].[WindowsUser] = [ADG Events].[WindowsUser]

  ORDER BY
	[Name]