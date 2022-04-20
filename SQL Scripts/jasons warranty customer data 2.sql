USE [Stargatedb]
GO

--USE [BWSdb]
--GO

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
      ,[WO#]
      ,[DealerID]
      ,[Model No]
      ,[Serial Number]
      ,[Claim Number]
      ,[Claim Date]
      ,[Date Closed]
      ,[Approval Date]
      ,[Reason Denied/Goodwill]
      ,[Auth By]
      ,[Issue Number]
      ,[BWS Invoice #]
      ,[Carrier]
      ,[BOL#]
      ,[Failure]
      ,[Location]
      ,[Dealer]
      ,[Supplier]
      ,[S/N]
      ,[Customer]
      ,[Parts/Labour]
      ,[Customer V2]
      ,[Dealer V2]
      ,[S/N V2]
      ,[Supplier V2]
  FROM [dbo].[Warranty Claims]

  BEGIN TRAN

	UPDATE
		[Warranty Claims]
	SET
		[Customer] = 'Fortress Foundations LLC, 3103 W. Thompson Rd. Ste 435, Fenton, MI, 48430',
		[Dealer] = 'Wieland Truck Center',
		[S/N] = '2S9DS457XNM118762',
		[S/N V2] = '2S9DS457XNM118762'
	WHERE
		[WO#] = 8762

		
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
      ,[WO#]
      ,[DealerID]
      ,[Model No]
      ,[Serial Number]
      ,[Claim Number]
      ,[Claim Date]
      ,[Date Closed]
      ,[Approval Date]
      ,[Reason Denied/Goodwill]
      ,[Auth By]
      ,[Issue Number]
      ,[BWS Invoice #]
      ,[Carrier]
      ,[BOL#]
      ,[Failure]
      ,[Location]
      ,[Dealer]
      ,[Supplier]
      ,[S/N]
      ,[Customer]
      ,[Parts/Labour]
      ,[Customer V2]
      ,[Dealer V2]
      ,[S/N V2]
      ,[Supplier V2]
  FROM [dbo].[Warranty Claims]


  ROLLBACK;
  COMMIT;