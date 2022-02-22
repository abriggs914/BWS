USE [BWSdb]
GO

INSERT INTO [dbo].[IT Requests]
           ([RequestDate]
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
           ,[Company]
           ,[Status])
     VALUES
           ('2021-11-17'
           ,NULL
           ,'2021-11-25'
           ,'This is sample request text. It may be very long because the request could be very specific, therfore this text box should be rather large to store all of the available text. Should alos allow someone to add picture files or any additional information pertaining to the request. This will need to be stored somewhere in the public drive. So I will have to verify the path before appending it to the "array" list.'
           ,0
           ,0
           ,'Avery Briggs'
           ,10
           ,'100'
           ,'Hardware'
           ,'Computer'
           ,NULL
           ,'BWS'
           ,NULL)
GO


