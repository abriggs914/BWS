USE BWSdb
GO

SELECT
	*
FROM
	[Budget Options]
WHERE
	[Obsolete] = 0
	--AND GETDATE() BETWEEN [StartDate] AND [EndDate]
;

SELECT
	*
FROM
	[Options]
WHERE
	[Obsolete] = 0
	AND GETDATE() BETWEEN [Start Date] AND [End Date]
;

DECLARE @d AS DATETIME = GETDATE();

SELECT
	(CASE 
		WHEN [Obsolete] = 1 THEN
			(CASE 
				WHEN @d NOT BETWEEN [Start Date] AND [End Date] THEN
					'Obs'
				ELSE
					'Obs Date'
			END)
		ELSE
			(CASE 
				WHEN @d NOT BETWEEN [Start Date] AND [End Date] THEN
					'Date'
				ELSE
					'valid'
			END)
		END) AS [State]
	, *
FROM
	[Options]
;