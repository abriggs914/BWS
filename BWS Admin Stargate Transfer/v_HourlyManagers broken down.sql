USE Stargatedb
GO


SELECT
	dbo.Dept.Dept,
	dbo.Dept.DeptID,
	CASE dept.Dept 
		--WHEN 'Assembly' THEN 'Lester Brooker'
		--WHEN 'Axle' THEN 'Lester Brooker'
		--WHEN 'Finish - Assembly' THEN 'Gaylon Smith' 
		--WHEN 'Finish - Blast' THEN 'Gaylon Smith' 
		--WHEN 'Finish - Paint' THEN 'Gaylon Smith'
        --WHEN 'Machine Shop' THEN 'Charlie Guest' 
		--WHEN 'Screener - Assembly' THEN 'Lester Brooker' 
		--WHEN 'Sub Beams' THEN 'Lester Brooker' 
		--WHEN 'Sub GNK' THEN 'Lester Brooker' 
		--WHEN 'Sub Parts' THEN 'Lester Brooker' 
		--WHEN 'Parts Dept.' THEN 'Lance Lunn' 
		--WHEN 'Production' THEN 'Lester Brooker' 
		--WHEN 'Special Projects' THEN 'Gary Thomas' 
		--WHEN 'Bill Of Materials' THEN 'Jamie Merrithew'
		
		WHEN 'Human Resources' THEN 'Todd Saunders' 
		WHEN 'Engineering' THEN 'Amir Kondri'
		WHEN 'Truck Driver' THEN 'Lori Piper'
		WHEN 'Parts Processor' THEN 'Lori Piper'
		WHEN 'Purchasing' THEN 'Lori Piper'
		WHEN 'Quality Control' THEN 'Matthew Evans'
		WHEN 'Quality Control' THEN 'Matthew Evans'
		WHEN 'Parts & Sales' THEN 'Matthew Evans'
		WHEN 'Parts Dept.' THEN 'Matthew Evans'
		WHEN 'Maintenance' THEN 'Matthew Evans' 
		WHEN 'Box Up' THEN 'Greg Szutka' 
		WHEN 'Walls' THEN 'Greg Szutka' 
		WHEN 'Truck' THEN 'Greg Szutka' 
		WHEN 'Robot' THEN 'Greg Szutka' 
		WHEN 'Prep' THEN 'Greg Szutka' 
		WHEN 'Polish' THEN 'Greg Szutka' 
		WHEN 'Sand Blast / Paint' THEN 'Rick Howard' 
		WHEN 'Finishing' THEN 'Rick Howard' 
		WHEN 'Electric' THEN 'Rick Howard' 
		WHEN 'Forklift Operators' THEN 'Rick Howard' 
		WHEN 'Chassie' THEN 'Rick Howard' 
		WHEN 'Live Bottom' THEN 'Tim Garraway / Bharat (Ricky) Surujbally' 
		WHEN 'Afternoon Shift Employees' THEN 'Andrew Forbes' 
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
SELECT * 
FROM
	[Employees]
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