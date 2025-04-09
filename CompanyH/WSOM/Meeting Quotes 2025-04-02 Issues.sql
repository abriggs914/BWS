SELECT * FROM [BWSdb].[dbo].[WSOM_MeetingNotes]
SELECT * FROM [BWSdb].[dbo].[WSOM_Meetings]

-- Meeting Quotes 2025-04-02
-- MeetingID=12


BEGIN TRAN;


INSERT INTO [BWSdb].[dbo].[WSOM_MeetingNotes] ([Quote], [MeetingID], [IssueDescription]) VALUES
	(31318, 12, 'Grease hubs may cause delay'),
	(31311, 12, 'Missing red to lights ''marker lights'''),
	(31230, 12, 'CYC -- 72, 72, 100 -- fractions to decimals on box construction -- 8 in el cargo tape  -- Stainless Steel -- SW Paint'),
	(31231, 12, '3 # for spread -- ''RA220-1N'' -- WIRE INSTRUCTIONS dump box -- SW Paint'),
	(31247, 12, 'Double check the dimensions length -- CYC -- Steer Axle config (84.5 Track) -- Inside Gussets'),
	(31308, 12, 'tailgate locks air cylinder, ''dumps the '''),
	(31309, 12, 'hoist 280 -- shovel holder'),
	(31326, 12, 'remove NPO Wiring Instructions')
;

ROLLBACK;
COMMIT;
