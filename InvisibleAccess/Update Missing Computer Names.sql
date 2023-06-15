USE BWSdb
GO

BEGIN TRAN


SELECT DISTINCT
	[WindowsUser]
	, [ComputerName]
FROM
	[ADG Events]
GROUP BY
	[WindowsUser]
	, [ComputerName]
;

UPDATE
	[A]
SET
	[ComputerName] = [B].[ComputerName]
FROM
	[ADG Events] AS [A]
INNER JOIN (
	SELECT DISTINCT
		[WindowsUser]
		, [ComputerName]
	FROM
		[ADG Events]
	WHERE
		[ComputerName] IS NOT NULL
	GROUP BY
		[WindowsUser]
		, [ComputerName]
) AS [B]
ON
	[A].[WindowsUser] = [B].[WindowsUser]
WHERE
	[A].[ComputerName] IS NULL
;

SELECT DISTINCT
	[WindowsUser]
	, [ComputerName]
FROM
	[ADG Events]
GROUP BY
	[WindowsUser]
	, [ComputerName]
;

ROLLBACK;
COMMIT;