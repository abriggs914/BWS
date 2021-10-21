
USE Stargatedb
GO


SELECT * FROM [v_EmployeeBadges] ORDER BY [Emp#]

DECLARE @StartEmp VARCHAR(8), @EndEmp VARCHAR(8);
SET @StartEmp = '300001';
SET @EndEmp = '300003';

SELECT * FROM [v_EmployeeBadges]
WHERE [Emp#] between @StartEmp and @EndEmp
ORDER BY [Emp#]