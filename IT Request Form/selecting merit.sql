USE [BWSdb]
GO

DECLARE @RC int
DECLARE @names nvarchar(max)
DECLARE @type nvarchar(max)
DECLARE @gt_1 bit
DECLARE @gt_5 bit
DECLARE @gt_10 bit
DECLARE @gt_25 bit
DECLARE @gt_50 bit
DECLARE @gt_100 bit
DECLARE @gt_200 bit
DECLARE @gt_250 bit
DECLARE @gt_500 bit
DECLARE @gt_750 bit
DECLARE @gt_1000 bit
DECLARE @gt_1500 bit
DECLARE @gt_2000 bit
DECLARE @gt_2500 bit
DECLARE @isM25 bit
DECLARE @isM50 bit
DECLARE @isM100 bit

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[sp_ITRCheckMerit] 
   @names='avery'
  ,@type='software'
  ,@gt_1=NULL
  ,@gt_5=NULL
  ,@gt_10=1
  ,@gt_25=NULL
  ,@gt_50=NULL
  ,@gt_100=NULL
  ,@gt_200=NULL
  ,@gt_250=NULL
  ,@gt_500=NULL
  ,@gt_750=NULL
  ,@gt_1000=NULL
  ,@gt_1500=NULL
  ,@gt_2000=NULL
  ,@gt_2500=NULL
  ,@isM25=NULL
  ,@isM50=NULL
  ,@isM100=NULL
GO

SELECT [RequestedBy], COUNT(*) AS [#] FROM [IT Requests] WHERE [RequestedBy] LIKE '%avery%' AND [RequestType] LIKE '%software%' GROUP BY [RequestedBy] HAVING COUNT(*) >= 1018
