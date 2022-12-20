use SysproCompanyA
go

select *
from 
    ArInvoice with (nolock)
WHERE
    Invoice in ('512756', '512770')

select *
from 
    SorMasterRep with (nolock)
WHERE
    InvoiceNumber in ('512756', '512770')

select *
FROM
    ArInvoiceReference with (nolock)
WHERE
    Invoice in ('512756', '512770')


--SELECT * FROM [BWSdb].[dbo].[]


SELECT
	[Invoice #]
FROM
	[BWSdb].[dbo].[Orders] WITH (NOLOCK)
WHERE
    [Invoice #] IN ('512756', '512770')


;

SELECT
	*
FROM
	[BWSdb].[dbo].[Orders] WITH (NOLOCK)
WHERE
	RIGHT(CAST([WO#] AS NVARCHAR(MAX)), 5) = '15714'
;


SELECT
	*
FROM
	[BWSdb].[dbo].[Production] WITH (NOLOCK)
WHERE
	RIGHT(CAST([WO#] AS NVARCHAR(MAX)), 5) = '15714'
;

