USE BWSdb
GO


CREATE VIEW [v_ADG User Access Log] AS

SELECT
	CAST((CAST(YEAR([DateCreated]) AS NVARCHAR(4)) + ' - ' +
	CAST(MONTH([DateCreated]) AS NVARCHAR(4)) + ' - ' +
	CAST(DAY([DateCreated]) AS NVARCHAR(4))) AS DATETIME) AS [Date]
	, [WindowsUser]
	, [AccessDB]
	, COUNT(*) AS [NumAccesses]
FROM
	[ADG Events]
GROUP BY
	[WindowsUser]
	, [AccessDB]
	, [AccessDB]
	, YEAR([DateCreated])
	, MONTH([DateCreated])
	, DAY([DateCreated])
;
GO