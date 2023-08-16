USE BWSdb
GO

SELECT
	[AccessDB]
	, [CtlClicked]
	, [CtlCaption]
	, COUNT([ID]) AS [C]
FROM
	[ADG Events]
--WHERE
--	[AccessDB] = 'SysproCompanyA'
GROUP BY
	[AccessDB]
	, [CtlClicked]
	, [CtlCaption]
ORDER BY
	[AccessDB]
	, [C] DESC
	--[CtlCaption]