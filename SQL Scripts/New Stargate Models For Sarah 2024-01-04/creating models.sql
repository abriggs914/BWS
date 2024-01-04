

BEGIN TRAN;

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

SELECT TOP 3
	*
FROM
	[ProductsV2]
ORDER BY
	[IDTrailer] DESC


DECLARE @i INT = 0;
DECLARE @j INT = 18;

WHILE @i < @j BEGIN

	INSERT INTO [ProductsV2] (
		[Class], [Grouping], [Model No],
		[Model], [CompanyID], [Proposed], [Non-Current],
		[Start Date], [End Date], [Make], [Price], [NVIS],
		[Width], [Weight], [Spread], [Paint], [S/NL1], [S/NL2],
		[S/NT1], [S/NT2], [S/NAxles]
	)
	SELECT 
		[Class],
		[Grouping],
		'TempModel_' + RIGHT('00' + CAST(@i AS NVARCHAR(2)), 2),
		'TempModel_' + RIGHT('00' + CAST(@i AS NVARCHAR(2)), 2),
		1, 1, 1, GETDATE(),  DATEADD(YEAR, 1, GETDATE()),
		'BWS',  -- Make
		0,
		'TempModel_' + RIGHT('00' + CAST(@i AS NVARCHAR(2)), 2),  -- NVIS
		19472, 102, 72, 2, 3, 7, 4, 3, 3
	FROM @newTable WHERE [ID] = @i;

	SELECT @i = @i + 1;

END

ROLLBACK;
COMMIT;