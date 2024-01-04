USE BWSdb
GO
SELECT
*
FROM
	[IT Requests]
WHERE
	([Request] LIKE '%vault%'
	OR [Comments] LIKE '%vault%'
	)
	AND ([Request] LIKE '%vinay%'
	OR [Comments] LIKE '%vinay%')

	
SELECT
*
FROM
	[IT Requests]
WHERE
	([Request] LIKE '%trust%'
	OR [Comments] LIKE '%trust%')
	--AND ([Request] LIKE '%vinay%'
	--OR [Comments] LIKE '%vinay%')


SELECT
*
FROM
	[IT Requests]
WHERE
	([Request] LIKE '%server1%'
	OR [Comments] LIKE '%server1%')
	--AND ([Request] LIKE '%vinay%'
	--OR [Comments] LIKE '%vinay%')