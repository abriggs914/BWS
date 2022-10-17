USE BWSdb
GO

SELECT [Quote#], [DataEntryUser], [DataEntryCheck] FROM [Orders] WHERE [DataEntryUser] IS NOT NULL