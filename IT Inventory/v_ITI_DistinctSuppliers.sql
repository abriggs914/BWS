USE BWSdb
GO

CREATE VIEW [v_ITI_DistinctSuppliers]
AS
	SELECT
		[BrandName]
		,[ModelName]
		,[Supplier]
	FROM
		[ITI Inventory]
	GROUP BY
		[BrandName]
		,[ModelName]
		,[Supplier]
;