BEGIN TRAN;

SELECT * FROM [Dept] WHERE [Dept] LIKE '%WIP%'
UPDATE [Dept] SET [Dept]
133	NULL	Indirect Labour	NULL	WIP - Work In Progress	Forklift Operator	1	1	NULL	NULL

ROLLBACK;
COMMIT;