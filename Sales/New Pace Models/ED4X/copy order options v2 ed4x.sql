
BEGIN TRAN;

DECLARE @oq AS NVARCHAR(8) = 'SG101115';
DECLARE @nq AS NVARCHAR(8) = 'SG101116';

SELECT 
	*
FROM
	[Order OptionsV2]
WHERE
	[SGQuote] = @nq
;

INSERT INTO
[Order OptionsV2] (
[Quote Date]
           ,[Order Date]
           ,[WO#]
           ,[SGQuote]
           ,[Option No]
           ,[Price]
           ,[Qty]
           ,[Sections]
           ,[Description]
           ,[Comments]
           ,[Weight]
           ,[Cost]
           ,[Material Cost]
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
           ,[Start Date]
           ,[End Date]
           ,[SortSe]
           ,[Width]
           ,[Spread]
           ,[Draw/Part#]
           ,[OptionInfo]
           ,[OptionPromptFlag]
           ,[OptionPrompt]
           ,[OptionConfigInfo]
           ,[Are WO Specs Different?]
           ,[Comments V2]
           ,[Operation1Hours]
           ,[Operation2Hours]
           ,[Operation3Hours]
           ,[Operation4Hours]
           ,[Operation5Hours]
           ,[Operation6Hours]
           ,[Operation7Hours]
           ,[Operation8Hours]
           ,[Operation9Hours]
           ,[Operation10Hours]
           ,[Operation11Hours]
           ,[Operation12Hours]
           ,[Operation13Hours]
           ,[Operation14Hours]
           ,[Operation15Hours]
           ,[Operation16Hours]
           ,[Operation17Hours]
)
SELECT
	[Quote Date]
           ,[Order Date]
           ,[WO#]
           ,@nq
           ,[Option No]
           ,[Price]
           ,[Qty]
           ,[Sections]
           ,[Description]
           ,[Comments]
           ,[Weight]
           ,[Cost]
           ,[Material Cost]
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
           ,[Start Date]
           ,[End Date]
           ,[SortSe]
           ,[Width]
           ,[Spread]
           ,[Draw/Part#]
           ,[OptionInfo]
           ,[OptionPromptFlag]
           ,[OptionPrompt]
           ,[OptionConfigInfo]
           ,[Are WO Specs Different?]
           ,[Comments V2]
           ,[Operation1Hours]
           ,[Operation2Hours]
           ,[Operation3Hours]
           ,[Operation4Hours]
           ,[Operation5Hours]
           ,[Operation6Hours]
           ,[Operation7Hours]
           ,[Operation8Hours]
           ,[Operation9Hours]
           ,[Operation10Hours]
           ,[Operation11Hours]
           ,[Operation12Hours]
           ,[Operation13Hours]
           ,[Operation14Hours]
           ,[Operation15Hours]
           ,[Operation16Hours]
           ,[Operation17Hours]
		FROM
			[Order OptionsV2]
		WHERE
			[SGQuote] = @oq

SELECT 
	*
FROM
	[Order OptionsV2]
WHERE
	[SGQuote] = @nq
;

ROLLBACK;
COMMIT;