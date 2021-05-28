use BWSdb
go

	--select * from SysproCompanyA.dbo.SorDeliveryPerf with (nolock)
	--select * from SysproCompanyA.dbo.SorQuoteDet with (nolock)
	--select * from SysproCompanyA.dbo.SorQuote with (nolock)
	--select * from SysproCompanyA.dbo.SorQuoteDet with (nolock)
	--select * from SysproCompanyA.dbo.SorQuoteListDetail with (nolock)
	--select * from SysproCompanyA.dbo.TblSaDelTerms with (nolock)
	--select * from BWSdb.dbo.dtProductionSchedule with (nolock)
	
	select * from [Order Options] as A with (nolock)where [Quote Date] > '2020-09-30 00:00:00.000' AND [Sections] = 'SUSPENSION/AXLES' AND [Description] LIKE '%Alum%' order by [WO#];

	--select [JobDeliveryDate] from SysproCompanyA.dbo.WipMaster with (nolock) Intersect select [Quote Date] from [Order Options] with (nolock)
	
	--select * from SysproCompanyA.dbo.WipMaster with (nolock) where [JobDeliveryDate] > '2021-03-31 00:00:00.000' and [JobDeliveryDate] < '2021-04-22 00:00:00.000' and [Job] < 20000000 order by [JobDeliveryDate]
	SELECT * FROM SysproCompanyA.dbo.WipMaster WITH (NOLOCK) WHERE [JobDeliveryDate] > '2021-03-31 00:00:00.000' AND [JobDeliveryDate] < '2021-04-22 00:00:00.000' AND [Job] < 20000000;
	
	SELECT Job, StockCode, CustomerName, JobDeliveryDate 
		FROM SysproCompanyA.dbo.WipMaster AS A WITH (NOLOCK)
			WHERE [JobDeliveryDate] > '2021-03-31 00:00:00.000' AND
				[Job] < 20000000 AND
				A.[Job] IN (SELECT [WO#]
								FROM [Order Options] WITH (NOLOCK)
									WHERE [Sections] = 'SUSPENSION/AXLES' AND
										[Description] != 'Aluminum Air Tanks' AND
										[Description] LIKE '%Alum%')
										ORDER BY [Job];

	--select * from B;
	--select * from (select Job, StockCode, CustomerName, JobDeliveryDate from SysproCompanyA.dbo.WipMaster with (nolock) where [JobDeliveryDate] > '2021-03-31 00:00:00.000' and [JobDeliveryDate] < '2021-04-22 00:00:00.000' and [Job] < 20000000 order by [JobDeliveryDate]) where (select Job, StockCode, CustomerName, JobDeliveryDate from SysproCompanyA.dbo.WipMaster with (nolock) where [JobDeliveryDate] > '2021-03-31 00:00:00.000' and [JobDeliveryDate] < '2021-04-22 00:00:00.000' and [Job] < 20000000 order by [JobDeliveryDate]).[Job] in (select * from [Order Options] with (nolock)where [Quote Date] > '2021-03-31 00:00:00.000' AND [Sections] = 'SUSPENSION/AXLES' AND [Description] LIKE '%Alum%').[WO#]
	--select * from B where B.[Job] in A.[WO#]

	--select  from SysproCompanyA.dbo.WipMaster with (nolock) where [JobDeliveryDate] > '2021-03-31 00:00:00.000' and [JobDeliveryDate] < '2021-04-22 00:00:00.000'
	
	--select * from [Order Options] with (nolock) where [Quote Date] > '2021-03-31 00:00:00.000' AND [Sections] = 'SUSPENSION/AXLES' AND [Description] LIKE '%Alum%'