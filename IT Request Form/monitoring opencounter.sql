/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (10000) [ITRequestID#]
      ,[RequestDate]
      ,[StartDate]
      ,[DueDate]
      ,[Request]
      ,[Priority]
      ,[SubPriority]
      ,[RequestedBy]
      ,[Department]
      ,[RequestFollowUpPersonnel]
      ,[RequestType]
      ,[RequestSubType]
      ,[Comments]
      ,[ITRequestts]
      ,[Company]
      ,[Status]
      ,[Directory]
      ,[ITPersonAssignedID]
      ,[CompletionDate]
      ,[LastStatusUpdate]
      ,[LabourEstimate]
      ,[LabourActual]
      ,[TimerStart]
      ,[TimerStop]
      ,[Timer]
	  ,[OpenCounter]
	  ,[IsOpened]
  FROM [BWSdb].[dbo].[IT Requests]



  /****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (10000)
	[ITPersonAssignedID]
	, [Name]
	, [RequestedBy]
FROM
	[BWSdb].[dbo].[IT Requests]
LEFT JOIN
	[IT Personnel]
ON
	[ITPersonAssignedID] = [IT Personnel].ITPersonID#