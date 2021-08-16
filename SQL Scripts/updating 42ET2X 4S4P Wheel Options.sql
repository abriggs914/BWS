USE BWSdb
GO



BEGIN TRAN;

SELECT
	*
FROM
	[Options_SpecLines]
WHERE
	[Option No] LIKE '%42et2x-77%'
;
UPDATE
	[Options_SpecLines]
SET
	[SpecDescription] = 'Alum. Wheel Pkg. 17.5  (4 steel, 4 polished)'
WHERE
	[Option No] LIKE '%42et2x-77%'
;


SELECT
	*
FROM
	[Options_SpecLines]
WHERE
	[Option No] LIKE '%42et2x-77%'
;

ROLLBACK;
COMMIT;