USE BWSdb
GO

CREATE VIEW [v_ADG Buttons Inventory]
AS

SELECT
	[AccessDB]
	, [FormAccessed]
	, [CtlClicked]
	, [OpensForm]
	, [DestinationForm]
	, COUNT(*) AS [NumAccesses]
	, MAX([ID]) AS [LastID]
FROM
	[ADG Events]
GROUP BY
	[AccessDB]
	, [FormAccessed]
	, [CtlClicked]
	, [OpensForm]
	, [DestinationForm]
;
GO