
BEGIN TRAN;

DECLARE @oq AS NVARCHAR(8) = 'SG101115';
DECLARE @nq AS NVARCHAR(8) = 'SG101116';

SELECT 
	*
FROM
	[Custom WorkV2_FactoryLines]
WHERE
	[SGQuote] = @nq
;

INSERT INTO
[Custom WorkV2_FactoryLines] (
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
		FROM
			[Custom WorkV2_FactoryLines]
		WHERE
			[SGQuote] = @oq

SELECT 
	*
FROM
	[Custom WorkV2_FactoryLines]
WHERE
	[SGQuote] = @nq
;

ROLLBACK;
COMMIT;