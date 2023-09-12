USE BWSdb
GO

CREATE VIEW [v_ITI_DistinctBrandNames]
AS
	SELECT
		DISTINCT [BrandName]
	FROM
		[ITI Inventory]
;