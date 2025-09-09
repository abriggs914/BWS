

BEGIN TRAN;

INSERT INTO
	[BWSdb].[dbo].[PROD_YellowTagsAdmins]
(
	[ITRCustomerID]
)
SELECT
	[C].[CustomerID]
FROM
	[BWSdb].[dbo].[ITR Customers] [C]
WHERE
	[C].[WindowsUser] IN (
		'abriggs',
		'lpiper',
		'jam'
	)

ROLLBACK;
COMMIT;