
BEGIN TRAN;

SELECT 'ITI Item' AS [Table], * FROM [ITI Item];
SELECT 'ITI InvMaster' AS [Table], * FROM [ITI InvMaster];
SELECT 'ITI InvMaster' AS [Table], * FROM [ITI InvMaster Snap];

--INSERT INTO
--	[ITI Item] (
--		[Name],
--		[Description],
--		[IsActive],
--		[Condition], 
--		[Status],
--		[Type],
--		[SubType],
--		[DateCreated]
--	)
--VALUES 
--	('UNKNOWN', 'UNKNOWN', 1, 6, 3, 1, 1, '2022-07-04 1:39:46 PM')
INSERT INTO [ITI Item] ([Name], [Description], [IsActive], [Condition], [Status], [Type], [SubType], [DateCreated]) VALUES ('19" Monitor', '19" Monitor', 1, 2, 3, 3, 10, '2022-07-04 1:58:49 PM')

SELECT 'ITI Item' AS [Table], * FROM [ITI Item];
SELECT 'ITI InvMaster' AS [Table], * FROM [ITI InvMaster];
SELECT 'ITI InvMaster' AS [Table], * FROM [ITI InvMaster Snap];

ROLLBACK;
COMMIT;