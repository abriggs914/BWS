USE BWSdb
GO

DECLARE @t AS TABLE (
	[ID] INT IDENTITY(0, 1),
	[Class] NVARCHAR(MAX),
	[ModelNo] NVARCHAR(MAX),
	[Description] NVARCHAR(MAX),
	[Other] NVARCHAR(MAX) DEFAULT NULL
);
INSERT INTO @t ([Class], [ModelNo], [Description], [Other])
VALUES
('End Dumps', 'FHRED2X', 'Tandem Frameless Half Round', NULL),
('End Dumps', 'FHRED3X', 'Tridem Frameless Half Round', NULL),
('End Dumps', 'ED2X', 'Tandem End Dump', NULL),
('End Dumps', 'ED3X', 'Tridem End Dump', NULL),
('End Dumps', 'ED4X', 'Quad End Dump', NULL),
('End Dumps', 'ED5X', '5 Axle End Dump', NULL),
('End Dumps', 'ED6X', '6 Axle End Dump', NULL),
('End Dumps', 'FED2X', 'Tandem frameless End Dump', NULL),

('B-Trains', 'BTL', 'Lead Train', 'Ontario/Canada Spec'),
('B-Trains', 'BTP', 'Pull Train', 'Ontario/Canada Spec'),
('B-Trains', 'STL', 'Lead Super Train', 'USA/Michigan'),
('B-Trains', 'STP', 'Pull Super Train', 'USA/Michigan'),
('B-Trains', 'TTL', 'Lead Triple Ten', 'USA/Michigan'),
('B-Trains', 'TTP', 'Pull Triple Ten', 'USA/Michigan'),

('Live Bottom', 'LB2X', 'Tandem Live Bottom', NULL),
('Live Bottom', 'LB3X', 'Tridem Live Bottom', NULL),
('Live Bottom', 'LB4X', 'Quad Live Bottom', NULL),

('Transfer Trailers', 'TP2X', 'Tandem Tipper', NULL),
('Transfer Trailers', 'TP3X', 'Tridem Tipper', NULL),
('Transfer Trailers', 'TP4X', 'Quad Tipper', NULL),
('Transfer Trailers', 'TP5X', '5 Axle Tipper', NULL),
('Transfer Trailers', 'WF2X', 'Tandem Walking Floor', NULL),
('Transfer Trailers', 'WF3X', 'Tridem Walking Floor', NULL),
('Transfer Trailers', 'WF4X', 'Quad Walking Floor', NULL),
('Transfer Trailers', 'PK2X', 'Tandem Packer', NULL),
('Transfer Trailers', 'PK3X', 'Tridem Packer', NULL),
('Transfer Trailers', 'PK4X', 'Quad Packer', NULL),

('Bodies', 'TB', 'Truck Body', NULL),
('Bodies', 'EDB', 'End Dump Body', NULL),

('Pony', 'PC3X', 'Tridem Pony Chassis', NULL),
('Pony', 'PED3X', 'Tridem Pony End Dump', NULL)
;

SELECT * FROM [ProductsV2]
SELECT * FROM [ProductsV2_Classes]

SELECT * FROM [StandardsV2]

SELECT *
FROM (
	SELECT 
		(CASE WHEN [ProductsV2].[Model No] = [@t].[ModelNo] THEN 1 ELSE 0 END) AS [A], 
		(CASE WHEN [ProductsV2].[Model] = [@t].[Description] THEN 1 ELSE 0 END) AS [B], 
		(CASE WHEN [ProductsV2].[Class] = [@t].[Class] THEN 1 ELSE 0 END) AS [C], 
		[ProductsV2].*
	FROM [ProductsV2] INNER JOIN @t ON 
		[ProductsV2].[Model No] = [@t].[ModelNo]
		OR [ProductsV2].[Model] = [@t].[Description]
		OR [ProductsV2].[Class] = [@t].[Class]
) AS [Sub]
WHERE 
	([A] + [B] + [C]) > 1

--SELECT * FROM [ProductsV2_Classes] INNER JOIN @t ON [ProductsV2_Classes].[] = [@t].[ModelNo]

SELECT * FROM [StandardsV2] INNER JOIN @t ON [StandardsV2].[Model No] = [@t].[ModelNo]