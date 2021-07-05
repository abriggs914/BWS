USE BWSdb
GO


-- Starting wage
WITH CurrentPay AS (
	SELECT
		ROW_NUMBER() OVER (
			PARTITION BY [2nd Name], [1st Name]
			ORDER BY [Date]
		) AS row_num, *
	FROM 
		[Payroll]
),
CP AS (SELECT * FROM [Orders])
SELECT 
	[Emp#], [Date], [2nd Name], [1st Name], [Salary], [Annual], [Bonus%], [Dep Life], [Health], [Dental], [Vacation%], [RRSP%], [RaiseID]
FROM
	CurrentPay WITH (NOLOCK)
WHERE
	CurrentPay.[row_num] = 1
ORDER BY [Date]


-- Current wage
WITH CurrentPay AS (
	SELECT
		ROW_NUMBER() OVER (
			PARTITION BY [2nd Name], [1st Name]
			ORDER BY [Date] DESC
		) AS row_num, *
	FROM 
		[Payroll]
),
CP AS (SELECT * FROM [Orders])
SELECT 
	[Emp#], [Date], [2nd Name], [1st Name], [Salary], [Annual], [Bonus%], [Dep Life], [Health], [Dental], [Vacation%], [RRSP%], [RaiseID]
FROM
	CurrentPay WITH (NOLOCK)
WHERE
	CurrentPay.[row_num] = 1
ORDER BY [Date]

-- Current wage
WITH CurrentPay AS (
	SELECT
		ROW_NUMBER() OVER (
			PARTITION BY [2nd Name], [1st Name]
			ORDER BY [Date] DESC
		) AS row_num, *
	FROM 
		[Payroll]
	WHERE
		[row_num] = 1
)

--FirstPay AS (
--	SELECT
--		ROW_NUMBER() OVER (
--			PARTITION BY [2nd Name], [1st Name]
--			ORDER BY [Date]
--		) AS row_num, *
--	FROM 
--		[Payroll]
--	WHERE
--		FirstPay.[row_num] = 1
--)
SELECT 
	CurrentPay.[Emp#],
	CurrentPay.[Date] AS [Last Pay Rise],
	CurrentPay.[2nd Name],
	CurrentPay.[1st Name],
	CASE
        WHEN CurrentPay.[Salary] IS NULL AND CurrentPay.[Annual] IS NULL THEN -1
        WHEN CurrentPay.[Salary] IS NULL THEN CurrentPay.[Annual] / 52
        WHEN CurrentPay.[Annual] IS NULL THEN (CurrentPay.[Salary] * 40 * 50) / 52
        WHEN (CurrentPay.[Salary] * 40 * 50) / 52 >= CurrentPay.[Annual] / 52 THEN (CurrentPay.[Salary] * 40 * 50) / 52
        ELSE                                        CurrentPay.[Annual] / 52
    END AS [Per Week],
	CurrentPay.[Salary],
	(CurrentPay.[Salary] * 40 * 50) / 52 AS [Salary Per Week], 
	CurrentPay.[Salary] * 40 * 50 AS [Salary Per Year],
	CurrentPay.[Annual],
	CurrentPay.[Annual] / 52 AS [Annual Per Week],
	CurrentPay.[Bonus%],
	CurrentPay.[Dep Life],
	CurrentPay.[Health],
	CurrentPay.[Dental],
	CurrentPay.[Vacation%],
	CurrentPay.[RRSP%],
	CurrentPay.[RaiseID]
FROM
	CurrentPay
INNER JOIN
	FirstPay
ON
	CurrentPay.[Emp#] = FirstPay.[Emp#]
ORDER BY [Per Week]
--ORDER BY [2nd Name]

-- table of current values with columns of first day, and first wage. difference columns for days and wages
