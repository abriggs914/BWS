USE BWSdb
GO

-- Most Popular form.
-- Oldest Clicked Form.

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
ORDER BY
	[NumAccesses] DESC
;


SELECT
	*
FROM
	[ADG Events]
INNER JOIN (
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
) AS [A]
ON
	[ADG Events].[ID] = [A].[LastID]