USE BWSdb
GO


CREATE VIEW [v_ADG Latest Accessors]
AS

SELECT
	[A].[WindowsUser] AS [Latest Accessor(s)]
	, [DateCreated] AS [When]
	, [AccessDB] AS [DB]
	, [FormAccessed] AS [On Form]
	, [DestinationForm] AS [Target Form]
	, [LastID] AS [Last ID]
FROM
	[ADG Events]
INNER JOIN (
	SELECT
		MAX([ID]) AS [LastID]
		, [WindowsUser]
	FROM
		[ADG Events]
	GROUP BY
		[WindowsUser]
) AS [A]
ON
	[ADG Events].[ID] = [LastID]
--ORDER BY
--	[DateCreated] DESC
;
GO