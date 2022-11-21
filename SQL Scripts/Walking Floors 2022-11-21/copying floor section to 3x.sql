USE BWSdb
GO

SELECT * FROM [OptionsV2] WHERE [Model No] LIKE '%walking floor 2x%' AND [Sections] LIKE '%floor%'
SELECT * FROM [OptionsV2] WHERE [Model No] LIKE '%walking floor 3x%' AND [Sections] LIKE '%floor%'
SELECT * FROM [Budget Options V2] WHERE [Model No] LIKE '%walking floor 2x%' AND [Sections] LIKE '%floor%'
SELECT * FROM [Budget Options V2] WHERE [Model No] LIKE '%walking floor 3x%' AND [Sections] LIKE '%floor%'

BEGIN TRAN;

INSERT INTO
	[OptionsV2]
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
      ,[US Price]
      ,[CompanyID])
	SELECT
	 'Walking Floor 3X'
      ,REPLACE([Option No], 'Walking Floor 2X', 'Walking Floor 3X')
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
      ,[US Price]
      ,[CompanyID]
	  FROM 
		[OptionsV2]
		 WHERE [Model No] LIKE '%walking floor 2x%' AND [Sections] LIKE '%floor%'

INSERT INTO
	[Budget Options V2]
([Bud_Date_Opt]
      ,[Model No]
      ,[Option No]
      ,[Description]
      ,[Cost]
      ,[Labour Cost]
      ,[Made In Material]
      ,[Bought Out Material]
      ,[Machine Shop]
      ,[Steel Kit]
      ,[Axles]
      ,[Stakes/Bunks]
      ,[Beam]
      ,[GNK]
      ,[Parts]
      ,[Line]
      ,[Step 1]
      ,[Step 2]
      ,[Blast]
      ,[Paint]
      ,[Finish]
      ,[Finish - GNK]
      ,[Final Assembly]
      ,[Tire Assembly]
      ,[Shipping]
      ,[Sections]
      ,[SortSe]
      ,[Obsolete]
      ,[CompanyID])
	SELECT
		[Bud_Date_Opt]
      ,'Walking Floor 3X'
      ,REPLACE([Option No], 'Walking Floor 2X', 'Walking Floor 3X')
      ,[Description]
      ,[Cost]
      ,[Labour Cost]
      ,[Made In Material]
      ,[Bought Out Material]
      ,[Machine Shop]
      ,[Steel Kit]
      ,[Axles]
      ,[Stakes/Bunks]
      ,[Beam]
      ,[GNK]
      ,[Parts]
      ,[Line]
      ,[Step 1]
      ,[Step 2]
      ,[Blast]
      ,[Paint]
      ,[Finish]
      ,[Finish - GNK]
      ,[Final Assembly]
      ,[Tire Assembly]
      ,[Shipping]
      ,[Sections]
      ,[SortSe]
      ,[Obsolete]
      ,[CompanyID]
	  FROM 
		[Budget Options V2]
		 WHERE [Model No] LIKE '%walking floor 2x%' AND [Sections] LIKE '%floor%'

SELECT * FROM [OptionsV2] WHERE [Model No] LIKE '%walking floor 2x%' AND [Sections] LIKE '%floor%'
SELECT * FROM [OptionsV2] WHERE [Model No] LIKE '%walking floor 3x%' AND [Sections] LIKE '%floor%'
SELECT * FROM [Budget Options V2] WHERE [Model No] LIKE '%walking floor 2x%' AND [Sections] LIKE '%floor%'
SELECT * FROM [Budget Options V2] WHERE [Model No] LIKE '%walking floor 3x%' AND [Sections] LIKE '%floor%'

ROLLBACK;
COMMIT;