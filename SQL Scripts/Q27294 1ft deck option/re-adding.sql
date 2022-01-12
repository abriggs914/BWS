USE [BWSdb]
GO
BEGIN TRAN;
INSERT INTO [dbo].[Options]
           ([Model No]
           ,[Option No]
           ,[Start Date]
           ,[End Date]
           ,[Price]
           ,[Sections]
           ,[Description]
           ,[Weight]
           ,[Width]
           ,[Deck Length]
           ,[Spread]
           ,[SortSe]
           ,[Draw/Part#]
           ,[Std Hours]
           ,[Obsolete]
           ,[Selection]
           ,[New Option Wording]
           ,[OptionInfo]
           ,[OptionPromptFlag]
           ,[OptionPrompt]
           ,[OptionConfigInfo]
           ,[US Price])
     VALUES
           ('10GT1X'
           ,'10GT1X-00002'
           ,'2022-01-12'
           ,'2022-02-12'
           , 0
           ,'GOOSENECK'
           ,'* 1 ft. Additional Main Deck'
           ,0
           ,NULL
           ,NULL
           ,NULL
           ,7
           ,NULL
           ,NULL
           ,1
           ,0
           ,NULL
           ,NULL
           ,0
           ,NULL
           ,NULL
           ,0)

ROLLBACK;
COMMIT;
GO


