DECLARE @t AS TABLE ([ID] INT IDENTITY(1, 1), [RowID] INT, [Name] NVARCHAR(MAX));
INSERT INTO @t ([RowID], [Name])
SELECT
	* 
FROM (
	SELECT [ID], [Name] FROM [ITI Condition]
	UNION ALL
	SELECT [ID], [Name] FROM [ITI Status]
	UNION ALL
	SELECT [ID], [Name] FROM [ITI Type]
	UNION ALL
	SELECT [ID], [Name] FROM [ITI Computer]
	UNION ALL
	SELECT [ID], [Name] FROM [ITI Peripherals]
	UNION ALL
	SELECT [ID], [Name] FROM [ITI Network]
	UNION ALL
	SELECT [ID], [Name] FROM [ITI Wire]
	UNION ALL
	SELECT [ID], [Name] FROM [ITI Unknown]
) AS [Src]
;

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [ITI Serial Indication].[ID]
      ,[DateCreated]
      ,[Active]
      ,[DateActive]
      ,[DateInactive]
      ,[TableName]
      ,[ITI Serial Indication].[RowID]
      ,[Serial]
	  ,[Name]
  FROM [BWSdb].[dbo].[ITI Serial Indication]
INNER JOIN
	@t
ON
	[ITI Serial Indication].[ID] = [@t].[ID]