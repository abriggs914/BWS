USE Stargatedb
GO


SELECT
	dbo.Dept.Dept,
	dbo.Dept.DeptID,
	CASE dept.Dept 
		WHEN 'Assembly' THEN 'Lester Brooker'
		WHEN 'Axle' THEN 'Lester Brooker'
		WHEN 'Finish - Assembly' THEN 'Gaylon Smith' 
		WHEN 'Finish - Blast' THEN 'Gaylon Smith' 
		WHEN 'Finish - Paint' THEN 'Gaylon Smith'
        WHEN 'Machine Shop' THEN 'Charlie Guest' 
		WHEN 'Screener - Assembly' THEN 'Lester Brooker' 
		WHEN 'Sub Beams' THEN 'Lester Brooker' 
		WHEN 'Sub GNK' THEN 'Lester Brooker' 
		WHEN 'Sub Parts' THEN 'Lester Brooker' 
		WHEN 'Parts Dept.' THEN 'Lance Lunn' 
		WHEN 'Maintenance' THEN 'Gary Thomas' 
		WHEN 'Production' THEN 'Lester Brooker' 
		WHEN 'Special Projects' THEN 'Gary Thomas' 
		WHEN 'Human Resources' THEN 'Todd Saunders' 
		WHEN 'Bill Of Materials' THEN 'Jamie Merrithew' 
		WHEN 'Engineering' THEN 'Barry Blaney'
		ELSE ''
	END AS Manager
FROM
	dbo.Employees
INNER JOIN
	dbo.Dept
ON
	dbo.Employees.Dept = dbo.Dept.DeptID

SELECT * 
FROM
	[Dept]
--SELECT * 
--FROM
--	[Employees]


--SELECT 
--	[Emp#],
--	[2nd Name],
--	[1st Name]
--FROM
--	[Employees]
--UNION ALL
--SELECT	
--	[Emp#],
--	[2nd Name],
--	[1st Name]
--FROM
--	[Employees - Salary]