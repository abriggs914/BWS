USE BWSdb
GO

DECLARE @StartDate DATETIME;
DECLARE @EndDate DATETIME;
SET @StartDate = '2020-07-01'
SET @EndDate = '2021-07-16'

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
	Defects_Location.Location HAVING (((Defects_Location.Location) Is Not Null));