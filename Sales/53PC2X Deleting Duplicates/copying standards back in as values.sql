USE BWSdb
GO

DECLARE @mn AS NVARCHAR(MAX) = '53PC2X';

SELECT
	'Standards' AS [T],
	*
FROM
	[Standards]
WHERE 
	[Model No] = @mn
ORDER BY
	[SortGV2]
	,[SortSeV2]
;

SELECT
	'Order Standards' AS [T],
	*
FROM
	[Order Standards]
WHERE 
	[Model No] = @mn
ORDER BY
	[SortGV2]
	,[SortSeV2]
;

BEGIN TRAN;

SELECT
	'Standards' AS [T],
	*
FROM
	[Standards]
WHERE 
	[Model No] = @mn
ORDER BY
	[SortGV2]
	,[SortSeV2]
;

DELETE FROM
	[Standards]
WHERE 
	[Model No] = @mn
;
INSERT INTO [Standards] ([Model No]
           ,[Standard No]
           ,[Group]
           ,[Section]
           ,[Description]
           ,[Start Date]
           ,[End Date]
           ,[SortG]
           ,[SortSe]
           ,[Selection]
           ,[SortGv2]
           ,[SortSev2]
           ,[New Spec Wording])
VALUES 
('53PC2X', '53PC2X-001', 'TRAILER', 'Overall Length', '53 ft.', '2023-10-30', '2024-10-29', 1, 1, NULL, 1, 10, NULL),
('53PC2X', '53PC2X-002', 'TRAILER', 'Overall Width', '102 in.', '2023-10-30', '2024-10-29', 1, 2, NULL, 1, 20, NULL),
('53PC2X', '53PC2X-003', 'TRAILER', 'Weight lbs +/- 2%', '15,000', '2023-10-30', '2024-10-29', 1, 3, NULL, 1, 30, NULL),
('53PC2X', '53PC2X-040', 'GOOSENECK', 'Gooseenck', '10 in.', '2023-10-30', '2024-10-29', NULL, NULL, NULL, 7, 9, NULL),
('53PC2X', '53PC2X-006', 'GOOSENECK', 'Coupler', 'Weld in King Pin', '2023-10-30', '2024-10-29', 2, 1, NULL, 7, 10, NULL),
('53PC2X', '53PC2X-007', 'GOOSENECK', 'Coupler Plate', '5/16 in. Hi-Tensile, 48 in. Height', '2023-10-30', '2024-10-29', 2, 2, NULL, 7, 20, NULL),
('53PC2X', '53PC2X-008', 'GOOSENECK', 'Coupler Location', '24 in.', '2023-10-30', '2024-10-29', 2, 3, NULL, 7, 30, NULL),
('53PC2X', '53PC2X-005', 'GOOSENECK', 'Cross Members', 'Hi-Tensile 3 in. I-beam @ 16 in. O/C', '2023-10-30', '2024-10-29', 2, 5, NULL, 7, 50, NULL),
('53PC2X', '53PC2X-009', 'GOOSENECK', 'Web', '1/4 in. Hi-Tensile', '2023-10-30', '2024-10-29', 2, 6, NULL, 7, 60, NULL),
('53PC2X', '53PC2X-010', 'GOOSENECK', 'Floor', 'Apitong', '2023-10-30', '2024-10-29', 2, 7, NULL, 7, 70, NULL),
('53PC2X', '53PC2X-044', 'GOOSENECK', 'Load Securement', '2 winches, 16 in ahead from front and 18 in. from reat pg GNK, Driver Side', '2023-10-30', '2024-10-29', NULL, NULL, NULL, 7, 80, NULL),
('53PC2X', '53PC2X-012', 'DECK', 'Loaded Deck Height', '58 in . Nominal', '2023-10-30', '2024-10-29', 5, 2, NULL, 19, 20, NULL),
('53PC2X', '53PC2X-013', 'DECK', 'Main Frame', 'Top and Bottom Flanges 100 KSI x 24 in. Beam (approx)', '2023-10-30', '2024-10-29', 5, 3, NULL, 19, 30, NULL),
('53PC2X', '53PC2X-014', 'DECK', 'Cross Members', 'Hi-Tensile', '2023-10-30', '2024-10-29', 5, 4, NULL, 19, 40, NULL),
('53PC2X', '53PC2X-017', 'DECK', 'Web', 'Hi-Tensile', '2023-10-30', '2024-10-29', 5, 7, NULL, 19, 70, NULL),
('53PC2X', '53PC2X-018', 'DECK', 'Floor', 'Softwood center on main deck only for a walkway, Apitong on Rear Deck', '2023-10-30', '2024-10-29', 5, 8, NULL, 19, 80, NULL),
('53PC2X', '53PC2X-019', 'DECK', 'Landing Gear', 'Dual 2 Speed', '2023-10-30', '2024-10-29', 5, 9, NULL, 19, 90, NULL), 
('53PC2X', '53PC2X-039', 'DECK', 'Concrete Rack', '2 pc. Per side, adjustable 6 in . To 12 in. ground Clearance loaded.   Rack to be 12 ft high form gorund to top and 32 ft (Nominal) in length, c/w with front at rear ladder', '2023-10-30', '2024-10-29', NULL, NULL, NULL, 19, 100, NULL),
('53PC2X', '53PC2X-042', 'DECK', 'Rack Floor', '3/4  in x 6 in. 100 KSI Floor with 3/4 in. Hardwood', '2023-10-30', '2024-10-29', NULL, NULL, NULL, 19, 101, NULL),
('53PC2X', '53PC2X-041', 'DECK', 'Load Securement', 'Rubrail and Pockets on 24 in. center on GNK and Rear Deck', '2023-10-30', '2024-10-29', NULL, NULL, NULL, 19, 110, NULL),
('53PC2X', '53PC2X-043', 'DECK', 'Rack Load Securement', '4 sliding winches (per side) on the rack with flat underneath', '2023-10-30', '2024-10-29', NULL, NULL, NULL, 19, 111, NULL),
('53PC2X', '53PC2X-045', 'DECK', 'Load Securement', '3 winches evenly spaced on rear deck, Driver side.', '2023-10-30', '2024-10-29', NULL, NULL, NULL, 19, 112, NULL),
('53PC2X', '53PC2X-046', 'DECK', 'Load Securement', '13 of 3 in. x 30 ft. strap c/w chain and hook', '2023-10-30', '2024-10-29', NULL, NULL, NULL, 19, 113, NULL),
('53PC2X', '53PC2X-047', 'DECK', 'Load Securement', 'Winch track located on Driver Side and Passenger side', '2023-10-30', '2024-10-29', NULL, NULL, NULL, 19, 114, NULL), 
('53PC2X', '53PC2X-020', 'SUSPENSION/AXLES', 'Axles', '2 of 25,000 lbs Capacity', '2023-10-30', '2024-10-29', 7, 1, NULL, 40, 10, NULL),
('53PC2X', '53PC2X-021', 'SUSPENSION/AXLES', 'Spread', '60 in.', '2023-10-30', '2024-10-29', 7, 2, NULL, 40, 20, NULL),
('53PC2X', '53PC2X-022', 'SUSPENSION/AXLES', 'Suspension', 'Ridewell RAR 260, Air Ride 25,000 lbs, 15 in. Ride Height, adjustable  - includes air gauge and dump valve', '2023-10-30', '2024-10-29', 7, 3, NULL, 40, 30, NULL), 
('53PC2X', '53PC2X-023', 'SUSPENSION/AXLES', 'Brakes', '16 1/2 in. x 7 in.,  Includes Dust Shields', '2023-10-30', '2024-10-29', 7, 4, NULL, 40, 40, NULL), 
('53PC2X', '53PC2X-024', 'SUSPENSION/AXLES', 'Brake Chamber', '#3030,  All Axles', '2023-10-30', '2024-10-29', 7, 5, NULL, 40, 50, NULL),
('53PC2X', '53PC2X-025', 'SUSPENSION/AXLES', 'Air Brake System', '2S/1M', '2023-10-30', '2024-10-29', 7, 6, NULL, 40, 60, NULL), 
('53PC2X', '53PC2X-027', 'SUSPENSION/AXLES', 'Camshafts', '28 Spline Enclosed', '2023-10-30', '2024-10-29', 7, 7, NULL, 40, 70, NULL),
('53PC2X', '53PC2X-026', 'SUSPENSION/AXLES', 'Slack Adjusters', 'Automatic', '2023-10-30', '2024-10-29', 7, 8, NULL, 40, 80, NULL),
('53PC2X', '53PC2X-028', 'SUSPENSION/AXLES', 'Hubs & Drums', '10 Stud, Hub Piloted, Long Stud C / W  Cast Drums', '2023-10-30', '2024-10-29', 7, 9, NULL, 40, 90, NULL),
('53PC2X', '53PC2X-029', 'SUSPENSION/AXLES', 'Tires', '11R24.5', '2023-10-30', '2024-10-29', 7, 10, NULL, 40, 100, NULL),
('53PC2X', '53PC2X-030', 'SUSPENSION/AXLES', 'Wheels', '8.25 x 24.5 Steel Disc - Painted White', '2023-10-30', '2024-10-29', 7, 11, NULL, 40, 110, NULL), 
('53PC2X', '53PC2X-031', 'GENERAL SPECIFICATIONS', 'Electrical System', 'Modular, Vapor Proof GROTE Ultra Blue', '2023-10-30', '2024-10-29', 10, 2, NULL, 73, 20, NULL),
('53PC2X', '53PC2X-032', 'GENERAL SPECIFICATIONS', 'Front Connector', 'SAE J560 7 Pin', '2023-10-30', '2024-10-29', 10, 3, NULL, 73, 30, NULL),
('53PC2X', '53PC2X-033', 'GENERAL SPECIFICATIONS', 'Lights', 'LED CMVSS 108 / FMVSS 108', '2023-10-30', '2024-10-29', 10, 4, NULL, 73, 40, NULL),
('53PC2X', '53PC2X-036', 'GENERAL SPECIFICATIONS', 'Finishing', 'Preparation by Steel Shot Blast, Commercial / Industrial Topcoat, Oven Baked', '2023-10-30', '2024-10-29', 10, 6, NULL, 73, 50, NULL),
('53PC2X', '53PC2X-037', 'GENERAL SPECIFICATIONS', 'Color', 'Black', '2023-10-30', '2024-10-29', 10, 7, NULL, 73, 60, NULL),
('53PC2X', '53PC2X-038', 'GENERAL SPECIFICATIONS', 'Mudflaps', '2 set of BWS at rear', '2023-10-30', '2024-10-29', 10, 10, NULL, 73, 80, NULL)
;

--SELECT
--	@mn, [Standard No],
--	[Group], [Section], [Description], GETDATE(), DATEADD(YEAR, 1, GETDATE()), [SortG], [SortSe], NULL, [SortGv2], [SortSev2], NULL
--FROM
--	[Order Standards]
--WHERE 
--	[Model No] = @mn
--ORDER BY
--	[SortGV2]
--	,[SortSeV2]

SELECT
	'Standards' AS [T],
	*
FROM
	[Standards]
WHERE 
	[Model No] = @mn
ORDER BY
	[SortGV2]
	,[SortSeV2]

;

ROLLBACK;
COMMIT;