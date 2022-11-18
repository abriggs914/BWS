
BEGIN TRAN
INSERT INTO [Discounts]
([ProductID], [DealerID], [Active])
SELECT
	
	[IDTrailer]
	, [ID]
	, 1
FROM
	[Products]
CROSS JOIN
	[Dealers]
WHERE
	[Proposed] = 0 
	AND [Non-Current] = 0
	AND [CURRENT DEALER] = 1
ORDER BY
	[COMPANY NAME]
	, [Class]
	, [Model No]


ROLLBACK;
COMMIT;