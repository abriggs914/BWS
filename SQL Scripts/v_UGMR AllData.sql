USE BWSdb
GO

CREATE VIEW [dbo].[v_UGMR AllData] AS

SELECT
	*
FROM
	[User Happiness Rating]
LEFT JOIN
	[ITR Customers]
ON
	[User Happiness Rating].[UserName] = [ITR Customers].[Name]
LEFT JOIN
	[Dept]
ON	
	[ITR Customers].[Department] = [Dept].[DeptID]