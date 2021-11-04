SELECT 
	[TransactionID],
	[JobNumber],
	[EmployeeNumber],
	[EmployeeName],
	[LoggedOn],
	[InTimeFromShopClk],
	[LoggedOff],
	[OutTimeFromShopClk],
(CASE WHEN [LoggedOff] IS NULL THEN 0 ELSE 1 END) AS [PlaceHolder]
FROM
	[ClkTransaction]
WHERE
	[InTimeFromShopClk] IS NOT NULL
	OR [OutTimeFromShopClk] IS NOT NULL
	AND ([LoggedOn] BETWEEN DATEADD(DAY, -7,GETDATE()) AND GETDATE()
		OR [LoggedOff] BETWEEN DATEADD(DAY, -7,GETDATE()) AND GETDATE())
ORDER BY
[PlaceHolder], [LoggedOn], [LoggedOff]