USE BWSdb
GO

/*
SELECT * FROM [Defects_Receiving]
*/

DECLARE @StartDate DATETIME;
DECLARE @EndDate DATETIME;
SET @StartDate = '2020-07-01';
SET @EndDate = '2021-07-16';

WITH [SupplierDefects] AS (
	SELECT
		[Supplier],
		[Reason],
		ROW_NUMBER() OVER (
			PARTITION BY 
				[Supplier],
				[Reason]
			ORDER BY 
				[Supplier] DESC
		) AS [# Defects]
	FROM
		[Defects_Receiving]
	WHERE
		[Reason] IS NOT NULL
		AND [Input Date] Between @StartDate	And @EndDate
)
SELECT
	[Supplier],
	[Reason],
	MAX([# Defects]) AS [Total Defects]
FROM
	[SupplierDefects]
GROUP BY
	[Supplier],
	[Reason]
ORDER BY
	[Supplier],
	[Reason]
;