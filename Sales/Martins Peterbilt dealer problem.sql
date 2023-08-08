SELECT 
	BWSdb_DealersV2_SalesPersonBranch.DealersV2_SPBID,
	BWSdb_DealersV2_SalesPersonBranch.Branch,
	BWSdb_DealersV2_SalesPersonBranch.Address,
	BWSdb_DealersV2_SalesPersonBranch.City,
	BWSdb_DealersV2_SalesPersonBranch.Province
FROM
	[DealersV2_SalesPersonBranch] AS BWSdb_DealersV2_SalesPersonBranch
WHERE (
		(
			(
				BWSdb_DealersV2_SalesPersonBranch.DealerID
			)=791092--[Forms]![QE Input - Stargate]![Combo148]
		)
	)
ORDER BY 
	BWSdb_DealersV2_SalesPersonBranch.DealersV2_SPBID,
	BWSdb_DealersV2_SalesPersonBranch.Province; 

SELECT
	*
FROM
	[DealersV2_SalesPersonBranch]
	

SELECT
	*
FROM
	[DealersV2]
WHERE
	[COMPANY NAME] LIKE '%peter%'
	AND [CURRENT DEALER] = 1
	--AND [CompanyID] = 1

SELECT
	*
FROM
	[Dealers]
WHERE
	[COMPANY NAME] LIKE '%peter%'
	AND [CURRENT DEALER] = 1
	--AND [CompanyID] = 1

SELECT 
	BWSdb_DealersV2_SalesPersonBranch.DealersV2_SPBID,
	BWSdb_DealersV2_SalesPersonBranch.Branch,
	BWSdb_DealersV2_SalesPersonBranch.Address,
	BWSdb_DealersV2_SalesPersonBranch.City,
	BWSdb_DealersV2_SalesPersonBranch.Province
FROM
	[DealersV2_SalesPersonBranch] AS BWSdb_DealersV2_SalesPersonBranch
WHERE (
		(
			(
				BWSdb_DealersV2_SalesPersonBranch.DealerID
			)=457--[Forms]![QE Input - Stargate]![Combo148]
		)
	)
ORDER BY 
	BWSdb_DealersV2_SalesPersonBranch.DealersV2_SPBID,
	BWSdb_DealersV2_SalesPersonBranch.Province; 
