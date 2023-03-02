/****** Script for SelectTopNRows command from SSMS  ******/

BEGIN TRAN;

SELECT [ID]
      ,[COMPANY NAME]
      ,[ADDRESS]
      ,[CITY]
      ,[PROVINCE]
      ,[POSTAL CODE]
      ,[PHONE]
      ,[TOLL FREE]
      ,[FAX]
      ,[CONTACT]
      ,[CELL]
      ,[EMAIL]
      ,[DEALER NUMBER]
      ,[CURRENT DEALER]
      ,[CURRENT DEALER CDN]
      ,[CURRENT DEALER US]
      ,[Invoice]
      ,[Eastern Canada]
      ,[Eastern US]
      ,[Central Canada]
      ,[Central US]
      ,[Western Canada]
      ,[Western US]
      ,[American]
      ,[Proprietary/Direct/Other]
      ,[Initials]
      ,[dealers_timestamp]
      ,[DataEntryCheck]
      ,[DataEntryUser]
      ,[DefaultPayID]
      ,[SendDealerStatusEmail?]
      ,[CompanyID]
      ,[SlotsRequestedPerMonth]
  FROM [BWSdb].[dbo].[DealersV2]
  WHERE [ID] = 85505

  UPDATE
	[DealersV2]
	SET
	[ADDRESS] = 'ConExpo Marshall Yard 6555 W Serene Ave'
      ,[CITY] = 'Las Vegas'
      ,[PROVINCE]='NV'
      ,[POSTAL CODE]='89139'
  WHERE [ID] = 723544

SELECT
	*
FROM
	[DealersV2]
 WHERE [ID] = 723544

ROLLBACK;
COMMIT;