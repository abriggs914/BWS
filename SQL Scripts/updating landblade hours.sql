USE SysproCompanyA
GO
/*
WOs Done:
	10014898
	10014897
	10014896
	10014895
	10014894
	10014893
	10014889
	10014892
	10014891
	10014890
	10014887
	10014888
*/
/*
41
05
06
*/
/*
*/


DECLARE @JOB AS INT;
DECLARE @M AS INT;
SET @JOB = 10014887;
SET @M = 21;
--SELECT * FROM [BWSdb].[dbo].[Order Hours]
SELECT * FROM WipJobAllLab INNER JOIN [BomMachine] ON [WipJobAllLab].[IMachine] = Machine WHERE [Job] LIKE @JOB AND [IMachine] = @M
/*
SELECT * FROM WipJobAllLab INNER JOIN [BomMachine] ON [WipJobAllLab].[IMachine] = Machine WHERE [Job] LIKE '%10014898%'
*/
BEGIN TRAN;

SELECT * FROM [BWSdb].[dbo].[Order Hours] WHERE CAST([WO#] AS VARCHAR(8)) LIKE @JOB
UPDATE
	BWSdb.dbo.[Order Hours]
SET
	[Final Assembly] = [IExpUnitRunTim]
FROM
	BWSdb.dbo.[Order Hours]
INNER JOIN
	WipJobAllLab
ON
	[Job] = CAST(BWSdb.dbo.[Order Hours].[WO#] AS VARCHAR(8)) 
WHERE 
	[Job] LIKE @JOB
	AND [IMachine] = @M
SELECT * FROM [BWSdb].[dbo].[Order Hours] WHERE CAST([WO#] AS VARCHAR(8)) LIKE @JOB

ROLLBACK;
COMMIT;