USE BWSdb
GO

DECLARE @PRINT BIT = 1;

IF @PRINT = 1 BEGIN
	SELECT * FROM [Defects_Print]
	SELECT * FROM [Design StaffV2]
	SELECT * FROM [Defects_Print] ORDER BY [Input Date] DESC
	SELECT * FROM [Defects_Causes]
END

DECLARE @StartDate DATETIME;
DECLARE @EndDate DATETIME;
DECLARE @Companies TABLE ([CompanyID] int);

SET @StartDate = '2020-07-01';
SET @EndDate = '2021-07-16';
INSERT INTO @Companies VALUES (0);

WITH [EngineerDefects] AS (
	SELECT
		[Engineer],
		[Defect],
		ROW_NUMBER() OVER (
			PARTITION BY 
				[Engineer],
				[Defect]
			ORDER BY 
				Engineer DESC
		) AS [# Defects]
	FROM
		[Defects_Print]
	WHERE
		[Input Date] Between @StartDate	And @EndDate
)
SELECT
	[Staff],
	[Defect],
	MAX([# Defects]) AS [Total Defects]
FROM
	[EngineerDefects]
LEFT JOIN
	[Design StaffV2]
ON
	[EngineerDefects].[Engineer] = [Design StaffV2].[ID-SaleStaff]
WHERE
	[Design StaffV2].[CompanyID] IN (SELECT [CompanyID] FROM @Companies)
GROUP BY
	[Staff],
	[Defect]
ORDER BY
	[Staff],
	[Defect]
;


DECLARE @StartDate DATETIME;
DECLARE @EndDate DATETIME;
DECLARE @Companies TABLE ([CompanyID] int);

SET @StartDate = '2020-07-01';
SET @EndDate = '2021-07-16';
INSERT INTO @Companies VALUES (0), (1);

SELECT
	*
FROM (
	SELECT
		[Staff],
		[Problem],
		MAX([# Defects]) AS [Total Defects]
	FROM (
		SELECT
			[Engineer],
			[Problem],
		ROW_NUMBER() OVER (
			PARTITION BY 
				[Engineer],
				[ProblemID]
			ORDER BY 
				Engineer DESC
			) AS [# Defects]
		FROM (
			SELECT
				[Engineer],
				[Input Date],
				[Problem],
				[ProblemID]
			FROM
				[Defects_Print]
			INNER JOIN
				[Defects_Print_Problems]
			ON
				[Defects_Print_Problems].[DefPrintProbsID#] = [ProblemID]
			) AS A
		WHERE
			[Input Date] Between @StartDate	And @EndDate
	) AS [EngineerDefects]
	LEFT JOIN
		[Design StaffV2]
	ON
		[EngineerDefects].[Engineer] = [Design StaffV2].[ID-SaleStaff]
	WHERE
		[Design StaffV2].[CompanyID] IN (SELECT [CompanyID] FROM @Companies)
	GROUP BY
		[Staff],
		[Problem]
) AS [SourceTable]
PIVOT (
	SUM([Total Defects])
	FOR
		[Problem]
	IN (
		[Typo],
		[Material],
		[Missing Dimension],
		[Left + Right],
		[Missing / Inompletet Parts List],
		[Different Parts Labeled As Same],
		[Incorrect Part #''s],
		[Other]
	)
) AS [PivotTable]
ORDER BY
	[Staff]
;



DECLARE @StartDate DATETIME;
DECLARE @EndDate DATETIME;
DECLARE @Companies TABLE ([CompanyID] int);

SET @StartDate = '2020-07-01';
SET @EndDate = '2021-08-16';
INSERT INTO @Companies VALUES (0), (1);

SELECT
	[Engineer],
	[Problem],
ROW_NUMBER() OVER (
	PARTITION BY 
		[Engineer],
		[ProblemID]
	ORDER BY 
		Engineer DESC
	) AS [# Defects]
FROM (
	SELECT
		[Engineer],
		[Input Date],
		[Problem],
		[ProblemID]
	FROM
		[Defects_Print]
	INNER JOIN
		[Defects_Print_Problems]
	ON
		[Defects_Print_Problems].[DefPrintProbsID#] = [ProblemID]
	) AS A
WHERE
	[Input Date] Between @StartDate	And @EndDate


SELECT
		[Engineer],
		[Input Date],
		[ProblemID]
	FROM
		[Defects_Print]