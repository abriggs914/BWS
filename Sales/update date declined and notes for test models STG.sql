-- set notes, declined, and date declined
-- Stargate

BEGIN TRAN;

DECLARE @t AS TABLE ([Quote] NVARCHAR(MAX));
INSERT INTO @t ([Quote]) VALUES
('SG101116'),
('SG101115'),
('SG101122'),
('SG101123'),
('SG101125'),
('SG101126'),
('SG101127'),
('SG101128'),
('SG101133'),
('SG101134'),
('SG101129'),
('SG101130'),
('SG101131'),
('SG101132')
;

SELECT 
	*
FROM
	[OrdersV2]
INNER JOIN
	@t
ON
	[OrdersV2].[SGQuote] = [@t].[Quote]
;

UPDATE	
	[OrdersV2]
SET
	[Notes] = '2023-03-22 - abriggs - Testing new pace models'
	, [Date Declined] = GETDATE()
	, [Decline/Rejected] = 5
FROM
	[OrdersV2]
INNER JOIN
	@t
ON
	[OrdersV2].[SGQuote] = [@t].[Quote]
;

SELECT 
	*
FROM
	[OrdersV2]
INNER JOIN
	@t
ON
	[OrdersV2].[SGQuote] = [@t].[Quote]
;

ROLLBACK;
COMMIT;