USE BWSdb
GO

DECLARE @PRINT BIT = 1;

IF @PRINT = 1 BEGIN
	SELECT * FROM [Defects_Print]
	SELECT * FROM [Design StaffV2]
	SELECT * FROM [Defects_Print]
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
INSERT INTO @Companies VALUES (0);

SELECT
	*
FROM (
	SELECT
		[Staff],
		[Defect],
		MAX([# Defects]) AS [Total Defects]
	FROM (
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
	) AS [EngineerDefects]
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
) AS [SourceTable]
PIVOT (
	SUM([Total Defects])
	FOR
		[Defect]
	IN (
		[Wrong Count],
		[Incorrect Parts],
		[Labelled Wrong]
	)
) AS [PivotTable]
ORDER BY
	[Supplier]
;
