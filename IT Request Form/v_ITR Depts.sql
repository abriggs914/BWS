
USE BWSdb
GO


ALTER VIEW [v_ITR Depts] AS
	
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
		[Position] IS NOT NULL
		AND LEN([Position]) > 0