USE [SysproCompanyA]
GO

--/****** Object:  View [dbo].[v_CompletedJobInfo]    Script Date: 2022-10-04 1:06:11 PM ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO



----2022-09-28 James Crawford - Added where clause to exclude 3 Half Round Work Orders from reports: 10015030 - 10015032
----IT Request #001197

--ALTER view [dbo].[v_CompletedJobInfo] as

--NEW VERSION
SELECT * FROM (
select WipMaster.Job, subA.[Sales Order#] as [Sales Order#], InvoiceNumber, 
EntInvoiceDate, PaidDate, 
case when WipMaster.Job = '10012555' and subA.[Sales Order#] = '510787' then EntInvoiceDate
	 when WipMaster.Job = '10012883' and subA.[Sales Order#] = '510989' then '2018-04-20 00:00:00.000'
	 else ActCompleteDate end as ActCompleteDate, 
ExchangeRate
from BWSdb.dbo.Orders with (nolock)
inner join WipMaster with (nolock) on cast(Orders.WO# as varchar(20)) = WipMaster.Job
left outer join (select WipMaster.Job, 
				 c.[Sales Order#] as [Sales Order#], 
				 case when b.EntInvoice is null then a.EntInvoice when WipMaster.Job = '10010454' then a.EntInvoice else b.EntInvoice end as InvoiceNumber, 
				 case when b.EntInvoiceDate is null then a.EntInvoiceDate when WipMaster.Job = '10010454' then a.EntInvoiceDate else b.EntInvoiceDate end as EntInvoiceDate,
				 PaidDate,
				 case when b.ExchangeRate is null then a.ExchangeRate when WipMaster.Job = '10010454' then a.ExchangeRate else b.ExchangeRate end as ExchangeRate
				 from [CusSorMaster+] with (nolock)
				 inner join BWSdb.dbo.Orders with (nolock) on [CusSorMaster+].AccessQuote = cast(Orders.Quote# as varchar(99))
				 -- Jan 20, 2020 - Added function to SalesOrder to ensure sales order critiera still works! WILL NEED TO CHANGE IN FUTURE IF LEADING ZEROS ARE REMOVED FROM FIELDS!!! - James Crawford
				 -- function reference: https://stackoverflow.com/questions/28379337/removing-leading-zeros-from-a-string-in-sql-server-2008-r2
				 inner join (select [CusSorMaster+].AccessQuote, max(case when b.SalesOrder is null and REPLACE(LTRIM(REPLACE(a.SalesOrder, '0', ' ')), ' ', '0') like '5%' then a.SalesOrder 
																		  when REPLACE(LTRIM(REPLACE(b.SalesOrder, '0', ' ')), ' ', '0') like '5%' then b.SalesOrder else null end) as [Sales Order#] from [CusSorMaster+] with (nolock)
							 left outer join SorMaster as a with (nolock) on [CusSorMaster+].SalesOrder = a.SalesOrder
							 left outer join SorMasterRep as b with (nolock) on [CusSorMaster+].SalesOrder = b.SalesOrder
							 group by [CusSorMaster+].AccessQuote) as c on [CusSorMaster+].SalesOrder = c.[Sales Order#]
				 left outer join SorMaster as a with (nolock) on c.[Sales Order#] = a.SalesOrder
				 left outer join SorMasterRep as b with (nolock) on c.[Sales Order#] = b.SalesOrder
				 inner join WipMaster with (nolock) on cast(Orders.WO# as varchar(20)) = WipMaster.Job
				 left outer join (select Invoice, min(JournalDate) as PaidDate from ArInvoicePay with (nolock)
								  group by Invoice) as d on (case when b.EntInvoice is null then a.EntInvoice when WipMaster.Job = '10010454' then a.EntInvoice else b.EntInvoice end) = d.Invoice) as subA on WipMaster.Job = subA.Job
where (case when subA.[Sales Order#] is null then 0 else len(subA.[Sales Order#]) end)
	+ (case when ActCompleteDate is null then 0 else len(ActCompleteDate) end) <> 0
and (InvoiceNumber not in ('509104', '509152', '509259', '509214', 511871) or InvoiceNumber is null) --Excluded 511871 as it was a backorder invoice - JWC - 2022-03-31
and WipMaster.Job not in ('10015030', '10015031', '10015032')
) AS [SrcA]

LEFT JOIN (

select DISTINCT WipMaster.Job, subA.[Sales Order#] as [Sales Order#], InvoiceNumber, 
EntInvoiceDate, PaidDate, 
case when WipMaster.Job = '10012555' and subA.[Sales Order#] = '510787' then EntInvoiceDate
	 when WipMaster.Job = '10012883' and subA.[Sales Order#] = '510989' then '2018-04-20 00:00:00.000'
	 else ActCompleteDate end as ActCompleteDate, 
ExchangeRate
from BWSdb.dbo.Orders with (nolock)
inner join WipMaster with (nolock) on cast(Orders.WO# as varchar(20)) = WipMaster.Job
left outer join (select WipMaster.Job, 
				 c.[Sales Order#] as [Sales Order#], 
				 case when b.EntInvoice is null then a.EntInvoice when WipMaster.Job = '10010454' then a.EntInvoice else b.EntInvoice end as InvoiceNumber, 
				 case when b.EntInvoiceDate is null then a.EntInvoiceDate when WipMaster.Job = '10010454' then a.EntInvoiceDate else b.EntInvoiceDate end as EntInvoiceDate,
				 PaidDate,
				 case when b.ExchangeRate is null then a.ExchangeRate when WipMaster.Job = '10010454' then a.ExchangeRate else b.ExchangeRate end as ExchangeRate
				 from [CusSorMaster+] with (nolock)
				 inner join BWSdb.dbo.Orders with (nolock) on [CusSorMaster+].AccessQuote = cast(Orders.Quote# as varchar(99))
				 -- Jan 20, 2020 - Added function to SalesOrder to ensure sales order critiera still works! WILL NEED TO CHANGE IN FUTURE IF LEADING ZEROS ARE REMOVED FROM FIELDS!!! - James Crawford
				 -- function reference: https://stackoverflow.com/questions/28379337/removing-leading-zeros-from-a-string-in-sql-server-2008-r2
				 inner join (select [CusSorMaster+].AccessQuote, max(case when b.SalesOrder is null and REPLACE(LTRIM(REPLACE(a.SalesOrder, '0', ' ')), ' ', '0') like '5%' then a.SalesOrder 
																		  when REPLACE(LTRIM(REPLACE(b.SalesOrder, '0', ' ')), ' ', '0') like '5%' then b.SalesOrder else null end) as [Sales Order#] from [CusSorMaster+] with (nolock)
							 left outer join SorMaster as a with (nolock) on [CusSorMaster+].SalesOrder = a.SalesOrder
							 left outer join SorMasterRep as b with (nolock) on [CusSorMaster+].SalesOrder = b.SalesOrder
							 group by [CusSorMaster+].AccessQuote) as c on [CusSorMaster+].SalesOrder = c.[Sales Order#]
				 left outer join SorMaster as a with (nolock) on c.[Sales Order#] = a.SalesOrder
				 left outer join SorMasterRep as b with (nolock) on c.[Sales Order#] = b.SalesOrder
				 inner join WipMaster with (nolock) on cast(Orders.WO# as varchar(20)) = WipMaster.Job
				 left outer join (select Invoice, min(JournalDate) as PaidDate from ArInvoicePay with (nolock)
								  group by Invoice) as d on (case when b.EntInvoice is null then a.EntInvoice when WipMaster.Job = '10010454' then a.EntInvoice else b.EntInvoice end) = d.Invoice) as subA on WipMaster.Job = subA.Job
where (case when subA.[Sales Order#] is null then 0 else len(subA.[Sales Order#]) end)
	+ (case when ActCompleteDate is null then 0 else len(ActCompleteDate) end) <> 0
and (InvoiceNumber not in ('509104', '509152', '509259', '509214', 511871) or InvoiceNumber is null) --Excluded 511871 as it was a backorder invoice - JWC - 2022-03-31
and WipMaster.Job not in ('10015030', '10015031', '10015032')
) AS [SrcB]
ON
	[SrcA].[Job] = [SrcB].[Job]
WHERE
	[SrcB].[Job] IS NULL
ORDER BY
	[SrcA].[Job]



	select WipMaster.Job, subA.[Sales Order#] as [Sales Order#], InvoiceNumber, 
EntInvoiceDate, PaidDate, 
case when WipMaster.Job = '10012555' and subA.[Sales Order#] = '510787' then EntInvoiceDate
	 when WipMaster.Job = '10012883' and subA.[Sales Order#] = '510989' then '2018-04-20 00:00:00.000'
	 else ActCompleteDate end as ActCompleteDate, 
ExchangeRate
from BWSdb.dbo.Orders with (nolock)
inner join WipMaster with (nolock) on cast(Orders.WO# as varchar(20)) = WipMaster.Job
left outer join (select WipMaster.Job, 
				 c.[Sales Order#] as [Sales Order#], 
				 case when b.EntInvoice is null then a.EntInvoice when WipMaster.Job = '10010454' then a.EntInvoice else b.EntInvoice end as InvoiceNumber, 
				 case when b.EntInvoiceDate is null then a.EntInvoiceDate when WipMaster.Job = '10010454' then a.EntInvoiceDate else b.EntInvoiceDate end as EntInvoiceDate,
				 PaidDate,
				 case when b.ExchangeRate is null then a.ExchangeRate when WipMaster.Job = '10010454' then a.ExchangeRate else b.ExchangeRate end as ExchangeRate
				 from [CusSorMaster+] with (nolock)
				 inner join BWSdb.dbo.Orders with (nolock) on [CusSorMaster+].AccessQuote = cast(Orders.Quote# as varchar(99))
				 -- Jan 20, 2020 - Added function to SalesOrder to ensure sales order critiera still works! WILL NEED TO CHANGE IN FUTURE IF LEADING ZEROS ARE REMOVED FROM FIELDS!!! - James Crawford
				 -- function reference: https://stackoverflow.com/questions/28379337/removing-leading-zeros-from-a-string-in-sql-server-2008-r2
				 inner join (select [CusSorMaster+].AccessQuote, max(case when b.SalesOrder is null and REPLACE(LTRIM(REPLACE(a.SalesOrder, '0', ' ')), ' ', '0') like '5%' then a.SalesOrder 
																		  when REPLACE(LTRIM(REPLACE(b.SalesOrder, '0', ' ')), ' ', '0') like '5%' then b.SalesOrder else null end) as [Sales Order#] from [CusSorMaster+] with (nolock)
							 left outer join SorMaster as a with (nolock) on [CusSorMaster+].SalesOrder = a.SalesOrder
							 left outer join SorMasterRep as b with (nolock) on [CusSorMaster+].SalesOrder = b.SalesOrder
							 group by [CusSorMaster+].AccessQuote) as c on [CusSorMaster+].SalesOrder = c.[Sales Order#]
				 left outer join SorMaster as a with (nolock) on c.[Sales Order#] = a.SalesOrder
				 left outer join SorMasterRep as b with (nolock) on c.[Sales Order#] = b.SalesOrder
				 inner join WipMaster with (nolock) on cast(Orders.WO# as varchar(20)) = WipMaster.Job
				 left outer join (select Invoice, min(JournalDate) as PaidDate from ArInvoicePay with (nolock)
								  group by Invoice) as d on (case when b.EntInvoice is null then a.EntInvoice when WipMaster.Job = '10010454' then a.EntInvoice else b.EntInvoice end) = d.Invoice) as subA on WipMaster.Job = subA.Job
where (case when subA.[Sales Order#] is null then 0 else len(subA.[Sales Order#]) end)
	+ (case when ActCompleteDate is null then 0 else len(ActCompleteDate) end) <> 0
and (InvoiceNumber not in ('509104', '509152', '509259', '509214', 511871) or InvoiceNumber is null) --Excluded 511871 as it was a backorder invoice - JWC - 2022-03-31
and WipMaster.Job not in ('10015030', '10015031', '10015032')
GROUP BY
		WipMaster.Job, [subA].[Sales Order#], InvoiceNumber, 
	EntInvoiceDate, PaidDate, 
	--case when WipMaster.Job = '10012555' and subA.[Sales Order#] = '510787' then EntInvoiceDate
	--	 when WipMaster.Job = '10012883' and subA.[Sales Order#] = '510989' then '2018-04-20 00:00:00.000'
	--	 else ActCompleteDate end as
	ActCompleteDate, 
	ExchangeRate
HAVING 
	COUNT(*) > 1


/*
--old version
select WipMaster.Job, 
c.[Sales Order#] as [Sales Order#], 
case when b.EntInvoice is null then a.EntInvoice when WipMaster.Job = '10010454' then a.EntInvoice else b.EntInvoice end as InvoiceNumber, 
case when b.EntInvoiceDate is null then a.EntInvoiceDate when WipMaster.Job = '10010454' then a.EntInvoiceDate else b.EntInvoiceDate end as EntInvoiceDate,
PaidDate, ActCompleteDate, 
case when b.ExchangeRate is null then a.ExchangeRate when WipMaster.Job = '10010454' then a.ExchangeRate else b.ExchangeRate end as ExchangeRate
from AdmFormData
inner join BWSdb.dbo.Orders on AdmFormData.AlphaValue = cast(Orders.Quote# as char(100))
inner join (select AdmFormData.AlphaValue, max(case when b.SalesOrder is null and a.SalesOrder like '5%' then a.SalesOrder when b.SalesOrder like '5%' then b.SalesOrder else null end) as [Sales Order#] from AdmFormData
			left outer join SorMaster as a on AdmFormData.KeyField = cast(a.SalesOrder as char(80))
			left outer join SorMasterRep as b on AdmFormData.KeyField = cast(b.SalesOrder as char(80))
			group by AdmFormData.AlphaValue) as c on AdmFormData.KeyField = cast(c.[Sales Order#] as char(80))
left outer join SorMaster as a on c.[Sales Order#] = a.SalesOrder
left outer join SorMasterRep as b on c.[Sales Order#] = b.SalesOrder
inner join WipMaster on cast(Orders.WO# as varchar(20)) = WipMaster.Job
left outer join (select Invoice, min(JournalDate) as PaidDate from ArInvoicePay
				 group by Invoice) as d on (case when b.EntInvoice is null then a.EntInvoice when WipMaster.Job = '10010454' then a.EntInvoice else b.EntInvoice end) = d.Invoice
--group by WipMaster.Job, c.[Sales Order#], a.EntInvoice, a.EntInvoiceDate, b.EntInvoice, b.EntInvoiceDate, ActCompleteDate, a.ExchangeRate, b.ExchangeRate

--select WipMaster.Job, Orders.[Sales Order#], EntInvoice as InvoiceNumber, SorMaster.EntInvoiceDate, ActCompleteDate, SorMaster.ExchangeRate
--from WipMaster
--inner join BWSdb.dbo.Orders on WipMaster.Job = cast(Orders.WO# as varchar(20)) collate Latin1_General_BIN
--left outer join SorMaster on Orders.[Sales Order#] = SorMaster.SalesOrder and right(WipMaster.Job, 5) = SorMaster.SpecialInstrs
/*where InvoiceNumber = any (select [IN] from (select SalesOrder, SpecialInstrs, max(InvoiceNumber) as [IN] from SorMasterRep
						 group by SalesOrder, SpecialInstrs) as subA group by [IN])
or InvoiceNumber is null*/
*/


--GO


