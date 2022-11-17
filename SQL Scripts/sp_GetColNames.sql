USE BWSdb
GO


ALTER PROCEDURE [dbo].[sp_GetColNames]
	@tableName AS NVARCHAR(MAX),
	@omitColNames AS NVARCHAR(MAX)=NULL
AS BEGIN


--DECLARE @tableName AS NVARCHAR(MAX);
--SELECT @tableName = 'ITI Locations';
--DECLARE @omitColNames AS NVARCHAR(MAX);
--SELECT @omitColNames = 'ID;DateCreated;Active;DateActive;DateInactive';

DECLARE @t AS TABLE ([ID] INT, [ColName] NVARCHAR(MAX));
INSERT INTO @t
SELECT * FROM [BWSdb].[dbo].[split_string_idx](@omitColNames, ';')

-- Begin 
SELECT
        COLUMN_NAME, ORDINAL_POSITION, DATA_TYPE
    FROM
        INFORMATION_SCHEMA.COLUMNS
	LEFT JOIN
		@t
	ON
		COLUMN_NAME = [ColName]
    WHERE
        TABLE_NAME = @tableName
		AND [ColName] IS NULL
    ORDER BY 2
-- end

END