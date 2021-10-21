USE Stargatedb
GO

BEGIN TRAN;

SELECT * FROM [Employees] ORDER BY [Emp#] DESC
SELECT * FROM [Employees - Salary] ORDER BY [Emp#] DESC


DELETE
	e
FROM
	[Employees] e
INNER JOIN
	[Employees - Salary] s
ON
	e.[Emp#] = s.[Emp#]
WHERE
	1=1
	


SELECT * FROM [Employees] ORDER BY [Emp#] DESC
SELECT * FROM [Employees - Salary] ORDER BY [Emp#] DESC

ROLLBACK;
COMMIT;