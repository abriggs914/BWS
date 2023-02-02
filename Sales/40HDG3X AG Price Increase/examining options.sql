
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
	[Description]
	, [Start Date]
;


SELECT 
	[Options].[Start Date]
	, [Options].[End Date]
	, [Description]
	, [Model No]
	, [Options].[Price]
FROM
	[Options]
WHERE
	[Model No] LIKE '%HDG%'
ORDER BY
	[Description]
	, [Start Date]