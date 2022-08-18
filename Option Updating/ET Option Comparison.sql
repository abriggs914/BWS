------------------------------------------------------------------------------------------------------------------------
USE BWSdb
GO

BEGIN TRAN;


UPDATE
	[Options]
SET
	[Obsolete] = 1
WHERE
	[Model No] IN (
		'42ET2X'
		, '42ET3X'
		, '48ET2X'
		, '48ET2XP'
		, '48ET3X'
		, '48ET3XP'
		, '53ET2X'
		, '53ET2XP'
		, '53ET3X'
		, '53ET3XP'
		, '48ET3X MR'
		, '53ET3X MR EAST'
		, '53ET3X MR WEST'
		, '53ET4X'
		, '53ET4X MR'
		, '53ET4XP'
	);


UPDATE
	[Budget Options]
SET
	[Obsolete] = 1
WHERE
	[Model No] IN (
		'42ET2X'
		, '42ET3X'
		, '48ET2X'
		, '48ET2XP'
		, '48ET3X'
		, '48ET3XP'
		, '53ET2X'
		, '53ET2XP'
		, '53ET3X'
		, '53ET3XP'
		, '48ET3X MR'
		, '53ET3X MR EAST'
		, '53ET3X MR WEST'
		, '53ET4X'
		, '53ET4X MR'
		, '53ET4XP'
	);


--MODEL=42ET2X
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('42ET2X', '42ET2X-00076', '2022-08-18', '2023-08-18', 0.0, 'DECK', '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('42ET2X', '42ET2X-00077', '2022-08-18', '2023-08-18', 0.0, 'DECK', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('42ET2X', '42ET2X-00078', '2022-08-18', '2023-08-18', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('42ET2X', '42ET2X-00079', '2022-08-18', '2023-08-18', 0.0, 'DECK', '97.5 in. width excluding load securement devices', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '42ET2X', '42ET2X-00079', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '42ET2X', '42ET2X-00080', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '42ET2X', '42ET2X-00081', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '42ET2X', '42ET2X-00082', '97.5 in. width excluding load securement devices', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);

--MODEL=42ET3X
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('42ET3X', '42ET3X-00074', '2022-08-18', '2023-08-18', 0.0, 'DECK', '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('42ET3X', '42ET3X-00075', '2022-08-18', '2023-08-18', 0.0, 'DECK', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('42ET3X', '42ET3X-00076', '2022-08-18', '2023-08-18', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('42ET3X', '42ET3X-00077', '2022-08-18', '2023-08-18', 0.0, 'DECK', '97.5 in. width excluding load securement devices', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '42ET3X', '42ET3X-00075', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '42ET3X', '42ET3X-00076', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '42ET3X', '42ET3X-00077', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '42ET3X', '42ET3X-00078', '97.5 in. width excluding load securement devices', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);

--MODEL=48ET2X
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET2X', '48ET2X-00181', '2022-08-18', '2023-08-18', 0.0, 'DECK', '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET2X', '48ET2X-00182', '2022-08-18', '2023-08-18', 0.0, 'DECK', '* 120 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET2X', '48ET2X-00183', '2022-08-18', '2023-08-18', 0.0, 'DECK', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET2X', '48ET2X-00184', '2022-08-18', '2023-08-18', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET2X', '48ET2X-00185', '2022-08-18', '2023-08-18', 0.0, 'DECK', '97.5 in. width excluding load securement devices', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '48ET2X', '48ET2X-00206', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '48ET2X', '48ET2X-00207', '* 120 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '48ET2X', '48ET2X-00208', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '48ET2X', '48ET2X-00209', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '48ET2X', '48ET2X-00210', '97.5 in. width excluding load securement devices', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);

--MODEL=48ET2XP
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET2XP', '48ET2XP-00065', '2022-08-18', '2023-08-18', 0.0, 'DECK', '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET2XP', '48ET2XP-00066', '2022-08-18', '2023-08-18', 0.0, 'DECK', '* 120 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET2XP', '48ET2XP-00067', '2022-08-18', '2023-08-18', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET2XP', '48ET2XP-00068', '2022-08-18', '2023-08-18', 0.0, 'DECK', '97.5 in. width excluding load securement devices', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '48ET2XP', '48ET2XP-00065', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '48ET2XP', '48ET2XP-00066', '* 120 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '48ET2XP', '48ET2XP-00067', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '48ET2XP', '48ET2XP-00068', '97.5 in. width excluding load securement devices', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);

--MODEL=48ET3X
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET3X', '48ET3X-00239', '2022-08-18', '2023-08-18', 0.0, 'DECK', '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET3X', '48ET3X-00240', '2022-08-18', '2023-08-18', 0.0, 'DECK', '* 120 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET3X', '48ET3X-00241', '2022-08-18', '2023-08-18', 0.0, 'DECK', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET3X', '48ET3X-00242', '2022-08-18', '2023-08-18', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET3X', '48ET3X-00243', '2022-08-18', '2023-08-18', 0.0, 'DECK', '97.5 in. width excluding load securement devices', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '48ET3X', '48ET3X-00292', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '48ET3X', '48ET3X-00293', '* 120 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '48ET3X', '48ET3X-00294', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '48ET3X', '48ET3X-00295', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '48ET3X', '48ET3X-00296', '97.5 in. width excluding load securement devices', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);

--MODEL=48ET3XP
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET3XP', '48ET3XP-00067', '2022-08-18', '2023-08-18', 0.0, 'DECK', '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET3XP', '48ET3XP-00068', '2022-08-18', '2023-08-18', 0.0, 'DECK', '* 120 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET3XP', '48ET3XP-00069', '2022-08-18', '2023-08-18', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET3XP', '48ET3XP-00070', '2022-08-18', '2023-08-18', 0.0, 'DECK', '97.5 in. width excluding load securement devices', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '48ET3XP', '48ET3XP-00067', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '48ET3XP', '48ET3XP-00068', '* 120 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '48ET3XP', '48ET3XP-00069', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '48ET3XP', '48ET3XP-00070', '97.5 in. width excluding load securement devices', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);

--MODEL=53ET2X
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET2X', '53ET2X-00142', '2022-08-18', '2023-08-18', 0.0, 'DECK', '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET2X', '53ET2X-00143', '2022-08-18', '2023-08-18', 0.0, 'DECK', '* 120 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET2X', '53ET2X-00144', '2022-08-18', '2023-08-18', 0.0, 'DECK', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET2X', '53ET2X-00145', '2022-08-18', '2023-08-18', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET2X', '53ET2X-00146', '2022-08-18', '2023-08-18', 0.0, 'DECK', '97.5 in. width excluding load securement devices', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET2X', '53ET2X-00147', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET2X', '53ET2X-00148', '* 120 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET2X', '53ET2X-00149', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET2X', '53ET2X-00150', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET2X', '53ET2X-00151', '97.5 in. width excluding load securement devices', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);

--MODEL=53ET2XP
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET2XP', '53ET2XP-00064', '2022-08-18', '2023-08-18', 0.0, 'DECK', '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET2XP', '53ET2XP-00065', '2022-08-18', '2023-08-18', 0.0, 'DECK', '* 120 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET2XP', '53ET2XP-00066', '2022-08-18', '2023-08-18', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET2XP', '53ET2XP-00067', '2022-08-18', '2023-08-18', 0.0, 'DECK', '97.5 in. width excluding load securement devices', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET2XP', '53ET2XP-00066', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET2XP', '53ET2XP-00067', '* 120 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET2XP', '53ET2XP-00068', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET2XP', '53ET2XP-00069', '97.5 in. width excluding load securement devices', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);

--MODEL=53ET3X
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3X', '53ET3X-00321', '2022-08-18', '2023-08-18', 0.0, 'DECK', '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3X', '53ET3X-00322', '2022-08-18', '2023-08-18', 0.0, 'DECK', '* 120 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3X', '53ET3X-00323', '2022-08-18', '2023-08-18', 0.0, 'DECK', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3X', '53ET3X-00324', '2022-08-18', '2023-08-18', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3X', '53ET3X-00325', '2022-08-18', '2023-08-18', 0.0, 'DECK', '97.5 in. width excluding load securement devices', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET3X', '53ET3X-00376', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET3X', '53ET3X-00377', '* 120 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET3X', '53ET3X-00378', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET3X', '53ET3X-00379', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET3X', '53ET3X-00380', '97.5 in. width excluding load securement devices', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);

--MODEL=53ET3XP
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3XP', '53ET3XP-00110', '2022-08-18', '2023-08-18', 0.0, 'DECK', '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3XP', '53ET3XP-00111', '2022-08-18', '2023-08-18', 0.0, 'DECK', '* 120 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3XP', '53ET3XP-00112', '2022-08-18', '2023-08-18', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3XP', '53ET3XP-00113', '2022-08-18', '2023-08-18', 0.0, 'DECK', '97.5 in. width excluding load securement devices', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET3XP', '53ET3XP-00113', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET3XP', '53ET3XP-00114', '* 120 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET3XP', '53ET3XP-00115', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET3XP', '53ET3XP-00116', '97.5 in. width excluding load securement devices', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);

--MODEL=48ET3X MR
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET3X MR', '48ET3X MR-00097', '2022-08-18', '2023-08-18', 0.0, 'DECK', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET3X MR', '48ET3X MR-00098', '2022-08-18', '2023-08-18', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '48ET3X MR', '48ET3X MR-00148', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '48ET3X MR', '48ET3X MR-00149', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);

--MODEL=53ET3X MR EAST
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3X MR EAST', '53ET3X MR EAST-00061', '2022-08-18', '2023-08-18', 0.0, 'DECK', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3X MR EAST', '53ET3X MR EAST-00062', '2022-08-18', '2023-08-18', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET3X MR EAST', '53ET3X MR EAST-00088', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET3X MR EAST', '53ET3X MR EAST-00089', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);

--MODEL=53ET3X MR WEST
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3X MR WEST', '53ET3X MR WEST-00064', '2022-08-18', '2023-08-18', 0.0, 'DECK', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3X MR WEST', '53ET3X MR WEST-00065', '2022-08-18', '2023-08-18', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3X MR WEST', '53ET3X MR WEST-00066', '2022-08-18', '2023-08-18', 0.0, 'DECK', '97.5 in. width excluding load securement devices', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET3X MR WEST', '53ET3X MR WEST-00087', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET3X MR WEST', '53ET3X MR WEST-00088', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET3X MR WEST', '53ET3X MR WEST-00089', '97.5 in. width excluding load securement devices', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);

--MODEL=53ET4X
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET4X', '53ET4X-00191', '2022-08-18', '2023-08-18', 0.0, 'DECK', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET4X', '53ET4X-00227', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);

--MODEL=53ET4X MR
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET4X MR', '53ET4X MR-00056', '2022-08-18', '2023-08-18', 0.0, 'DECK', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET4X MR', '53ET4X MR-00082', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);

--MODEL=53ET4XP
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET4XP', '53ET4XP-00063', '2022-08-18', '2023-08-18', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '53ET4XP', '53ET4XP-00067', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0);

ROLLBACK;
COMMIT;
------------------------------------------------------------------------------------------------------------------------
