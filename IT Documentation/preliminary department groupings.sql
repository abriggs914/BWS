
SELECT
	[Dept],
	REPLACE([Departments], ' ', '') AS [Departments]
FROM (
	SELECT
		[SrcA].[Dept]
		, (SUBSTRING((
			SELECT
				';' + LTRIM(RTRIM(CAST([DeptID] AS NVARCHAR(MAX)))) AS 'data()'
			FROM
				[Dept]
			WHERE
				[SrcA].[Dept] = [Dept]
			FOR XML PATH('')), 2 , 9999)
		) AS [Departments]
	FROM
		[Dept]
	INNER JOIN
		(
			SELECT
				[Dept]
			FROM
				[Dept]
			GROUP BY
				[Dept]
		) AS [SrcA]
	ON
		[Dept].[Dept] = [SrcA].[Dept]
) AS [SrcB]
GROUP BY
	[Dept]
	, [Departments]