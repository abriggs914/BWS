USE BWSdb
GO

DECLARE @INC AS MONEY;
SET @INC = 1.06;
DECLARE @ID_STG AS INT;
SET @ID_STG = 1;

-- Update
-- ProductsV2
-- OptionsV2
-- Budget Options V2

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

SELECT * FROM [OptionsV2] WHERE [CompanyID] = @ID_STG
UPDATE
	[OptionsV2]
SET
	[Price] = [Price] * @INC,
	[US Price] = [US Price] * @INC
WHERE
	[CompanyID] = @ID_STG
;
SELECT * FROM [OptionsV2] WHERE [CompanyID] = @ID_STG;

SELECT * FROM [Budget Options V2] WHERE [CompanyID] = @ID_STG;
UPDATE
	[Budget Options V2]
SET
	[Cost] = [Cost] * @INC
WHERE
	[CompanyID] = @ID_STG
;
SELECT * FROM [Budget Options V2] WHERE [CompanyID] = @ID_STG;


-- Not sure if I should be separating on the ID or not.
-- For this increase I ran both versions:

--SELECT * FROM [ProductsV2] WHERE [CompanyID] <> @ID_STG;
--UPDATE
--	[ProductsV2]
--SET
--	[Price] = [Price] * @INC,
--	[US Price] = [US Price] * @INC
--WHERE
--	[CompanyID] <> @ID_STG
--;
--SELECT * FROM [ProductsV2] WHERE [CompanyID] <> @ID_STG;

--SELECT * FROM [OptionsV2] WHERE [CompanyID] <> @ID_STG
--UPDATE
--	[OptionsV2]
--SET
--	[Price] = [Price] * @INC,
--	[US Price] = [US Price] * @INC
--WHERE
--	[CompanyID] <> @ID_STG
--;
--SELECT * FROM [OptionsV2] WHERE [CompanyID] <> @ID_STG;

--SELECT * FROM [Budget Options V2] WHERE [CompanyID] <> @ID_STG;
--UPDATE
--	[Budget Options V2]
--SET
--	[Cost] = [Cost] * @INC
--WHERE
--	[CompanyID] <> @ID_STG
--;
--SELECT * FROM [Budget Options V2] WHERE [CompanyID] <> @ID_STG;

ROLLBACK;
COMMIT;