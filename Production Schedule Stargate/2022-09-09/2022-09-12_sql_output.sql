
-- SG100400
UPDATE [BWSdb].[dbo].[OrdersV2] SET [Available Date] = '2022-01-16 00:00:00' WHERE [SGQuote] = 'SG100400';
UPDATE [Stargatedb].[dbo].[dtProductionScheduleV2] SET [JobFinishDate] = '2022-01-16 00:00:00', [JobStartLine] = 'T3' WHERE [SGQuote] = 'SG100400'
-- SG100404
UPDATE [BWSdb].[dbo].[OrdersV2] SET [Available Date] = '2022-01-30 00:00:00' WHERE [SGQuote] = 'SG100404';
UPDATE [Stargatedb].[dbo].[dtProductionScheduleV2] SET [JobFinishDate] = '2022-01-30 00:00:00', [JobStartLine] = 'T2' WHERE [SGQuote] = 'SG100404'
-- SG100619
UPDATE [BWSdb].[dbo].[OrdersV2] SET [Available Date] = '2022-01-05 00:00:00' WHERE [SGQuote] = 'SG100619';
UPDATE [Stargatedb].[dbo].[dtProductionScheduleV2] SET [JobFinishDate] = '2022-01-05 00:00:00', [JobStartLine] = 'T2' WHERE [SGQuote] = 'SG100619'
-- SG100621
UPDATE [BWSdb].[dbo].[OrdersV2] SET [Available Date] = '2022-01-10 00:00:00' WHERE [SGQuote] = 'SG100621';
UPDATE [Stargatedb].[dbo].[dtProductionScheduleV2] SET [JobFinishDate] = '2022-01-10 00:00:00', [JobStartLine] = 'T3' WHERE [SGQuote] = 'SG100621'