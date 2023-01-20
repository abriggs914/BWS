
BEGIN TRAN

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
      [Model No]
      ,[Position4]
      ,[Position5]
      ,[Position6]
      ,[Position7]
      ,[Position8]
      ,[CompanyID]
  FROM [BWSdb].[dbo].[SN Type V2]
  WHERE [CompanyID] = 1
  AND [Model No] LIKE '%michigan%'
  AND [Model No] LIKE '%lead%'
  ORDER BY [Model No]

UPDATE
[SN Type V2]
SET [Position5] = '2'
  WHERE [CompanyID] = 1
  AND [Model No] LIKE '%michigan%'
  AND [Model No] LIKE '%lead%'

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
      [Model No]
      ,[Position4]
      ,[Position5]
      ,[Position6]
      ,[Position7]
      ,[Position8]
      ,[CompanyID]
  FROM [BWSdb].[dbo].[SN Type V2]
  WHERE [CompanyID] = 1
  AND [Model No] LIKE '%michigan%'
  AND [Model No] LIKE '%lead%'
  ORDER BY [Model No]


ROLLBACK;
COMMIT;