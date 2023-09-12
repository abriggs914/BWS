USE BWSdb
GO

CREATE VIEW [v_ITI_DistinctModelNames]
AS
	SELECT
		[BrandName]
		,[ModelName]
	FROM
		[ITI Inventory]
	GROUP BY
		[BrandName]
		,[ModelName]
;