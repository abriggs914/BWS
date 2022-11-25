USE BWSdb
GO


CREATE VIEW [dbo].[v_ITI_SerialIndication] AS

-- Indication Loctions
SELECT 
	*
FROM (
	SELECT
		[ITI Serial Indication].[ID] AS [SerialID]
		, [ITI Serial Indication].[TableName]
		, [ITI Serial Indication].[ColName]
		, [ITI Serial Indication].[RowID]
		, [ITI Serial Indication].[Serial]
		, [ITI Locations].[Name]
		, [ITI Locations].[Description]
	FROM
		[ITI Serial Indication]
	INNER JOIN
		[ITI Locations]
	ON
		[ITI Serial Indication].[RowID] = [ITI Locations].[ID]
	WHERE
		[ITI Serial Indication].[TableName] = 'ITI Locations'
		AND [ITI Serial Indication].[Active] = 1

	UNION ALL

	SELECT
		[ITI Serial Indication].[ID] AS [SerialID]
		, [ITI Serial Indication].[TableName]
		, [ITI Serial Indication].[ColName]
		, [ITI Serial Indication].[RowID]
		, [ITI Serial Indication].[Serial]
		, [ITI Condition].[Name]
		, NULL AS [Description]
	FROM
		[ITI Serial Indication]
	INNER JOIN
		[ITI Condition]
	ON
		[ITI Serial Indication].[RowID] = [ITI Condition].[ID]
	WHERE
		[ITI Serial Indication].[TableName] = 'ITI Condition'
		AND [ITI Serial Indication].[Active] = 1

	UNION ALL

	SELECT
		[ITI Serial Indication].[ID] AS [SerialID]
		, [ITI Serial Indication].[TableName]
		, [ITI Serial Indication].[ColName]
		, [ITI Serial Indication].[RowID]
		, [ITI Serial Indication].[Serial]
		, [ITI Peripherals].[Name]
		, NULL AS [Description]
	FROM
		[ITI Serial Indication]
	INNER JOIN
		[ITI Peripherals]
	ON
		[ITI Serial Indication].[RowID] = [ITI Peripherals].[ID]
	WHERE
		[ITI Serial Indication].[TableName] = 'ITI Peripherals'
		AND [ITI Serial Indication].[Active] = 1

	UNION ALL

	SELECT
		[ITI Serial Indication].[ID] AS [SerialID]
		, [ITI Serial Indication].[TableName]
		, [ITI Serial Indication].[ColName]
		, [ITI Serial Indication].[RowID]
		, [ITI Serial Indication].[Serial]
		, [ITI Wire].[Name]
		, NULL AS [Description]
	FROM
		[ITI Serial Indication]
	INNER JOIN
		[ITI Wire]
	ON
		[ITI Serial Indication].[RowID] = [ITI Wire].[ID]
	WHERE
		[ITI Serial Indication].[TableName] = 'ITI Wire'
		AND [ITI Serial Indication].[Active] = 1

	UNION ALL

	SELECT
		[ITI Serial Indication].[ID] AS [SerialID]
		, [ITI Serial Indication].[TableName]
		, [ITI Serial Indication].[ColName]
		, [ITI Serial Indication].[RowID]
		, [ITI Serial Indication].[Serial]
		, [ITI Status].[Name]
		, NULL AS [Description]
	FROM
		[ITI Serial Indication]
	INNER JOIN
		[ITI Status]
	ON
		[ITI Serial Indication].[RowID] = [ITI Status].[ID]
	WHERE
		[ITI Serial Indication].[TableName] = 'ITI Status'
		AND [ITI Serial Indication].[Active] = 1

	UNION ALL

	SELECT
		[ITI Serial Indication].[ID] AS [SerialID]
		, [ITI Serial Indication].[TableName]
		, [ITI Serial Indication].[ColName]
		, [ITI Serial Indication].[RowID]
		, [ITI Serial Indication].[Serial]
		, [ITI UOM].[Name]
		, NULL AS [Description]
	FROM
		[ITI Serial Indication]
	INNER JOIN
		[ITI UOM]
	ON
		[ITI Serial Indication].[RowID] = [ITI UOM].[ID]
	WHERE
		[ITI Serial Indication].[TableName] = 'ITI UOM'
		AND [ITI Serial Indication].[Active] = 1

	UNION ALL

	SELECT
		[ITI Serial Indication].[ID] AS [SerialID]
		, [ITI Serial Indication].[TableName]
		, [ITI Serial Indication].[ColName]
		, [ITI Serial Indication].[RowID]
		, [ITI Serial Indication].[Serial]
		, [ITI Network].[Name]
		, NULL AS [Description]
	FROM
		[ITI Serial Indication]
	INNER JOIN
		[ITI Network]
	ON
		[ITI Serial Indication].[RowID] = [ITI Network].[ID]
	WHERE
		[ITI Serial Indication].[TableName] = 'ITI Network'
		AND [ITI Serial Indication].[Active] = 1

	UNION ALL

	SELECT
		[ITI Serial Indication].[ID] AS [SerialID]
		, [ITI Serial Indication].[TableName]
		, [ITI Serial Indication].[ColName]
		, [ITI Serial Indication].[RowID]
		, [ITI Serial Indication].[Serial]
		, [ITI Type].[Name]
		, NULL AS [Description]
	FROM
		[ITI Serial Indication]
	INNER JOIN
		[ITI Type]
	ON
		[ITI Serial Indication].[RowID] = [ITI Type].[ID]
	WHERE
		[ITI Serial Indication].[TableName] = 'ITI Type'
		AND [ITI Serial Indication].[Active] = 1

	UNION ALL

	SELECT
		[ITI Serial Indication].[ID] AS [SerialID]
		, [ITI Serial Indication].[TableName]
		, [ITI Serial Indication].[ColName]
		, [ITI Serial Indication].[RowID]
		, [ITI Serial Indication].[Serial]
		, [ITI Unknown].[Name]
		, NULL AS [Description]
	FROM
		[ITI Serial Indication]
	INNER JOIN
		[ITI Unknown]
	ON
		[ITI Serial Indication].[RowID] = [ITI Unknown].[ID]
	WHERE
		[ITI Serial Indication].[TableName] = 'ITI Unknown'
		AND [ITI Serial Indication].[Active] = 1

	UNION ALL

	SELECT
		[ITI Serial Indication].[ID] AS [SerialID]
		, [ITI Serial Indication].[TableName]
		, [ITI Serial Indication].[ColName]
		, [ITI Serial Indication].[RowID]
		, [ITI Serial Indication].[Serial]
		, [ITI Buildings].[Name]
		, NULL AS [Description]
	FROM
		[ITI Serial Indication]
	INNER JOIN
		[ITI Buildings]
	ON
		[ITI Serial Indication].[RowID] = [ITI Buildings].[ID]
	WHERE
		[ITI Serial Indication].[TableName] = 'ITI Buildings'
		AND [ITI Serial Indication].[Active] = 1

	UNION ALL

	SELECT
		[ITI Serial Indication].[ID] AS [SerialID]
		, [ITI Serial Indication].[TableName]
		, [ITI Serial Indication].[ColName]
		, [ITI Serial Indication].[RowID]
		, [ITI Serial Indication].[Serial]
		, [ITI Computer].[Name]
		, NULL AS [Description]
	FROM
		[ITI Serial Indication]
	INNER JOIN
		[ITI Computer]
	ON
		[ITI Serial Indication].[RowID] = [ITI Computer].[ID]
	WHERE
		[ITI Serial Indication].[TableName] = 'ITI Computer'
		AND [ITI Serial Indication].[Active] = 1

) AS [Src]
--ORDER BY [SerialID]
;

GO