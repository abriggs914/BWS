
DECLARE @t AS TABLE ([ID] INT IDENTITY(0, 1), [Q] INT)

INSERT INTO @t ([Q])
SELECT
	[Quote#]
FROM
	[BWSdb].[dbo].[Orders] [O]
WHERE
	[O].[Quote#] IN (
		31689,
		31798,
		31613,
		31789,
		31790,
		31655,
		31780
)

BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[Orders]
SET
	[WO Review Date] = GETDATE(),
	[WO Reviewed] = 1
FROM
	[BWSdb].[dbo].[Orders] [O]
INNER JOIN
	@t [T]
ON
	[O].[Quote#] = [T].[Q]

ROLLBACK;
COMMIT;


SELECT
	*
FROM
	[BWSdb].[dbo].[Orders] [O]
INNER JOIN
	@t [T]
ON
	[O].[Quote#] = [T].[Q]


SELECT
	*
FROM
	[BWSdb].[dbo].[WSOM_MeetingNotes] [O]
INNER JOIN
	@t [T]
ON
	[O].[Quote] = [T].[Q]