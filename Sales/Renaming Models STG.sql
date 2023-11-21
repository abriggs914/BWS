USE BWSdb
GO

-- Stargate

--DECLARE @mn AS NVARCHAR(MAX) = '50HF5XSPB'
--DECLARE @newMN AS NVARCHAR(MAX) = '50HF5X SPB'
DECLARE @mn AS NVARCHAR(MAX) = '48HF4XSPS'
DECLARE @newMN AS NVARCHAR(MAX) = '48HF4X SPS'

BEGIN TRAN;
	SELECT
		'Bef' AS [T],
		*
	FROM
		[StandardsV2]
	WHERE
		[Model No] = @mn
		AND [CompanyID] = 1
		
	;
	SELECT
		'Bef' AS [T],
		*
	FROM
		[ProductsV2]
	WHERE
		[Model No] = @mn
		AND [CompanyID] = 1
	;
	SELECT
		'Bef' AS [T],
		*
	FROM
		[OptionsV2]
	WHERE
		[Model No] = @mn
		AND [CompanyID] = 1
	;
	SELECT
		'Bef' AS [T],
		*
	FROM
		[Budget Options V2] 
	WHERE
		[Model No] = @mn
		AND [CompanyID] = 1
	;
	SELECT
		'Bef' AS [T],
		*
	FROM
		[SN Type V2]
	WHERE
		[Model No] = @mn
		AND [CompanyID] = 1
	-----------------------------------
	
	UPDATE
		[StandardsV2]
	SET
		[Model No] = @newMN
		,[Standard No] = REPLACE([Standard No], @mn, @newMN)
	WHERE
		[Model No] = @mn
		AND [CompanyID] = 1
	;

	UPDATE
		[ProductsV2]
	SET
		[Model No] = @newMN
	WHERE
		[Model No] = @mn
		AND [CompanyID] = 1
	;
	UPDATE
		[OptionsV2]
	SET
		[Model No] = @newMN
		,[Option No] = REPLACE([Option No], @mn, @newMN)
	WHERE
		[Model No] = @mn
		AND [CompanyID] = 1
	;
	UPDATE
		[Budget Options V2]
	SET
		[Model No] = @newMN
		,[Option No] = REPLACE([Option No], @mn, @newMN)
	WHERE
		[Model No] = @mn
		AND [CompanyID] = 1
	;
	UPDATE
		[SN Type V2]
	SET
		[Model No] = @newMN
	WHERE
		[Model No] = @mn
		AND [CompanyID] = 1

	-----------------------------------	
	SELECT
		'Aft' AS [T],
		*
	FROM
		[StandardsV2]
	WHERE
		[Model No] = @mn
		AND [CompanyID] = 1
	;
	SELECT
		'Aft' AS [T],
		*
	FROM
		[ProductsV2]
	WHERE
		[Model No] = @mn
		AND [CompanyID] = 1
	;
	SELECT
		'Aft' AS [T],
		*
	FROM
		[OptionsV2]
	WHERE
		[Model No] = @mn
		AND [CompanyID] = 1
	;
	SELECT
		'Aft' AS [T],
		*
	FROM
		[Budget Options V2]
	WHERE
		[Model No] = @mn
		AND [CompanyID] = 1
	;
	SELECT
		'Aft' AS [T],
		*
	FROM
		[SN Type V2]
	WHERE
		[Model No] = @mn
		AND [CompanyID] = 1
	--SELECT
	--	*
	--FROM
	--	[Order Options_FactoryLines] 
	--WHERE
	--	[Model No] = @mn
	--;
ROLLBACK;
COMMIT;