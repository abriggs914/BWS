use BWSdb
go

SELECT [IDTrailer], [Grouping], [Class], [Model], [Model No], [Non-Current], [Proposed]
FROM [BWSdb].[dbo].[ProductsV2] 
WHERE [CompanyID] = 1 
GROUP BY [IDTrailer], [Grouping], [Class], [Model], [Model No], [Non-Current], [Proposed]
ORDER BY [Class]