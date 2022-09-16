
-- SG100291
UPDATE [BWSdb].[dbo].[OrdersV2] SET [Available Date] = NULL WHERE [SGQuote] = 'SG100291';
UPDATE [Stargatedb].[dbo].[dtProductionScheduleV2] SET [JobFinishDate] = NULL, [JobStartLine] = NULL WHERE [SGQuote] = 'SG100291'