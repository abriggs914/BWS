DECLARE
	@StartDate DATETIME,
	@EndDate DATETIME,
	@CompanyString VARCHAR(MAX)
	
SET @StartDate = '2000-01-01';
SET @EndDate = '2030-01-01';
SET @CompanyString = '0,1';

SELECT
	[Engineer],
	[Input Date],
	[Problem],
	[ProblemID]
FROM
	[Defects_Print]
LEFT JOIN
	[Defects_Print_Problems]
ON
	[Defects_Print_Problems].[DefPrintProbsID#] = [ProblemID]


DECLARE @Companies TABLE ([CompanyID] int);
	INSERT INTO @Companies ([CompanyID]) (
		SELECT
			*
		FROM
			dbo.split_string(@CompanyString, ',')
		)
	--INSERT INTO @Companies VALUES (0), (1);

	SELECT
		*
	FROM (
		SELECT
			[CompanyID],
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
				LEFT JOIN
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
			[CompanyID],
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
			[Finish],
			[Other]
		)
	) AS [PivotTable]
	ORDER BY
		[CompanyID], [Staff]
	;