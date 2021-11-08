
SELECT 
	[EmployeeNumber],
	[EmployeeName],
	ROUND(((60 * (SUM(DATEPART(HOUR, [OutTimeFromShopClk] - [InTimeFromShopClk])))) + SUM(DATEPART(MINUTE, [OutTimeFromShopClk] - [InTimeFromShopClk]))) / 60.0, 2) AS [HrsWorked]
FROM
	[ClkTransaction]
WHERE
	[InTimeFromShopClk] IS NOT NULL
	OR [OutTimeFromShopClk] IS NOT NULL
	AND ([InTimeFromShopClk] BETWEEN DATEADD(DAY, -7,GETDATE()) AND GETDATE()
		OR [OutTimeFromShopClk] BETWEEN DATEADD(DAY, -7,GETDATE()) AND GETDATE())
GROUP BY
	[EmployeeNumber], [EmployeeName]
ORDER BY
	[EmployeeNumber]

