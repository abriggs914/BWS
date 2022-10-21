
SELECT
	--'IT Requests History' AS [Table]
	--,
	[ITRequestID#]
	, COUNT(*) AS [C]
	--, *
FROM
	[IT Requests History]
--WHERE
--	[ITRequestID#] = 1308
GROUP BY
	[ITRequestID#]
;