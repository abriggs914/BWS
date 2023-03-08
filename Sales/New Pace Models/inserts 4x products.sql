USE BWSdb
GO

-- [Products] group 1 (4X)

BEGIN TRAN;

DECLARE @modelCopyFrom AS NVARCHAR(MAX) = 'B-Train Lead  - 4X - S.S. Pace';
DECLARE @modelID AS INT;
SELECT @modelID = [IDTrailer] FROM [ProductsV2] WHERE [Model No] = @modelCopyFrom;

--SELECT @modelCopyFrom AS [MC]

DECLARE @class AS NVARCHAR(MAX);
SELECT @class = 'Pace'; 

SELECT @modelID AS [@modelID], @modelCopyFrom AS [@modelCopyFrom];

DECLARE @modelsToCopy AS TABLE 
(
	[ID] INT IDENTITY(0, 1),
	[Model] NVARCHAR(MAX),
	[Model No] NVARCHAR(MAX)
);

INSERT INTO @modelsToCopy ([Model], [Model No]) VALUES
('BTL4XAA PACE', 'BTL4XAA PACE')
;

DECLARE @i AS INT = 0;
DECLARE @c AS INT;

SELECT @c = COUNT(*) FROM @modelsToCopy;

SELECT
	'Before' AS [T],
	[ProductsV2].*
FROM
	@modelsToCopy AS [MTC]
CROSS JOIN
	[ProductsV2]
WHERE
	[ProductsV2].[Model No] = [MTC].[Model No]
	--OR [IDTrailer] = @modelID
UNION ALL
	SELECT
		'B' AS [T],
		*
	FROM
		[ProductsV2]
	WHERE
		[IDTrailer] = @modelID
;

WHILE @i < @c BEGIN

	INSERT INTO
		[ProductsV2]
	(
		[Class]
		,[Proposed]
		,[Non-Current]
		,[Model]
		,[Model No]
		,[Top Level Part# (SYSPRO)]           
		,[Grouping]
		,[Start Date]
		,[End Date]
		,[Price]
		,[Weight]
		,[Make]
		,[NVIS]
		,[Promo Drawing]
		,[Width]
		,[Spread]
		,[Deck Length]
		,[Days]
		,[GN]
		,[Paint]
		,[Finish]
		,[S/NL1]           
		,[S/NL2]
		,[S/NT1]
		,[S/NT2]
		,[S/NAxles]
		,[Selection]
		,[EffComDate]
		,[ComRate]
		,[LastCostUpdate]
		,[LCUInitials]
		,[QR_Discount1]
		,[QR_Discount2]
		,[QR_Discount3]
		,[QR_ExpectedMargin]
		,[tmpProductsV2ClassesID]
		,[QRUS_Discount1]
		,[QRUS_Discount2]
		,[QRUS_Discount3]
		,[QRUS_ExpectedMargin]
		,[US Price]
		,[Customer]
		,[Top Level Part# (SYSPRO 8)]
		,[Promo Drawing V2]
		,[CompanyID]
	)
	SELECT
		@class
		,0
		,0
		
		,[MTC].[Model]
		,[MTC].[Model No]

		,[Top Level Part# (SYSPRO)]
		,[Grouping]
		,[Start Date]
		,[End Date]
		,[Price]
		,[Weight]
		,[Make]
		,[NVIS]
		,[Promo Drawing]
		,[Width]
		,[Spread]
		,[Deck Length]
		,[Days]
		,[GN]
		,[Paint]
		,[Finish]
		,[S/NL1]
		,[S/NL2]
		,[S/NT1]
		,[S/NT2]
		,[S/NAxles]
		,[Selection]
		,[EffComDate]
		,[ComRate]
		,[LastCostUpdate]
		,[LCUInitials]
		,[QR_Discount1]
		,[QR_Discount2]
		,[QR_Discount3]
		,[QR_ExpectedMargin]
		,[tmpProductsV2ClassesID]
		,[QRUS_Discount1]
		,[QRUS_Discount2]
		,[QRUS_Discount3]
		,[QRUS_ExpectedMargin]
		,[US Price]
		,[Customer]
		,[Top Level Part# (SYSPRO 8)]
		,[Promo Drawing V2]
		,[CompanyID]
	FROM
		[ProductsV2]
	CROSS JOIN
		@modelsToCopy AS [MTC]
	WHERE
		[MTC].[ID] = @i
		AND [ProductsV2].[Model No] = @modelCopyFrom
		

	SELECT @i = @i + 1;
END

SELECT
	'After' AS [T],
	[ProductsV2].*
FROM
	@modelsToCopy AS [MTC]
CROSS JOIN
	[ProductsV2]
WHERE
	[ProductsV2].[Model No] = [MTC].[Model No]
	--OR [IDTrailer] = @modelID
UNION ALL
	SELECT
		'B' AS [T],
		*
	FROM
		[ProductsV2]
	WHERE
		[IDTrailer] = @modelID
;

ROLLBACK;
COMMIT;

--SELECT
--	@modelID = [IDTrailer]
--FROM
--	[ProductsV2]
--WHERE 
--	[Model No] = @modelCopyFrom

	
--SELECT
--	'ProductsV2' AS [Table],
--	*
--FROM
--	[ProductsV2]
--WHERE
--	[IDTrailer] = @modelID
--;
	
SELECT
	'StandardsV2' AS [Table],
	*
FROM
	[StandardsV2]
WHERE
	[Model No] = @modelCopyFrom
;

SELECT
	'OptionsV2' AS [Table],
	*
FROM
	[OptionsV2]
WHERE
	[Model No] = @modelCopyFrom
;
SELECT
	'Budget Options V2' AS [Table],
	*
FROM
	[Budget Options V2]
WHERE
	[Model No] = @modelCopyFrom
;
SELECT
	'Options V2_FactoryLines' AS [Table],
	*
FROM
	[Options V2_FactoryLines]
WHERE
	[Model No] = @modelCopyFrom
;
SELECT
	'Options V2_SpecLines' AS [Table],
	*
FROM
	[Options V2_SpecLines]
WHERE
	[Model No] = @modelCopyFrom

;