use uniPoint_Live
go

select File_Path, * from PT_QC_Doc with (nolock) ORDER BY [Doc_Name]


select File_Path, * from PT_QC_Doc with (nolock)
WHERE
	[Doc_Name] LIKE '%inspect%'
ORDER BY [Doc_Name]

select File_Path, * from PT_QC_Doc with (nolock)
WHERE
	[Doc_Num] LIKE '%031%'
ORDER BY [Doc_Name]