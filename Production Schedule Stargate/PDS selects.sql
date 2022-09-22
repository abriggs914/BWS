USE Stargatedb
GO

DECLARE @t AS TABLE ([ID] INT IDENTITY(1, 1), [SGQuote] NVARCHAR(255));
INSERT INTO @t ([SGQuote]) VALUES 
('SG100400'), ('SG100404'), ('SG100291'), ('SG100621'), ('SG100623');

SELECT * FROM [PDS Updates]
SELECT * FROM [PDS Valid Updaters]

SELECT [Available Date], * FROM [BWSdb].[dbo].[OrdersV2] INNER JOIN @t ON [OrdersV2].[SGQuote] = [@t].[SGQuote]
SELECT * FROM [dtProductionSchedule] INNER JOIN @t ON [dtProductionSchedule].[SGQuote] = [@t].[SGQuote]
SELECT [JobFinishDate], [JobStartLine], * FROM [dtProductionScheduleV2] INNER JOIN @t ON [dtProductionScheduleV2].[SGQuote] = [@t].[SGQuote]
SELECT * FROM [BWSdb].[dbo].[v_GalvanizedStargateOrders] INNER JOIN @t ON [v_GalvanizedStargateOrders].[SGQuote] = [@t].[SGQuote]

--SELECT DISTINCT [JobStartLine] FROM [dtProductionScheduleV2]
--SELECT [JobStartLine], * FROM [dtProductionScheduleV2] WHERE [JobStartLine] = 'AS'

--BEGIN TRAN;
--UPDATE
--[dtProductionScheduleV2]
--SET
--	[JobStartLine] = NULL

--WHERE [JobStartLine] = 'AS'
--COMMIT;