USE BWSdb
GO

SELECT
	*
FROM
	[ProductsV2]

SELECT
	*
FROM
	[ProductsV2_Classes]
	
SELECT TOP 10000
	*
FROM
	[ProductsV2]
ORDER BY
	[IDTrailer] DESC





SELECT COUNT(*) AS [# Products] FROM [ProductsV2];
SELECT COUNT(*) AS [# Non-Null Model No Products] FROM [ProductsV2] WHERE [Model No] IS NOT NULL;
SELECT COUNT(*) AS [# Null Model No Products] FROM [ProductsV2] WHERE [Model No] IS NULL;
SELECT TOP 21
	*
FROM
	[ProductsV2]
ORDER BY
	[IDTrailer] DESC








DECLARE @newTable TABLE ([ID] INT IDENTITY(0, 1), [Grouping] NVARCHAR(MAX), [Class] NVARCHAR(MAX))

INSERT INTO @newTable ([Grouping], [Class]) VALUES
('Belt Trailers', 'Aluminum Panel Belt Trailers'),
('Boxes', 'Aluminum Boxes'),
('End Dumps', 'Aluminum End Dumps'),
('End Dumps', 'Aluminum Half Round End Dumps'),
('End Dumps', 'Aluminum Frameless End Dumps'),
('End Dumps', 'Combo End Dumps'),
('End Dumps', 'Steel End Dumps'),
('Ponies', 'Combo Ponies'),
('Trains', 'Aluminum Leads'),
('Trains', 'Combo Leads'),
('Trains', 'Steel Leads'),
('Trains', 'Aluminum Pulls'),
('Trains', 'Combo Pulls'),
('Trains', 'Steel Pulls'),
('Trains', 'Aluminum Dolly Pulls'),
('Trains', 'Combo Dolly Pulls'),
('Trains', 'Steel Dolly Pulls'),
('Dollies', 'Dollies')
;

SELECT * FROM @newTable