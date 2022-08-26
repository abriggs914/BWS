USE BWSdb
GO
SELECT
                            MAX(CAST([BWSdb].[dbo].[TrailingDigits](RIGHT([Serial Number], 6)) AS INTEGER)) AS [X]
                        from 
                            Orders with (nolock)
                        cross join
                            [SNC Year] with (nolock)
                        where
                            [Year] = 2023
                            AND LEN([Serial Number]) = 17
                            AND CHARINDEX(' ', [Serial Number]) = 0
                            and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A%'
                        ;


SELECT * FROM [Orders] WHERE [Quote#] = 24545
SELECT * FROM [SN Type] WHERE [Model No] = 'Dump SF4X'