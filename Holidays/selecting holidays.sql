EXEC [sp_CheckUpcomingHolidays] @sd='2023-04-02'


SELECT DISTINCT 
	[HolidayName]
FROM
	[Calendar]
WHERE
	[HolidayName] IS NOT NULL
ORDER BY
	[HolidayName]
;

SELECT
	[Date]
	, [HolidayName]
FROM
	[Calendar]
WHERE
	[HolidayName] IS NOT NULL
	AND [HolidayName] = 'Civic Holiday'
ORDER BY
	[Date]


BEGIN TRAN;


SELECT
	[Date]
	, [HolidayName]
FROM
	[Calendar]
WHERE
	[HolidayName] IS NOT NULL
	AND [HolidayName] = 'Civic Holiday'
ORDER BY
	[Date]

	
UPDATE
	[Calendar]
SET
	[HolidayName] = ''
WHERE
	[HolidayName] IS NOT NULL
	AND [HolidayName] = 'Civic Holiday'
ORDER BY
	[Date]


SELECT
	[Date]
	, [HolidayName]
FROM
	[Calendar]
WHERE
	[HolidayName] IS NOT NULL
	AND [HolidayName] = 'Civic Holiday'
ORDER BY
	[Date]

ROLLBACK;
COMMIT;