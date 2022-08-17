/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UserHappyRatingID#]
      ,[UserName]
      ,[RatingDate]
      ,[Rating]
      ,[userhappyratingts]
      ,[RatingTime (DO NOT USE)]
      ,[RatingTime2]
  FROM [BWSdb].[dbo].[User Happiness Rating]

SELECT CAST(CAST([RatingDate] AS NVARCHAR(MAX)) + ' ' + CAST([RatingTime2] AS NVARCHAR(MAX)) AS DATETIME) FROM [User Happiness Rating]

SELECT * FROM [User Happiness Rating] WHERE [UserName] = 'Avery Briggs' AND CDATE(CSTR([RatingDate]) + ' ' + CSTR([RatingTime2])) BETWEEN DATEADD('d', -1, #2022-08-16 1:40:58 PM#) AND #2022-08-16 1:40:58 PM#

SELECT CAST('2022-08-12 10:07:18.673' AS DATETIME)