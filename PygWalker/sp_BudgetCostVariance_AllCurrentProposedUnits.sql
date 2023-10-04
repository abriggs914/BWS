USE BWSdb
GO


exec sp_BudgetCostVariance_AllCurrentProposedUnits
	@archivedate='December 31 2019',
	@FX='1.5',
	@excludeinactive='1',
	@excludeproposed='1'