
DECLARE @sg_mn NVARCHAR(MAX) = 'Walking Floor 4X';
SELECT @sg_mn = 'AWF4X'

-- [ProductsV2]
SELECT
	*
FROM
	[BWSdb].[dbo].[ProductsV2]
WHERE
	[Model No] = @sg_mn
;
SELECT
	*
FROM
	[BWSdb].[dbo].[Products]
WHERE
	[Model No] = @sg_mn
;
/*
BEGIN TRAN;
DELETE FROM [BWSdb].[dbo].[Products] WHERE [IDTrailer] = 2305
ROLLBACK;
COMMIT;
*/

BEGIN TRAN;
UPDATE
	[BWSdb].[dbo].[ProductsV2]
SET
	[Proposed] = 0
	,[Class] = 'Walking Floor'
	,[Model] = 'Walking Floor 4X'
	,[Grouping] = 'Walking Floor'
WHERE [IDTrailer] = 793
ROLLBACK;
COMMIT;


-- [Products]
SELECT
	[P].[IDTrailer],
	[P].[Class],
	[P].[Proposed],
	[P].[Non-Current],
	[P].[Model],
	[P].[Model No],
	[P].[Top Level Part# (SYSPRO)],
	[P].[Grouping],
	[P].[Start Date],
	[P].[End Date],
	[P].[Price],
	[P].[Weight],
	[P].[Make],
	[P].[NVIS],
	[P].[Promo Drawing],
	[P].[Width],
	[P].[Spread],
	[P].[Deck Length],
	[P].[Days],
	[P].[GN],
	[P].[Paint],
	[P].[Finish],
	[P].[S/NL1],
	[P].[S/NL2],
	[P].[S/NT1],
	[P].[S/NT2],
	[P].[S/NAxles],
	[P].[Selection],
	[P].[EffComDate],
	[P].[CompanyID],
	[P].[LastCostUpdate],
	[P].[LCUInitials],
	[P].[QR_Discount1],
	[P].[QR_Discount2],
	[P].[QR_Discount3],
	[P].[QR_ExpectedMargin],
	[P].[tmpProductsClassesID],
	[P].[QRUS_Discount1],
	[P].[QR_Discount2],
	[P].[QRUS_Discount3],
	[P].[QRUS_ExpectedMargin],
	[P].[US Price],
	[P].[Customer],
	[P].[Top Level Part# (SYSPRO 8)],
	[P].[Promo Drawing V2],
	[P].[CompanyID]
FROM
	[BWSdb].[dbo].[Products] [P]
WHERE
	[Model No] IN (@sg_mn, 'AED4X')
;
/*
	BEGIN TRAN;
	
DECLARE @sg_mn NVARCHAR(MAX) = 'Walking Floor 4X';
	INSERT INTO 
		[BWSdb].[dbo].[Products]
	(
		[Class],
		[Proposed],
		[Non-Current],
		[Model],
		[Model No],
		[Top Level Part# (SYSPRO)],
		[Grouping],
		[Start Date],
		[End Date],
		[Price],
		[Weight],
		[Make],
		[NVIS],
		[Promo Drawing],
		[Width],
		[Spread],
		[Deck Length],
		[Days],
		[GN],
		[Paint],
		[Finish],
		[S/NL1],
		[S/NL2],
		[S/NT1],
		[S/NT2],
		[S/NAxles],
		[Selection],
		[EffComDate],
		[LastCostUpdate],
		[LCUInitials],
		[QR_Discount1],
		[QR_Discount2],
		[QR_Discount3],
		[QR_ExpectedMargin],
		[QRUS_Discount1],
		[QRUS_Discount2],
		[QRUS_Discount3],
		[QRUS_ExpectedMargin],
		[US Price],
		[Customer],
		[Top Level Part# (SYSPRO 8)],
		[Promo Drawing V2],
		[CompanyID]
	)
	SELECT
		[Class],
		[P].[Proposed],
		[P].[Non-Current],
		[P].[Model],
		'AWF4X',  -- [Model No]
		[P].[Top Level Part# (SYSPRO)],
		[P].[Grouping],
		CONVERT(DATETIME, CONVERT(DATE, GETDATE())),  -- [P].[Start Date],
		DATEADD(YEAR, 1, CONVERT(DATETIME, CONVERT(DATE, GETDATE()))),  -- [P].[End Date],
		[P].[Price],
		[P].[Weight],
		[P].[Make],
		[P].[NVIS],
		[P].[Promo Drawing],
		[P].[Width],
		[P].[Spread],
		[P].[Deck Length],
		[P].[Days],
		[P].[GN],
		[P].[Paint],
		[P].[Finish],
		[P].[S/NL1],
		[P].[S/NL2],
		[P].[S/NT1],
		[P].[S/NT2],
		[P].[S/NAxles],
		[P].[Selection],
		[P].[EffComDate],
		[P].[LastCostUpdate],
		[P].[LCUInitials],
		[P].[QR_Discount1],
		[P].[QR_Discount2],
		[P].[QR_Discount3],
		[P].[QR_ExpectedMargin],
		[P].[QRUS_Discount1],
		[P].[QRUS_Discount2],
		[P].[QRUS_Discount3],
		[P].[QRUS_ExpectedMargin],
		[P].[US Price],
		[P].[Customer],
		[P].[Top Level Part# (SYSPRO 8)],
		[P].[Promo Drawing V2],
		0
	FROM
		[BWSdb].[dbo].[ProductsV2] [P]
	WHERE
		[P].[Model No] = @sg_mn
	;

	ROLLBACK
	COMMIT;
	*/