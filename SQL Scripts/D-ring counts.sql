USE SysproCompanyA
GO

--SELECT DISTINCT LEFT([ParentPart], 10) FROM [BomStructure] AS A WITH (NOLOCK)
--	WHERE [Component] IS NOT NULL
--		AND REGEXP_INSTR([ParentPart], '[[:digit:]]')
--		AND ([Component] LIKE '%40577%'
--		OR [Component] LIKE '%40573%')

SELECT DISTINCT LEFT([ParentPart], 10), [QtyPer] FROM [BomStructure] AS A WITH (NOLOCK)
	WHERE [Component] IS NOT NULL
		AND [ParentPart] LIKE '%[A-Za-z]%'
		AND [ParentPart] NOT LIKE '87%'
		AND ([Component] LIKE '%40577%'
		OR [Component] LIKE '%40573%')
	ORDER BY 1,2

SELECT DISTINCT LEFT([ParentPart], 10), [QtyPer] FROM [BomStructure] AS A WITH (NOLOCK)
	WHERE [Component] IS NOT NULL
		AND [ParentPart] LIKE '%[A-Za-z]%'
		AND [ParentPart] LIKE '87%'
		AND [Component] LIKE '%40577%'
	ORDER BY 1,2
		
SELECT DISTINCT LEFT([ParentPart], 10), [QtyPer] FROM [BomStructure] AS A WITH (NOLOCK)
	WHERE [Component] IS NOT NULL
		AND [ParentPart] LIKE '%[A-Za-z]%'
		AND [ParentPart] LIKE '87%'
		AND [Component] LIKE '%40573%'
	ORDER BY 1,2

		
SELECT * FROM [BomStructure] AS A WITH (NOLOCK)
	WHERE [Component] IS NOT NULL
		AND [ParentPart] LIKE '%[A-Za-z]%'
		AND [ParentPart] LIKE '87%'
		AND ([Component] LIKE '%40577%'
		OR [Component] LIKE '%40573%')
	ORDER BY [ParentPart], [QtyPer]


SELECT DISTINCT v_BaseBOMReport.Class, v_BaseBOMReport.[Model No] AS B,
		BomStructure.[ParentPart], BomStructure.[Component], BomStructure.[QtyPer] AS A
	FROM 
		[BomStructure]
	LEFT OUTER JOIN
		v_BaseBOMReport
	ON BomStructure.[Component] IS NOT NULL
			AND BomStructure.[ParentPart] LIKE '%[A-Za-z]%'
			AND BomStructure.[ParentPart] LIKE '87%'
			AND (BomStructure.[Component] LIKE '%40577%'
			OR BomStructure.[Component] LIKE '%40573%')
;

SELECT v_BaseBOMReport.[Class], v_BaseBOMReport.[Model No] AS
	class_model,
		BomStructure.[ParentPart], BomStructure.[Component], BomStructure.[QtyPer] AS
	stock_components
FROM 
	v_BaseBOMReport
LEFT OUTER JOIN
	BomStructure
ON v_BaseBOMReport.[StockCode] LIKE BomStructure.[ParentPart]
WHERE v_BaseBOMReport.[Class] IS NOT NULL
	AND v_BaseBOMReport.[Model No] IS NOT NULL
	AND BomStructure.[Component] IS NOT NULL
	AND BomStructure.[ParentPart] LIKE '%[A-Za-z]%'
	AND BomStructure.[ParentPart] LIKE '87%'
	AND (BomStructure.[Component] LIKE '%40577%'
	OR BomStructure.[Component] LIKE '%40573%')
ORDER BY 2, 1, 4

	--v_BaseBOMReport.[Class] IS NOT NULL
	--	AND v_BaseBOMReport.[Model No] IS NOT NULL
	--	AND BomStructure.[Component] IS NOT NULL
	--	AND BomStructure.[ParentPart] LIKE '%[A-Za-z]%'
	--	AND BomStructure.[ParentPart] LIKE '87%'
	--	AND (BomStructure.[Component] LIKE '%40577%'
	--	OR BomStructure.[Component] LIKE '%40573%')


	--ON
	--ORDER BY [ParentPart], [QtyPer]		


--SELECT DISTINCT v_BaseBOMReport.Class, v_BaseBOMReport.[Model No],
--		BomStructure.[ParentPart], BomStructure.[Component], BomStructure.[QtyPer]
--	FROM 
--		[BomStructure]
--	WHERE
--		v_BaseBOMReport.[Class] IS NOT NULL
--		AND v_BaseBOMReport.[Model No] IS NOT NULL
--		AND BomStructure.[Component] IS NOT NULL
--		AND BomStructure.[ParentPart] LIKE '%[A-Za-z]%'
--		AND BomStructure.[ParentPart] LIKE '87%'
--		AND (BomStructure.[Component] LIKE '%40577%'
--		OR BomStructure.[Component] LIKE '%40573%')
--	LEFT OUTER JOIN
--		v_BaseBOMReport
--	ON
--		v_BaseBOMReport.[StockCode] LIKE BomStructure.[ParentPart]
	--ON
	--ORDER BY [ParentPart], [QtyPer]	


--SELECT * FROM [v_BaseBOMReport] AS B WITH (NOLOCK)

--SELECT * FROM [BomStructure] AS A WITH (NOLOCK)

