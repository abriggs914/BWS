USE BWSdb
GO

SELECT
	'[Department]' AS [T]
	,*
FROM
	[Department]
;

SELECT
	'[Dept]' AS [T]
	,*
FROM
	[Dept]
;

SELECT
	'[ITD Dept]' AS [T]
	,*
FROM
	[ITD Dept]
;

SELECT
	'[v_ITR Depts]' AS [T]
	,*
FROM
	[v_ITR Depts]
;

SELECT
	[Class]
	,[Dept]
	,[Position]
FROM
	[Dept]
WHERE
	[Class] <> ''
GROUP BY
	[Class]
	,[Dept]
	,[Position]

SELECT
	*
FROM
	[ITR Customers]

/*
SELECT
	*
FROM
	[]
*/

SELECT
	*
FROM
	[Employees]
	
SELECT
	[E].*
FROM
	[Employees] [E]
INNER JOIN (
	SELECT
		[1st Name]
		,[2nd Name]
		,[Emp#]
		,ROW_NUMBER() OVER(
			PARTITION BY
				[1st Name]
				,[2nd Name]
				,[Emp#]
			ORDER BY
				[1st Name]
				,[2nd Name]
				,[Emp#] DESC
		) AS [RN]
	FROM		
		[Employees] [E]
	WHERE
		[RN] = 1
) AS [SRC]
ON
	[E].[Emp#]= [SRC].[Emp#]
ORDER BY
	[2nd Name]
	,[1st Name]
;


SELECT
	*
FROM
	[ITR Customers] [C]
FULL OUTER JOIN (
	SELECT
		
	[Employees] [E]
ON
	LOWER([C].[Name]) = LOWER([E].[1st Name] + ' ' + [E].[2nd Name])
