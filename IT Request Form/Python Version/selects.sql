/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [Dept ID] AS [ID]
      ,[Department] AS [DeptName]
  FROM [BWSdb].[dbo].[Department]

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [DeptID]
      ,[BWS Code]
      ,[Class]
      ,[Grouping]
      ,[Dept]
      ,[Position]
      ,[Budget]
      ,[Authorized]
      ,[Pay Scale]
      ,[Comments]
  FROM [BWSdb].[dbo].[Dept]

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
	[ID]
	,[Name] AS [DeptName]
	,[DeptRelations]
	,[DateAdded]

	,[DeptID]
      ,[BWS Code]
      ,[Class]
      ,[Grouping]
      ,[Dept]
      ,[Position]
      ,[Budget]
      ,[Authorized]
      ,[Pay Scale]
      ,[Comments]
FROM 
	[ITD Dept]
FULL OUTER JOIN
	[Dept]
ON
	[DeptRelations] LIKE '%;' + CAST([Dept].[DeptID] AS NVARCHAR(MAX)) + ';%'
	OR [DeptRelations] LIKE CAST([Dept].[DeptID] AS NVARCHAR(MAX)) + ';%'
	OR [DeptRelations] LIKE '%;' + CAST([Dept].[DeptID] AS NVARCHAR(MAX))
	OR [DeptRelations] = CAST([Dept].[DeptID] AS NVARCHAR(MAX))
WHERE
	[ID] IS NULL
	AND [Position] IS NOT NULL
	AND LEN([Position]) > 0


SELECT * FROM [v_ITR Depts] ORDER BY [DeptName]

SELECT * FROM [IT Requests]

SELECT 
	[HardwareID],
	[Hardware]
FROM
	[ITR Hardware]

SELECT
	[SoftwareID],
	[Software]
FROM
	[ITR Software]

SELECT
	[TrainingID],
	[Training]
FROM
	[ITR Training]