USE BWSdb;


IF OBJECT_ID('BWSdb..tempdb_tempOptionsTable') IS NOT NULL BEGIN

    -- Grant ALTER permission to user5 on tempdb_tempOptionsTable
    GRANT ALTER ON OBJECT::tempdb_tempOptionsTable TO user5
    
    -- Drop the table if it exists
    DROP TABLE tempdb_tempOptionsTable
    
END;

GRANT CREATE TABLE TO user5;

-- Create the table
CREATE TABLE tempdb_tempOptionsTable (
    [ID] INT IDENTITY(0, 1) PRIMARY KEY,
    [Quote] NVARCHAR(MAX),
    [Model No] NVARCHAR(MAX),
    [Dealer] INT,
    [Customer] INT,
    [WO] NVARCHAR(8)
);

-- Revoke ALTER permission from user5
REVOKE ALTER ON OBJECT::tempdb_tempOptionsTable TO user5;

-- Grant SELECT, UPDATE, INSERT permission to user5 on the table
GRANT SELECT, UPDATE, INSERT ON tempdb_tempOptionsTable TO user5;

-- Insert data into the table
INSERT INTO tempdb_tempOptionsTable ([Quote]) VALUES
('SG101115');

UPDATE
    tempdb_tempOptionsTable
SET
    [Model No] = [OrdersV2].[Model No],
    [Dealer] = [OrdersV2].[DealerID],
    [Customer] = [OrdersV2].[CustID],
    [WO] = [OrdersV2].[WO#]
FROM
    [OrdersV2]
WHERE
    [tempdb_tempOptionsTable].[Quote] = [OrdersV2].[SGQuote];

SELECT * FROM tempdb_tempOptionsTable;