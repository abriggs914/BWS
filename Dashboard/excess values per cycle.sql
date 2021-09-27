USE SysproCompanyA
GO

select CycleCount, [Excess Value] as [Excess$], *
from v_ExcessInventoryPrint

select CycleCount, sum([Excess Value]) as [Excess$]
from v_ExcessInventoryPrint
group by CycleCount

select CycleCount, 
case sum([Excess Value]) when 0 then 0.00 else sum([Excess Value]) / sum([Value On Hand]) end as [Excess%]
from v_ExcessInventoryPrint
group by CycleCount