USE BWSdb
GO

SELECT
	[COMPANY NAME],
	[SlotsRequestedPerMonth]
FROM
	[Dealers]
WHERE
	[SlotsRequestedPerMonth] IS NOT NULL
ORDER BY
	[COMPANY NAME]