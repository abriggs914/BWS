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