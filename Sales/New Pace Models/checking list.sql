
SELECT
		*
	FROM
		[ProductsV2]
	WHERE
		[Model No] LIKE '%BTL2X%'


BEGIN TRAN;

	DECLARE @t AS TABLE (
		[ID] INT IDENTITY(0, 1)
		, [OldName] NVARCHAR(MAX)
		, [NewName] NVARCHAR(MAX)
	)

	INSERT INTO @t ([OldName], [NewName]) VALUES
	('B-Train LEAD 3X - Pace', 'BTL3XSS PACE'),
	('B-Train Lead  - 4X - S.S. Pace', 'BTL4XASS PACE'),
	
	('B-Train Lead - 4XAF - Pace', 'BTL4XAS PACE'),
	('B-Train Pull - 2XAF - Pace', 'BTP2XAS PACE'),

	('B-Train Lead - 4X - Pace', 'BTL4XSS PACE'),
	('B-Train Pull - 2X - Pace', 'BTP2XSS PACE'),

	('B-Train Lead - 4X - S.S. Pace', 'BTL4XASS PACE'),
	('B-Train Pull - 2X - S.S. Pace', 'BTP2XASS PACE'),

	('B-Train Lead - 3X - Pace', 'BTL3XSS PACE'),
	('B-Train Pull - 3X - Pace', 'BTP3XSS PACE')
	
	SELECT
		*
	FROM
		[ProductsV2]
	WHERE
		[IDTrailer] = 622
	
	;

	UPDATE
		[ProductsV2]
	SET
		[Model] = 'BTL4XASS PACE'
		, [Model No] = 'BTL4XASS PACE'
	FROM
		[ProductsV2]
	WHERE
		[IDTrailer] = 622
	;

	SELECT
		*
	FROM
		[ProductsV2]
	WHERE
		[IDTrailer] = 622
	;

ROLLBACK;
COMMIT;