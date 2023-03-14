USE [BWSdb]
GO

 -- WHERE
	----[Position6] = 'W'  -- -> 1
	---- s --> 2
	---- 4 --> 2
	---- 5 --> 3
	--AND [CompanyID] = 1


BEGIN TRAN;



SELECT [ID]
      ,[Model No]
      ,[MNT1]
      ,[MNT2]
      ,[Position4]
      ,[Position5]
      ,[Position6]
      ,[Position7]
      ,[Position8]
      ,[CompanyID]
  FROM [dbo].[SN Type V2]

  WHERE
  [Position5] IN ('2', '6', NULL)
  AND [CompanyID] = 1
  ORDER BY
	[Position5]


  WHERE
	[Position6] = 'F'  -- -> 1
	--[Position6] = 'T'  -- -> 1
	AND [CompanyID] = 1
	-- s --> 2
	-- f --> d
	-- 4 --> 2
UPDATE
	[SN Type V2]
SET
	[Position6] = 'D'
WHERE
	[Position6] = 'F'  -- -> 1
	AND [CompanyID] = 1
	
SELECT [ID]
      ,[Model No]
      ,[MNT1]
      ,[MNT2]
      ,[Position4]
      ,[Position5]
      ,[Position6]
      ,[Position7]
      ,[Position8]
      ,[CompanyID]
  FROM [dbo].[SN Type V2]
  WHERE
	[Position6] = 'F'  -- -> 1
	--[Position6] = 'T'  -- -> 1
	AND [CompanyID] = 1
	-- s --> 2
	-- 4 --> 2

ROLLBACK

COMMIT;