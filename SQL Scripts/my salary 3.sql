--USE Stargatedb
USE BWSdb
GO

DECLARE @current_wage AS TABLE (
	[row_num] INT,
	[RaiseID] INT,
	[Emp#] REAL,
	[Date] DATETIME,
	[STS] NVARCHAR(MAX),
	[Salary] FLOAT,
	[Annual] MONEY,
	[Bonus%] FLOAT,
	[Dep Life] FLOAT,
	[Health] FLOAT,
	[Dental] FLOAT,
	[Vacation%] FLOAT,
	[RRSP%] FLOAT,
	[Absent] FLOAT,
	[Late] FLOAT,
	[Leave Early] FLOAT,
	[NQ] BIT,
	[Reason] NVARCHAR(MAX),
	[2nd Name] NVARCHAR(MAX),
	[1st Name] NVARCHAR(MAX),
	[Hourly/Salary] NVARCHAR(MAX),
	[Comments] NVARCHAR(MAX)
)

INSERT INTO @current_wage
	SELECT
		ROW_NUMBER() OVER (
			PARTITION BY [2nd Name], [1st Name]
			ORDER BY [Date] DESC
		) AS row_num,
		[RaiseID],
	[Emp#],
	[Date],
	[STS],
	[Salary],
	[Annual],
	[Bonus%],
	[Dep Life],
	[Health],
	[Dental],
	[Vacation%],
	[RRSP%],
	[Absent],
	[Late],
	[Leave Early],
	[NQ],
	[Reason],
	[2nd Name],
	[1st Name],
	[Hourly/Salary],
	[Comments]
	FROM 
		[Payroll]

-- Current Wage
SELECT 
	[Emp#], [Date], [2nd Name], [1st Name], [Salary], [Annual], [Bonus%], [Dep Life], [Health], [Dental], [Vacation%], [RRSP%], [RaiseID]
FROM
	@current_wage
WHERE
	[row_num] = 1
ORDER BY [Date]


SELECT
	[Emp#], [Date], [2nd Name], [1st Name], [Salary], [Annual], [Bonus%], [Dep Life], [Health], [Dental], [Vacation%], [RRSP%], [RaiseID]
FROM
	@current_wage
ORDER BY
	[2nd Name], [1st Name], [row_num] DESC


SELECT
	[2nd Name],
	[1st Name],
	COUNT(*) AS [# Raises],

	MIN([Date]) AS [1st Date],
	MAX([Date]) AS [-1st Date],
	DATEDIFF(DAY, MIN([Date]), MAX([Date])) AS [Date Diff],

	MIN([Salary]) AS [Min Salary],
	MAX([Salary]) AS [Max Salary],
	AVG([Salary]) AS [Avg Salary],
	MAX([Salary]) - MIN([Salary]) AS [Salary Diff],
	MAX([Salary]) - MIN([Salary]) / (CASE WHEN DATEDIFF(DAY, MIN([Date]), MAX([Date])) = 0 THEN 1 ELSE DATEDIFF(DAY, MIN([Date]), MAX([Date])) END) AS [Salary Diff / Day],

	MIN([Annual]) AS [Min Annual],
	MAX([Annual]) AS [Max Annual],
	AVG([Annual]) AS [Avg Annual],
	MAX([Annual]) - MIN([Annual]) AS [Annual Diff],
	MAX([Annual]) - MIN([Annual]) / (CASE WHEN DATEDIFF(DAY, MIN([Date]), MAX([Date])) = 0 THEN 1 ELSE DATEDIFF(DAY, MIN([Date]), MAX([Date])) END) AS [Annual Diff / Day],

	MIN([Health]) AS [Min Health],
	MAX([Health]) AS [Max Health],
	AVG([Health]) AS [Avg Health],
	MAX([Health]) - MIN([Health]) AS [Health Diff],
	MAX([Health]) - MIN([Health]) / (CASE WHEN DATEDIFF(DAY, MIN([Date]), MAX([Date])) = 0 THEN 1 ELSE DATEDIFF(DAY, MIN([Date]), MAX([Date])) END) AS [Health Diff / Day],

	MIN([Dental]) AS [Min Dental],
	MAX([Dental]) AS [Max Dental],
	AVG([Dental]) AS [Avg Dental],
	MAX([Dental]) - MIN([Dental]) AS [Dental Diff],
	MAX([Dental]) - MIN([Dental]) / (CASE WHEN DATEDIFF(DAY, MIN([Date]), MAX([Date])) = 0 THEN 1 ELSE DATEDIFF(DAY, MIN([Date]), MAX([Date])) END) AS [Dental Diff / Day],

	MIN([Vacation%]) AS [Min Vacation%],
	MAX([Vacation%]) AS [Max Vacation%],
	AVG([Vacation%]) AS [Avg Vacation%],
	MAX([Vacation%]) - MIN([Vacation%]) AS [Vacation% Diff],
	MAX([Vacation%]) - MIN([Vacation%]) / (CASE WHEN DATEDIFF(DAY, MIN([Date]), MAX([Date])) = 0 THEN 1 ELSE DATEDIFF(DAY, MIN([Date]), MAX([Date])) END) AS [Vacation% Diff / Day],

	MIN([RRSP%]) AS [Min RRSP%],
	MAX([RRSP%]) AS [Max RRSP%],
	AVG([RRSP%]) AS [Avg RRSP%],
	MAX([RRSP%]) - MIN([RRSP%]) AS [RRSP% Diff],
	MAX([RRSP%]) - MIN([RRSP%]) / (CASE WHEN DATEDIFF(DAY, MIN([Date]), MAX([Date])) = 0 THEN 1 ELSE DATEDIFF(DAY, MIN([Date]), MAX([Date])) END) AS [RRSP% Diff / Day]
FROM
	@current_wage
GROUP BY
	[2nd Name], [1st Name]
ORDER BY
	[Salary Diff] DESC
	--[2nd Name], [1st Name]



-- Current Wage
SELECT 
	[Emp#], [Date], [2nd Name], [1st Name], [Salary], [Annual], [Bonus%], [Dep Life], [Health], [Dental], [Vacation%], [RRSP%], [RaiseID]
FROM
	@current_wage
WHERE
	[row_num] = 1
	AND YEAR([Date]) = 2022
ORDER BY [Date]