USE BWSdb
GO

SELECT
	[CtlClicked]
	, [CtlCaption]
	, COUNT([ID]) AS [C]
FROM
	[ADG Events]
WHERE
	[AccessDB] = 'SysproCompanyA'
GROUP BY
	[CtlClicked]
	, [CtlCaption]
ORDER BY
	[C] DESC
	--[CtlCaption]