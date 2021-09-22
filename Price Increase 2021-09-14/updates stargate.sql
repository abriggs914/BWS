USE BWSdb
GO

DECLARE @INC AS MONEY;
SET @INC = 1.09;
DECLARE @ID_STG AS INT;
SET @ID_STG = 1;

BEGIN TRAN;

SELECT * FROM [ProductsV2] WHERE [CompanyID] = @ID_STG;
UPDATE
	[ProductsV2]
SET
	[Price] = [Price] * @INC,
	[US Price] = [US Price] * @INC
WHERE
	[CompanyID] = @ID_STG
;
SELECT * FROM [ProductsV2] WHERE [CompanyID] = @ID_STG;

SELECT * FROM [OptionsV2] WHERE	[CompanyID] = @ID_STG;
UPDATE
	[OptionsV2]
SET
	[Price] = [Price] * @INC,
	[US Price] = [US Price] * @INC
WHERE
	[CompanyID] = @ID_STG
;
SELECT * FROM [OptionsV2] WHERE [CompanyID] = @ID_STG;
ROLLBACK;
COMMIT;
