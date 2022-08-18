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
		'20ANR'
		, '20ART'
		, '20FDNT'
		, '20NTT'
		, '25ANR'
		, '30ANR'
		, '25ART'
		, '30ART'
		, '25FDNT'
		, '30FDNT'
		, '25NTT'
		, '30NTT'
	);


UPDATE
	[Budget Options]
SET
	[Obsolete] = 1
WHERE
	[Model No] IN (
		'20ANR'
		, '20ART'
		, '20FDNT'
		, '20NTT'
		, '25ANR'
		, '30ANR'
		, '25ART'
		, '30ART'
		, '25FDNT'
		, '30FDNT'
		, '25NTT'
		, '30NTT'
	);


--MODEL=20ANR
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00050', '2022-08-18', '2023-08-18', 0.0, NULL, '* 1 ft. Additional Main Deck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00051', '2022-08-18', '2023-08-18', 0.0, NULL, '* 108 in. Width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00052', '2022-08-18', '2023-08-18', 0.0, NULL, '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00053', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Ride Suspension (includes air gauge and dump valve)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00054', '2022-08-18', '2023-08-18', 0.0, NULL, '* Axle Spacing 61 in.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00055', '2022-08-18', '2023-08-18', 0.0, NULL, '* Tilt Deck Package (4 Air Bags)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00056', '2022-08-18', '2023-08-18', 0.0, NULL, '1 3/8 in. x 7 in. Keruing Shiplapped', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00057', '2022-08-18', '2023-08-18', 0.0, NULL, '1 ft. Bolt On A-Frame Extension', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00058', '2022-08-18', '2023-08-18', 0.0, NULL, 'Add 3/8 in. flatbar full length under deck approx 6 in. from siderail, passenger side', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00059', '2022-08-18', '2023-08-18', 0.0, NULL, 'Additional Mudflaps with Brackets (pair)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00060', '2022-08-18', '2023-08-18', 0.0, NULL, 'Air Ride Suspension (includes air gauge and dump valve)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00061', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 17.5  (4 steel, 4 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00062', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 17.5  (8 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00063', '2022-08-18', '2023-08-18', 0.0, NULL, 'Amber Flashing Strobe Lights(Mounted in Bumper)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00064', '2022-08-18', '2023-08-18', 0.0, NULL, 'BWS Red - PPG#370-75034', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00065', '2022-08-18', '2023-08-18', 0.0, NULL, 'BWS Yellow - PPG#920612', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00066', '2022-08-18', '2023-08-18', 0.0, NULL, 'Dual Holland Mark V 2 Speed Landing Gear', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00067', '2022-08-18', '2023-08-18', 0.0, NULL, 'Extra, Side Mount D-Rings (pair)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00068', '2022-08-18', '2023-08-18', 0.0, NULL, 'Flag Holders (set of 4)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00069', '2022-08-18', '2023-08-18', 0.0, NULL, 'Four Pin Plug w/Strobe Light Pocket at Rear', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00070', '2022-08-18', '2023-08-18', 0.0, NULL, 'Galvanizing Unit', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00071', '2022-08-18', '2023-08-18', 0.0, NULL, 'J-Hooks', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00072', '2022-08-18', '2023-08-18', 0.0, NULL, 'Remove mud flaps, set up for flaps only – customer will install their own.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00073', '2022-08-18', '2023-08-18', 0.0, NULL, 'Rub Rail and Stake Pockets - 48 in. OC (Outside nominal width)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00074', '2022-08-18', '2023-08-18', 0.0, NULL, 'Rub Rail and Stake Pockets - 24 in. OC (Outside nominal width)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00075', '2022-08-18', '2023-08-18', 0.0, NULL, 'Straps (3 in. x 30 ft. with Chain and Hook)(each)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00076', '2022-08-18', '2023-08-18', 0.0, NULL, 'Swingout Outriggers (5 per side)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00077', '2022-08-18', '2023-08-18', 0.0, NULL, 'Tire Carrier Only (A Frame Top Mount)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00078', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winch Track', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00079', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches - Sliding  #5820 (hooks not included)(EACH)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00080', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches - Sliding - 3 Bar #14011NP (hooks not included)(EACH)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00081', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches (3 Bar Weld On) #148101-143 Undermount (hooks not included)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00082', '2022-08-18', '2023-08-18', 0.0, NULL, 'Zinc Primer', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00083', '2022-08-18', '2023-08-18', 0.0, NULL, 'Replace White Steel Rims With Black Steel Rims', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ANR', '20ANR-00084', '2022-08-18', '2023-08-18', 0.0, NULL, 'Double L Aluminum Winch Track', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00051', '* 1 ft. Additional Main Deck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00052', '* 108 in. Width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00053', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00054', '* Air Ride Suspension (includes air gauge and dump valve)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00055', '* Axle Spacing 61 in.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00056', '* Tilt Deck Package (4 Air Bags)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00057', '1 3/8 in. x 7 in. Keruing Shiplapped', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00058', '1 ft. Bolt On A-Frame Extension', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00059', 'Add 3/8 in. flatbar full length under deck approx 6 in. from siderail, passenger side', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00060', 'Additional Mudflaps with Brackets (pair)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00061', 'Air Ride Suspension (includes air gauge and dump valve)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00062', 'Alum. Wheel Pkg. 17.5  (4 steel, 4 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00063', 'Alum. Wheel Pkg. 17.5  (8 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00064', 'Amber Flashing Strobe Lights(Mounted in Bumper)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00065', 'BWS Red - PPG#370-75034', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00066', 'BWS Yellow - PPG#920612', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00067', 'Dual Holland Mark V 2 Speed Landing Gear', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00068', 'Extra, Side Mount D-Rings (pair)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00069', 'Flag Holders (set of 4)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00070', 'Four Pin Plug w/Strobe Light Pocket at Rear', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00071', 'Galvanizing Unit', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00072', 'J-Hooks', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00073', 'Remove mud flaps, set up for flaps only – customer will install their own.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00074', 'Rub Rail and Stake Pockets - 48 in. OC (Outside nominal width)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00075', 'Rub Rail and Stake Pockets - 24 in. OC (Outside nominal width)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00076', 'Straps (3 in. x 30 ft. with Chain and Hook)(each)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00077', 'Swingout Outriggers (5 per side)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00078', 'Tire Carrier Only (A Frame Top Mount)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00079', 'Winch Track', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00080', 'Winches - Sliding  #5820 (hooks not included)(EACH)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00081', 'Winches - Sliding - 3 Bar #14011NP (hooks not included)(EACH)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00082', 'Winches (3 Bar Weld On) #148101-143 Undermount (hooks not included)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00083', 'Zinc Primer', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00084', 'Replace White Steel Rims With Black Steel Rims', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ANR', '20ANR-00085', 'Double L Aluminum Winch Track', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);

--MODEL=20ART
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00046', '2022-08-18', '2023-08-18', 0.0, NULL, '* 1 ft. Additional Main Deck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00047', '2022-08-18', '2023-08-18', 0.0, NULL, '* 108 in. Width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00048', '2022-08-18', '2023-08-18', 0.0, NULL, '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00049', '2022-08-18', '2023-08-18', 0.0, NULL, '* 38 in. x 76 in. Self Cleaning Air Operated Ramp', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00050', '2022-08-18', '2023-08-18', 0.0, NULL, '* 38 in. x 76 in. Wood Filled Air Operated Ramp', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00051', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 in. x 76 in. Air Operated Planked', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00052', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Ride Suspension (includes air gauge and dump valve)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00053', '2022-08-18', '2023-08-18', 0.0, NULL, '* Axle Spacing 61 in.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00054', '2022-08-18', '2023-08-18', 0.0, NULL, '* Self Cleaning Beavertail', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00055', '2022-08-18', '2023-08-18', 0.0, NULL, '* Tilt Deck Package (4 Air Bags)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00056', '2022-08-18', '2023-08-18', 0.0, NULL, '1 3/8 in. x 7 in. Keruing Shiplapped', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00057', '2022-08-18', '2023-08-18', 0.0, NULL, '1 ft. Bolt On A-Frame Extension', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00058', '2022-08-18', '2023-08-18', 0.0, NULL, '6 ft. Beavertail ', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00059', '2022-08-18', '2023-08-18', 0.0, NULL, 'Add 3/8 in. flatbar full length under deck approx 6 in. from siderail, passenger side', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00060', '2022-08-18', '2023-08-18', 0.0, NULL, 'Additional Mudflaps with Brackets (pair)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00061', '2022-08-18', '2023-08-18', 0.0, NULL, 'Air Ride Suspension (includes air gauge and dump valve)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00062', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 17.5  (4 steel, 4 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00063', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 17.5  (8 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00064', '2022-08-18', '2023-08-18', 0.0, NULL, 'Amber Flashing Strobe Lights(Mounted in Ramps)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00065', '2022-08-18', '2023-08-18', 0.0, NULL, 'BWS Red - PPG#370-75034', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00066', '2022-08-18', '2023-08-18', 0.0, NULL, 'BWS Yellow - PPG#920612', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00067', '2022-08-18', '2023-08-18', 0.0, NULL, 'Dual Holland Mark V 2 Speed Landing Gear', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00068', '2022-08-18', '2023-08-18', 0.0, NULL, 'Extra, Side Mount D-Rings (pair)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00069', '2022-08-18', '2023-08-18', 0.0, NULL, 'Flag Holders (set of 4)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00070', '2022-08-18', '2023-08-18', 0.0, NULL, 'Four Pin Plug w/Strobe Light Pocket at Rear', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00071', '2022-08-18', '2023-08-18', 0.0, NULL, 'Galvanizing Unit', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00072', '2022-08-18', '2023-08-18', 0.0, NULL, 'J-Hooks', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00073', '2022-08-18', '2023-08-18', 0.0, NULL, 'Remove mud flaps, set up for flaps only – customer will install their own.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00074', '2022-08-18', '2023-08-18', 0.0, NULL, 'Rub Rail and Stake Pockets - 48 in. OC (Outside nominal width)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00075', '2022-08-18', '2023-08-18', 0.0, NULL, 'Rub Rail and Stake Pockets - 24 in. OC (Outside nominal width)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00076', '2022-08-18', '2023-08-18', 0.0, NULL, 'Straps (3 in. x 30 ft. with Chain and Hook)(each)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00077', '2022-08-18', '2023-08-18', 0.0, NULL, 'Swingout Outriggers (5 per side)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00078', '2022-08-18', '2023-08-18', 0.0, NULL, 'Tire Carrier Only (A Frame Top Mount)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00079', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winch Track', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00080', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches - Sliding  #5820 (hooks not included)(EACH)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00081', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches - Sliding - 3 Bar #14011NP (hooks not included)(EACH)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00082', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches (3 Bar Weld On) #148101-143 Undermount (hooks not included)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00083', '2022-08-18', '2023-08-18', 0.0, NULL, 'Zinc Primer', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00084', '2022-08-18', '2023-08-18', 0.0, NULL, 'Replace White Steel Rims With Black Steel Rims', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20ART', '20ART-00085', '2022-08-18', '2023-08-18', 0.0, NULL, 'Double L Aluminum Winch Track', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00046', '* 1 ft. Additional Main Deck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00047', '* 108 in. Width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00048', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00049', '* 38 in. x 76 in. Self Cleaning Air Operated Ramp', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00050', '* 38 in. x 76 in. Wood Filled Air Operated Ramp', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00051', '* 45 in. x 76 in. Air Operated Planked', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00052', '* Air Ride Suspension (includes air gauge and dump valve)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00053', '* Axle Spacing 61 in.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00054', '* Self Cleaning Beavertail', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00055', '* Tilt Deck Package (4 Air Bags)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00056', '1 3/8 in. x 7 in. Keruing Shiplapped', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00057', '1 ft. Bolt On A-Frame Extension', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00058', '6 ft. Beavertail ', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00059', 'Add 3/8 in. flatbar full length under deck approx 6 in. from siderail, passenger side', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00060', 'Additional Mudflaps with Brackets (pair)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00061', 'Air Ride Suspension (includes air gauge and dump valve)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00062', 'Alum. Wheel Pkg. 17.5  (4 steel, 4 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00063', 'Alum. Wheel Pkg. 17.5  (8 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00064', 'Amber Flashing Strobe Lights(Mounted in Ramps)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00065', 'BWS Red - PPG#370-75034', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00066', 'BWS Yellow - PPG#920612', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00067', 'Dual Holland Mark V 2 Speed Landing Gear', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00068', 'Extra, Side Mount D-Rings (pair)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00069', 'Flag Holders (set of 4)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00070', 'Four Pin Plug w/Strobe Light Pocket at Rear', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00071', 'Galvanizing Unit', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00072', 'J-Hooks', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00073', 'Remove mud flaps, set up for flaps only – customer will install their own.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00074', 'Rub Rail and Stake Pockets - 48 in. OC (Outside nominal width)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00075', 'Rub Rail and Stake Pockets - 24 in. OC (Outside nominal width)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00076', 'Straps (3 in. x 30 ft. with Chain and Hook)(each)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00077', 'Swingout Outriggers (5 per side)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00078', 'Tire Carrier Only (A Frame Top Mount)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00079', 'Winch Track', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00080', 'Winches - Sliding  #5820 (hooks not included)(EACH)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00081', 'Winches - Sliding - 3 Bar #14011NP (hooks not included)(EACH)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00082', 'Winches (3 Bar Weld On) #148101-143 Undermount (hooks not included)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00083', 'Zinc Primer', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00084', 'Replace White Steel Rims With Black Steel Rims', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20ART', '20ART-00085', 'Double L Aluminum Winch Track', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);

--MODEL=20FDNT
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00078', '2022-08-18', '2023-08-18', 0.0, NULL, '* 1 ft. Additional Main Deck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00079', '2022-08-18', '2023-08-18', 0.0, NULL, '* 108 in. Width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00080', '2022-08-18', '2023-08-18', 0.0, NULL, '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00081', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Ride Suspension (includes air gauge and dump valve)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00082', '2022-08-18', '2023-08-18', 0.0, NULL, '* Axle Spacing 61 in.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00083', '2022-08-18', '2023-08-18', 0.0, NULL, '* Install Headboard Pockets', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00084', '2022-08-18', '2023-08-18', 0.0, NULL, '1 3/8 in. x 7 in. Keruing Shiplapped', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00085', '2022-08-18', '2023-08-18', 0.0, NULL, '1 ft. Bolt On A-Frame Extension', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00086', '2022-08-18', '2023-08-18', 0.0, NULL, 'Add 3/8 in. flatbar full length under deck approx 6 in. from siderail, passenger side', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00087', '2022-08-18', '2023-08-18', 0.0, NULL, 'Additional Mudflaps with Brackets (pair)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00088', '2022-08-18', '2023-08-18', 0.0, NULL, 'Air Ride Suspension (includes air gauge and dump valve)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00089', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 17.5  (4 steel, 4 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00090', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 17.5  (8 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00091', '2022-08-18', '2023-08-18', 0.0, NULL, 'Amber Flashing Strobe Lights(Mounted in Bumper)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00092', '2022-08-18', '2023-08-18', 0.0, NULL, 'BWS Red - PPG#370-75034', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00093', '2022-08-18', '2023-08-18', 0.0, NULL, 'BWS Yellow - PPG#920612', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00094', '2022-08-18', '2023-08-18', 0.0, NULL, 'Dual Holland Mark V 2 Speed Landing Gear', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00095', '2022-08-18', '2023-08-18', 0.0, NULL, 'Flag Holders (set of 4)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00096', '2022-08-18', '2023-08-18', 0.0, NULL, 'Four Pin Plug w/Strobe Light Pocket at Rear', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00097', '2022-08-18', '2023-08-18', 0.0, NULL, 'Galvanizing Unit', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00098', '2022-08-18', '2023-08-18', 0.0, NULL, 'J-Hooks', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00099', '2022-08-18', '2023-08-18', 0.0, NULL, 'Remove mud flaps, set up for flaps only – customer will install their own.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00100', '2022-08-18', '2023-08-18', 0.0, NULL, 'Rub Rail and Stake Pockets - 24 in. OC', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00101', '2022-08-18', '2023-08-18', 0.0, NULL, 'Straps (3 in. x 30 ft. with Chain and Hook)(each)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00102', '2022-08-18', '2023-08-18', 0.0, NULL, 'Tire Carrier Only (A Frame Top Mount)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00103', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winch Track', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00104', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches - Sliding  #5820 (hooks not included)(EACH)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00105', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches - Sliding - 3 Bar #14011NP (hooks not included)(EACH)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00106', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches (3 Bar Weld On) #148101-143 Undermount (hooks not included)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00107', '2022-08-18', '2023-08-18', 0.0, NULL, 'Zinc Primer', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00108', '2022-08-18', '2023-08-18', 0.0, NULL, 'Replace White Steel Rims With Black Steel Rims', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20FDNT', '20FDNT-00109', '2022-08-18', '2023-08-18', 0.0, NULL, 'Double L Aluminum Winch Track', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00106', '* 1 ft. Additional Main Deck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00107', '* 108 in. Width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00108', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00109', '* Air Ride Suspension (includes air gauge and dump valve)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00110', '* Axle Spacing 61 in.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00111', '* Install Headboard Pockets', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00112', '1 3/8 in. x 7 in. Keruing Shiplapped', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00113', '1 ft. Bolt On A-Frame Extension', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00114', 'Add 3/8 in. flatbar full length under deck approx 6 in. from siderail, passenger side', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00115', 'Additional Mudflaps with Brackets (pair)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00116', 'Air Ride Suspension (includes air gauge and dump valve)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00117', 'Alum. Wheel Pkg. 17.5  (4 steel, 4 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00118', 'Alum. Wheel Pkg. 17.5  (8 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00119', 'Amber Flashing Strobe Lights(Mounted in Bumper)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00120', 'BWS Red - PPG#370-75034', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00121', 'BWS Yellow - PPG#920612', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00122', 'Dual Holland Mark V 2 Speed Landing Gear', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00123', 'Flag Holders (set of 4)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00124', 'Four Pin Plug w/Strobe Light Pocket at Rear', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00125', 'Galvanizing Unit', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00126', 'J-Hooks', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00127', 'Remove mud flaps, set up for flaps only – customer will install their own.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00128', 'Rub Rail and Stake Pockets - 24 in. OC', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00129', 'Straps (3 in. x 30 ft. with Chain and Hook)(each)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00130', 'Tire Carrier Only (A Frame Top Mount)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00131', 'Winch Track', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00132', 'Winches - Sliding  #5820 (hooks not included)(EACH)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00133', 'Winches - Sliding - 3 Bar #14011NP (hooks not included)(EACH)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00134', 'Winches (3 Bar Weld On) #148101-143 Undermount (hooks not included)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00135', 'Zinc Primer', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00136', 'Replace White Steel Rims With Black Steel Rims', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20FDNT', '20FDNT-00137', 'Double L Aluminum Winch Track', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);

--MODEL=20NTT
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00079', '2022-08-18', '2023-08-18', 0.0, NULL, '* 1 ft. Additional Main Deck', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00080', '2022-08-18', '2023-08-18', 0.0, NULL, '* 108 in. Width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00081', '2022-08-18', '2023-08-18', 0.0, NULL, '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00082', '2022-08-18', '2023-08-18', 0.0, NULL, '* 38 in. x 76 in. Self Cleaning Air Operated Ramp', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00083', '2022-08-18', '2023-08-18', 0.0, NULL, '* 38 in. x 76 in. Wood Filled Air Operated Ramp', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00084', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 in. x 76 in. Air Operated Planked', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00085', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Ride Suspension (includes air gauge and dump valve)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00086', '2022-08-18', '2023-08-18', 0.0, NULL, '* Axle Spacing 61 in.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00087', '2022-08-18', '2023-08-18', 0.0, NULL, '* Self Cleaning Beavertail', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00088', '2022-08-18', '2023-08-18', 0.0, NULL, '1 3/8 in. x 7 in. Keruing Shiplapped', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00089', '2022-08-18', '2023-08-18', 0.0, NULL, '1 ft. Bolt On A-Frame Extension', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00090', '2022-08-18', '2023-08-18', 0.0, NULL, '20 in. x 48 in. Spring assist, self cleaning, adjustable total width 99 in. max./ 68 in. min.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00091', '2022-08-18', '2023-08-18', 0.0, NULL, '20 in. x 50 in. Lay Level Spring Assist, Self Cleaning, adjustable total width 99 in. max. / 68 in.min', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00092', '2022-08-18', '2023-08-18', 0.0, NULL, '6 ft. Beavertail ', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00093', '2022-08-18', '2023-08-18', 0.0, NULL, 'Add 3/8 in. flatbar full length under deck approx 6 in. from siderail, passenger side', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00094', '2022-08-18', '2023-08-18', 0.0, NULL, 'Additional Mudflaps with Brackets (pair)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00095', '2022-08-18', '2023-08-18', 0.0, NULL, 'Air Ride Suspension (includes air gauge and dump valve)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00096', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 17.5  (4 steel, 4 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00097', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 17.5  (8 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00098', '2022-08-18', '2023-08-18', 0.0, NULL, 'Amber Flashing Strobe Lights(Mounted in Ramps)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00099', '2022-08-18', '2023-08-18', 0.0, NULL, 'BWS Red - PPG#370-75034', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00100', '2022-08-18', '2023-08-18', 0.0, NULL, 'BWS Yellow - PPG#920612', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00101', '2022-08-18', '2023-08-18', 0.0, NULL, 'Dual Holland Mark V 2 Speed Landing Gear', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00102', '2022-08-18', '2023-08-18', 0.0, NULL, 'Extra, Side Mount D-Rings (pair)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00103', '2022-08-18', '2023-08-18', 0.0, NULL, 'Flag Holders (set of 4)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00104', '2022-08-18', '2023-08-18', 0.0, NULL, 'Four Pin Plug w/Strobe Light Pocket at Rear', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00105', '2022-08-18', '2023-08-18', 0.0, NULL, 'Galvanizing Unit', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00106', '2022-08-18', '2023-08-18', 0.0, NULL, 'J-Hooks', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00107', '2022-08-18', '2023-08-18', 0.0, NULL, 'Remove mud flaps, set up for flaps only – customer will install their own.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00108', '2022-08-18', '2023-08-18', 0.0, NULL, 'Rub Rail and Stake Pockets - 48 in. OC (Outside nominal width)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00109', '2022-08-18', '2023-08-18', 0.0, NULL, 'Rub Rail and Stake Pockets - 24 in. OC (Outside nominal width)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00110', '2022-08-18', '2023-08-18', 0.0, NULL, 'Straps (3 in. x 30 ft. with Chain and Hook)(each)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00111', '2022-08-18', '2023-08-18', 0.0, NULL, 'Swingout Outriggers (5 per side)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00112', '2022-08-18', '2023-08-18', 0.0, NULL, 'Tire Carrier Only (A Frame Top Mount)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00113', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winch Track', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00114', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches - Sliding  #5820 (hooks not included)(EACH)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00115', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches - Sliding - 3 Bar #14011NP (hooks not included)(EACH)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00116', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches (3 Bar Weld On) #148101-143 Undermount (hooks not included)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00117', '2022-08-18', '2023-08-18', 0.0, NULL, 'Zinc Primer', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00118', '2022-08-18', '2023-08-18', 0.0, NULL, 'Replace White Steel Rims With Black Steel Rims', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('20NTT', '20NTT-00119', '2022-08-18', '2023-08-18', 0.0, NULL, 'Double L Aluminum Winch Track', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00089', '* 1 ft. Additional Main Deck', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00090', '* 108 in. Width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00091', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00092', '* 38 in. x 76 in. Self Cleaning Air Operated Ramp', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00093', '* 38 in. x 76 in. Wood Filled Air Operated Ramp', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00094', '* 45 in. x 76 in. Air Operated Planked', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00095', '* Air Ride Suspension (includes air gauge and dump valve)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00096', '* Axle Spacing 61 in.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00097', '* Self Cleaning Beavertail', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00098', '1 3/8 in. x 7 in. Keruing Shiplapped', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00099', '1 ft. Bolt On A-Frame Extension', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00100', '20 in. x 48 in. Spring assist, self cleaning, adjustable total width 99 in. max./ 68 in. min.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00101', '20 in. x 50 in. Lay Level Spring Assist, Self Cleaning, adjustable total width 99 in. max. / 68 in.min', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00102', '6 ft. Beavertail ', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00103', 'Add 3/8 in. flatbar full length under deck approx 6 in. from siderail, passenger side', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00104', 'Additional Mudflaps with Brackets (pair)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00105', 'Air Ride Suspension (includes air gauge and dump valve)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00106', 'Alum. Wheel Pkg. 17.5  (4 steel, 4 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00107', 'Alum. Wheel Pkg. 17.5  (8 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00108', 'Amber Flashing Strobe Lights(Mounted in Ramps)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00109', 'BWS Red - PPG#370-75034', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00110', 'BWS Yellow - PPG#920612', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00111', 'Dual Holland Mark V 2 Speed Landing Gear', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00112', 'Extra, Side Mount D-Rings (pair)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00113', 'Flag Holders (set of 4)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00114', 'Four Pin Plug w/Strobe Light Pocket at Rear', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00115', 'Galvanizing Unit', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00116', 'J-Hooks', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00117', 'Remove mud flaps, set up for flaps only – customer will install their own.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00118', 'Rub Rail and Stake Pockets - 48 in. OC (Outside nominal width)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00119', 'Rub Rail and Stake Pockets - 24 in. OC (Outside nominal width)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00120', 'Straps (3 in. x 30 ft. with Chain and Hook)(each)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00121', 'Swingout Outriggers (5 per side)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00122', 'Tire Carrier Only (A Frame Top Mount)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00123', 'Winch Track', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00124', 'Winches - Sliding  #5820 (hooks not included)(EACH)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00125', 'Winches - Sliding - 3 Bar #14011NP (hooks not included)(EACH)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00126', 'Winches (3 Bar Weld On) #148101-143 Undermount (hooks not included)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00127', 'Zinc Primer', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00128', 'Replace White Steel Rims With Black Steel Rims', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '20NTT', '20NTT-00129', 'Double L Aluminum Winch Track', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);

--MODEL=25ANR
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00080', '2022-08-18', '2023-08-18', 0.0, NULL, '* 1 ft. Additional Main Deck (up to 4 extra Feet)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00081', '2022-08-18', '2023-08-18', 0.0, NULL, '* 108 in. Width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00082', '2022-08-18', '2023-08-18', 0.0, NULL, '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00083', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Lift c/w  Control Box, 2 Spring Susp., 1 Air Susp.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00084', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Lift c/w  Control Box, all Air Susp., Dump Valve and Air Gauge', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00085', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Ride Suspension (includes air gauge and dump valve)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00086', '2022-08-18', '2023-08-18', 0.0, NULL, '* Axle Spacing 61 in.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00087', '2022-08-18', '2023-08-18', 0.0, NULL, '* Tilt Deck Package (4 Air Bags)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00088', '2022-08-18', '2023-08-18', 0.0, NULL, '1 3/8 in. x 7 in. Keruing Shiplapped', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00089', '2022-08-18', '2023-08-18', 0.0, NULL, '1 ft. Bolt On A-Frame Extension', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00090', '2022-08-18', '2023-08-18', 0.0, NULL, 'Add 3/8 in. flatbar full length under deck approx 6 in. from siderail, passenger side', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00091', '2022-08-18', '2023-08-18', 0.0, NULL, 'Additional Mudflaps with Brackets (pair)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00092', '2022-08-18', '2023-08-18', 0.0, NULL, 'Air Ride Suspension (includes air gauge and dump valve)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00093', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 17.5  (12 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00094', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 17.5  (6 steel, 6 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00095', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 22.5  (6 Machined, 6 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00096', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 22.5  (6 steel, 6 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00097', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 22.5 (12 Polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00098', '2022-08-18', '2023-08-18', 0.0, NULL, 'Amber Flashing Strobe Lights(Mounted in Bumper)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00099', '2022-08-18', '2023-08-18', 0.0, NULL, 'BWS Red - PPG#370-75034', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00100', '2022-08-18', '2023-08-18', 0.0, NULL, 'BWS Yellow - PPG#920612', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00101', '2022-08-18', '2023-08-18', 0.0, NULL, 'Dual Holland Mark V 2 Speed Landing Gear', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00102', '2022-08-18', '2023-08-18', 0.0, NULL, 'Extra, Side Mount D-Rings (pair)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00103', '2022-08-18', '2023-08-18', 0.0, NULL, 'Flag Holders (set of 4)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00104', '2022-08-18', '2023-08-18', 0.0, NULL, 'Four Pin Plug w/Strobe Light Pocket at Rear', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00105', '2022-08-18', '2023-08-18', 0.0, NULL, 'Galvanizing Unit', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00106', '2022-08-18', '2023-08-18', 0.0, NULL, 'J-Hooks', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00107', '2022-08-18', '2023-08-18', 0.0, NULL, 'Remove mud flaps, set up for flaps only – customer will install their own.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00108', '2022-08-18', '2023-08-18', 0.0, NULL, 'Rub Rail and Stake Pockets - 48 in. OC (Outside nominal width)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00109', '2022-08-18', '2023-08-18', 0.0, NULL, 'Rub Rail and Stake Pockets - 24 in. OC (Outside nominal width)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00110', '2022-08-18', '2023-08-18', 0.0, NULL, 'Straps (3 in. x 30 ft. with Chain and Hook)(each)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00111', '2022-08-18', '2023-08-18', 0.0, NULL, 'Swingout Outriggers (6 per side)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00112', '2022-08-18', '2023-08-18', 0.0, NULL, 'Tire Carrier Only (A Frame Top Mount)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00113', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winch Track', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00114', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches - Sliding  #5820 (hooks not included)(EACH)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00115', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches - Sliding - 3 Bar #14011NP (hooks not included)(EACH)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00116', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches (3 Bar Weld On) #148101-143 Undermount (hooks not included)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00117', '2022-08-18', '2023-08-18', 0.0, NULL, 'Zinc Primer', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00118', '2022-08-18', '2023-08-18', 0.0, NULL, 'Replace White Steel Rims With Black Steel Rims', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ANR', '25ANR-00119', '2022-08-18', '2023-08-18', 0.0, NULL, 'Double L Aluminum Winch Track', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00084', '* 1 ft. Additional Main Deck (up to 4 extra Feet)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00085', '* 108 in. Width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00086', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00087', '* Air Lift c/w  Control Box, 2 Spring Susp., 1 Air Susp.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00088', '* Air Lift c/w  Control Box, all Air Susp., Dump Valve and Air Gauge', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00089', '* Air Ride Suspension (includes air gauge and dump valve)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00090', '* Axle Spacing 61 in.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00091', '* Tilt Deck Package (4 Air Bags)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00092', '1 3/8 in. x 7 in. Keruing Shiplapped', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00093', '1 ft. Bolt On A-Frame Extension', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00094', 'Add 3/8 in. flatbar full length under deck approx 6 in. from siderail, passenger side', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00095', 'Additional Mudflaps with Brackets (pair)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00096', 'Air Ride Suspension (includes air gauge and dump valve)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00097', 'Alum. Wheel Pkg. 17.5  (12 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00098', 'Alum. Wheel Pkg. 17.5  (6 steel, 6 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00099', 'Alum. Wheel Pkg. 22.5  (6 Machined, 6 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00100', 'Alum. Wheel Pkg. 22.5  (6 steel, 6 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00101', 'Alum. Wheel Pkg. 22.5 (12 Polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00102', 'Amber Flashing Strobe Lights(Mounted in Bumper)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00103', 'BWS Red - PPG#370-75034', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00104', 'BWS Yellow - PPG#920612', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00105', 'Dual Holland Mark V 2 Speed Landing Gear', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00106', 'Extra, Side Mount D-Rings (pair)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00107', 'Flag Holders (set of 4)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00108', 'Four Pin Plug w/Strobe Light Pocket at Rear', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00109', 'Galvanizing Unit', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00110', 'J-Hooks', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00111', 'Remove mud flaps, set up for flaps only – customer will install their own.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00112', 'Rub Rail and Stake Pockets - 48 in. OC (Outside nominal width)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00113', 'Rub Rail and Stake Pockets - 24 in. OC (Outside nominal width)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00114', 'Straps (3 in. x 30 ft. with Chain and Hook)(each)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00115', 'Swingout Outriggers (6 per side)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00116', 'Tire Carrier Only (A Frame Top Mount)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00117', 'Winch Track', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00118', 'Winches - Sliding  #5820 (hooks not included)(EACH)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00119', 'Winches - Sliding - 3 Bar #14011NP (hooks not included)(EACH)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00120', 'Winches (3 Bar Weld On) #148101-143 Undermount (hooks not included)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00121', 'Zinc Primer', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00122', 'Replace White Steel Rims With Black Steel Rims', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ANR', '25ANR-00123', 'Double L Aluminum Winch Track', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);

--MODEL=30ANR
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00076', '2022-08-18', '2023-08-18', 0.0, NULL, '* 1 ft. Additional Main Deck (up to 4 extra Feet)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00077', '2022-08-18', '2023-08-18', 0.0, NULL, '* 108 in. Width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00078', '2022-08-18', '2023-08-18', 0.0, NULL, '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00079', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Lift c/w  Control Box, 2 Spring Susp., 1 Air Susp.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00080', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Lift c/w  Control Box, all Air Susp., Dump Valve and Air Gauge', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00081', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Ride Suspension (includes air gauge and dump valve)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00082', '2022-08-18', '2023-08-18', 0.0, NULL, '* Axle Spacing 61 in.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00083', '2022-08-18', '2023-08-18', 0.0, NULL, '* Tilt Deck Package (4 Air Bags)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00084', '2022-08-18', '2023-08-18', 0.0, NULL, '1 3/8 in. x 7 in. Keruing Shiplapped', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00085', '2022-08-18', '2023-08-18', 0.0, NULL, '1 ft. Bolt On A-Frame Extension', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00086', '2022-08-18', '2023-08-18', 0.0, NULL, 'Add 3/8 in. flatbar full length under deck approx 6 in. from siderail, passenger side', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00087', '2022-08-18', '2023-08-18', 0.0, NULL, 'Additional Mudflaps with Brackets (pair)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00088', '2022-08-18', '2023-08-18', 0.0, NULL, 'Air Ride Suspension (includes air gauge and dump valve)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00089', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 17.5  (12 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00090', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 17.5  (6 steel, 6 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00091', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 22.5  (6 Machined, 6 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00092', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 22.5  (6 steel, 6 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00093', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 22.5 (12 Polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00094', '2022-08-18', '2023-08-18', 0.0, NULL, 'Amber Flashing Strobe Lights(Mounted in Bumper)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00095', '2022-08-18', '2023-08-18', 0.0, NULL, 'BWS Red - PPG#370-75034', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00096', '2022-08-18', '2023-08-18', 0.0, NULL, 'BWS Yellow - PPG#920612', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00097', '2022-08-18', '2023-08-18', 0.0, NULL, 'Dual Holland Mark V 2 Speed Landing Gear', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00098', '2022-08-18', '2023-08-18', 0.0, NULL, 'Extra, Side Mount D-Rings (pair)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00099', '2022-08-18', '2023-08-18', 0.0, NULL, 'Flag Holders (set of 4)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00100', '2022-08-18', '2023-08-18', 0.0, NULL, 'Four Pin Plug w/Strobe Light Pocket at Rear', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00101', '2022-08-18', '2023-08-18', 0.0, NULL, 'Galvanizing Unit', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00102', '2022-08-18', '2023-08-18', 0.0, NULL, 'J-Hooks', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00103', '2022-08-18', '2023-08-18', 0.0, NULL, 'Remove mud flaps, set up for flaps only – customer will install their own.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00104', '2022-08-18', '2023-08-18', 0.0, NULL, 'Rub Rail and Stake Pockets - 48 in. OC (Outside nominal width)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00105', '2022-08-18', '2023-08-18', 0.0, NULL, 'Rub Rail and Stake Pockets - 24 in. OC (Outside nominal width)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00106', '2022-08-18', '2023-08-18', 0.0, NULL, 'Straps (3 in. x 30 ft. with Chain and Hook)(each)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00107', '2022-08-18', '2023-08-18', 0.0, NULL, 'Swingout Outriggers (6 per side)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00108', '2022-08-18', '2023-08-18', 0.0, NULL, 'Tire Carrier Only (A Frame Top Mount)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00109', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winch Track', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00110', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches - Sliding  #5820 (hooks not included)(EACH)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00111', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches - Sliding - 3 Bar #14011NP (hooks not included)(EACH)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00112', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches (3 Bar Weld On) #148101-143 Undermount (hooks not included)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00113', '2022-08-18', '2023-08-18', 0.0, NULL, 'Zinc Primer', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00114', '2022-08-18', '2023-08-18', 0.0, NULL, 'Replace White Steel Rims With Black Steel Rims', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ANR', '30ANR-00115', '2022-08-18', '2023-08-18', 0.0, NULL, 'Double L Aluminum Winch Track', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00079', '* 1 ft. Additional Main Deck (up to 4 extra Feet)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00080', '* 108 in. Width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00081', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00082', '* Air Lift c/w  Control Box, 2 Spring Susp., 1 Air Susp.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00083', '* Air Lift c/w  Control Box, all Air Susp., Dump Valve and Air Gauge', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00084', '* Air Ride Suspension (includes air gauge and dump valve)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00085', '* Axle Spacing 61 in.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00086', '* Tilt Deck Package (4 Air Bags)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00087', '1 3/8 in. x 7 in. Keruing Shiplapped', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00088', '1 ft. Bolt On A-Frame Extension', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00089', 'Add 3/8 in. flatbar full length under deck approx 6 in. from siderail, passenger side', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00090', 'Additional Mudflaps with Brackets (pair)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00091', 'Air Ride Suspension (includes air gauge and dump valve)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00092', 'Alum. Wheel Pkg. 17.5  (12 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00093', 'Alum. Wheel Pkg. 17.5  (6 steel, 6 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00094', 'Alum. Wheel Pkg. 22.5  (6 Machined, 6 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00095', 'Alum. Wheel Pkg. 22.5  (6 steel, 6 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00096', 'Alum. Wheel Pkg. 22.5 (12 Polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00097', 'Amber Flashing Strobe Lights(Mounted in Bumper)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00098', 'BWS Red - PPG#370-75034', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00099', 'BWS Yellow - PPG#920612', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00100', 'Dual Holland Mark V 2 Speed Landing Gear', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00101', 'Extra, Side Mount D-Rings (pair)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00102', 'Flag Holders (set of 4)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00103', 'Four Pin Plug w/Strobe Light Pocket at Rear', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00104', 'Galvanizing Unit', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00105', 'J-Hooks', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00106', 'Remove mud flaps, set up for flaps only – customer will install their own.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00107', 'Rub Rail and Stake Pockets - 48 in. OC (Outside nominal width)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00108', 'Rub Rail and Stake Pockets - 24 in. OC (Outside nominal width)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00109', 'Straps (3 in. x 30 ft. with Chain and Hook)(each)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00110', 'Swingout Outriggers (6 per side)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00111', 'Tire Carrier Only (A Frame Top Mount)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00112', 'Winch Track', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00113', 'Winches - Sliding  #5820 (hooks not included)(EACH)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00114', 'Winches - Sliding - 3 Bar #14011NP (hooks not included)(EACH)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00115', 'Winches (3 Bar Weld On) #148101-143 Undermount (hooks not included)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00116', 'Zinc Primer', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00117', 'Replace White Steel Rims With Black Steel Rims', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ANR', '30ANR-00118', 'Double L Aluminum Winch Track', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);

--MODEL=25ART
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00101', '2022-08-18', '2023-08-18', 0.0, NULL, '* 1 ft. Additional Main Deck (up to 4 extra Feet)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00102', '2022-08-18', '2023-08-18', 0.0, NULL, '* 108 in. Width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00103', '2022-08-18', '2023-08-18', 0.0, NULL, '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00104', '2022-08-18', '2023-08-18', 0.0, NULL, '* 38 in. x 76 in. Self Cleaning Air Operated Ramp', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00105', '2022-08-18', '2023-08-18', 0.0, NULL, '* 38 in. x 76 in. Wood Filled Air Operated Ramp', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00106', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 in. x 76 in. Air Operated Planked', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00107', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 in. x 96 in. Air Operated Planked', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00108', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 in. x 96 in. Bi Fold Air Operated Planked (Spring Susp)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00109', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 x 96 Bifold Ramps Planked c/w 1 Lift Axle, 2 Spring Susp., 1 Air Susp.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00110', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 x 96 Bifold Ramps Planked c/w 1 Lift Axle, All Air Susp.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00111', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 x 96 Bifold Ramps Planked c/w 3 Air Susp., No Lift Axle', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00112', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Lift c/w  Control Box, 2 Spring Susp., 1 Air Susp.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00113', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Lift c/w  Control Box, all Air Susp., Dump Valve and Air Gauge', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00114', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Ride Suspension (includes air gauge and dump valve)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00115', '2022-08-18', '2023-08-18', 0.0, NULL, '* Axle Spacing 61 in.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00116', '2022-08-18', '2023-08-18', 0.0, NULL, '* Self Cleaning Beavertail', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00117', '2022-08-18', '2023-08-18', 0.0, NULL, '* Tilt Deck Package (4 Air Bags)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00118', '2022-08-18', '2023-08-18', 0.0, NULL, '1 3/8 in. x 7 in. Keruing Shiplapped', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00119', '2022-08-18', '2023-08-18', 0.0, NULL, '1 ft. Bolt On A-Frame Extension', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00120', '2022-08-18', '2023-08-18', 0.0, NULL, '6 ft. Beavertail ', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00121', '2022-08-18', '2023-08-18', 0.0, NULL, 'Add 3/8 in. flatbar full length under deck approx 6 in. from siderail, passenger side', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00122', '2022-08-18', '2023-08-18', 0.0, NULL, 'Additional Mudflaps with Brackets (pair)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00123', '2022-08-18', '2023-08-18', 0.0, NULL, 'Air Ride Suspension (includes air gauge and dump valve)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00124', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 17.5  (12 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00125', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 17.5  (6 steel, 6 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00126', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 22.5  (6 Machined, 6 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00127', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 22.5  (6 steel, 6 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00128', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 22.5 (12 Polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00129', '2022-08-18', '2023-08-18', 0.0, NULL, 'Amber Flashing Strobe Lights(Mounted in Ramps)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00130', '2022-08-18', '2023-08-18', 0.0, NULL, 'BWS Red - PPG#370-75034', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00131', '2022-08-18', '2023-08-18', 0.0, NULL, 'BWS Yellow - PPG#920612', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00132', '2022-08-18', '2023-08-18', 0.0, NULL, 'Dual Holland Mark V 2 Speed Landing Gear', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00133', '2022-08-18', '2023-08-18', 0.0, NULL, 'Extra, Side Mount D-Rings (pair)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00134', '2022-08-18', '2023-08-18', 0.0, NULL, 'Flag Holders (set of 4)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00135', '2022-08-18', '2023-08-18', 0.0, NULL, 'Four Pin Plug w/Strobe Light Pocket at Rear', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00136', '2022-08-18', '2023-08-18', 0.0, NULL, 'Galvanizing Unit', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00137', '2022-08-18', '2023-08-18', 0.0, NULL, 'J-Hooks', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00138', '2022-08-18', '2023-08-18', 0.0, NULL, 'Remove mud flaps, set up for flaps only – customer will install their own.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00139', '2022-08-18', '2023-08-18', 0.0, NULL, 'Rub Rail and Stake Pockets - 48 in. OC (Outside nominal width)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00140', '2022-08-18', '2023-08-18', 0.0, NULL, 'Rub Rail and Stake Pockets - 24 in. OC (Outside nominal width)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00141', '2022-08-18', '2023-08-18', 0.0, NULL, 'Straps (3 in. x 30 ft. with Chain and Hook)(each)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00142', '2022-08-18', '2023-08-18', 0.0, NULL, 'Swingout Outriggers (6 per side)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00143', '2022-08-18', '2023-08-18', 0.0, NULL, 'Tire Carrier Only (A Frame Top Mount)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00144', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winch Track', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00145', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches - Sliding  #5820 (hooks not included)(EACH)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00146', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches - Sliding - 3 Bar #14011NP (hooks not included)(EACH)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00147', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches (3 Bar Weld On) #148101-143 Undermount (hooks not included)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00148', '2022-08-18', '2023-08-18', 0.0, NULL, 'Zinc Primer', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00149', '2022-08-18', '2023-08-18', 0.0, NULL, 'Replace White Steel Rims With Black Steel Rims', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25ART', '25ART-00150', '2022-08-18', '2023-08-18', 0.0, NULL, 'Double L Aluminum Winch Track', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00104', '* 1 ft. Additional Main Deck (up to 4 extra Feet)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00105', '* 108 in. Width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00106', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00107', '* 38 in. x 76 in. Self Cleaning Air Operated Ramp', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00108', '* 38 in. x 76 in. Wood Filled Air Operated Ramp', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00109', '* 45 in. x 76 in. Air Operated Planked', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00110', '* 45 in. x 96 in. Air Operated Planked', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00111', '* 45 in. x 96 in. Bi Fold Air Operated Planked (Spring Susp)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00112', '* 45 x 96 Bifold Ramps Planked c/w 1 Lift Axle, 2 Spring Susp., 1 Air Susp.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00113', '* 45 x 96 Bifold Ramps Planked c/w 1 Lift Axle, All Air Susp.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00114', '* 45 x 96 Bifold Ramps Planked c/w 3 Air Susp., No Lift Axle', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00115', '* Air Lift c/w  Control Box, 2 Spring Susp., 1 Air Susp.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00116', '* Air Lift c/w  Control Box, all Air Susp., Dump Valve and Air Gauge', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00117', '* Air Ride Suspension (includes air gauge and dump valve)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00118', '* Axle Spacing 61 in.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00119', '* Self Cleaning Beavertail', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00120', '* Tilt Deck Package (4 Air Bags)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00121', '1 3/8 in. x 7 in. Keruing Shiplapped', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00122', '1 ft. Bolt On A-Frame Extension', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00123', '6 ft. Beavertail ', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00124', 'Add 3/8 in. flatbar full length under deck approx 6 in. from siderail, passenger side', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00125', 'Additional Mudflaps with Brackets (pair)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00126', 'Air Ride Suspension (includes air gauge and dump valve)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00127', 'Alum. Wheel Pkg. 17.5  (12 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00128', 'Alum. Wheel Pkg. 17.5  (6 steel, 6 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00129', 'Alum. Wheel Pkg. 22.5  (6 Machined, 6 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00130', 'Alum. Wheel Pkg. 22.5  (6 steel, 6 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00131', 'Alum. Wheel Pkg. 22.5 (12 Polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00132', 'Amber Flashing Strobe Lights(Mounted in Ramps)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00133', 'BWS Red - PPG#370-75034', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00134', 'BWS Yellow - PPG#920612', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00135', 'Dual Holland Mark V 2 Speed Landing Gear', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00136', 'Extra, Side Mount D-Rings (pair)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00137', 'Flag Holders (set of 4)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00138', 'Four Pin Plug w/Strobe Light Pocket at Rear', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00139', 'Galvanizing Unit', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00140', 'J-Hooks', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00141', 'Remove mud flaps, set up for flaps only – customer will install their own.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00142', 'Rub Rail and Stake Pockets - 48 in. OC (Outside nominal width)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00143', 'Rub Rail and Stake Pockets - 24 in. OC (Outside nominal width)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00144', 'Straps (3 in. x 30 ft. with Chain and Hook)(each)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00145', 'Swingout Outriggers (6 per side)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00146', 'Tire Carrier Only (A Frame Top Mount)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00147', 'Winch Track', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00148', 'Winches - Sliding  #5820 (hooks not included)(EACH)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00149', 'Winches - Sliding - 3 Bar #14011NP (hooks not included)(EACH)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00150', 'Winches (3 Bar Weld On) #148101-143 Undermount (hooks not included)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00151', 'Zinc Primer', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00152', 'Replace White Steel Rims With Black Steel Rims', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25ART', '25ART-00153', 'Double L Aluminum Winch Track', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);

--MODEL=30ART
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00056', '2022-08-18', '2023-08-18', 0.0, NULL, '* 1 ft. Additional Main Deck (up to 4 extra Feet)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00057', '2022-08-18', '2023-08-18', 0.0, NULL, '* 108 in. Width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00058', '2022-08-18', '2023-08-18', 0.0, NULL, '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00059', '2022-08-18', '2023-08-18', 0.0, NULL, '* 38 in. x 76 in. Self Cleaning Air Operated Ramp', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00060', '2022-08-18', '2023-08-18', 0.0, NULL, '* 38 in. x 76 in. Wood Filled Air Operated Ramp', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00061', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 in. x 76 in. Air Operated Planked', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00062', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 in. x 96 in. Air Operated Planked', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00063', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 in. x 96 in. Bi Fold Air Operated Planked (Spring Susp)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00064', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 x 96 Bifold Ramps Planked c/w 1 Lift Axle, 2 Spring Susp., 1 Air Susp.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00065', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 x 96 Bifold Ramps Planked c/w 1 Lift Axle, All Air Susp.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00066', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 x 96 Bifold Ramps Planked c/w 3 Air Susp., No Lift Axle', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00067', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Lift c/w  Control Box, 2 Spring Susp., 1 Air Susp.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00068', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Lift c/w  Control Box, all Air Susp., Dump Valve and Air Gauge', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00069', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Ride Suspension (includes air gauge and dump valve)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00070', '2022-08-18', '2023-08-18', 0.0, NULL, '* Axle Spacing 61 in.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00071', '2022-08-18', '2023-08-18', 0.0, NULL, '* Self Cleaning Beavertail', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00072', '2022-08-18', '2023-08-18', 0.0, NULL, '* Tilt Deck Package (4 Air Bags)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00073', '2022-08-18', '2023-08-18', 0.0, NULL, '1 3/8 in. x 7 in. Keruing Shiplapped', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00074', '2022-08-18', '2023-08-18', 0.0, NULL, '1 ft. Bolt On A-Frame Extension', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00075', '2022-08-18', '2023-08-18', 0.0, NULL, '6 ft. Beavertail ', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00076', '2022-08-18', '2023-08-18', 0.0, NULL, 'Add 3/8 in. flatbar full length under deck approx 6 in. from siderail, passenger side', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00077', '2022-08-18', '2023-08-18', 0.0, NULL, 'Additional Mudflaps with Brackets (pair)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00078', '2022-08-18', '2023-08-18', 0.0, NULL, 'Air Ride Suspension (includes air gauge and dump valve)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00079', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 17.5  (12 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00080', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 17.5  (6 steel, 6 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00081', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 22.5  (6 Machined, 6 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00082', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 22.5  (6 steel, 6 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00083', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 22.5 (12 Polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00084', '2022-08-18', '2023-08-18', 0.0, NULL, 'Amber Flashing Strobe Lights(Mounted in Ramps)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00085', '2022-08-18', '2023-08-18', 0.0, NULL, 'BWS Red - PPG#370-75034', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00086', '2022-08-18', '2023-08-18', 0.0, NULL, 'BWS Yellow - PPG#920612', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00087', '2022-08-18', '2023-08-18', 0.0, NULL, 'Dual Holland Mark V 2 Speed Landing Gear', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00088', '2022-08-18', '2023-08-18', 0.0, NULL, 'Extra, Side Mount D-Rings (pair)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00089', '2022-08-18', '2023-08-18', 0.0, NULL, 'Flag Holders (set of 4)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00090', '2022-08-18', '2023-08-18', 0.0, NULL, 'Four Pin Plug w/Strobe Light Pocket at Rear', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00091', '2022-08-18', '2023-08-18', 0.0, NULL, 'Galvanizing Unit', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00092', '2022-08-18', '2023-08-18', 0.0, NULL, 'J-Hooks', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00093', '2022-08-18', '2023-08-18', 0.0, NULL, 'Remove mud flaps, set up for flaps only – customer will install their own.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00094', '2022-08-18', '2023-08-18', 0.0, NULL, 'Rub Rail and Stake Pockets - 48 in. OC (Outside nominal width)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00095', '2022-08-18', '2023-08-18', 0.0, NULL, 'Rub Rail and Stake Pockets - 24 in. OC (Outside nominal width)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00096', '2022-08-18', '2023-08-18', 0.0, NULL, 'Straps (3 in. x 30 ft. with Chain and Hook)(each)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00097', '2022-08-18', '2023-08-18', 0.0, NULL, 'Swingout Outriggers (6 per side)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00098', '2022-08-18', '2023-08-18', 0.0, NULL, 'Tire Carrier Only (A Frame Top Mount)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00099', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winch Track', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00100', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches - Sliding  #5820 (hooks not included)(EACH)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00101', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches - Sliding - 3 Bar #14011NP (hooks not included)(EACH)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00102', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches (3 Bar Weld On) #148101-143 Undermount (hooks not included)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00103', '2022-08-18', '2023-08-18', 0.0, NULL, 'Zinc Primer', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00104', '2022-08-18', '2023-08-18', 0.0, NULL, 'Replace White Steel Rims With Black Steel Rims', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30ART', '30ART-00105', '2022-08-18', '2023-08-18', 0.0, NULL, 'Double L Aluminum Winch Track', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00055', '* 1 ft. Additional Main Deck (up to 4 extra Feet)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00056', '* 108 in. Width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00057', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00058', '* 38 in. x 76 in. Self Cleaning Air Operated Ramp', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00059', '* 38 in. x 76 in. Wood Filled Air Operated Ramp', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00060', '* 45 in. x 76 in. Air Operated Planked', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00061', '* 45 in. x 96 in. Air Operated Planked', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00062', '* 45 in. x 96 in. Bi Fold Air Operated Planked (Spring Susp)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00063', '* 45 x 96 Bifold Ramps Planked c/w 1 Lift Axle, 2 Spring Susp., 1 Air Susp.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00064', '* 45 x 96 Bifold Ramps Planked c/w 1 Lift Axle, All Air Susp.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00065', '* 45 x 96 Bifold Ramps Planked c/w 3 Air Susp., No Lift Axle', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00066', '* Air Lift c/w  Control Box, 2 Spring Susp., 1 Air Susp.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00067', '* Air Lift c/w  Control Box, all Air Susp., Dump Valve and Air Gauge', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00068', '* Air Ride Suspension (includes air gauge and dump valve)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00069', '* Axle Spacing 61 in.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00070', '* Self Cleaning Beavertail', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00071', '* Tilt Deck Package (4 Air Bags)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00072', '1 3/8 in. x 7 in. Keruing Shiplapped', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00073', '1 ft. Bolt On A-Frame Extension', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00074', '6 ft. Beavertail ', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00075', 'Add 3/8 in. flatbar full length under deck approx 6 in. from siderail, passenger side', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00076', 'Additional Mudflaps with Brackets (pair)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00077', 'Air Ride Suspension (includes air gauge and dump valve)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00078', 'Alum. Wheel Pkg. 17.5  (12 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00079', 'Alum. Wheel Pkg. 17.5  (6 steel, 6 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00080', 'Alum. Wheel Pkg. 22.5  (6 Machined, 6 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00081', 'Alum. Wheel Pkg. 22.5  (6 steel, 6 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00082', 'Alum. Wheel Pkg. 22.5 (12 Polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00083', 'Amber Flashing Strobe Lights(Mounted in Ramps)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00084', 'BWS Red - PPG#370-75034', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00085', 'BWS Yellow - PPG#920612', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00086', 'Dual Holland Mark V 2 Speed Landing Gear', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00087', 'Extra, Side Mount D-Rings (pair)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00088', 'Flag Holders (set of 4)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00089', 'Four Pin Plug w/Strobe Light Pocket at Rear', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00090', 'Galvanizing Unit', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00091', 'J-Hooks', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00092', 'Remove mud flaps, set up for flaps only – customer will install their own.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00093', 'Rub Rail and Stake Pockets - 48 in. OC (Outside nominal width)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00094', 'Rub Rail and Stake Pockets - 24 in. OC (Outside nominal width)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00095', 'Straps (3 in. x 30 ft. with Chain and Hook)(each)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00096', 'Swingout Outriggers (6 per side)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00097', 'Tire Carrier Only (A Frame Top Mount)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00098', 'Winch Track', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00099', 'Winches - Sliding  #5820 (hooks not included)(EACH)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00100', 'Winches - Sliding - 3 Bar #14011NP (hooks not included)(EACH)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00101', 'Winches (3 Bar Weld On) #148101-143 Undermount (hooks not included)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00102', 'Zinc Primer', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00103', 'Replace White Steel Rims With Black Steel Rims', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30ART', '30ART-00104', 'Double L Aluminum Winch Track', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);

--MODEL=25FDNT
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00087', '2022-08-18', '2023-08-18', 0.0, NULL, '* 1 ft. Additional Main Deck (up to 4 extra Feet)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00088', '2022-08-18', '2023-08-18', 0.0, NULL, '* 108 in. Width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00089', '2022-08-18', '2023-08-18', 0.0, NULL, '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00090', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Lift c/w  Control Box, 2 Spring Susp., 1 Air Susp.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00091', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Lift c/w  Control Box, all Air Susp., Dump Valve and Air Gauge', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00092', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Ride Suspension (includes air gauge and dump valve)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00093', '2022-08-18', '2023-08-18', 0.0, NULL, '* Axle Spacing 61 in.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00094', '2022-08-18', '2023-08-18', 0.0, NULL, '* Install Headboard Pockets', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00095', '2022-08-18', '2023-08-18', 0.0, NULL, '1 3/8 in. x 7 in. Keruing Shiplapped', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00096', '2022-08-18', '2023-08-18', 0.0, NULL, '1 ft. Bolt On A-Frame Extension', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00097', '2022-08-18', '2023-08-18', 0.0, NULL, 'Add 3/8 in. flatbar full length under deck approx 6 in. from siderail, passenger side', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00098', '2022-08-18', '2023-08-18', 0.0, NULL, 'Additional Mudflaps with Brackets (pair)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00099', '2022-08-18', '2023-08-18', 0.0, NULL, 'Air Ride Suspension (includes air gauge and dump valve)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00100', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 17.5  (12 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00101', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 17.5  (6 steel, 6 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00102', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 22.5  (6 Machined, 6 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00103', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 22.5  (6 steel, 6 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00104', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 22.5 (12 Polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00105', '2022-08-18', '2023-08-18', 0.0, NULL, 'Amber Flashing Strobe Lights(Mounted in Bumper)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00106', '2022-08-18', '2023-08-18', 0.0, NULL, 'BWS Red - PPG#370-75034', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00107', '2022-08-18', '2023-08-18', 0.0, NULL, 'BWS Yellow - PPG#920612', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00108', '2022-08-18', '2023-08-18', 0.0, NULL, 'Dual Holland Mark V 2 Speed Landing Gear', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00109', '2022-08-18', '2023-08-18', 0.0, NULL, 'Flag Holders (set of 4)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00110', '2022-08-18', '2023-08-18', 0.0, NULL, 'Four Pin Plug w/Strobe Light Pocket at Rear', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00111', '2022-08-18', '2023-08-18', 0.0, NULL, 'Galvanizing Unit', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00112', '2022-08-18', '2023-08-18', 0.0, NULL, 'J-Hooks', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00113', '2022-08-18', '2023-08-18', 0.0, NULL, 'Remove mud flaps, set up for flaps only – customer will install their own.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00114', '2022-08-18', '2023-08-18', 0.0, NULL, 'Rub Rail and Stake Pockets - 24 in. OC', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00115', '2022-08-18', '2023-08-18', 0.0, NULL, 'Straps (3 in. x 30 ft. with Chain and Hook)(each)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00116', '2022-08-18', '2023-08-18', 0.0, NULL, 'Tire Carrier Only (A Frame Top Mount)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00117', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winch Track', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00118', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches - Sliding  #5820 (hooks not included)(EACH)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00119', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches - Sliding - 3 Bar #14011NP (hooks not included)(EACH)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00120', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches (3 Bar Weld On) #148101-143 Undermount (hooks not included)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00121', '2022-08-18', '2023-08-18', 0.0, NULL, 'Zinc Primer', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00122', '2022-08-18', '2023-08-18', 0.0, NULL, 'Replace White Steel Rims With Black Steel Rims', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25FDNT', '25FDNT-00123', '2022-08-18', '2023-08-18', 0.0, NULL, 'Double L Aluminum Winch Track', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00087', '* 1 ft. Additional Main Deck (up to 4 extra Feet)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00088', '* 108 in. Width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00089', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00090', '* Air Lift c/w  Control Box, 2 Spring Susp., 1 Air Susp.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00091', '* Air Lift c/w  Control Box, all Air Susp., Dump Valve and Air Gauge', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00092', '* Air Ride Suspension (includes air gauge and dump valve)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00093', '* Axle Spacing 61 in.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00094', '* Install Headboard Pockets', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00095', '1 3/8 in. x 7 in. Keruing Shiplapped', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00096', '1 ft. Bolt On A-Frame Extension', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00097', 'Add 3/8 in. flatbar full length under deck approx 6 in. from siderail, passenger side', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00098', 'Additional Mudflaps with Brackets (pair)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00099', 'Air Ride Suspension (includes air gauge and dump valve)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00100', 'Alum. Wheel Pkg. 17.5  (12 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00101', 'Alum. Wheel Pkg. 17.5  (6 steel, 6 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00102', 'Alum. Wheel Pkg. 22.5  (6 Machined, 6 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00103', 'Alum. Wheel Pkg. 22.5  (6 steel, 6 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00104', 'Alum. Wheel Pkg. 22.5 (12 Polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00105', 'Amber Flashing Strobe Lights(Mounted in Bumper)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00106', 'BWS Red - PPG#370-75034', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00107', 'BWS Yellow - PPG#920612', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00108', 'Dual Holland Mark V 2 Speed Landing Gear', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00109', 'Flag Holders (set of 4)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00110', 'Four Pin Plug w/Strobe Light Pocket at Rear', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00111', 'Galvanizing Unit', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00112', 'J-Hooks', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00113', 'Remove mud flaps, set up for flaps only – customer will install their own.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00114', 'Rub Rail and Stake Pockets - 24 in. OC', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00115', 'Straps (3 in. x 30 ft. with Chain and Hook)(each)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00116', 'Tire Carrier Only (A Frame Top Mount)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00117', 'Winch Track', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00118', 'Winches - Sliding  #5820 (hooks not included)(EACH)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00119', 'Winches - Sliding - 3 Bar #14011NP (hooks not included)(EACH)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00120', 'Winches (3 Bar Weld On) #148101-143 Undermount (hooks not included)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00121', 'Zinc Primer', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00122', 'Replace White Steel Rims With Black Steel Rims', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25FDNT', '25FDNT-00123', 'Double L Aluminum Winch Track', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);

--MODEL=30FDNT
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00050', '2022-08-18', '2023-08-18', 0.0, NULL, '* 1 ft. Additional Main Deck (up to 4 extra Feet)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00051', '2022-08-18', '2023-08-18', 0.0, NULL, '* 108 in. Width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00052', '2022-08-18', '2023-08-18', 0.0, NULL, '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00053', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Lift c/w  Control Box, 2 Spring Susp., 1 Air Susp.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00054', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Lift c/w  Control Box, all Air Susp., Dump Valve and Air Gauge', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00055', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Ride Suspension (includes air gauge and dump valve)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00056', '2022-08-18', '2023-08-18', 0.0, NULL, '* Axle Spacing 61 in.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00057', '2022-08-18', '2023-08-18', 0.0, NULL, '* Install Headboard Pockets', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00058', '2022-08-18', '2023-08-18', 0.0, NULL, '1 3/8 in. x 7 in. Keruing Shiplapped', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00059', '2022-08-18', '2023-08-18', 0.0, NULL, '1 ft. Bolt On A-Frame Extension', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00060', '2022-08-18', '2023-08-18', 0.0, NULL, 'Add 3/8 in. flatbar full length under deck approx 6 in. from siderail, passenger side', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00061', '2022-08-18', '2023-08-18', 0.0, NULL, 'Additional Mudflaps with Brackets (pair)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00062', '2022-08-18', '2023-08-18', 0.0, NULL, 'Air Ride Suspension (includes air gauge and dump valve)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00063', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 17.5  (12 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00064', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 17.5  (6 steel, 6 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00065', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 22.5  (6 Machined, 6 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00066', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 22.5  (6 steel, 6 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00067', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 22.5 (12 Polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00068', '2022-08-18', '2023-08-18', 0.0, NULL, 'Amber Flashing Strobe Lights(Mounted in Bumper)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00069', '2022-08-18', '2023-08-18', 0.0, NULL, 'BWS Red - PPG#370-75034', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00070', '2022-08-18', '2023-08-18', 0.0, NULL, 'BWS Yellow - PPG#920612', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00071', '2022-08-18', '2023-08-18', 0.0, NULL, 'Dual Holland Mark V 2 Speed Landing Gear', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00072', '2022-08-18', '2023-08-18', 0.0, NULL, 'Flag Holders (set of 4)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00073', '2022-08-18', '2023-08-18', 0.0, NULL, 'Four Pin Plug w/Strobe Light Pocket at Rear', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00074', '2022-08-18', '2023-08-18', 0.0, NULL, 'Galvanizing Unit', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00075', '2022-08-18', '2023-08-18', 0.0, NULL, 'J-Hooks', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00076', '2022-08-18', '2023-08-18', 0.0, NULL, 'Remove mud flaps, set up for flaps only – customer will install their own.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00077', '2022-08-18', '2023-08-18', 0.0, NULL, 'Rub Rail and Stake Pockets - 24 in. OC', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00078', '2022-08-18', '2023-08-18', 0.0, NULL, 'Straps (3 in. x 30 ft. with Chain and Hook)(each)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00079', '2022-08-18', '2023-08-18', 0.0, NULL, 'Tire Carrier Only (A Frame Top Mount)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00080', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winch Track', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00081', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches - Sliding  #5820 (hooks not included)(EACH)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00082', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches - Sliding - 3 Bar #14011NP (hooks not included)(EACH)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00083', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches (3 Bar Weld On) #148101-143 Undermount (hooks not included)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00084', '2022-08-18', '2023-08-18', 0.0, NULL, 'Zinc Primer', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00085', '2022-08-18', '2023-08-18', 0.0, NULL, 'Replace White Steel Rims With Black Steel Rims', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30FDNT', '30FDNT-00086', '2022-08-18', '2023-08-18', 0.0, NULL, 'Double L Aluminum Winch Track', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00050', '* 1 ft. Additional Main Deck (up to 4 extra Feet)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00051', '* 108 in. Width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00052', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00053', '* Air Lift c/w  Control Box, 2 Spring Susp., 1 Air Susp.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00054', '* Air Lift c/w  Control Box, all Air Susp., Dump Valve and Air Gauge', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00055', '* Air Ride Suspension (includes air gauge and dump valve)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00056', '* Axle Spacing 61 in.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00057', '* Install Headboard Pockets', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00058', '1 3/8 in. x 7 in. Keruing Shiplapped', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00059', '1 ft. Bolt On A-Frame Extension', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00060', 'Add 3/8 in. flatbar full length under deck approx 6 in. from siderail, passenger side', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00061', 'Additional Mudflaps with Brackets (pair)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00062', 'Air Ride Suspension (includes air gauge and dump valve)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00063', 'Alum. Wheel Pkg. 17.5  (12 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00064', 'Alum. Wheel Pkg. 17.5  (6 steel, 6 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00065', 'Alum. Wheel Pkg. 22.5  (6 Machined, 6 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00066', 'Alum. Wheel Pkg. 22.5  (6 steel, 6 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00067', 'Alum. Wheel Pkg. 22.5 (12 Polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00068', 'Amber Flashing Strobe Lights(Mounted in Bumper)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00069', 'BWS Red - PPG#370-75034', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00070', 'BWS Yellow - PPG#920612', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00071', 'Dual Holland Mark V 2 Speed Landing Gear', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00072', 'Flag Holders (set of 4)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00073', 'Four Pin Plug w/Strobe Light Pocket at Rear', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00074', 'Galvanizing Unit', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00075', 'J-Hooks', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00076', 'Remove mud flaps, set up for flaps only – customer will install their own.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00077', 'Rub Rail and Stake Pockets - 24 in. OC', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00078', 'Straps (3 in. x 30 ft. with Chain and Hook)(each)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00079', 'Tire Carrier Only (A Frame Top Mount)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00080', 'Winch Track', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00081', 'Winches - Sliding  #5820 (hooks not included)(EACH)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00082', 'Winches - Sliding - 3 Bar #14011NP (hooks not included)(EACH)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00083', 'Winches (3 Bar Weld On) #148101-143 Undermount (hooks not included)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00084', 'Zinc Primer', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00085', 'Replace White Steel Rims With Black Steel Rims', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30FDNT', '30FDNT-00086', 'Double L Aluminum Winch Track', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);

--MODEL=25NTT
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00094', '2022-08-18', '2023-08-18', 0.0, NULL, '* 1 ft. Additional Main Deck (up to 4 extra Feet)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00095', '2022-08-18', '2023-08-18', 0.0, NULL, '* 108 in. Width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00096', '2022-08-18', '2023-08-18', 0.0, NULL, '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00097', '2022-08-18', '2023-08-18', 0.0, NULL, '* 38 in. x 76 in. Self Cleaning Air Operated Ramp', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00098', '2022-08-18', '2023-08-18', 0.0, NULL, '* 38 in. x 76 in. Wood Filled Air Operated Ramp', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00099', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 in. x 76 in. Air Operated Planked', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00100', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 in. x 96 in. Air Operated Planked', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00101', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 in. x 96 in. Bi Fold Air Operated Planked (Spring Susp)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00102', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 x 96 Bifold Ramps Planked c/w 1 Lift Axle, 2 Spring Susp., 1 Air Susp.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00103', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 x 96 Bifold Ramps Planked c/w 1 Lift Axle, All Air Susp.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00104', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 x 96 Bifold Ramps Planked c/w 3 Air Susp., No Lift Axle', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00105', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Lift c/w  Control Box, 2 Spring Susp., 1 Air Susp.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00106', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Lift c/w  Control Box, all Air Susp., Dump Valve and Air Gauge', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00107', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Ride Suspension (includes air gauge and dump valve)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00108', '2022-08-18', '2023-08-18', 0.0, NULL, '* Axle Spacing 61 in.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00109', '2022-08-18', '2023-08-18', 0.0, NULL, '* Self Cleaning Beavertail', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00110', '2022-08-18', '2023-08-18', 0.0, NULL, '1 3/8 in. x 7 in. Keruing Shiplapped', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00111', '2022-08-18', '2023-08-18', 0.0, NULL, '1 ft. Bolt On A-Frame Extension', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00112', '2022-08-18', '2023-08-18', 0.0, NULL, '20 in. x 48 in. Spring assist, self cleaning, adjustable total width 99 in. max./ 68 in. min.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00113', '2022-08-18', '2023-08-18', 0.0, NULL, '20 in. x 50 in. Lay Level Spring Assist, Self Cleaning, adjustable total width 99 in. max. / 68 in.min', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00114', '2022-08-18', '2023-08-18', 0.0, NULL, '6 ft. Beavertail ', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00115', '2022-08-18', '2023-08-18', 0.0, NULL, 'Add 3/8 in. flatbar full length under deck approx 6 in. from siderail, passenger side', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00116', '2022-08-18', '2023-08-18', 0.0, NULL, 'Additional Mudflaps with Brackets (pair)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00117', '2022-08-18', '2023-08-18', 0.0, NULL, 'Air Ride Suspension (includes air gauge and dump valve)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00118', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 17.5  (12 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00119', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 17.5  (6 steel, 6 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00120', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 22.5  (6 Machined, 6 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00121', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 22.5  (6 steel, 6 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00122', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 22.5 (12 Polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00123', '2022-08-18', '2023-08-18', 0.0, NULL, 'Amber Flashing Strobe Lights(Mounted in Ramps)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00124', '2022-08-18', '2023-08-18', 0.0, NULL, 'BWS Red - PPG#370-75034', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00125', '2022-08-18', '2023-08-18', 0.0, NULL, 'BWS Yellow - PPG#920612', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00126', '2022-08-18', '2023-08-18', 0.0, NULL, 'Dual Holland Mark V 2 Speed Landing Gear', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00127', '2022-08-18', '2023-08-18', 0.0, NULL, 'Extra, Side Mount D-Rings (pair)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00128', '2022-08-18', '2023-08-18', 0.0, NULL, 'Flag Holders (set of 4)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00129', '2022-08-18', '2023-08-18', 0.0, NULL, 'Four Pin Plug w/Strobe Light Pocket at Rear', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00130', '2022-08-18', '2023-08-18', 0.0, NULL, 'Galvanizing Unit', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00131', '2022-08-18', '2023-08-18', 0.0, NULL, 'J-Hooks', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00132', '2022-08-18', '2023-08-18', 0.0, NULL, 'Remove mud flaps, set up for flaps only – customer will install their own.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00133', '2022-08-18', '2023-08-18', 0.0, NULL, 'Rub Rail and Stake Pockets - 48 in. OC (Outside nominal width)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00134', '2022-08-18', '2023-08-18', 0.0, NULL, 'Rub Rail and Stake Pockets - 24 in. OC (Outside nominal width)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00135', '2022-08-18', '2023-08-18', 0.0, NULL, 'Straps (3 in. x 30 ft. with Chain and Hook)(each)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00136', '2022-08-18', '2023-08-18', 0.0, NULL, 'Swingout Outriggers (6 per side)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00137', '2022-08-18', '2023-08-18', 0.0, NULL, 'Tire Carrier Only (A Frame Top Mount)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00138', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winch Track', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00139', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches - Sliding  #5820 (hooks not included)(EACH)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00140', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches - Sliding - 3 Bar #14011NP (hooks not included)(EACH)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00141', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches (3 Bar Weld On) #148101-143 Undermount (hooks not included)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00142', '2022-08-18', '2023-08-18', 0.0, NULL, 'Zinc Primer', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00143', '2022-08-18', '2023-08-18', 0.0, NULL, 'Replace White Steel Rims With Black Steel Rims', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('25NTT', '25NTT-00144', '2022-08-18', '2023-08-18', 0.0, NULL, 'Double L Aluminum Winch Track', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00099', '* 1 ft. Additional Main Deck (up to 4 extra Feet)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00100', '* 108 in. Width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00101', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00102', '* 38 in. x 76 in. Self Cleaning Air Operated Ramp', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00103', '* 38 in. x 76 in. Wood Filled Air Operated Ramp', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00104', '* 45 in. x 76 in. Air Operated Planked', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00105', '* 45 in. x 96 in. Air Operated Planked', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00106', '* 45 in. x 96 in. Bi Fold Air Operated Planked (Spring Susp)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00107', '* 45 x 96 Bifold Ramps Planked c/w 1 Lift Axle, 2 Spring Susp., 1 Air Susp.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00108', '* 45 x 96 Bifold Ramps Planked c/w 1 Lift Axle, All Air Susp.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00109', '* 45 x 96 Bifold Ramps Planked c/w 3 Air Susp., No Lift Axle', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00110', '* Air Lift c/w  Control Box, 2 Spring Susp., 1 Air Susp.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00111', '* Air Lift c/w  Control Box, all Air Susp., Dump Valve and Air Gauge', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00112', '* Air Ride Suspension (includes air gauge and dump valve)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00113', '* Axle Spacing 61 in.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00114', '* Self Cleaning Beavertail', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00115', '1 3/8 in. x 7 in. Keruing Shiplapped', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00116', '1 ft. Bolt On A-Frame Extension', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00117', '20 in. x 48 in. Spring assist, self cleaning, adjustable total width 99 in. max./ 68 in. min.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00118', '20 in. x 50 in. Lay Level Spring Assist, Self Cleaning, adjustable total width 99 in. max. / 68 in.min', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00119', '6 ft. Beavertail ', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00120', 'Add 3/8 in. flatbar full length under deck approx 6 in. from siderail, passenger side', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00121', 'Additional Mudflaps with Brackets (pair)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00122', 'Air Ride Suspension (includes air gauge and dump valve)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00123', 'Alum. Wheel Pkg. 17.5  (12 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00124', 'Alum. Wheel Pkg. 17.5  (6 steel, 6 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00125', 'Alum. Wheel Pkg. 22.5  (6 Machined, 6 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00126', 'Alum. Wheel Pkg. 22.5  (6 steel, 6 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00127', 'Alum. Wheel Pkg. 22.5 (12 Polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00128', 'Amber Flashing Strobe Lights(Mounted in Ramps)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00129', 'BWS Red - PPG#370-75034', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00130', 'BWS Yellow - PPG#920612', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00131', 'Dual Holland Mark V 2 Speed Landing Gear', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00132', 'Extra, Side Mount D-Rings (pair)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00133', 'Flag Holders (set of 4)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00134', 'Four Pin Plug w/Strobe Light Pocket at Rear', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00135', 'Galvanizing Unit', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00136', 'J-Hooks', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00137', 'Remove mud flaps, set up for flaps only – customer will install their own.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00138', 'Rub Rail and Stake Pockets - 48 in. OC (Outside nominal width)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00139', 'Rub Rail and Stake Pockets - 24 in. OC (Outside nominal width)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00140', 'Straps (3 in. x 30 ft. with Chain and Hook)(each)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00141', 'Swingout Outriggers (6 per side)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00142', 'Tire Carrier Only (A Frame Top Mount)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00143', 'Winch Track', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00144', 'Winches - Sliding  #5820 (hooks not included)(EACH)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00145', 'Winches - Sliding - 3 Bar #14011NP (hooks not included)(EACH)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00146', 'Winches (3 Bar Weld On) #148101-143 Undermount (hooks not included)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00147', 'Zinc Primer', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00148', 'Replace White Steel Rims With Black Steel Rims', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '25NTT', '25NTT-00149', 'Double L Aluminum Winch Track', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);

--MODEL=30NTT
	--TABLE=[Options]
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00084', '2022-08-18', '2023-08-18', 0.0, NULL, '* 1 ft. Additional Main Deck (up to 4 extra Feet)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00085', '2022-08-18', '2023-08-18', 0.0, NULL, '* 108 in. Width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00086', '2022-08-18', '2023-08-18', 0.0, NULL, '* 114 in. width excluding load securement devices (over width permits may be required)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00087', '2022-08-18', '2023-08-18', 0.0, NULL, '* 38 in. x 76 in. Self Cleaning Air Operated Ramp', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00088', '2022-08-18', '2023-08-18', 0.0, NULL, '* 38 in. x 76 in. Wood Filled Air Operated Ramp', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00089', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 in. x 76 in. Air Operated Planked', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00090', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 in. x 96 in. Air Operated Planked', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00091', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 in. x 96 in. Bi Fold Air Operated Planked (Spring Susp)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00092', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 x 96 Bifold Ramps Planked c/w 1 Lift Axle, 2 Spring Susp., 1 Air Susp.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00093', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 x 96 Bifold Ramps Planked c/w 1 Lift Axle, All Air Susp.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00094', '2022-08-18', '2023-08-18', 0.0, NULL, '* 45 x 96 Bifold Ramps Planked c/w 3 Air Susp., No Lift Axle', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00095', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Lift c/w  Control Box, 2 Spring Susp., 1 Air Susp.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00096', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Lift c/w  Control Box, all Air Susp., Dump Valve and Air Gauge', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00097', '2022-08-18', '2023-08-18', 0.0, NULL, '* Air Ride Suspension (includes air gauge and dump valve)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00098', '2022-08-18', '2023-08-18', 0.0, NULL, '* Axle Spacing 61 in.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00099', '2022-08-18', '2023-08-18', 0.0, NULL, '* Self Cleaning Beavertail', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00100', '2022-08-18', '2023-08-18', 0.0, NULL, '1 3/8 in. x 7 in. Keruing Shiplapped', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00101', '2022-08-18', '2023-08-18', 0.0, NULL, '1 ft. Bolt On A-Frame Extension', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00102', '2022-08-18', '2023-08-18', 0.0, NULL, '20 in. x 48 in. Spring assist, self cleaning, adjustable total width 99 in. max./ 68 in. min.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00103', '2022-08-18', '2023-08-18', 0.0, NULL, '20 in. x 50 in. Lay Level Spring Assist, Self Cleaning, adjustable total width 99 in. max. / 68 in.min', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00104', '2022-08-18', '2023-08-18', 0.0, NULL, '6 ft. Beavertail ', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00105', '2022-08-18', '2023-08-18', 0.0, NULL, 'Add 3/8 in. flatbar full length under deck approx 6 in. from siderail, passenger side', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00106', '2022-08-18', '2023-08-18', 0.0, NULL, 'Additional Mudflaps with Brackets (pair)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00107', '2022-08-18', '2023-08-18', 0.0, NULL, 'Air Ride Suspension (includes air gauge and dump valve)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00108', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 17.5  (12 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00109', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 17.5  (6 steel, 6 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00110', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 22.5  (6 Machined, 6 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00111', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 22.5  (6 steel, 6 polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00112', '2022-08-18', '2023-08-18', 0.0, NULL, 'Alum. Wheel Pkg. 22.5 (12 Polished)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00113', '2022-08-18', '2023-08-18', 0.0, NULL, 'Amber Flashing Strobe Lights(Mounted in Ramps)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00114', '2022-08-18', '2023-08-18', 0.0, NULL, 'BWS Red - PPG#370-75034', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00115', '2022-08-18', '2023-08-18', 0.0, NULL, 'BWS Yellow - PPG#920612', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00116', '2022-08-18', '2023-08-18', 0.0, NULL, 'Dual Holland Mark V 2 Speed Landing Gear', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00117', '2022-08-18', '2023-08-18', 0.0, NULL, 'Extra, Side Mount D-Rings (pair)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00118', '2022-08-18', '2023-08-18', 0.0, NULL, 'Flag Holders (set of 4)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00119', '2022-08-18', '2023-08-18', 0.0, NULL, 'Four Pin Plug w/Strobe Light Pocket at Rear', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00120', '2022-08-18', '2023-08-18', 0.0, NULL, 'Galvanizing Unit', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00121', '2022-08-18', '2023-08-18', 0.0, NULL, 'J-Hooks', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00122', '2022-08-18', '2023-08-18', 0.0, NULL, 'Remove mud flaps, set up for flaps only – customer will install their own.', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00123', '2022-08-18', '2023-08-18', 0.0, NULL, 'Rub Rail and Stake Pockets - 48 in. OC (Outside nominal width)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00124', '2022-08-18', '2023-08-18', 0.0, NULL, 'Rub Rail and Stake Pockets - 24 in. OC (Outside nominal width)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00125', '2022-08-18', '2023-08-18', 0.0, NULL, 'Straps (3 in. x 30 ft. with Chain and Hook)(each)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00126', '2022-08-18', '2023-08-18', 0.0, NULL, 'Swingout Outriggers (6 per side)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00127', '2022-08-18', '2023-08-18', 0.0, NULL, 'Tire Carrier Only (A Frame Top Mount)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00128', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winch Track', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00129', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches - Sliding  #5820 (hooks not included)(EACH)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00130', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches - Sliding - 3 Bar #14011NP (hooks not included)(EACH)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00131', '2022-08-18', '2023-08-18', 0.0, NULL, 'Winches (3 Bar Weld On) #148101-143 Undermount (hooks not included)', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00132', '2022-08-18', '2023-08-18', 0.0, NULL, 'Zinc Primer', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00133', '2022-08-18', '2023-08-18', 0.0, NULL, 'Replace White Steel Rims With Black Steel Rims', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
			INSERT INTO [Options] ([Model No], [Option No], [Start Date], [End Date], [Price],
                [Sections], [Description], [Weight], [Width], [Deck Length], [Spread], [SortSe], [Draw/Part#],
                [Std Hours], [Obsolete], [Selection], [New Option Wording], [OptionInfo], [OptionPromptFlag],
                [OptionPrompt], [OptionConfigInfo], [US Price]) VALUES ('30NTT', '30NTT-00134', '2022-08-18', '2023-08-18', 0.0, NULL, 'Double L Aluminum Winch Track', 0, NULL, 0, NULL, 1, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, NULL, 0.0);
	--TABLE=[Budget Options]
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00094', '* 1 ft. Additional Main Deck (up to 4 extra Feet)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00095', '* 108 in. Width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00096', '* 114 in. width excluding load securement devices (over width permits may be required)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00097', '* 38 in. x 76 in. Self Cleaning Air Operated Ramp', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00098', '* 38 in. x 76 in. Wood Filled Air Operated Ramp', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00099', '* 45 in. x 76 in. Air Operated Planked', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00100', '* 45 in. x 96 in. Air Operated Planked', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00101', '* 45 in. x 96 in. Bi Fold Air Operated Planked (Spring Susp)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00102', '* 45 x 96 Bifold Ramps Planked c/w 1 Lift Axle, 2 Spring Susp., 1 Air Susp.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00103', '* 45 x 96 Bifold Ramps Planked c/w 1 Lift Axle, All Air Susp.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00104', '* 45 x 96 Bifold Ramps Planked c/w 3 Air Susp., No Lift Axle', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00105', '* Air Lift c/w  Control Box, 2 Spring Susp., 1 Air Susp.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00106', '* Air Lift c/w  Control Box, all Air Susp., Dump Valve and Air Gauge', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00107', '* Air Ride Suspension (includes air gauge and dump valve)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00108', '* Axle Spacing 61 in.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00109', '* Self Cleaning Beavertail', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00110', '1 3/8 in. x 7 in. Keruing Shiplapped', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00111', '1 ft. Bolt On A-Frame Extension', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00112', '20 in. x 48 in. Spring assist, self cleaning, adjustable total width 99 in. max./ 68 in. min.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00113', '20 in. x 50 in. Lay Level Spring Assist, Self Cleaning, adjustable total width 99 in. max. / 68 in.min', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00114', '6 ft. Beavertail ', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00115', 'Add 3/8 in. flatbar full length under deck approx 6 in. from siderail, passenger side', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00116', 'Additional Mudflaps with Brackets (pair)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00117', 'Air Ride Suspension (includes air gauge and dump valve)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00118', 'Alum. Wheel Pkg. 17.5  (12 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00119', 'Alum. Wheel Pkg. 17.5  (6 steel, 6 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00120', 'Alum. Wheel Pkg. 22.5  (6 Machined, 6 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00121', 'Alum. Wheel Pkg. 22.5  (6 steel, 6 polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00122', 'Alum. Wheel Pkg. 22.5 (12 Polished)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00123', 'Amber Flashing Strobe Lights(Mounted in Ramps)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00124', 'BWS Red - PPG#370-75034', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00125', 'BWS Yellow - PPG#920612', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00126', 'Dual Holland Mark V 2 Speed Landing Gear', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00127', 'Extra, Side Mount D-Rings (pair)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00128', 'Flag Holders (set of 4)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00129', 'Four Pin Plug w/Strobe Light Pocket at Rear', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00130', 'Galvanizing Unit', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00131', 'J-Hooks', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00132', 'Remove mud flaps, set up for flaps only – customer will install their own.', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00133', 'Rub Rail and Stake Pockets - 48 in. OC (Outside nominal width)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00134', 'Rub Rail and Stake Pockets - 24 in. OC (Outside nominal width)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00135', 'Straps (3 in. x 30 ft. with Chain and Hook)(each)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00136', 'Swingout Outriggers (6 per side)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00137', 'Tire Carrier Only (A Frame Top Mount)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00138', 'Winch Track', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00139', 'Winches - Sliding  #5820 (hooks not included)(EACH)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00140', 'Winches - Sliding - 3 Bar #14011NP (hooks not included)(EACH)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00141', 'Winches (3 Bar Weld On) #148101-143 Undermount (hooks not included)', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00142', 'Zinc Primer', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00143', 'Replace White Steel Rims With Black Steel Rims', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);
			INSERT INTO [Budget Options] ([Bud_Date_Opt], [Model No], [Option No], [Description],
                [Cost], [Labour Cost], [Made In Material], [Bought Out Material], [Machine Shop], [Steel Kit], [Axles],
                [Stakes/Bunks], [Beam], [GNK], [Parts], [Line], [Step 1], [Step 2], [Blast], [Paint], [Finish],
                [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Sections],[SortSe],[Obsolete])
                VALUES ('2022-08-18', '30NTT', '30NTT-00144', 'Double L Aluminum Winch Track', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NULL, 0, 0);

ROLLBACK;
COMMIT;
------------------------------------------------------------------------------------------------------------------------
