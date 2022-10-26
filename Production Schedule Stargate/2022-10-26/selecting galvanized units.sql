select *
						from (
								select distinct SGQuote
								from [Order OptionsV2_SpecLines] with (nolock)
								where SpecGroup = 'GENERAL SPECIFICATIONS'
								and SpecSection = 'Color'
								and SpecSortSeLine = 0
								and lower([SpecDescription]) like '%galv%'

								union all select distinct SGQuote
								from [Custom WorkV2_SpecLines] with (nolock)
								where SpecGroup = 'GENERAL SPECIFICATIONS'
								and SpecSection = 'Color'
								and SpecSortSeLine = 0
								and lower([SpecDescription]) like '%galv%'
							) as galvoptionsandnpos
LEFT JOIN
	[BWSdb].[dbo].[OrdersV2]
ON
	[galvoptionsandnpos].SGQuote = [OrdersV2].[SGQuote] 