
BEGIN TRAN;

DECLARE @oq AS NVARCHAR(8) = 'SG101115';
DECLARE @nq AS NVARCHAR(8) = 'SG101116';

SELECT 
	*
FROM
	[Custom WorkV2]
WHERE
	[SGQuote] = @nq
;

INSERT INTO
[Custom WorkV2] (
[Quote Date]
           ,[SGQuote]
           ,[Order Date]
           ,[WO#]
           ,[Section]
           ,[SortSe]
           ,[Description]
           ,[Qty]
           ,[Price]
           ,[Cost]
           ,[Labour Cost]
           ,[Made In Material]
           ,[Bought Out Material]
           ,[Weight]
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
           ,[Eng Hours]
           ,[Option Date]
           ,[Draw/Part#]
           ,[NPOInfo]
           ,[NPOPromptFlag]
           ,[NPOPrompt]
           ,[NPOConfigInfo]
           ,[NPOExpirationDate]
           ,[US Price]
           ,[Are WO Specs Different?]
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
           ,@nq
           ,[Order Date]
           ,[WO#]
           ,[Section]
           ,[SortSe]
           ,[Description]
           ,[Qty]
           ,[Price]
           ,[Cost]
           ,[Labour Cost]
           ,[Made In Material]
           ,[Bought Out Material]
           ,[Weight]
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
           ,[Eng Hours]
           ,[Option Date]
           ,[Draw/Part#]
           ,[NPOInfo]
           ,[NPOPromptFlag]
           ,[NPOPrompt]
           ,[NPOConfigInfo]
           ,[NPOExpirationDate]
           ,[US Price]
           ,[Are WO Specs Different?]
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
			[Custom WorkV2]
		WHERE
			[SGQuote] = @oq

SELECT 
	*
FROM
	[Custom WorkV2]
WHERE
	[SGQuote] = @nq
;

ROLLBACK;
COMMIT;