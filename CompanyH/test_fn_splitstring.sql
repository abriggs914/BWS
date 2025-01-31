
-- Testing [fn_SplitString] 2025-01

SELECT 
    [D].[Name],
    [S].[ID] AS [ProductID]
FROM 
	[BWSdb].[dbo].[ITD Dept] [D]
CROSS APPLY 
    [CompanyH].[dbo].[fn_SplitString]([D].[DeptRelations], ';') [S];



SELECT
	*
FROM 
	[BWSdb].[dbo].[ITD Dept]
;