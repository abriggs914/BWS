USE BWSdb
GO

DECLARE @PRINT BIT = 1;

IF @PRINT = 1 BEGIN
	SELECT * FROM [Defects_Receiving];
	SELECT * FROM [Defects_Receiving_Problems]
END

DECLARE @StartDate DATETIME;
DECLARE @EndDate DATETIME;
SET @StartDate = '2019-07-01';
SET @EndDate = '2021-07-18';

WITH [SupplierDefects] AS (
	SELECT
		[Supplier],
		[ProblemID],
		ROW_NUMBER() OVER (
			PARTITION BY 
				[Supplier],
				[ProblemID]
			ORDER BY 
				[Supplier] DESC
		) AS [# Defects]
	FROM
		[Defects_Receiving]
	WHERE
		[Input Date] Between @StartDate	And @EndDate
)
SELECT
	[Supplier],
	[Problem],
	MAX([# Defects]) AS [Total Defects]
FROM
	[SupplierDefects]
INNER JOIN
	[Defects_Receiving_Problems]
ON
	[SupplierDefects].[ProblemID] = [Defects_Receiving_Problems].[DefRecProbsID#]
GROUP BY
	[Supplier],
	[Problem]
ORDER BY
	[Supplier],
	[Problem]
;


DECLARE @StartDate DATETIME;
DECLARE @EndDate DATETIME;
SET @StartDate = '2019-07-01';
SET @EndDate = '2021-07-18';
DECLARE @Problems TABLE ([Problem] VARCHAR(30))
INSERT INTO @Problems ([Problem]) (SELECT [Problem] FROM [Defects_Receiving_Problems]);
SELECT * FROM @Problems
SELECT
	*
FROM (
	SELECT
		[Supplier],
		[Problem],
		MAX([# Defects]) AS [Total Defects]
	FROM (
		SELECT
			[Supplier],
			[Problem],
			ROW_NUMBER() OVER (
				PARTITION BY 
					[Supplier],
					[Reason]
				ORDER BY 
					[Supplier] DESC
			) AS [# Defects]
		FROM
			[Defects_Receiving]
		INNER JOIN
			[Defects_Receiving_Problems]
		ON
			[Defects_Receiving].[ProblemID] = [Defects_Receiving_Problems].[DefRecProbsID#]
		WHERE
			[Input Date] Between @StartDate	And @EndDate
	) AS [StartTable]
	GROUP BY
		[Supplier],
		[Problem]
) AS [SourceTable]
PIVOT (
	SUM([Total Defects])
	FOR
		[Problem]
	IN (
		[Wrong Count],
		[Incorrect Parts],
		[Labelled Wrong]
	)
) AS [PivotTable]
ORDER BY
	[Supplier]
;