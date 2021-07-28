USE BWSdb
GO


--SELECT * FROM [WO]
--SELECT * FROM [v_Access/SysproWORef]
--SELECT * FROM [Order Hours]
--SELECT * FROM [Hours Worked]
--SELECT * FROM [Hours Required]

SELECT
	[Emp#],
	([2nd Name] + ', ' + [1st Name]) AS [Name],
	[Status]
FROM
	[Employees]
WHERE
	[Emp#] IS NOT NULL
	AND [1st Name] IS NOT NULL
	AND [2nd Name] IS NOT NULL
ORDER BY
	[Name]

SELECT * FROM [Status]

SELECT * FROM [Defects]


SELECT Employees.[Emp#], (Employees.[2nd Name] + ', ' + Employees.[1st Name]) AS [Name], Employees.	[Status]
FROM Employees
WHERE Employees.[Emp#] IS NOT NULL 	AND Employees.[1st Name] IS NOT NULL 	AND Employees.[2nd Name] IS NOT NULL 
ORDER BY [Name]

SELECT * FROM [Production]


SELECT
	*
FROM
	[Defects_Print]
ORDER BY
	[Input Date] DESC
;

SELECT
	*
FROM
	[Defects_Location]
	
SELECT
	*
FROM
	[Defects_Print]
ORDER BY
	[Input Date] DESC
;