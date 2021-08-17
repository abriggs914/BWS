USE BWSdb
GO

BEGIN TRAN;

SELECT * FROM [Defects_Print] ORDER BY [Input Date] DESC;

DELETE
FROM
	[Defects_Print]
WHERE
	[ReportedBy] LIKE '%Avery Briggs%'
	OR [ReportedBy] LIKE '%James Crawford%'
	OR [Comment] LIKE '%THIS IS A TEST%'
;

SELECT * FROM [Defects_Print] ORDER BY [Input Date] DESC;

ROLLBACK;
COMMIT;