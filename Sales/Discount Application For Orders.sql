DECLARE @tol DECIMAL(14, 4) = 0.5;
SELECT
	*
FROM (
	SELECT
		ABS([TotalDiscountsD1D2D3] - [TotalDiscountsD3D2D1]) AS [dA]
		,ABS([TotalDiscountsD1D2D3] - [TotalDiscountsFixedFirst]) AS [dB]
		,ABS([TotalDiscountsD1D2D3] - [TotalDiscountsPercentFirst]) AS [dC]
		,ABS([TotalDiscountsD3D2D1] - [TotalDiscountsFixedFirst]) AS [dD]
		,ABS([TotalDiscountsD3D2D1] - [TotalDiscountsPercentFirst]) AS [dE]
		,ABS([TotalDiscountsFixedFirst] - [TotalDiscountsPercentFirst]) AS [dF]
		,*
	FROM (
		SELECT
		*
		,CAST([TotalDiscountsMethod1] AS DECIMAL(14, 2)) AS [TotalDiscountsD1D2D3]
		,CAST([TotalDiscountsMethod2] AS DECIMAL(14, 2)) AS [TotalDiscountsD3D2D1]
		,CAST([TotalDiscountsMethod3] AS DECIMAL(14, 2)) AS [TotalDiscountsFixedFirst]
		,CAST([TotalDiscountsMethod4] AS DECIMAL(14, 2)) AS [TotalDiscountsPercentFirst]
			--SUM([TotalDiscountsMethod1]) AS [SumM1]
			--,SUM([TotalDiscountsMethod2]) AS [SumM2]
			--,SUM([TotalDiscountsMethod3]) AS [SumM3]
			--,SUM([TotalDiscountsMethod4]) AS [SumM4]
		FROM (
			SELECT
				COUNT(*) AS [Count]
			,SUM([O].[Price]) AS [TotalModelBasePrice]
					,SUM(CASE 
						WHEN ISNULL([O].[Discount1], 0) = 0 THEN 0
						ELSE (CASE
								WHEN ISNULL([O].[Discount1_Type], '') = 'Percent' THEN (-1 * ([O].[Discount1] * [O].[Price]))
								ELSE [O].[Discount1]
							END)
					END)
					+ SUM(CASE 
						WHEN ISNULL([O].[Discount2], 0) = 0 THEN 0
						ELSE (CASE
								WHEN ISNULL([O].[Discount2_Type], '') = 'Percent' THEN (-1 * ([O].[Discount2] * [O].[Price]))
								ELSE [O].[Discount2]
							END)
					END)
					+ SUM(CASE 
						WHEN ISNULL([O].[Discount3], 0) = 0 THEN 0
						ELSE (CASE
								WHEN ISNULL([O].[Discount3_Type], '') = 'Percent' THEN (-1 * ([O].[Discount3] * [O].[Price]))
								ELSE [O].[Discount3]
							END)
					END) AS [TotalDiscountsMethod1]  --(D1D2D3)
					,SUM(CASE 
						WHEN ISNULL([O].[Discount3], 0) = 0 THEN 0
						ELSE (CASE
								WHEN ISNULL([O].[Discount3_Type], '') = 'Percent' THEN (-1 * ([O].[Discount3] * [O].[Price]))
								ELSE [O].[Discount3]
							END)
					END)
					+ SUM(CASE 
						WHEN ISNULL([O].[Discount2], 0) = 0 THEN 0
						ELSE (CASE
								WHEN ISNULL([O].[Discount2_Type], '') = 'Percent' THEN (-1 * ([O].[Discount2] * [O].[Price]))
								ELSE [O].[Discount2]
							END)
					END)
					+ SUM(CASE 
						WHEN ISNULL([O].[Discount1], 0) = 0 THEN 0
						ELSE (CASE
								WHEN ISNULL([O].[Discount1_Type], '') = 'Percent' THEN (-1 * ([O].[Discount1] * [O].[Price]))
								ELSE [O].[Discount1]
							END)
					END) AS [TotalDiscountsMethod2]  --(D3D2D1)

					,SUM(
						(CASE WHEN ISNULL([O].[Discount1_Type], '') = 'Fixed' THEN [Discount1] ELSE 0 END)
						+ (CASE WHEN ISNULL([O].[Discount2_Type], '') = 'Fixed' THEN [Discount2] ELSE 0 END)
						+ (CASE WHEN ISNULL([O].[Discount3_Type], '') = 'Fixed' THEN [Discount3] ELSE 0 END)
					 + (-([O].[Price] 
						+ (CASE WHEN ISNULL([O].[Discount1_Type], '') = 'Fixed' THEN [Discount1] ELSE 0 END)
						+ (CASE WHEN ISNULL([O].[Discount2_Type], '') = 'Fixed' THEN [Discount2] ELSE 0 END)
						+ (CASE WHEN ISNULL([O].[Discount3_Type], '') = 'Fixed' THEN [Discount3] ELSE 0 END))

						* (CASE WHEN
							(ISNULL([Discount1_Type], '') = 'Percent' AND ISNULL([Discount1], 0) = 0)
							AND (ISNULL([Discount2_Type], '') = 'Percent' AND ISNULL([Discount2], 0) = 0) 
							AND (ISNULL([Discount3_Type], '') = 'Percent' AND ISNULL([Discount3], 0) = 0) THEN 0 -- No Discount
						ELSE
							(1 - 
							(CASE WHEN ISNULL([O].[Discount1_Type], '') = 'Percent' THEN (CASE WHEN [Discount1] = 0 THEN 1 ELSE (1 - [Discount1]) END) ELSE 1.0 END)
							* (CASE WHEN ISNULL([O].[Discount2_Type], '') = 'Percent' THEN (CASE WHEN [Discount2] = 0 THEN 1 ELSE (1 - [Discount2]) END) ELSE 1.0 END)
							* (CASE WHEN ISNULL([O].[Discount3_Type], '') = 'Percent' THEN (CASE WHEN [Discount3] = 0 THEN 1 ELSE (1 - [Discount3]) END) ELSE 1.0 END))
						END))
					) AS [TotalDiscountsMethod3]  --(Fixed First)

					,SUM(-([O].[Price] * 
		
						(CASE WHEN 
							(ISNULL([Discount1_Type], '') = 'Percent' AND ISNULL([Discount1], 0) = 0)
							AND (ISNULL([Discount2_Type], '') = 'Percent' AND ISNULL([Discount2], 0) = 0) 
							AND (ISNULL([Discount3_Type], '') = 'Percent' AND ISNULL([Discount3], 0) = 0) THEN 0 -- No Discount
						ELSE
							(1 - 
							(CASE WHEN ISNULL([O].[Discount1_Type], '') = 'Percent' THEN (CASE WHEN [Discount1] = 0 THEN 1 ELSE (1 - [Discount1]) END) ELSE 1.0 END)
							* (CASE WHEN ISNULL([O].[Discount2_Type], '') = 'Percent' THEN (CASE WHEN [Discount2] = 0 THEN 1 ELSE (1 - [Discount2]) END) ELSE 1.0 END)
							* (CASE WHEN ISNULL([O].[Discount3_Type], '') = 'Percent' THEN (CASE WHEN [Discount3] = 0 THEN 1 ELSE (1 - [Discount3]) END) ELSE 1.0 END))
						END))
						+ (CASE WHEN ISNULL([O].[Discount1_Type], '') = 'Fixed' THEN [Discount1] ELSE 0 END)
						+ (CASE WHEN ISNULL([O].[Discount2_Type], '') = 'Fixed' THEN [Discount2] ELSE 0 END)
						+ (CASE WHEN ISNULL([O].[Discount3_Type], '') = 'Fixed' THEN [Discount3] ELSE 0 END)
					) AS [TotalDiscountsMethod4]  --(Percent First)
					,[Price]
					,[Discount1]
					,[Discount2]
					,[Discount3]
		
		
					,
						(CASE WHEN ISNULL([O].[Discount1_Type], '') = 'Fixed' THEN [Discount1] ELSE 0 END)
						+ (CASE WHEN ISNULL([O].[Discount2_Type], '') = 'Fixed' THEN [Discount2] ELSE 0 END)
						+ (CASE WHEN ISNULL([O].[Discount3_Type], '') = 'Fixed' THEN [Discount3] ELSE 0 END) AS [A]
					 ,-([O].[Price] 
						+ (CASE WHEN ISNULL([O].[Discount1_Type], '') = 'Fixed' THEN [Discount1] ELSE 0 END)
						+ (CASE WHEN ISNULL([O].[Discount2_Type], '') = 'Fixed' THEN [Discount2] ELSE 0 END)
						+ (CASE WHEN ISNULL([O].[Discount3_Type], '') = 'Fixed' THEN [Discount3] ELSE 0 END)) AS [B]

						,(CASE WHEN
							(ISNULL([Discount1_Type], '') = 'Percent' AND ISNULL([Discount1], 0) = 0)
							AND (ISNULL([Discount2_Type], '') = 'Percent' AND ISNULL([Discount2], 0) = 0) 
							AND (ISNULL([Discount3_Type], '') = 'Percent' AND ISNULL([Discount3], 0) = 0) THEN 0 -- No Discount
						ELSE
							(1 - 
							(CASE WHEN ISNULL([O].[Discount1_Type], '') = 'Percent' THEN (CASE WHEN [Discount1] = 0 THEN 1 ELSE (1 - [Discount1]) END) ELSE 1.0 END)
							* (CASE WHEN ISNULL([O].[Discount2_Type], '') = 'Percent' THEN (CASE WHEN [Discount2] = 0 THEN 1 ELSE (1 - [Discount2]) END) ELSE 1.0 END)
							* (CASE WHEN ISNULL([O].[Discount3_Type], '') = 'Percent' THEN (CASE WHEN [Discount3] = 0 THEN 1 ELSE (1 - [Discount3]) END) ELSE 1.0 END))
						END) AS [C]
					--) AS [TotalDiscountsMethod3]  --(Fixed First)
		 
					,[Discount1_Type]
					,[Discount2_Type]
					,[Discount3_Type]

				FROM
					[v_SFC_BWSUnionSTGOrders] AS [O]
				GROUP BY
					[Price]
					,[Discount1]
					,[Discount2]
					,[Discount3]
					,[Discount1_Type]
					,[Discount2_Type]
					,[Discount3_Type]
		) AS [SrcA]
	) AS [SrcB]
	WHERE
		ABS([TotalDiscountsD1D2D3] - [TotalDiscountsD3D2D1]) > @tol
		OR ABS([TotalDiscountsD1D2D3] - [TotalDiscountsFixedFirst]) > @tol
		OR ABS([TotalDiscountsD1D2D3] - [TotalDiscountsPercentFirst]) > @tol
		OR ABS([TotalDiscountsD3D2D1] - [TotalDiscountsFixedFirst]) > @tol
		OR ABS([TotalDiscountsD3D2D1] - [TotalDiscountsPercentFirst]) > @tol
		OR ABS([TotalDiscountsFixedFirst] - [TotalDiscountsPercentFirst]) > @tol
) AS [SrcC]
ORDER BY
	(CASE 
		WHEN (([dA] >= [dB]) AND ([dA] >= [dC]) AND ([dA] >= [dD])) THEN [dA]
		WHEN (([dB] >= [dC]) AND ([dB] >= [dD])) THEN [dB]
		WHEN ([dC] >= [dD]) THEN [dC]
		ELSE [dD]
	END) DESC

--ORDER BY
--	(CASE WHEN 
--		ABS([TotalDiscountsD1D2D3] - [TotalDiscountsD3D2D1]) > ABS([TotalDiscountsD1D2D3] - [TotalDiscountsFixedFirst])
--		AND (ABS([TotalDiscountsD1D2D3] - [TotalDiscountsD3D2D1]) > ABS([TotalDiscountsD1D2D3] - [TotalDiscountsPercentFirst]))
--		AND (ABS([TotalDiscountsD1D2D3] - [TotalDiscountsD3D2D1]) > ABS([TotalDiscountsD3D2D1] - [TotalDiscountsFixedFirst]))
--		AND (ABS([TotalDiscountsD1D2D3] - [TotalDiscountsD3D2D1]) > ABS([TotalDiscountsD3D2D1] - [TotalDiscountsPercentFirst]))
--		AND (ABS([TotalDiscountsD1D2D3] - [TotalDiscountsD3D2D1]) > ABS([TotalDiscountsFixedFirst] - [TotalDiscountsPercentFirst]))
--	THEN ABS([TotalDiscountsD1D2D3] - [TotalDiscountsD3D2D1]) 

--	WHEN 
--		ABS([TotalDiscountsD1D2D3] - [TotalDiscountsD3D2D1]) > ABS([TotalDiscountsD1D2D3] - [TotalDiscountsFixedFirst])
--		AND (ABS([TotalDiscountsD1D2D3] - [TotalDiscountsD3D2D1]) > ABS([TotalDiscountsD1D2D3] - [TotalDiscountsPercentFirst]))
--		AND (ABS([TotalDiscountsD1D2D3] - [TotalDiscountsD3D2D1]) > ABS([TotalDiscountsD3D2D1] - [TotalDiscountsFixedFirst]))
--		AND (ABS([TotalDiscountsD1D2D3] - [TotalDiscountsD3D2D1]) > ABS([TotalDiscountsD3D2D1] - [TotalDiscountsPercentFirst]))
--		AND ABS([TotalDiscountsD1D2D3] - [TotalDiscountsFixedFirst]) > ABS([TotalDiscountsFixedFirst] - [TotalDiscountsPercentFirst]))
--	THEN ABS([TotalDiscountsD1D2D3] - [TotalDiscountsD3D2D1])


--	ELSE 
--		[TotalDiscountsD1D2D3]
--	END)
--	--(CASE WHEN (ABS([TotalDiscountsD1D2D3]) > ABS([TotalDiscountsD3D2D1]))
--	--	AND (ABS([TotalDiscountsD1D2D3]) > ABS([TotalDiscountsFixedFirst]))
--	--	AND (ABS([TotalDiscountsD1D2D3]) > ABS([TotalDiscountsPercentFirst]))
--	--THEN [TotalDiscountsD1D2D3] 
--	--WHEN (ABS([TotalDiscountsD3D2D1]) > ABS([TotalDiscountsD1D2D3]))
--	--	AND (ABS([TotalDiscountsD3D2D1]) > ABS([TotalDiscountsFixedFirst]))
--	--	AND (ABS([TotalDiscountsD3D2D1]) > ABS([TotalDiscountsPercentFirst]))
--	--THEN [TotalDiscountsD3D2D1] 
--	--WHEN (ABS([TotalDiscountsFixedFirst]) > ABS([TotalDiscountsD1D2D3]))
--	--	AND (ABS([TotalDiscountsFixedFirst]) > ABS([TotalDiscountsD3D2D1]))
--	--	AND (ABS([TotalDiscountsFixedFirst]) > ABS([TotalDiscountsPercentFirst]))
--	--THEN [TotalDiscountsFixedFirst]
--	--WHEN (ABS([TotalDiscountsPercentFirst]) > ABS([TotalDiscountsD1D2D3]))
--	--	AND (ABS([TotalDiscountsPercentFirst]) > ABS([TotalDiscountsD3D2D1]))
--	--	AND (ABS([TotalDiscountsPercentFirst]) > ABS([TotalDiscountsFixedFirst]))
--	--THEN [TotalDiscountsPercentFirst]
--	--ELSE 
--	--	[TotalDiscountsD1D2D3]
--	--END)