
SELECT
	*
FROM
	[BWSdb].[dbo].[Payroll]
ORDER BY
	[RaiseID]
;

SELECT
	*
FROM
	[BWSdb].[dbo].[Employees - Salary]
ORDER BY
	[2nd Name] ASC
	,[1st Name] ASC
	,[Date Hired] DESC
	,[Terminated] ASC
;

SELECT
	*
FROM
	[BWSdb].[dbo].[Employees]
ORDER BY
	[2nd Name] ASC
	,[1st Name] ASC
	,[Date Hired] DESC
	,[Terminated] ASC
;

SELECT
	*
FROM
	[BWSdb].[dbo].[Employees]
ORDER BY
	[2nd Name] ASC
	,[1st Name] ASC
	,[Date Hired] DESC
	,[Terminated] ASC
;

--WHERE
	--(
	--(([1st Name] LIKE '%aver%') OR [2nd Name] LIKE '%aver%')
	--OR 
	/*(([1st Name] LIKE '%josh%') AND [2nd Name] LIKE '%hath%')
	OR */
	--(([1st Name] LIKE '%caleb%') AND [2nd Name] LIKE '%g%')
ORDER BY
	[Date] DESC
;

SELECT
	[Src1].[RaiseID],
	[Src1].[Date],
	[Src1].[1st Name],
	[Src1].[2nd Name],
	[P].[Annual],
	[P].[Salary],
	[P].[Hourly/Salary]
	--,
	--[P].
FROM (
	SELECT
		ROW_NUMBER() OVER(
			PARTITION BY
				[All].[2nd Name]
				,[All].[1st Name]
			ORDER BY
				[All].[Date] DESC
		) AS [RaiseNumber]
		, *
	FROM
		[BWSdb].[dbo].[Payroll] [All]
	LEFT JOIN (
		SELECT
			[2nd Name] AS [C_2Name]
			,[1st Name] AS [C_1Name]
			,[Emp#] AS [C_Emp#]
		FROM
			[BWSdb].[dbo].[Payroll] [P]
		WHERE
			YEAR([Date]) = YEAR(GETDATE())
	) AS [Curr]
	ON
		([All].[2nd Name] = [Curr].[C_2Name])
		AND ([All].[1st Name] = [Curr].[C_1Name])
	WHERE
		([All].[2nd Name] IS NOT NULL)
		AND ([Curr].[C_Emp#] IS NULL)
		AND (YEAR([All].[Date]) <> YEAR(GETDATE()))
) AS [Src1]
INNER JOIN
	[BWSdb].[dbo].[Payroll] [P]
ON
	/*([P].[2nd Name] = [Src1].[2nd Name])
	AND ([P].[1st Name] = [Src1].[1st Name])*/
	[Src1].[RaiseID] = [P].[RaiseID]
WHERE
	[Src1].[RaiseNumber] = 1
ORDER BY
	[Date] DESC



GROUP BY
	[1st Name]
	, [2nd Name]
ORDER BY
	[2nd Name]
	, [1st Name]


	--(
	--(([1st Name] LIKE '%aver%') OR [2nd Name] LIKE '%aver%')
	--OR 
	/*(([1st Name] LIKE '%josh%') AND [2nd Name] LIKE '%hath%')
	OR */
	(([1st Name] LIKE '%luis%') AND [2nd Name] LIKE '%p%')
ORDER BY
	[Date] DESC