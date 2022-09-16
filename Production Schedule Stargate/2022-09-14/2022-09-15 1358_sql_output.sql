
-- SG100400
UPDATE [BWSdb].[dbo].[OrdersV2] SET [Available Date] = '2022-01-04 00:00:00' WHERE [SGQuote] = 'SG100400';
UPDATE [Stargatedb].[dbo].[dtProductionScheduleV2] SET [JobFinishDate] = '2022-01-04 00:00:00', [JobStartLine] = 'T1' WHERE [SGQuote] = 'SG100400'
-- SG100291
UPDATE [BWSdb].[dbo].[OrdersV2] SET [Available Date] = '2022-01-28 00:00:00' WHERE [SGQuote] = 'SG100291';
UPDATE [Stargatedb].[dbo].[dtProductionScheduleV2] SET [JobFinishDate] = '2022-01-28 00:00:00', [JobStartLine] = 'T1' WHERE [SGQuote] = 'SG100291'
-- SG100404
UPDATE [BWSdb].[dbo].[OrdersV2] SET [Available Date] = '2022-01-31 00:00:00' WHERE [SGQuote] = 'SG100404';
UPDATE [Stargatedb].[dbo].[dtProductionScheduleV2] SET [JobFinishDate] = '2022-01-31 00:00:00', [JobStartLine] = 'T3' WHERE [SGQuote] = 'SG100404'