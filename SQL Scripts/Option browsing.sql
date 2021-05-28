use BWSdb
go

select * from [Options] with (nolock) where [Description] like '%fender%' and [Description] like '%full%' and [Model No] like '%hdg%' order by [Model No]
select * from [Options] with (nolock) where [Description] like '%cover%' and [Description] like '%wheel%' and [Model No] like '%hdg%' order by [Model No]
select * from [Options] with (nolock) where [Sections] like '%light%' and [Model No] like '%hdg%' order by [Model No]
select * from [Options] with (nolock) where [Description] like '%tri%' and [Description] like '%drive%' order by [Model No]