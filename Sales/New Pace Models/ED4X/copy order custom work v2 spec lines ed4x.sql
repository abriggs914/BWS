
BEGIN TRAN;

DECLARE @oq AS NVARCHAR(8) = 'SG101115';
DECLARE @nq AS NVARCHAR(8) = 'SG101116';

SELECT 
	*
FROM
	[Custom WorkV2_SpecLines]
WHERE
	[SGQuote] = @nq
;

INSERT INTO
[Custom WorkV2_SpecLines] (
[SGQuote]
           ,[WO#]
           ,[Description]
           ,[Line#]
           ,[SpecGroup]
           ,[SpecSortG]
           ,[SpecSection]
           ,[SpecSortSe]
           ,[SpecDescription]
           ,[SpecDescriptionBold]
           ,[SpecDescriptionItalic]
           ,[SpecDescriptionUnderline]
           ,[SpecDescriptionBackColour]
           ,[SpecDescriptionFontColour]
           ,[SpecSortSeLine]
           ,[NPOID]
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
	@nq
           ,[WO#]
           ,[Description]
           ,[Line#]
           ,[SpecGroup]
           ,[SpecSortG]
           ,[SpecSection]
           ,[SpecSortSe]
           ,[SpecDescription]
           ,[SpecDescriptionBold]
           ,[SpecDescriptionItalic]
           ,[SpecDescriptionUnderline]
           ,[SpecDescriptionBackColour]
           ,[SpecDescriptionFontColour]
           ,[SpecSortSeLine]
           ,[NPOID]
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
			[Custom WorkV2_SpecLines]
		WHERE
			[SGQuote] = @oq

SELECT 
	*
FROM
	[Custom WorkV2_SpecLines]
WHERE
	[SGQuote] = @nq
;

ROLLBACK;
COMMIT;