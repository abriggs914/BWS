
BEGIN TRAN;

DECLARE @oq AS NVARCHAR(8) = 'SG101115';
DECLARE @nq AS NVARCHAR(8) = 'SG101116';

SELECT 
	*
FROM
	[Order OptionsV2_FactoryLines]
WHERE
	[SGQuote] = @nq
;

INSERT INTO
[Order OptionsV2_FactoryLines] (
[WO#]
           ,[SGQuote]
           ,[Option No]
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
           ,[OrderOptionID]
)
SELECT
	[WO#]
           ,@nq
           ,[Option No]
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
           ,[OrderOptionID]
		FROM
			[Order OptionsV2_FactoryLines]
		WHERE
			[SGQuote] = @oq

SELECT 
	*
FROM
	[Order OptionsV2_FactoryLines]
WHERE
	[SGQuote] = @nq
;

ROLLBACK;
COMMIT;