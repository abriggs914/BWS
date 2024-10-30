
SELECT
	*
FROM
	[ITR Customers]
ORDER BY
	[Name]
;

SELECT
	[ID]
	,COALESCE([DateCreated], GETDATE())
	,[DateCreated]
	,[Active]
	,COALESCE([DateActive], GETDATE())
	,[DateActive]
	,[DateInactive]
	,[LastModified]
	,[AppShortName]
	,[AppLongName]
	,[AppDescription]
FROM 
	[BWSdb].[dbo].[ITSTR_AppDirectory]
;

SELECT
	[ID]
	,COALESCE([DateCreated], GETDATE())
	,[DateCreated]
	,[Active]
	,COALESCE([DateActive], GETDATE())
	,[DateActive]
	,[DateInactive]
	,[ITRCustomerID]
	,[ITSTRAppID]
	,[AppUserName]
	,[AppPassword]
	,[LastModified]
FROM
	[BWSdb].[dbo].[ITSTR_UserDirectory]
;


/*
BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[ITSTR_UserDirectory]
SET
	[Active] = 1
WHERE
	[ID] = 0
	
ROLLBACK;
COMMIT;
*/

/*
BEGIN TRAN;

SELECT
	[ID]
	,[DateCreated]
	,[Active]
	,[DateActive]
	,[DateInactive]
	,[LastModified]
	,[AppShortName]
	,[AppLongName]
	,[AppDescription]
FROM 
	[BWSdb].[dbo].[ITSTR_AppDirectory]
;

INSERT INTO
	[BWSdb].[dbo].[ITSTR_AppDirectory]
(
	[Active]
	,[AppShortName]
	,[AppLongName]
	,[AppDescription]
) VALUES
	(1, 'Authentication Demo', 'Authentication Demo', NULL)

UPDATE
	[BWSdb].[dbo].[ITSTR_AppDirectory]
SET
	[DateCreated] = GETDATE()
WHERE
	[ID] = 1
;

SELECT
	[ID]
	,[DateCreated]
	,[Active]
	,[DateActive]
	,[DateInactive]
	,[LastModified]
	,[AppShortName]
	,[AppLongName]
	,[AppDescription]
FROM 
	[BWSdb].[dbo].[ITSTR_AppDirectory]
;

ROLLBACK;
COMMIT;
*/

/*
BEGIN TRAN;

INSERT INTO
	[BWSdb].[dbo].[ITSTR_UserDirectory]
(
	[Active]
	,[ITRCustomerID]
	,[ITSTRAppID]
	,[AppUserName]
	,[AppPassword]
) VALUES
	(1, 12, 3, 'JWC', 'trailer2')

ROLLBACK;
COMMIT;
*/

/*
BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[ITSTR_UserDirectory]
SET
	[ITRCustomerID] = 4
WHERE
	[AppUserName] = 'abriggs'

ROLLBACK;
COMMIT;
*/