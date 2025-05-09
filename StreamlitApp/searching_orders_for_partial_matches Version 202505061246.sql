

-- Version 202505061246

--DECLARE @st NVARCHAR(MAX) = '2SVS69434TM000233;2s9da6354pm119747;sg1000581';
--DECLARE @st NVARCHAR(MAX) = '2S9DA6354PM119747;2SVS69434TM000233;2S9DA64634M115319;2S9DA2144YM115038;2S9DA6468HM117329';
--DECLARE @st NVARCHAR(MAX) = '2S9DA6354PM119747;2SVS69434TM000233;2SVS6P434TM000233;2S9DA64634M115319;2S9DA2144YM115038;2S9DA6468HM117329';
--DECLARE @st NVARCHAR(MAX) = '4TM000233;2XBB6VY24TA000252;avery briggs';
DECLARE @st NVARCHAR(MAX) = '1000077;00077';
DECLARE @delim NVARCHAR(50) = ';';
DECLARE @allowPartial BIT = 1;

DECLARE @checkQuote BIT = 1;
DECLARE @checkWO BIT = 1;
DECLARE @checkSerial BIT = 1;
DECLARE @checkModelNo BIT = 1;
DECLARE @checkSpecialInstructions BIT = 1;
DECLARE @checkNotes BIT = 1;
DECLARE @checkEngNotes BIT = 1;
DECLARE @checkCustomerWO BIT = 1;
DECLARE @checkSO BIT = 1;
DECLARE @checkInvoice BIT = 1;

SELECT
	*
FROM
	[BWSdb].[dbo].[split_string_idx](@st, @delim)

SELECT
	'BWS' AS [Comp],
	CAST([Quote#] AS NVARCHAR(MAX)) AS [Quote]
FROM
	[BWSdb].[dbo].[Orders] [O]
CROSS JOIN
	[BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
WHERE
	(
		(CASE 
			WHEN @checkQuote = 1 THEN (
				CASE
					WHEN (CAST([O].[Quote#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 
					WHEN @allowPartial = 1 THEN (
						CASE
							WHEN LOWER(CAST([O].[Quote#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 1
							ELSE 0
						END)
					ELSE 0 
				END)
			ELSE 0
		END) = 1
	)
	OR (
		(CASE 
			WHEN @checkWO = 1 THEN (
				CASE
					WHEN (CAST([O].[WO#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 
					WHEN @allowPartial = 1 THEN (
						CASE
							WHEN LOWER(CAST([O].[WO#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 1
							ELSE 0
						END)
					ELSE 0 
				END)
			ELSE 0
		END) = 1
	)
	OR (
		(CASE 
			WHEN @checkSerial = 1 THEN (
				CASE
					WHEN ([O].[Serial Number] = [Splt].[splited_data]) THEN 1 
					WHEN @allowPartial = 1 THEN (
						CASE
							WHEN LOWER([O].[Serial Number]) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 1
							ELSE 0
						END)
					ELSE 0 
				END)
			ELSE 0
		END) = 1
	)
	OR (
		(CASE 
			WHEN @checkModelNo = 1 THEN (
				CASE
					WHEN ([O].[Model No] = [Splt].[splited_data]) THEN 1 
					WHEN @allowPartial = 1 THEN (
						CASE
							WHEN LOWER([O].[Model No]) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 1
							ELSE 0
						END)
					ELSE 0 
				END)
			ELSE 0
		END) = 1
	)
	OR (
		(CASE 
			WHEN @checkNotes = 1 THEN (
				CASE
					WHEN ([O].[Notes] = [Splt].[splited_data]) THEN 1 
					WHEN @allowPartial = 1 THEN (
						CASE
							WHEN LOWER([O].[Notes]) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 1
							ELSE 0
						END)
					ELSE 0 
				END)
			ELSE 0
		END) = 1
	)
	OR (
		(CASE 
			WHEN @checkSpecialInstructions = 1 THEN (
				CASE
					WHEN ([O].[Special Instructions] = [Splt].[splited_data]) THEN 1 
					WHEN @allowPartial = 1 THEN (
						CASE
							WHEN LOWER([O].[Special Instructions]) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 1
							ELSE 0
						END)
					ELSE 0 
				END)
			ELSE 0
		END) = 1
	)
	OR (
		(CASE 
			WHEN @checkEngNotes = 1 THEN (
				CASE
					WHEN (CAST([O].[EngNotes] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 
					WHEN @allowPartial = 1 THEN (
						CASE
							WHEN LOWER(CAST([O].[EngNotes] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 1
							ELSE 0
						END)
					ELSE 0 
				END)
			ELSE 0
		END) = 1
	)
	OR (
		(CASE 
			WHEN @checkCustomerWO = 1 THEN (
				CASE
					WHEN (CAST([O].[Customer WO#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 
					WHEN @allowPartial = 1 THEN (
						CASE
							WHEN LOWER(CAST([O].[Customer WO#] AS NVARCHAR(MAX))) LIKE LOWER('%' + RIGHT([Splt].[splited_data], 4) + '%') THEN 1
							ELSE 0
						END)
					ELSE 0 
				END)
			ELSE 0
		END) = 1
	)


UNION ALL 


SELECT
	'STG' AS [Comp],
	CAST([SGQuote] AS NVARCHAR(MAX)) AS [Quote]
FROM
	[BWSdb].[dbo].[OrdersV2] [O]
CROSS JOIN
	[BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
WHERE
	(
		(CASE 
			WHEN @checkQuote = 1 THEN (
				CASE
					WHEN (CAST([O].[SGQuote] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 
					WHEN @allowPartial = 1 THEN (
						CASE
							WHEN LOWER(CAST([O].[SGQuote] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 1
							ELSE 0
						END)
					ELSE 0 
				END)
			ELSE 0
		END) = 1
	)
	OR (
		(CASE 
			WHEN @checkWO = 1 THEN (
				CASE
					WHEN (CAST([O].[WO#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 
					WHEN @allowPartial = 1 THEN (
						CASE
							WHEN LOWER(CAST([O].[WO#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 1
							ELSE 0
						END)
					ELSE 0 
				END)
			ELSE 0
		END) = 1
	)
	OR (
		(CASE 
			WHEN @checkSerial = 1 THEN (
				CASE
					WHEN ([O].[Serial Number] = [Splt].[splited_data]) THEN 1 
					WHEN @allowPartial = 1 THEN (
						CASE
							WHEN LOWER([O].[Serial Number]) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 1
							ELSE 0
						END)
					ELSE 0 
				END)
			ELSE 0
		END) = 1
	)
	OR (
		(CASE 
			WHEN @checkModelNo = 1 THEN (
				CASE
					WHEN ([O].[Model No] = [Splt].[splited_data]) THEN 1 
					WHEN @allowPartial = 1 THEN (
						CASE
							WHEN LOWER([O].[Model No]) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 1
							ELSE 0
						END)
					ELSE 0 
				END)
			ELSE 0
		END) = 1
	)
	OR (
		(CASE 
			WHEN @checkNotes = 1 THEN (
				CASE
					WHEN ([O].[Notes] = [Splt].[splited_data]) THEN 1 
					WHEN @allowPartial = 1 THEN (
						CASE
							WHEN LOWER([O].[Notes]) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 1
							ELSE 0
						END)
					ELSE 0 
				END)
			ELSE 0
		END) = 1
	)
	OR (
		(CASE 
			WHEN @checkSpecialInstructions = 1 THEN (
				CASE
					WHEN ([O].[Special Instructions] = [Splt].[splited_data]) THEN 1 
					WHEN @allowPartial = 1 THEN (
						CASE
							WHEN LOWER([O].[Special Instructions]) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 1
							ELSE 0
						END)
					ELSE 0 
				END)
			ELSE 0
		END) = 1
	)
	OR (
		(CASE 
			WHEN @checkEngNotes = 1 THEN (
				CASE
					WHEN (CAST([O].[EngNotes] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 
					WHEN @allowPartial = 1 THEN (
						CASE
							WHEN LOWER(CAST([O].[EngNotes] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 1
							ELSE 0
						END)
					ELSE 0 
				END)
			ELSE 0
		END) = 1
	)
	OR (
		(CASE 
			WHEN @checkCustomerWO = 1 THEN (
				CASE
					WHEN (CAST([O].[Customer WO#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 
					WHEN @allowPartial = 1 THEN (
						CASE
							WHEN LOWER(CAST([O].[Customer WO#] AS NVARCHAR(MAX))) LIKE LOWER('%' + RIGHT([Splt].[splited_data], 4) + '%') THEN 1
							ELSE 0
						END)
					ELSE 0 
				END)
			ELSE 0
		END) = 1
	)






/*

WHERE
	([Serial Number] IN (
		'2S9DA6354PM119747'
	))
	--OR (
	--	([Serial Number] = '2S9DA64634M115319')
	--	OR ([Serial Number] = '2S9DA2144YM115038')
	--	OR ([Serial Number] = '2S9DA6468HM117329')
	--)
	OR (
		([Notes] LIKE '%2S9DA6354PM119747%')
	)
	OR (
		([EngNotes] LIKE '%2S9DA6354PM119747%')
	)
	OR (
		([Special Instructions] LIKE '%2S9DA6354PM119747%')
	)
	OR (
		([Special Instructions] LIKE '%2S9DA6354PM119747%')
	)

	UNION

SELECT
	[SGQuote]
FROM
	[BWSdb].[dbo].[OrdersV2]
WHERE
	([Serial Number] = @st
	OR (
		([Notes] LIKE '%2S9DA6354PM119747%')
	)
	OR (
		([EngNotes] LIKE '%2S9DA6354PM119747%')
	)
	OR (
		([Special Instructions] LIKE '%2S9DA6354PM119747%')
	)
;*/