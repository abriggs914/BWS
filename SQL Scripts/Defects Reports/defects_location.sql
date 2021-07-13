USE BWSdb
GO

/*
SELECT * FROM [Defects]
SELECT * FROM [Defects_Location]
*/

DECLARE @StartDate DATETIME;
DECLARE @EndDate DATETIME;
SET @StartDate = '2020-07-01';
SET @EndDate = '2021-07-16';

SELECT
	Defects_Location.Location,
	Sum(Defects.[#FrontDefects]) AS Front,
	Sum(Defects.[#RearDefects]) AS Rear
FROM
	Defects
INNER JOIN
	Defects_Location
ON
	Defects.LocationID = Defects_Location.[LocationID#]
WHERE
	(((Defects.[Input Date]) Between @StartDate	And @EndDate))
GROUP BY
	Defects_Location.Location HAVING (((Defects_Location.Location) Is Not Null))
;


-- Alter these values to include trailer lines in the "Other" category.
DECLARE @OtherLines TABLE (ID VARCHAR(17));
INSERT INTO @OtherLines VALUES 
				('Axle Shop'),
				('Engineering'),
				('Machine Shop'),
				('Material handling'),
				('S13'),
				('Supplier'),
				('Other')
;


WITH [OtherTable] AS (
	SELECT
		Defects_Location.Location,
		Sum(Defects.[#FrontDefects]) AS Front,
		Sum(Defects.[#RearDefects]) AS Rear
	FROM
		Defects
	INNER JOIN
		Defects_Location
	ON
		Defects.LocationID = Defects_Location.[LocationID#]
	WHERE
		(((Defects.[Input Date]) Between @StartDate	And @EndDate))
		AND 
			[Defects_Location].[Location] IN (SELECT [ID] FROM @OtherLines)
	GROUP BY
		Defects_Location.Location HAVING (((Defects_Location.Location) Is Not Null))
)
SELECT
	Defects_Location.Location,
	Sum(Defects.[#FrontDefects]) AS Front,
	Sum(Defects.[#RearDefects]) AS Rear
FROM
	Defects
INNER JOIN
	Defects_Location
ON
	Defects.LocationID = Defects_Location.[LocationID#]
WHERE
	(((Defects.[Input Date]) Between @StartDate	And @EndDate))
	AND [Defects_Location].[Location] NOT IN (SELECT [ID] FROM @OtherLines)
GROUP BY
	Defects_Location.Location HAVING (((Defects_Location.Location) Is Not Null))
UNION ALL (
		SELECT 
			'Other' AS [Other],
			SUM([OtherTable].[Front]),
			SUM([OtherTable].[Rear])
		FROM
			[OtherTable]
)
;