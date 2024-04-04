USE uniPoint_Live
GO

-- 2024-04-04

-- SQL script to scan an entire database's tables for ANY record that matched the input string.
-- Only considers simple data types

DECLARE @SearchString NVARCHAR(100) = 'abriggs2';
DECLARE @TableName NVARCHAR(100);
DECLARE @ColumnName NVARCHAR(100);
DECLARE @SQLQuery NVARCHAR(MAX);

DECLARE curTables CURSOR FOR
SELECT t.name AS TableName, c.name AS ColumnName
FROM sys.tables t
INNER JOIN sys.columns c ON t.object_id = c.object_id
WHERE c.system_type_id IN (231, 167, 175, 239) -- Data types suitable for searching

OPEN curTables;

FETCH NEXT FROM curTables INTO @TableName, @ColumnName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQLQuery = 'IF EXISTS(SELECT 1 FROM ' + QUOTENAME(@TableName) + ' WHERE ' + QUOTENAME(@ColumnName) + ' LIKE ''%' + @SearchString + '%'') 
                    BEGIN
                        PRINT ''Record Found in ' + @TableName + ' (' + @ColumnName + ')'';
                        SELECT ''' + QUOTENAME(@TableName) +  ''' AS [T], * FROM ' + QUOTENAME(@TableName) + ' WHERE ' + QUOTENAME(@ColumnName) + ' LIKE ''%' + @SearchString + '%'';
                    END';
    EXEC sp_executesql @SQLQuery;

    FETCH NEXT FROM curTables INTO @TableName, @ColumnName;
END

CLOSE curTables;
DEALLOCATE curTables;
