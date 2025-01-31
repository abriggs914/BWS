SELECT
	*
FROM
	[BWSdb].[dbo].[TestTable0]
SELECT
	*
FROM
	[BWSdb].[dbo].[hist_TestTable0]

/*
INSERT INTO [BWSdb].[dbo].[TestTable0] ([Name], [Description], [Comments]) VALUES ('Avery2', 'Desc2', 'Comments2')
UPDATE [BWSdb].[dbo].[TestTable0] SET [Active] = 0 WHERE [ID] = 0
*/

--DROP TABLE [BWSdb].[dbo].[TestTable0]
--DROP TABLE [BWSdb].[dbo].[hist_TestTable0]


-- Last 5 Changes on ID 0
SELECT TOP 5
	*
FROM
	[BWSdb].[dbo].[hist_TestTable0]
WHERE
	([ModifiedID] = 0)
	AND ([ModifiedColumn] = 'Active')
ORDER BY
	[ID] DESC
	, [NestLevel] DESC

	
SELECT
    [TABLE_CATALOG]
    ,[TABLE_NAME]
    ,[COLUMN_NAME]
    ,(CASE WHEN [IS_NULLABLE] = 'NO' THEN 1 ELSE 0 END) AS [PRIMARY_KEY]
    ,[DATA_TYPE]
    ,[CHARACTER_MAXIMUM_LENGTH]
FROM
    INFORMATION_SCHEMA.COLUMNS
ORDER BY
    [TABLE_NAME],
    [COLUMN_NAME]

SELECT
    [T].[TABLE_CATALOG]
    ,[T].[TABLE_NAME]
	,[T].[TABLE_TYPE]
	,COUNT(*) AS [N_Columns]
FROM
    INFORMATION_SCHEMA.TABLES [T]
INNER JOIN
	INFORMATION_SCHEMA.COLUMNS [C]
ON
	[T].[TABLE_NAME] = [C].[TABLE_NAME]
GROUP BY
    [T].[TABLE_CATALOG]
    ,[T].[TABLE_NAME]
	,[T].[TABLE_TYPE]
ORDER BY
    [TABLE_NAME]