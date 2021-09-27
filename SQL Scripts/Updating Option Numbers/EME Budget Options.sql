USE BWSdb
GO

DECLARE @model NVARCHAR(MAX); --[Forms]![Edit Existing Model Parameters]![Model No]
DECLARE @cid AS INT; --[Forms]![Edit Existing Model Parameters]![Frame41]
SET @model = '3X - Working Copy';
SET @cid = 1;

SELECT 
	[BWSdb_Budget Options V2].[ID#] AS BOID,
	BWSdb_OptionsV2.[ID#] AS OID,
	[BWSdb_Budget Options V2].[Model No],
	[BWSdb_Budget Options V2].[Option No],
	[BWSdb_Budget Options V2].Sections,
	[BWSdb_Budget Options V2].SortSe,
	[BWSdb_Budget Options V2].Description,
	BWSdb_OptionsV2.Obsolete,
	BWSdb_OptionsV2.Weight,
	BWSdb_OptionsV2.Width,
	BWSdb_OptionsV2.[Deck Length],
	BWSdb_OptionsV2.Spread,
	BWSdb_OptionsV2.Price,
	BWSdb_OptionsV2.[US Price],
	[BWSdb_Budget Options V2].Cost,
	[BWSdb_Budget Options V2].[Labour Cost],
	[BWSdb_Budget Options V2].[Made In Material],
	[BWSdb_Budget Options V2].[Bought Out Material],
	[BWSdb_Budget Options V2].[Steel Kit],
	[BWSdb_Budget Options V2].Axles,
	[BWSdb_Budget Options V2].[Step 1],
	[BWSdb_Budget Options V2].[Step 2],
	[BWSdb_Budget Options V2].Blast,
	[BWSdb_Budget Options V2].Paint AS Pnt,
	[BWSdb_Budget Options V2].[Finish - GNK],
	[BWSdb_Budget Options V2].[Final Assembly],
	[BWSdb_Budget Options V2].[Tire Assembly],
	[BWSdb_Budget Options V2].Shipping,
	([Steel Kit]+[Axles]+[Step 1]+[Step 2]+[Blast]+[Paint]+[Finish - GNK]+[Final Assembly]+[Tire Assembly]+[Shipping]) AS [Ttl Bud Hrs],
	BWSdb_OptionsV2.[Draw/Part#],
	BWSdb_OptionsV2.[Start Date],
	BWSdb_OptionsV2.[End Date],
	BWSdb_OptionsV2.OptionInfo,
	BWSdb_OptionsV2.OptionPromptFlag,
	BWSdb_OptionsV2.OptionPrompt,
	BWSdb_OptionsV2.OptionConfigInfo,
	[BWSdb_Budget Options V2].CompanyID
FROM 
	[Budget Options V2] AS [BWSdb_Budget Options V2]
INNER JOIN
	[OptionsV2] AS BWSdb_OptionsV2
ON 
	([BWSdb_Budget Options V2].[Option No] = BWSdb_OptionsV2.[Option No])
	AND ([BWSdb_Budget Options V2].CompanyID = BWSdb_OptionsV2.CompanyID)
WHERE 
	((([BWSdb_Budget Options V2].[Model No])=@model)
	AND (([BWSdb_Budget Options V2].CompanyID)=@cid))
ORDER BY
	[BWSdb_Budget Options V2].[Model No],
	[BWSdb_Budget Options V2].Sections,
	[BWSdb_Budget Options V2].SortSe,
	[BWSdb_Budget Options V2].Description;


	
DECLARE @model NVARCHAR(MAX); --[Forms]![Edit Existing Model Parameters]![Model No]
DECLARE @cid AS INT; --[Forms]![Edit Existing Model Parameters]![Frame41]
SET @model = '3X - Working Copy';
SET @cid = 1;
SELECT * FROM [Budget Options]
WHERE 
	(([Budget Options].[Model No])=@model)


BEGIN TRAN;

DECLARE @model NVARCHAR(MAX); --[Forms]![Edit Existing Model Parameters]![Model No]
DECLARE @cid AS INT; --[Forms]![Edit Existing Model Parameters]![Frame41]
SET @model = '3X - Working Copy';
SET @cid = 1;
SELECT * FROM [Budget Options V2]
WHERE 
	((([Budget Options V2].[Model No])=@model)
	AND (([Budget Options V2].CompanyID)=@cid))
	AND [Description] LIKE '%THIS IS A TEST%'
	--AND ([Option No] LIKE '%100%' OR [Option No] LIKE '%101%' or [Option No] LIKE '%102%' or [Option No] LIKE '%103%' or [Option No] LIKE '%104%')

DELETE
	[Budget Options V2]
WHERE 
	((([Budget Options V2].[Model No])=@model)
	AND (([Budget Options V2].CompanyID)=@cid))
	--AND ([Option No] LIKE '%100%' OR [Option No] LIKE '%101%' or [Option No] LIKE '%102%' or [Option No] LIKE '%103%' or [Option No] LIKE '%104%')
	AND [Description] LIKE '%THIS IS A TEST%'
	

SELECT * FROM [Budget Options V2]
WHERE 
	((([Budget Options V2].[Model No])=@model)
	AND (([Budget Options V2].CompanyID)=@cid))
	--AND ([Option No] LIKE '%100%' OR [Option No] LIKE '%101%' or [Option No] LIKE '%102%' or [Option No] LIKE '%103%' or [Option No] LIKE '%104%')
	AND [Description] LIKE '%THIS IS A TEST%'

ROLLBACK;
COMMIT;






BEGIN TRAN;

DECLARE @model NVARCHAR(MAX); --[Forms]![Edit Existing Model Parameters]![Model No]
DECLARE @cid AS INT; --[Forms]![Edit Existing Model Parameters]![Frame41]
SET @model = '3X - Working Copy';
SET @cid = 1;
SELECT * FROM [OptionsV2]
WHERE 
	((([OptionsV2].[Model No])=@model)
	AND (([OptionsV2].CompanyID)=@cid))
	AND [Description] LIKE '%THIS IS A TEST%'
	--AND ([Option No] LIKE '%100%' OR [Option No] LIKE '%101%' or [Option No] LIKE '%102%' or [Option No] LIKE '%103%' or [Option No] LIKE '%104%')

DELETE
	[OptionsV2]
WHERE 
	((([OptionsV2].[Model No])=@model)
	AND (([OptionsV2].CompanyID)=@cid))
	--AND ([Option No] LIKE '%100%' OR [Option No] LIKE '%101%' or [Option No] LIKE '%102%' or [Option No] LIKE '%103%' or [Option No] LIKE '%104%')
	AND [Description] LIKE '%THIS IS A TEST%'
	

SELECT * FROM [OptionsV2]
WHERE 
	((([OptionsV2].[Model No])=@model)
	AND (([OptionsV2].CompanyID)=@cid))
	--AND ([Option No] LIKE '%100%' OR [Option No] LIKE '%101%' or [Option No] LIKE '%102%' or [Option No] LIKE '%103%' or [Option No] LIKE '%104%')
	AND [Description] LIKE '%THIS IS A TEST%'

ROLLBACK;
COMMIT;