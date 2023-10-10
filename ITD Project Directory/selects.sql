
USE BWSdb
GO

SELECT TOP (1000) [ID]
      ,[DateCreated]
      ,[Active]
      ,[DateActive]
      ,[DateInactive]
      ,[Acronym]
      ,[LongName]
      ,[Description]
  FROM [BWSdb].[dbo].[ITD Project Directory]