------------------------------------------------------------------------------------------------------------------------
USE BWSdb
GO

BEGIN TRAN;
--MODEL=42ET2X
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('42ET2X', '42ET2X-00075', '2022-08-10', '2023-08-10', 0.0, 'DECK', '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('42ET2X', '42ET2X-00075', '2022-08-10', '2023-08-10', 0.0, 'DECK', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('42ET2X', '42ET2X-00076', '2022-08-10', '2023-08-10', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('42ET2X', '42ET2X-00077', '2022-08-10', '2023-08-10', 0.0, 'DECK', '97.5 in. width excluding load securement devices', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '42ET2X', '42ET2X-00078', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '42ET2X', '42ET2X-00078', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '42ET2X', '42ET2X-00079', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '42ET2X', '42ET2X-00080', '97.5 in. width excluding load securement devices', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
--MODEL=42ET3X
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('42ET3X', '42ET3X-00073', '2022-08-10', '2023-08-10', 0.0, 'DECK', '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('42ET3X', '42ET3X-00073', '2022-08-10', '2023-08-10', 0.0, 'DECK', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('42ET3X', '42ET3X-00074', '2022-08-10', '2023-08-10', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('42ET3X', '42ET3X-00075', '2022-08-10', '2023-08-10', 0.0, 'DECK', '97.5 in. width excluding load securement devices', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '42ET3X', '42ET3X-00074', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '42ET3X', '42ET3X-00074', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '42ET3X', '42ET3X-00075', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '42ET3X', '42ET3X-00076', '97.5 in. width excluding load securement devices', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
--MODEL=48ET2X
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET2X', '48ET2X-00180', '2022-08-10', '2023-08-10', 0.0, 'DECK', '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET2X', '48ET2X-00180', '2022-08-10', '2023-08-10', 0.0, 'DECK', '* 120 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET2X', '48ET2X-00181', '2022-08-10', '2023-08-10', 0.0, 'DECK', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET2X', '48ET2X-00182', '2022-08-10', '2023-08-10', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET2X', '48ET2X-00183', '2022-08-10', '2023-08-10', 0.0, 'DECK', '97.5 in. width excluding load securement devices', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '48ET2X', '48ET2X-00205', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '48ET2X', '48ET2X-00205', '* 120 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '48ET2X', '48ET2X-00206', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '48ET2X', '48ET2X-00207', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '48ET2X', '48ET2X-00208', '97.5 in. width excluding load securement devices', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
--MODEL=48ET2XP
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET2XP', '48ET2XP-00064', '2022-08-10', '2023-08-10', 0.0, 'DECK', '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET2XP', '48ET2XP-00064', '2022-08-10', '2023-08-10', 0.0, 'DECK', '* 120 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET2XP', '48ET2XP-00065', '2022-08-10', '2023-08-10', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET2XP', '48ET2XP-00066', '2022-08-10', '2023-08-10', 0.0, 'DECK', '97.5 in. width excluding load securement devices', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '48ET2XP', '48ET2XP-00064', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '48ET2XP', '48ET2XP-00064', '* 120 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '48ET2XP', '48ET2XP-00065', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '48ET2XP', '48ET2XP-00066', '97.5 in. width excluding load securement devices', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
--MODEL=48ET3X
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET3X', '48ET3X-00238', '2022-08-10', '2023-08-10', 0.0, 'DECK', '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET3X', '48ET3X-00238', '2022-08-10', '2023-08-10', 0.0, 'DECK', '* 120 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET3X', '48ET3X-00239', '2022-08-10', '2023-08-10', 0.0, 'DECK', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET3X', '48ET3X-00240', '2022-08-10', '2023-08-10', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET3X', '48ET3X-00241', '2022-08-10', '2023-08-10', 0.0, 'DECK', '97.5 in. width excluding load securement devices', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '48ET3X', '48ET3X-00291', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '48ET3X', '48ET3X-00291', '* 120 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '48ET3X', '48ET3X-00292', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '48ET3X', '48ET3X-00293', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '48ET3X', '48ET3X-00294', '97.5 in. width excluding load securement devices', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
--MODEL=48ET3XP
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET3XP', '48ET3XP-00066', '2022-08-10', '2023-08-10', 0.0, 'DECK', '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET3XP', '48ET3XP-00066', '2022-08-10', '2023-08-10', 0.0, 'DECK', '* 120 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET3XP', '48ET3XP-00067', '2022-08-10', '2023-08-10', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET3XP', '48ET3XP-00068', '2022-08-10', '2023-08-10', 0.0, 'DECK', '97.5 in. width excluding load securement devices', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '48ET3XP', '48ET3XP-00066', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '48ET3XP', '48ET3XP-00066', '* 120 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '48ET3XP', '48ET3XP-00067', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '48ET3XP', '48ET3XP-00068', '97.5 in. width excluding load securement devices', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
--MODEL=53ET2X
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET2X', '53ET2X-00141', '2022-08-10', '2023-08-10', 0.0, 'DECK', '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET2X', '53ET2X-00141', '2022-08-10', '2023-08-10', 0.0, 'DECK', '* 120 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET2X', '53ET2X-00142', '2022-08-10', '2023-08-10', 0.0, 'DECK', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET2X', '53ET2X-00143', '2022-08-10', '2023-08-10', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET2X', '53ET2X-00144', '2022-08-10', '2023-08-10', 0.0, 'DECK', '97.5 in. width excluding load securement devices', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET2X', '53ET2X-00146', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET2X', '53ET2X-00146', '* 120 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET2X', '53ET2X-00147', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET2X', '53ET2X-00148', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET2X', '53ET2X-00149', '97.5 in. width excluding load securement devices', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
--MODEL=53ET2XP
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET2XP', '53ET2XP-00063', '2022-08-10', '2023-08-10', 0.0, 'DECK', '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET2XP', '53ET2XP-00063', '2022-08-10', '2023-08-10', 0.0, 'DECK', '* 120 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET2XP', '53ET2XP-00064', '2022-08-10', '2023-08-10', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET2XP', '53ET2XP-00065', '2022-08-10', '2023-08-10', 0.0, 'DECK', '97.5 in. width excluding load securement devices', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET2XP', '53ET2XP-00065', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET2XP', '53ET2XP-00065', '* 120 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET2XP', '53ET2XP-00066', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET2XP', '53ET2XP-00067', '97.5 in. width excluding load securement devices', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
--MODEL=53ET3X
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3X', '53ET3X-00320', '2022-08-10', '2023-08-10', 0.0, 'DECK', '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3X', '53ET3X-00320', '2022-08-10', '2023-08-10', 0.0, 'DECK', '* 120 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3X', '53ET3X-00321', '2022-08-10', '2023-08-10', 0.0, 'DECK', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3X', '53ET3X-00322', '2022-08-10', '2023-08-10', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3X', '53ET3X-00323', '2022-08-10', '2023-08-10', 0.0, 'DECK', '97.5 in. width excluding load securement devices', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET3X', '53ET3X-00375', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET3X', '53ET3X-00375', '* 120 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET3X', '53ET3X-00376', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET3X', '53ET3X-00377', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET3X', '53ET3X-00378', '97.5 in. width excluding load securement devices', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
--MODEL=53ET3XP
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3XP', '53ET3XP-00109', '2022-08-10', '2023-08-10', 0.0, 'DECK', '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3XP', '53ET3XP-00109', '2022-08-10', '2023-08-10', 0.0, 'DECK', '* 120 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3XP', '53ET3XP-00110', '2022-08-10', '2023-08-10', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3XP', '53ET3XP-00111', '2022-08-10', '2023-08-10', 0.0, 'DECK', '97.5 in. width excluding load securement devices', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET3XP', '53ET3XP-00112', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET3XP', '53ET3XP-00112', '* 120 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET3XP', '53ET3XP-00113', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET3XP', '53ET3XP-00114', '97.5 in. width excluding load securement devices', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
--MODEL=48ET3X MR
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET3X MR', '48ET3X MR-00096', '2022-08-10', '2023-08-10', 0.0, 'DECK', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('48ET3X MR', '48ET3X MR-00096', '2022-08-10', '2023-08-10', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '48ET3X MR', '48ET3X MR-00147', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '48ET3X MR', '48ET3X MR-00147', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
--MODEL=53ET3X MR EAST
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3X MR EAST', '53ET3X MR EAST-00060', '2022-08-10', '2023-08-10', 0.0, 'DECK', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3X MR EAST', '53ET3X MR EAST-00060', '2022-08-10', '2023-08-10', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET3X MR EAST', '53ET3X MR EAST-00087', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET3X MR EAST', '53ET3X MR EAST-00087', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
--MODEL=53ET3X MR WEST
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3X MR WEST', '53ET3X MR WEST-00063', '2022-08-10', '2023-08-10', 0.0, 'DECK', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3X MR WEST', '53ET3X MR WEST-00063', '2022-08-10', '2023-08-10', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET3X MR WEST', '53ET3X MR WEST-00064', '2022-08-10', '2023-08-10', 0.0, 'DECK', '97.5 in. width excluding load securement devices', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET3X MR WEST', '53ET3X MR WEST-00086', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET3X MR WEST', '53ET3X MR WEST-00086', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET3X MR WEST', '53ET3X MR WEST-00087', '97.5 in. width excluding load securement devices', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
--MODEL=53ET4X
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET4X', '53ET4X-00190', '2022-08-10', '2023-08-10', 0.0, 'DECK', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET4X', '53ET4X-00226', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
--MODEL=53ET4X MR
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET4X MR', '53ET4X MR-00055', '2022-08-10', '2023-08-10', 0.0, 'DECK', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET4X MR', '53ET4X MR-00081', '1 3/8 inch All Keruing/Apitong Floor-Deck Only', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)
--MODEL=53ET4XP
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('53ET4XP', '53ET4XP-00062', '2022-08-10', '2023-08-10', 0.0, 'DECK', 'All Hardwood Floor Includes Gooseneck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0)
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-10', '53ET4XP', '53ET4XP-00066', 'All Hardwood Floor Includes Gooseneck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 'DECK', 0, 0)

ROLLBACK;
COMMIT;
------------------------------------------------------------------------------------------------------------------------
