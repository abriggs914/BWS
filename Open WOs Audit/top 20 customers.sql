use SysproCompanyA
go

select ArCustomer.Name, ArCustomer.Customer, 
ShipToAddr1, ShipToAddr2, ShipToAddr3, ShipToAddr4, ShipToAddr5, ArCustomer.ShipPostalCode,
case ArCustomer.Currency when '$' then 'CDN' else ArCustomer.Currency end as Country,
Contact, ArCustomer.Telephone, 
'N/A' as [Public/Private],
'N/A' as [Name of Parent Company],
'N/A' as [Website],
'N/A' as [Registration#],
CurrencyValue as InvoicePrice,
year(InvoiceDate) as InvoiceYear,
'N/A' as [Expected High A/R Balance],
'N/A' as [Currently Outstanding],
TblArTerms.[Description] as [Terms Offered to Buyers],
case ArCustomer.Currency when '$' then 'CDN' else ArCustomer.Currency end as Currency
into #CustomerData
from ArCustomer with (nolock)
inner join ArInvoice with (nolock) on ArCustomer.Customer = ArInvoice.Customer
left outer join TblArTerms with (nolock) on ArCustomer.TermsCode = TblArTerms.TermsCode
where InvoiceDate between '2020-04-01' and '2022-03-31'

select Name, #CustomerData.Customer, ShipToAddr1, ShipToAddr2, ShipToAddr3, ShipToAddr4, ShipToAddr5, ShipPostalCode, 
Country, Contact, Telephone, [Public/Private], [Name of Parent Company], [Website], [Registration#],
avg(InvoicePrice) as [Average Invoice Amount],
[Average Annual Invoice Amount], [Expected High A/R Balance], [Currently Outstanding], 
[Terms Offered to Buyers], 
'N/A' as [Average Payment Times],
Currency,
ROW_NUMBER() over (order by avg(InvoicePrice) desc) as [Rank]
into #finaldata
from #CustomerData
inner join (
            select Customer, avg([Total Annual Invoice Amount]) as [Average Annual Invoice Amount]
            from (
                select Customer, InvoiceYear, sum(InvoicePrice) as [Total Annual Invoice Amount]
                from #CustomerData
                group by Customer, InvoiceYear
                ) as mainsub
            group by Customer
            ) as subAvergeAnnual on #CustomerData.Customer = subAvergeAnnual.Customer
group by Name, #CustomerData.Customer, ShipToAddr1, ShipToAddr2, ShipToAddr3, ShipToAddr4, ShipToAddr5, ShipPostalCode,
Country, Contact, Telephone, [Public/Private], [Name of Parent Company], [Website], [Registration#],
[Average Annual Invoice Amount], [Average Annual Invoice Amount], [Expected High A/R Balance], [Currently Outstanding], 
[Terms Offered to Buyers], Currency
order by Customer

drop table #CustomerData

select * from #finaldata
where Rank <= 20

drop table #finaldata

use SysproCompanyS
go

select ArCustomer.Name, ArCustomer.Customer, 
ShipToAddr1, ShipToAddr2, ShipToAddr3, ShipToAddr4, ShipToAddr5, ArCustomer.ShipPostalCode,
case ArCustomer.Currency when '$' then 'CDN' else ArCustomer.Currency end as Country,
Contact, ArCustomer.Telephone, 
'N/A' as [Public/Private],
'N/A' as [Name of Parent Company],
'N/A' as [Website],
'N/A' as [Registration#],
CurrencyValue as InvoicePrice,
year(InvoiceDate) as InvoiceYear,
'N/A' as [Expected High A/R Balance],
'N/A' as [Currently Outstanding],
TblArTerms.[Description] as [Terms Offered to Buyers],
case ArCustomer.Currency when '$' then 'CDN' else ArCustomer.Currency end as Currency
into #CustomerData
from ArCustomer with (nolock)
inner join ArInvoice with (nolock) on ArCustomer.Customer = ArInvoice.Customer
left outer join TblArTerms with (nolock) on ArCustomer.TermsCode = TblArTerms.TermsCode
where InvoiceDate between '2020-04-01' and '2022-03-31'

select Name, #CustomerData.Customer, ShipToAddr1, ShipToAddr2, ShipToAddr3, ShipToAddr4, ShipToAddr5, ShipPostalCode, 
Country, Contact, Telephone, [Public/Private], [Name of Parent Company], [Website], [Registration#],
avg(InvoicePrice) as [Average Invoice Amount],
[Average Annual Invoice Amount], [Expected High A/R Balance], [Currently Outstanding], 
[Terms Offered to Buyers], 
'N/A' as [Average Payment Times],
Currency,
ROW_NUMBER() over (order by avg(InvoicePrice) desc) as [Rank]
into #finaldata
from #CustomerData
inner join (
            select Customer, avg([Total Annual Invoice Amount]) as [Average Annual Invoice Amount]
            from (
                select Customer, InvoiceYear, sum(InvoicePrice) as [Total Annual Invoice Amount]
                from #CustomerData
                group by Customer, InvoiceYear
                ) as mainsub
            group by Customer
            ) as subAvergeAnnual on #CustomerData.Customer = subAvergeAnnual.Customer
group by Name, #CustomerData.Customer, ShipToAddr1, ShipToAddr2, ShipToAddr3, ShipToAddr4, ShipToAddr5, ShipPostalCode,
Country, Contact, Telephone, [Public/Private], [Name of Parent Company], [Website], [Registration#],
[Average Annual Invoice Amount], [Average Annual Invoice Amount], [Expected High A/R Balance], [Currently Outstanding], 
[Terms Offered to Buyers], Currency
order by Customer

drop table #CustomerData

select * from #finaldata
where Rank <= 20

drop table #finaldata