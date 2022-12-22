BEGIN TRAN


SELECT * FROM 
[BWS DRAWING # CROSS REFERENCE]
  WHERE 
	[WO#:] = 10016273


/****** Script for SelectTopNRows command from SSMS  ******/
INSERT INTO [BWSdb].[dbo].[BWS DRAWING # CROSS REFERENCE]
SELECT [Orders].[WO#]
      ,NULL AS [Time Reqd]
      ,NULL AS [DATE]
      ,[Orders].[Serial Number] AS [S/N:]
      ,NULL AS [Correct S/N]
      ,0 AS [Status]
      ,NULL AS [MS WO]
      ,NULL AS [Date Issued]
      ,NULL AS [DECK WO]
      ,NULL AS [DESCRIPTION / MODEL:]
      ,NULL AS [Standard]
      ,NULL AS [Tare Weight (LBS)]
      ,0 AS [Actual]
      ,NULL AS [Calculated]
      ,NULL AS [GVWR (LBS)]
      ,NULL AS [DRAWING#:]
      ,NULL AS [COMPLETED By]
      ,[Orders].[CustID] AS [CUSTOMER:]
      ,[COMPANY NAME] AS [DEALER:]
      ,[Notes]
      ,0 AS [Checked]
      ,NULL AS [Checked By]
      ,0 AS [Photos]
      ,NULL AS [PhotosAdded]
      ,0 AS [Checklist Completed]
      ,NULL AS [Checklist Completed By]
      ,NULL AS [Notes V2]
      ,[Prod Date]
  --FROM [BWSdb].[dbo].[BWS DRAWING # CROSS REFERENCE]
  FROM 
	[BWSdb].[dbo].[Orders]
  LEFT JOIN
	[Dealers]
	ON
	[Orders].[DealerID] = [Dealers].[ID]
LEFT JOIN
	[Production]
	ON
		[Orders].[Quote#] = [Production].[Quote#]

  WHERE 
	[Orders].[WO#] = 10016273


SELECT * FROM 
[BWS DRAWING # CROSS REFERENCE]
  WHERE 
	[WO#:] = 10016273


ROLLBACK
COMMIT;