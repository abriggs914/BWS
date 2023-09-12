USE BWSdb
GO

CREATE VIEW [v_ITI_DistinctHardwareTypes]
AS
	SELECT
		DISTINCT [HardwareType]
	FROM
		[ITI Inventory]
;