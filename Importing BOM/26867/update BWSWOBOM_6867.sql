use BWSdb
go

declare @update int = 0 -- ******************************** CHANGE THIS IF YOU WANT THE UPDATE TO RUN (0 = no, 1 = yes) ********************************

if @update = 1 
	begin
		update [BWSWOBOM_6867]
		set SeqNo = subOrder.SeqNo
		from [BWSWOBOM_6867] with (nolock)
		inner join (select IDSGWO267,
					right('000000' + cast(ROW_NUMBER() over(partition by Component order by IDSGWO267, Component) as varchar(6)), 6) as SeqNo
					from [BWSWOBOM_6867] with (nolock)) as subOrder on [BWSWOBOM_6867].IDSGWO267 = subOrder.IDSGWO267
	end

select * from [BWSWOBOM_6867] with (nolock)

/*

****************************************************************************************************************************************************

-----------------------------------------------------------------------------------------------------------------------
SCRIPT TO CHECK FOR EXISTING COMPONENTS AND STOCK CODES (WHEN SARAH DOES NOT WANT YOU TO OVERWRITE EXISTING ENTRIES!!!)
-----------------------------------------------------------------------------------------------------------------------

use SysproCompanyS
go

select * from BomStructure with (nolock)
inner join Stargatedb.dbo.StargateWOBOM_8082-3 with (nolock) on BomStructure.SequenceNum = StargateWOBOM_8082-3.SeqNo collate Latin1_General_BIN
														 and BomStructure.Component = StargateWOBOM_8082-3.Component collate Latin1_General_BIN
where ParentPart = 'WO8082-3'
and Route = '0'

select * from Stargatedb.dbo.StargateWOBOM_8082-3 with (nolock)
order by SeqNo, Component

select * from BomStructure with (nolock)
where ParentPart = 'WO8082-3'
and Route = '0'
order by SequenceNum, Component

****************************************************************************************************************************************************

*/