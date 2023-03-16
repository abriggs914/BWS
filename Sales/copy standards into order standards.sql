USE BWSdb
GO

BEGIN TRAN;

DECLARE @q AS NVARCHAR(MAX) = 'SG101115';

SELECT * FROM [Order StandardsV2] WHERE [SGQuote] = @q;

INSERT INTO
	[Order StandardsV2]
(
	[SGQuote]
    ,[WO#]
    ,[StandardsV2].[Model No]
	,[Standard No]
	,[Group]
	,[Section]
	,[Description]
	,[Start Date]
	,[End Date]
	,[SortG]
	,[SortSe]
	,[SortGv2]
	,[SortSev2]
	,[StandardsV2].[CompanyID]
)
SELECT
	[SGQuote]
    ,[WO#]
    ,[StandardsV2].[Model No]
	,[Standard No]
	,[Group]
	,[Section]
	,[Description]
	,[Start Date]
	,[End Date]
	,[SortG]
	,[SortSe]
	,[SortGv2]
	,[SortSev2]
	,[StandardsV2].[CompanyID]
FROM
	[StandardsV2]
LEFT JOIN
	[OrdersV2]
ON
	[StandardsV2].[Model No] = [OrdersV2].[Model No]
WHERE
	[SGQuote] = @q

SELECT * FROM [Order StandardsV2] WHERE [SGQuote] = @q;

ROLLBACK;
COMMIT;