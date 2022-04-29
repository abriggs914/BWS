use SysproCompanyA
go

select InvMaster.StockCode, [Description], LongDesc, Warehouse,

sum(case when year(EntryDate) = 2021 and month(EntryDate) = 4 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [April 2021 Purchases],
avg(case when year(EntryDate) = 2021 and month(EntryDate) = 4 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [April 2021 Avg Unit Cost],
sum(case when year(EntryDate) = 2021 and month(EntryDate) = 4 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) * avg(case when year(EntryDate) = 2021 and month(EntryDate) = 4 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [April 2021 Cost],

sum(case when year(EntryDate) = 2021 and month(EntryDate) = 5 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [May 2021 Purchases],
avg(case when year(EntryDate) = 2021 and month(EntryDate) = 5 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [May 2021 Avg Unit Cost],
sum(case when year(EntryDate) = 2021 and month(EntryDate) = 5 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) * avg(case when year(EntryDate) = 2021 and month(EntryDate) = 5 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [May 2021 Cost],

sum(case when year(EntryDate) = 2021 and month(EntryDate) = 6 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [June 2021 Purchases],
avg(case when year(EntryDate) = 2021 and month(EntryDate) = 6 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [June 2021 Avg Unit Cost],
sum(case when year(EntryDate) = 2021 and month(EntryDate) = 6 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) * avg(case when year(EntryDate) = 2021 and month(EntryDate) = 6 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [June 2021 Cost],

sum(case when year(EntryDate) = 2021 and month(EntryDate) = 7 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [July 2021 Purchases],
avg(case when year(EntryDate) = 2021 and month(EntryDate) = 7 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [July 2021 Avg Unit Cost],
sum(case when year(EntryDate) = 2021 and month(EntryDate) = 7 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) * avg(case when year(EntryDate) = 2021 and month(EntryDate) = 7 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [July 2021 Cost],

sum(case when year(EntryDate) = 2021 and month(EntryDate) = 8 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [August 2021 Purchases],
avg(case when year(EntryDate) = 2021 and month(EntryDate) = 8 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [August 2021 Avg Unit Cost],
sum(case when year(EntryDate) = 2021 and month(EntryDate) = 8 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) * avg(case when year(EntryDate) = 2021 and month(EntryDate) = 8 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [August 2021 Cost],

sum(case when year(EntryDate) = 2021 and month(EntryDate) = 9 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [September 2021 Purchases],
avg(case when year(EntryDate) = 2021 and month(EntryDate) = 9 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [September 2021 Avg Unit Cost],
sum(case when year(EntryDate) = 2021 and month(EntryDate) = 9 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) * avg(case when year(EntryDate) = 2021 and month(EntryDate) = 9 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [September 2021 Cost],

sum(case when year(EntryDate) = 2021 and month(EntryDate) = 10 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [October 2021 Purchases],
avg(case when year(EntryDate) = 2021 and month(EntryDate) = 10 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [October 2021 Avg Unit Cost],
sum(case when year(EntryDate) = 2021 and month(EntryDate) = 10 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) * avg(case when year(EntryDate) = 2021 and month(EntryDate) = 10 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [October 2021 Cost],

sum(case when year(EntryDate) = 2021 and month(EntryDate) = 11 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [November 2021 Purchases],
avg(case when year(EntryDate) = 2021 and month(EntryDate) = 11 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [November 2021 Avg Unit Cost],
sum(case when year(EntryDate) = 2021 and month(EntryDate) = 11 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) * avg(case when year(EntryDate) = 2021 and month(EntryDate) = 11 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [November 2021 Cost],

sum(case when year(EntryDate) = 2021 and month(EntryDate) = 12 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [December 2021 Purchases],
avg(case when year(EntryDate) = 2021 and month(EntryDate) = 12 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [December 2021 Avg Unit Cost],
sum(case when year(EntryDate) = 2021 and month(EntryDate) = 12 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) * avg(case when year(EntryDate) = 2021 and month(EntryDate) = 12 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [December 2021 Cost],

sum(case when year(EntryDate) = 2022 and month(EntryDate) = 1 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [January 2022 Purchases],
avg(case when year(EntryDate) = 2022 and month(EntryDate) = 1 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [January 2022 Avg Unit Cost],
sum(case when year(EntryDate) = 2022 and month(EntryDate) = 1 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) * avg(case when year(EntryDate) = 2022 and month(EntryDate) = 1 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [January 2022 Cost],

sum(case when year(EntryDate) = 2022 and month(EntryDate) = 2 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [February 2022 Purchases],
avg(case when year(EntryDate) = 2022 and month(EntryDate) = 2 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [February 2022 Avg Unit Cost],
sum(case when year(EntryDate) = 2022 and month(EntryDate) = 2 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) * avg(case when year(EntryDate) = 2022 and month(EntryDate) = 2 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [February 2022 Cost],

sum(case when year(EntryDate) = 2022 and month(EntryDate) = 3 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [March 2022 Purchases], -- unit cost
avg(case when year(EntryDate) = 2022 and month(EntryDate) = 3 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [March 2022 Avg Unit Cost], -- unit cost
sum(case when year(EntryDate) = 2022 and month(EntryDate) = 3 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) * avg(case when year(EntryDate) = 2022 and month(EntryDate) = 3 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [March 2022 Cost]
from InvMovements with (nolock)
left outer join InvMaster with (nolock) on InvMovements.StockCode = InvMaster.StockCode
where (
        (Warehouse not in ('02', '03', '06', '99') and MovementType = 'I' and TrnType = 'R')
)
and EntryDate between '2021-04-01' and '2022-03-31'
group by InvMaster.StockCode, [Description], LongDesc, Warehouse

use SysproCompanyS
go

select InvMaster.StockCode, [Description], LongDesc, Warehouse,
sum(case when year(EntryDate) = 2021 and month(EntryDate) = 4 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [April 2021 Purchases],
sum(case when year(EntryDate) = 2021 and month(EntryDate) = 5 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [May 2021 Purchases],
sum(case when year(EntryDate) = 2021 and month(EntryDate) = 6 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [June 2021 Purchases],
sum(case when year(EntryDate) = 2021 and month(EntryDate) = 7 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [July 2021 Purchases],
sum(case when year(EntryDate) = 2021 and month(EntryDate) = 8 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [August 2021 Purchases],
sum(case when year(EntryDate) = 2021 and month(EntryDate) = 9 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [September 2021 Purchases],
sum(case when year(EntryDate) = 2021 and month(EntryDate) = 10 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [October 2021 Purchases],
sum(case when year(EntryDate) = 2021 and month(EntryDate) = 11 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [November 2021 Purchases],
sum(case when year(EntryDate) = 2021 and month(EntryDate) = 12 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [December 2021 Purchases],
sum(case when year(EntryDate) = 2022 and month(EntryDate) = 1 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [January 2022 Purchases],
sum(case when year(EntryDate) = 2022 and month(EntryDate) = 2 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [February 2022 Purchases],
sum(case when year(EntryDate) = 2022 and month(EntryDate) = 3 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [March 2022 Purchases]
from InvMovements with (nolock)
left outer join InvMaster with (nolock) on InvMovements.StockCode = InvMaster.StockCode
where (
        (Warehouse not in ('02', '03', '99') and MovementType = 'I' and TrnType = 'R')
)
and EntryDate between '2021-04-01' and '2022-03-31'
group by InvMaster.StockCode, [Description], LongDesc, Warehouse
