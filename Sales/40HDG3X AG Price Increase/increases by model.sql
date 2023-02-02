USE BWSdb
GO


SELECT 
	[Archive Date]
	, [Model No]
	, [Price]
FROM
	[arcProducts]
WHERE
	[Model No] = '20ART'

--UNION ALL

SELECT 
	[Archive Date]
	, [Model No]
	, [Price]
FROM
	[arcProducts]
WHERE
	[Model No] = '53ET3X'
ORDER BY
	[Archive Date]
;


SELECT 
	[Archive Date]
	, [Model No]
	, [Price]
FROM
	[arcProducts]
WHERE
	[Model No] LIKE '%HDG%'
ORDER BY
	[Archive Date] 


SELECT 
	[Archive Date]
	, [Model No]
	, [Price]
FROM
	[arcProducts]
WHERE
	[Model No] = '40HDG3X AG'
ORDER BY
	[Archive Date] 


SELECT 
	[arcOptions].[Date Changed]
	, [Model No]
	, [Price]
FROM
	[arcOptions]
WHERE
	[Model No] = '40HDG3X AG'
ORDER BY
	[Date Changed]  

	
SELECT 
	[arcBudget Options].[Bud_Date_Opt]
	, [Model No]
	, [arcBudget Options].[Cost]
FROM
	[arcBudget Options]
WHERE
	[Model No] = '40HDG3X AG'
ORDER BY
	[Bud_Date_Opt]  
	
SELECT 
	[Budget Options].[Bud_Date_Opt]
	, [Model No]
	, [Budget Options].[Cost]
FROM
	[Budget Options]
WHERE
	[Model No] = '40HDG3X AG'
ORDER BY
	[Bud_Date_Opt]  

SELECT 
	[Options].[Start Date]
	, [Options].[End Date]
	, [Description]
	, [Model No]
	, [Options].[Price]
FROM
	[Options]
WHERE
	[Model No] = '40HDG3X AG'
ORDER BY
	[Start Date]


SELECT 
	[Orders].[Order Date]
	, [Model No]
	, [Orders].[Price]
FROM
	[Orders]
WHERE
	[Model No] = '40HDG3X AG'
	AND [Order Date] IS NOT NULL
ORDER BY
	[Order Date]  