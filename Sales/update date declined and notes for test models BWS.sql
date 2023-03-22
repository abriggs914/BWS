-- set notes, declined, and date declined
-- BWS

BEGIN TRAN;

DECLARE @t AS TABLE ([Quote] INT);
INSERT INTO @t ([Quote]) VALUES
(28804),
(28805)
;

SELECT 
	*
FROM
	[Orders]
INNER JOIN
	@t
ON
	[Orders].[Quote#] = [@t].[Quote]
;

UPDATE	
	[Orders]
SET
	[Notes] = '2023-03-22 - abriggs - Testing new pace models'
	, [Date Declined] = GETDATE()
	, [Decline/Rejected] = 5
FROM
	[Orders]
INNER JOIN
	@t
ON
	[Orders].[Quote#] = [@t].[Quote]
;

SELECT 
	*
FROM
	[Orders]
INNER JOIN
	@t
ON
	[Orders].[Quote#] = [@t].[Quote]
;

ROLLBACK;
COMMIT;