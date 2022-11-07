USE [BWSdb]

GO

CREATE VIEW [v_UserGreetingAllDepartments] AS
SELECT DISTINCT
	[Dept]
FROM
	[Dept]
GROUP BY
	[Dept]
GO