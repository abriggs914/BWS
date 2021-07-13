USE BWSdb
GO

/*
SELECT * FROM [Defects_BPF]
SELECT * FROM [Defects_BPF_Location]
*/

DECLARE @StartDate DATETIME;
DECLARE @EndDate DATETIME;
SET @StartDate = '2020-07-01';
SET @EndDate = '2021-07-16';
	
SELECT
	[Defects_BPF_Location].Location,
	Sum([Defects_BPF].[#FrontDefects]) AS Front,
	Sum([Defects_BPF].[#RearDefects]) AS Rear
FROM
	[Defects_BPF]
INNER JOIN
	[Defects_BPF_Location]
ON
	[Defects_BPF].LocationID = [Defects_BPF_Location].[Location_BPFID#]
WHERE
	((([Defects_BPF].[Input Date]) Between @StartDate And @EndDate))
GROUP BY
	[Defects_BPF_Location].Location HAVING ((([Defects_BPF_Location].Location) Is Not Null))
