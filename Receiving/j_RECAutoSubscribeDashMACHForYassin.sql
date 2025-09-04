
-- 2025-09-04 11:31 - Avery Briggs
-- Create a job to determine if any stockcodes with POs are open and not received.
--		If so => register Yassin as a subscriber to PO alerts on that PO.


/*
-- All '-MACH' stockcodes
SELECT
	*
FROM
	[BWSdb].[dbo].[v_REC-MACHParts] [MP]
;
*/

/*
-- Subscribed POs by Yassin:
SELECT
	*
FROM
	[BWSdb].[dbo].[REC_POReceivedSubs] [PO]
WHERE
	LOWER(ISNULL([PO].[RequestedBy], '')) LIKE '%yassin%'
;
*/

INSERT INTO [BWSdb].[dbo].[REC_POReceivedSubs] ([PurchaseOrder], [RequestedBy])
SELECT
	RIGHT('000000000000000' + CAST([MP].[PO] AS NVARCHAR(512)), 6),
	'yassin.nasser'
FROM (
	SELECT
		*
	FROM
		[BWSdb].[dbo].[v_REC-MACHParts] [MP]
	WHERE
		ISNULL([MP].[LatestDueDate], DATEADD(YEAR, -5, GETDATE())) >= DATEADD(YEAR, -2, GETDATE())
) [MP]
FULL OUTER JOIN (
	SELECT
	*
	FROM
		[BWSdb].[dbo].[REC_POReceivedSubs] [PO]
	WHERE
		LOWER(ISNULL([PO].[RequestedBy], '')) LIKE '%yassin%'
) [PO]
ON
	[MP].[PO] = CAST([PO].[PurchaseOrder] AS INT)
WHERE
	[PO].[RequestedBy] IS NULL
GROUP BY
	[MP].[PO]
;