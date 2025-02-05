
-- Setting Quotes to Reviewed
-- 2025-02-04
-- From MeetingID=3

BEGIN TRAN;


DECLARE @t TABLE ([ID] INT IDENTITY(0, 1), [Q] INT)
INSERT INTO @t ([Q]) VALUES
(31006),
(31007),
(31008),
(31009),
(31010),
(31012),
(31013),
(31014),
(31015),
(31016),
(31017),
(31018),
(31019),
(31020),
(31021),
(31022),
(31023),
(31024),
(31025),
(31026),
(31027),
(31028),
(31029),
(31030),
(31031),
(31032),
(31033),
(31034),
(31057),
(30772),
(30977),
(31051),
(31052),
(30998)

SELECT
	[O].[WO Reviewed],
	[O].[WO Review Date]
	,*
FROM
	[BWSdb].[dbo].[Orders] [O]
INNER JOIN
	@t [T]
ON
	[O].[Quote#] = [T].[Q]
;

UPDATE
	[BWSdb].[dbo].[Orders]
SET
	[WO Reviewed] = 1
	, [WO Review Date] = GETDATE()
FROM
	[BWSdb].[dbo].[Orders] [O]
INNER JOIN
	@t [T]
ON
	[O].[Quote#] = [T].[Q]
;

SELECT
	[O].[WO Reviewed],
	[O].[WO Review Date]
	,*
FROM
	[BWSdb].[dbo].[Orders] [O]
INNER JOIN
	@t [T]
ON
	[O].[Quote#] = [T].[Q]
;

ROLLBACK;
COMMIT;