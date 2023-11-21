USE BWSdb
GO

--DECLARE @mn AS NVARCHAR(MAX) = '50HF5XSPB'
--DECLARE @newMN AS NVARCHAR(MAX) = '50HF5X SPB'
DECLARE @mn AS NVARCHAR(MAX) = '48HF4XSPB'
DECLARE @newMN AS NVARCHAR(MAX) = '48HF4X SPB'

BEGIN TRAN;
	SELECT
		'Bef' AS [T],
		*
	FROM
		[Standards]
	WHERE
		[Model No] = @mn
	;
	SELECT
		'Bef' AS [T],
		*
	FROM
		[Products]
	WHERE
		[Model No] = @mn
	;
	SELECT
		'Bef' AS [T],
		*
	FROM
		[Options]
	WHERE
		[Model No] = @mn
	;
	SELECT
		'Bef' AS [T],
		*
	FROM
		[Budget Options]
	WHERE
		[Model No] = @mn
	;
	SELECT
		'Bef' AS [T],
		*
	FROM
		[SN Type]
	WHERE
		[Model No] = @mn
	-----------------------------------
	
	UPDATE
		[Standards]
	SET
		[Model No] = @newMN
		,[Standard No] = REPLACE([Standard No], @mn, @newMN)
	WHERE
		[Model No] = @mn
	;

	UPDATE
		[Products]
	SET
		[Model No] = @newMN
	WHERE
		[Model No] = @mn
	;
	UPDATE
		[Options]
	SET
		[Model No] = @newMN
		,[Option No] = REPLACE([Option No], @mn, @newMN)
	WHERE
		[Model No] = @mn
	;
	UPDATE
		[Budget Options]
	SET
		[Model No] = @newMN
		,[Option No] = REPLACE([Option No], @mn, @newMN)
	WHERE
		[Model No] = @mn
	;
	UPDATE
		[SN Type]
	SET
		[Model No] = @newMN
	WHERE
		[Model No] = @mn

	-----------------------------------	
	SELECT
		'Aft' AS [T],
		*
	FROM
		[Standards]
	WHERE
		[Model No] = @mn
	;
	SELECT
		'Aft' AS [T],
		*
	FROM
		[Products]
	WHERE
		[Model No] = @mn
	;
	SELECT
		'Aft' AS [T],
		*
	FROM
		[Options]
	WHERE
		[Model No] = @mn
	;
	SELECT
		'Aft' AS [T],
		*
	FROM
		[Budget Options]
	WHERE
		[Model No] = @mn
	;
	SELECT
		'Aft' AS [T],
		*
	FROM
		[SN Type]
	WHERE
		[Model No] = @mn
	--SELECT
	--	*
	--FROM
	--	[Order Options_FactoryLines] 
	--WHERE
	--	[Model No] = @mn
	--;
ROLLBACK;
COMMIT;