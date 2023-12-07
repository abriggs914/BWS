USE BWSdb
GO

-- 2023-12-05
-- Correcting Pace Dealer Sales Person for Shelley


SELECT
	*
FROM
	[DealersV2] 
WHERE
	[COMPANY NAME] LIKE '%Pace%'
	AND [CURRENT DEALER] = 1

SELECT
	*
FROM
	[DealersV2_SalesPeople] AS [SP]
WHERE
	[SP].[DealerID] = 853313

SELECT
	*
FROM
	[DealersV2_SalesPersonBranch] AS [SP]
WHERE
	[SP].[DealerID] = 853313

BEGIN TRAN;
SELECT
	*
FROM
	[DealersV2_SalesPersonBranch] AS [SP]
WHERE
	[SP].[DealerID] = 853313

UPDATE
	[DealersV2_SalesPersonBranch]
SET
	[DealerID] = 853313
WHERE
	[DealersV2_SPBID] = 67
SELECT
	*
FROM
	[DealersV2_SalesPersonBranch] AS [SP]
WHERE
	[SP].[DealerID] = 853313

ROLLBACK;
COMMIT;