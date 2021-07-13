USE BWSdb
GO

/*
SELECT * FROM [Defects_Print]
SELECT * FROM [Design StaffV2]
*/

DECLARE @StartDate DATETIME;
DECLARE @EndDate DATETIME;
DECLARE @Companies TABLE ([CompanyID] int);

SET @StartDate = '2020-07-01';
SET @EndDate = '2021-07-16';
INSERT INTO @Companies VALUES (0), (1);

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
