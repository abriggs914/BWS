USE BWSdb
GO

--SELECT * FROM [Dealers] ORDER BY [COMPANY NAME]


CREATE PROCEDURE [dbo].[DealerStatusReportSlotReport]
	@dealer as VARCHAR(50)
AS
BEGIN
select 
	1 as QueryID,
	Slot#,
	null,
	null,
	[Slot Types],
	'Confirm Quote by ' + DATENAME(MONTH, case when [Prod Date 1] is null then dateadd(day, -120, [Prod Date 2]) else dateadd(day, -120, [Prod Date 1]) end) + ' '
                                                   + cast(DATEPART(day, case when [Prod Date 1] is null then dateadd(day, -120, [Prod Date 2]) else dateadd(day, -120, [Prod Date 1]) end) as nvarchar) + ', '
                                                   + cast(DATEPART(year, case when [Prod Date 1] is null then dateadd(day, -120, [Prod Date 2]) else dateadd(day, -120, [Prod Date 1]) end) as nvarchar) as SerialNumber,
	null,
	null,
	@dealer,
	null,
	null,
	null,
	dbo.fn_SlotEstimatedDeliveryDate(case when [Prod Date 1] is null then [Prod Date 2] else [Prod Date 1] end) as DeliveryDate,
	null,
	null,
	null,
	null,
	null,
	null,
	null,
	null,
	null,
	null,
	null,
	null,
	null,
	null
from
	dtProductionSchedule with (nolock)
inner join
	[Production Slots] with (nolock)
on
	dtProductionSchedule.Slot# = [Production Slots].PSlotID#
inner join
	Dealers with (nolock)
on
	[Production Slots].Dealer = Dealers.ID
where
	dtProductionSchedule.Quote# is null
	and [Slot/Quote] = 1
	and [COMPANY NAME] = @dealer
END