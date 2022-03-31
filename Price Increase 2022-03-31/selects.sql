USE BWSdb
GO

DECLARE @INC AS MONEY;
SET @INC = 1.06;

-- Update
-- Products
-- Options
-- Budget Options
-- Master Options

SELECT * FROM [Products];
SELECT * FROM [Options];
SELECT * FROM [Budget Options];
SELECT * FROM [Master Options];


DECLARE @ID_STG AS INT;
SET @ID_STG = 1;

SELECT * FROM [ProductsV2] WHERE [CompanyID] = @ID_STG;
SELECT * FROM [OptionsV2] WHERE [CompanyID] = @ID_STG
SELECT * FROM [Budget Options V2] WHERE [CompanyID] = @ID_STG;
