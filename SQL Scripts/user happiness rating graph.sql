USE BWSdb
GO

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
	'User Happiness Rating' AS [Table]
	,[UserHappyRatingID#]
	,[UserName]
	,[RatingDate]
	,[Rating]
	,[userhappyratingts]
	,[RatingTime (DO NOT USE)]
	,[RatingTime2]
FROM
	[BWSdb].[dbo].[User Happiness Rating]

SELECT 
	'Dept' AS [Table],
	* FROM [Dept]
SELECT 
	'BomEmployee' AS [Table],
	* FROM [SysproCompanyA].[dbo].[BomEmployee] ORDER BY [Name]

SELECT 
	'ITD Dept' AS [Table],
	* FROM [ITD Dept]
SELECT 
	'ITR Customers' AS [Table],
	* FROM [ITR Customers]


-----------------------------------------------------------------------------------------------------------------------

SELECT
	'FINAL' AS [Table]
	,[User Happiness Rating].[UserName]
	,[User Happiness Rating].[RatingDate]
	,[User Happiness Rating].[Rating]
	,[User Happiness Rating].[RatingTime2]
	,[ITR Customers].[Email]
	,[Dept].[Dept]
	,[Dept].[DeptID]
	,[ITR Customers].[Department]
FROM
	[User Happiness Rating]
INNER JOIN
	[ITR Customers]
ON
	[User Happiness Rating].[UserName] = [ITR Customers].[Name]
LEFT JOIN
	[Dept]
ON
	[ITR Customers].[Department] = [Dept].[DeptID]
;

--BEGIN TRAN;
--SELECT * FROM [ITR Customers] WHERE [Department] = 0
--UPDATE [ITR Customers] SET [Department] = 1 WHERE [Department] = 0
--SELECT * FROM [ITR Customers] WHERE [Department] = 0
--ROLLBACK;
--COMMIT;