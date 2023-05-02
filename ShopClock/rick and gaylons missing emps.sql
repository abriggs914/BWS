USE BWSdb
GO


--SELECT [Emp#], [2nd Name], [1st Name] FROM [Employees] ORDER BY [1st Name],  [2nd Name]
--WHERE
--	([2nd Name] = 'Samayoa' AND [1st Name] = 'Josiah')
--		--AND ([2nd Name] = 'Joey' AND [1st Name] = 'Alward') 
--		--AND ([2nd Name] = 'Eric')
--		--AND ([2nd Name] = 'Dennis')

DECLARE @day1 AS DATETIME = '2023-05-01';
DECLARE @day2 AS DATETIME = '2023-05-01 23:59:59';

DECLARE @employeesInQuestion AS TABLE (
	[ID] INT IDENTITY(0, 1),
	[EmpN] INT,
	[2ndName] NVARCHAR(MAX),
	[1stName] NVARCHAR(MAX),
	[AccessShift] NVARCHAR(MAX),
	[ShopClockShift] NVARCHAR(MAX)
);

INSERT INTO @employeesInQuestion ([EmpN], [2ndName], [1stName])
SELECT [Emp#], [2nd Name], [1st Name] FROM [Employees] 
WHERE
	(CASE 
		WHEN [1st Name] = 'Josiah' AND [2nd Name] = 'Samayoa' THEN 1 
		WHEN [1st Name] = 'Joey' AND [2nd Name] = 'Alward' THEN 1 
		WHEN [1st Name] = 'Eric' AND [2nd Name] = 'Ndulaka' THEN 1 
		WHEN [1st Name] = 'Dennis' THEN 1 
		ELSE 0
	END) = 1
ORDER BY
	[2nd Name],
	[1st Name]
;

UPDATE
	@employeesInQuestion
SET
	[AccessShift] = NULL,
	[ShopClockShift] = NULL
FROM 
	@employeesInQuestion
INNER JOIN
	
WHERE
	

SELECT * FROM @employeesInQuestion;


SELECT
	*
FROM
	[SysproCompanyA].[dbo].[ClkTransaction] AS [CT]
INNER JOIN
	@employeesInQuestion
ON
	[CT].[EmployeeNumber] = '200' + CAST([EmpN] AS NVARCHAR(3))
WHERE
	([LoggedOn] BETWEEN @day1 AND @day2)
	OR
	([LoggedOff] BETWEEN @day1 AND @day2)
ORDER BY
	[LoggedOn]