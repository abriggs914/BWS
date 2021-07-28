USE BWSdb
GO

BEGIN TRAN;

SELECT * FROM [Defects_Receiving] ORDER BY [Input Date] DESC;

DELETE
FROM
	[Defects_Receiving]
WHERE
	[Supplier] LIKE '%TEST%'
;

SELECT * FROM [Defects_Receiving] ORDER BY [Input Date] DESC;

ROLLBACK;
COMMIT;