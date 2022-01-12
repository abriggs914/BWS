USE BWSdb 
GO

DECLARE	@modelno nvarchar(max)
SET @modelno = '%10gt1x%';

SELECT * FROM [OptionsV2] WHERE [Model No] LIKE @modelno ORDER BY [Option No]
SELECT * FROM [Options] WHERE [Model No] LIKE @modelno ORDER BY [Option No]
SELECT * FROM [Budget Options] WHERE [Model No] LIKE @modelno ORDER BY [Option No]

SELECT * FROM [Order Options] WHERE [Quote#] = 27294

BEGIN TRAN

UPDATE 
	[Options]

ROLLBACK;
COMMIT;




--DECLARE	@description nvarchar(MAX);
--SET @description = '';

--BEGIN TRAN

----DELETE FROM
----	[OptionsV2]
----WHERE
----	[ID#] = 12870561

--	UPDATE
--		[Budget Options]
--	SET
--		[Option No] = '10GT1X-00002'
--	WHERE
--		[ID#] = 7647

--ROLLBACK;
--COMMIT;