use SysproCompanyA
go

declare @parentpart varchar(30) = '48HF4X-102-26867',
--declare @parentpart varchar(30) = '48HF4X-102-26967',
--declare @parentpart varchar(30) = 'WO8082',
		@update int = 1, -- ******************************** CHANGE THIS IF YOU WANT THE UPDATE TO RUN (0 = no, 1 = yes) ********************************
		@delete int = 1 -- ******************************** CHANGE THIS IF YOU WANT THE DELETE STATEMENT TO RUN (0 = no, 1 = yes) ********************************

select * from InvMaster with (nolock)
where StockCode = @parentpart

print 'here 1'

if @delete = 1
	begin
		delete from BomStructure where ParentPart = @parentpart
	end 
	
print 'here 2'
if @update = 1
	begin
		insert into BomStructure  (ParentPart, Version, Release, Route, SequenceNum, Component, ComVersion, ComRelease, EccConsumption, StructureOnDate, StructureOffDate,
								   OpOffsetFlag, OperationOffset, QtyPer, ScrapPercentage, ScrapQuantity, SoOptionFlag, SoPrintFlag, InclScrapFlag, ReasonForChange, RefDesignator,
								   AssemblyPlace, ItemNumber, AutoNarrCode, ComponentType, InclKitIssues, CreateSubJob, WetWeightPercent, IncludeBatch, IncludeFromJob, IncludeToJob, FixedQtyPerFlag, FixedQtyPer,
								   RollUpCost, Warehouse, IgnoreFloorFlag, CoProductCostVal, UomFlag, QtyPerEnt, ScrapQuantityEnt, FixedQtyPerEnt)
		select @parentpart, '', '', '0', SeqNo, Component, '', '', '', null, null,
		'O', [Operation], Qty, 0, 0, 'N', 'N', 'N', '', '',
		'', '', 0, '', 'Y', '', 0, 'N', '', '', 'N', 0,
		'', '01', '', '', 'S', Qty, 0, 0
		from BWSdb.dbo.[BWSWOBOM_6867] with (nolock)
	end
	
print 'here 3'
select * from BomStructure with (nolock)
where ParentPart = @parentpart

use BWSdb
go

print 'here 4'
select count(*) as [26867 BOM] from [BWSWOBOM_6867] with (nolock)

/*
**************************************************************************************************************************************

SCRIPT FOR UPDDATING THE SEQUENCE NUMBER!!!!
use Stargatedb
go

--update [StargateWOBOM_9009-9010]
--set SeqNo = subOrder.SeqNo
--from [StargateWOBOM_9009-9010] with (nolock)
--inner join (select IDSGWO1,
--			right('000000' + cast(ROW_NUMBER() over(partition by Component order by IDSGWO1, Component) as varchar(6)), 6) as SeqNo
--			from [StargateWOBOM_9009-9010] with (nolock)) as subOrder on [StargateWOBOM_9009-9010].IDSGWO1 = subOrder.IDSGWO1

select * from [StargateWOBOM_9009-9010] with (nolock)

**************************************************************************************************************************************
*/