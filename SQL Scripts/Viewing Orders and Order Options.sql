use BWSdb
go

--select * from [Dealers] order by [COMPANY NAME]
--select [Quote#], [Quote Date], [WO#], [Model No] from [Orders] where DealerBranchID = 61 or DealerBranchID = 64 or DealerBranchID = 29 or DealerBranchID = 72 or DealerBranchID = 140 or DealerBranchID = 264 or DealerBranchID = 236 or DealerBranchID = 396 or DealerBranchID = 415 or DealerBranchID = 256 order by [Quote Date]

--SELECT * FROM [Orders] WHERE [Serial Number] LIKE '%NA001576%'
--select * from Options where Description like '%wall%'

--SELECT * FROM [Shipments]
--SELECT * FROM [Carriers]

SELECT * FROM [Order Options] WHERE [Description] LIKE '%Blue%' ORDER BY [Description]