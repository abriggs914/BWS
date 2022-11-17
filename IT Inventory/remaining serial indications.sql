SELECT
	* 
FROM 
	[ITI Condition]
;

SELECT
	* 
FROM 
	[ITI Locations]
;

SELECT
	* 
FROM 
	[ITI Serial Indication]
WHERE
	[TableName] = 'ITI Condition' 
;

SELECT
	* 
FROM 
	[ITI Condition]
LEFT JOIN
	[ITI Serial Indication]
ON
	[ITI Condition].[ID] = [ITI Serial Indication].[RowID]
WHERE
	--[TableName] = 'ITI Condition'
	--AND 
	[ITI Serial Indication].[RowID] IS NULL
;


SELECT 
	* 
FROM
	[ITI Locations]
LEFT JOIN
(
	SELECT
		[ITI Locations].*
	FROM 
		[ITI Locations]
	INNER JOIN
		[ITI Serial Indication]
	ON
		[TableName] = 'ITI Locations'
		AND
		[ITI Locations].[ID] = [ITI Serial Indication].[RowID]
) AS [omit]
ON
	[ITI Locations].[ID] = [omit].[ID]
WHERE
	[omit].[ID] IS NULL
;


--WHERE
	--[TableName] = 'ITI Locations'
	--AND
	--[ITI Serial Indication].[RowID] IS NULL