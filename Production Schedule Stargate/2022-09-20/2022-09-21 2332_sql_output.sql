
-- SG100404
UPDATE [BWSdb].[dbo].[OrdersV2] SET [Available Date] = '2022-01-31 00:00:00' WHERE [SGQuote] = 'SG100404';
UPDATE [Stargatedb].[dbo].[dtProductionScheduleV2] SET [JobFinishDate] = '2022-01-31 00:00:00', [JobStartLine] = 'T3' WHERE [SGQuote] = 'SG100404'
-- SG100123
UPDATE [BWSdb].[dbo].[OrdersV2] SET [Available Date] = NULL WHERE [SGQuote] = 'SG100123';
UPDATE [Stargatedb].[dbo].[dtProductionScheduleV2] SET [JobFinishDate] = NULL, [JobStartLine] = NULL WHERE [SGQuote] = 'SG100123'
-- SG100231
UPDATE [BWSdb].[dbo].[OrdersV2] SET [Available Date] = NULL WHERE [SGQuote] = 'SG100231';
UPDATE [Stargatedb].[dbo].[dtProductionScheduleV2] SET [JobFinishDate] = NULL, [JobStartLine] = NULL WHERE [SGQuote] = 'SG100231'
-- SG100291
UPDATE [BWSdb].[dbo].[OrdersV2] SET [Available Date] = NULL WHERE [SGQuote] = 'SG100291';
UPDATE [Stargatedb].[dbo].[dtProductionScheduleV2] SET [JobFinishDate] = NULL, [JobStartLine] = NULL WHERE [SGQuote] = 'SG100291'
-- SG100276
UPDATE [BWSdb].[dbo].[OrdersV2] SET [Available Date] = NULL WHERE [SGQuote] = 'SG100276';
UPDATE [Stargatedb].[dbo].[dtProductionScheduleV2] SET [JobFinishDate] = NULL, [JobStartLine] = NULL WHERE [SGQuote] = 'SG100276'
-- SG100400
UPDATE [BWSdb].[dbo].[OrdersV2] SET [Available Date] = NULL WHERE [SGQuote] = 'SG100400';
UPDATE [Stargatedb].[dbo].[dtProductionScheduleV2] SET [JobFinishDate] = NULL, [JobStartLine] = NULL WHERE [SGQuote] = 'SG100400'