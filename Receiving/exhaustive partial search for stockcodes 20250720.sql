DECLARE @minWordLen INT = 2;
DECLARE @stSup NVARCHAR(255) = NULL; --LOWER('toews');
DECLARE @stInv NVARCHAR(255) = LOWER('genius professional tools 924892628 466010 l/0057 staging 41mm x 65mmL Hex screwdriver bit 41mm hex shank');
DECLARE @sts AS TABLE ([ID] INT IDENTITY(0, 1), [InvSup] NVARCHAR(3), [IdxWord] INT, [Word] NVARCHAR(MAX));
DECLARE @ots AS TABLE ([ID] INT IDENTITY(0, 1), [InvSup] NVARCHAR(3), [IdxWord] INT, [Word] NVARCHAR(MAX));

DECLARE @omit AS NVARCHAR(MAX) = LOWER('BOLT NUT')

SELECT @stSup = [BWSdb].[dbo].[fn_RemoveSpecials](@stSup, DEFAULT, DEFAULT, DEFAULT)
SELECT @stInv = [BWSdb].[dbo].[fn_RemoveSpecials](@stInv, DEFAULT, DEFAULT, DEFAULT)
SELECT @omit = [BWSdb].[dbo].[fn_RemoveSpecials](@omit, DEFAULT, DEFAULT, DEFAULT)

INSERT INTO
	@sts 
SELECT
	'SUP',
	[SP].* 
FROM
	[BWSdb].[dbo].[split_string_idx](@stSup, ' ') [SP]
WHERE
	LEN(LTRIM(RTRIM([SP].[splited_data]))) >= @minWordLen
;

INSERT INTO 
	@sts
SELECT
	'INV',
	[SP].* 
FROM
	[BWSdb].[dbo].[split_string_idx](@stInv, ' ') [SP]
WHERE
	LEN(LTRIM(RTRIM([SP].[splited_data]))) >= @minWordLen
;

INSERT INTO
	@ots 
SELECT
	'inv',
	[SP].* 
FROM
	[BWSdb].[dbo].[split_string_idx](@omit, ' ') [SP]
WHERE
	LEN(LTRIM(RTRIM([SP].[splited_data]))) >= @minWordLen
;

SELECT
	*
FROM
	@sts
;

SELECT
	*
FROM
	@ots
;

SELECT
	[ST].[Word],
	[IM].[Supplier],
	*
FROM
	[SysproCompanyA].[dbo].[InvMaster] [IM]
INNER JOIN
	[SysproCompanyA].[dbo].[ApSupplier] [AS]
ON
	[IM].[Supplier] = [AS].[Supplier]
INNER JOIN
	@sts [ST]
ON
	(LOWER([IM].[Description]) + ' ' + LOWER([IM].[LongDesc])) LIKE '%' + [ST].[Word] + '%'
LEFT JOIN
	@ots [OT]
ON
	(LOWER([IM].[Description]) + ' ' + LOWER([IM].[LongDesc])) NOT LIKE '%' + [ST].[Word] + '%'
WHERE
	[OT].[ID] IS NULL
	AND (
		(CASE WHEN @stSup IS NULL THEN 1 ELSE (
			CASE WHEN LOWER([AS].[SupplierName]) + ' ' + LOWER([AS].[SupShortName]) LIKE '%' + @stSup + '%' THEN 1 ELSE 0 END
			) END
		) > 0
	)
	/*((LOWER([AS].[SupplierName]) LIKE '%' + @stSup + '%')
	OR (LOWER([AS].[SupShortName]) LIKE '%' + @stSup + '%'))*/
	--AND
	/*
	(LOWER(ISNULL([AS].[SupplierName], '') + ' ' + ISNULL([AS].[SupShortName], '')) LIKE '%' + @stInv + '%')
	AND (LOWER(ISNULL([IM].[Description], '') + ' ' + ISNULL([IM].[LongDesc], '')) LIKE '%' + @stInv + '%')
	*/
;

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[ApSupplier] [AS]
WHERE
	(LOWER([AS].[SupplierName]) LIKE '%' + @stSup + '%')
	OR (LOWER([AS].[SupShortName]) LIKE '%' + @stSup + '%')
;