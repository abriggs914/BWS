
-- Version 202505061300


--DECLARE @st NVARCHAR(MAX) = '2SVS69434TM000233;2s9da6354pm119747;sg1000581';
--DECLARE @st NVARCHAR(MAX) = '2S9DA6354PM119747;2SVS69434TM000233;2S9DA64634M115319;2S9DA2144YM115038;2S9DA6468HM117329';
--DECLARE @st NVARCHAR(MAX) = '2S9DA6354PM119747;2SVS69434TM000233;2SVS6P434TM000233;2S9DA64634M115319;2S9DA2144YM115038;2S9DA6468HM117329';
--DECLARE @st NVARCHAR(MAX) = '4TM000233;2XBB6VY24TA000252;avery briggs';
--DECLARE @st NVARCHAR(MAX) = '1000077;00077';

DECLARE @doTest BIT = 0;
DECLARE @st NVARCHAR(MAX) = 'TA000062;2svbdl4xta000062;2svb6dl4xta000062;30929;928';
DECLARE @delim NVARCHAR(50) = ';';
DECLARE @newDelim NVARCHAR(50) = ';|||;';
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

DECLARE @checkOS BIT = 1;
DECLARE @checkOOFL BIT = 1;
DECLARE @checkOOSL BIT = 1;
DECLARE @checkCWFL BIT = 1;
DECLARE @checkCWSL BIT = 1;




SELECT
	*
FROM
	[BWSdb].[dbo].[split_string_idx](@st, @delim)
;







SELECT
	'BWS' AS [Comp],
	CAST([Quote#] AS NVARCHAR(MAX)) AS [Quote],
	'WO#' AS [MatchColumn],
	[Splt].[splited_data] AS [SearchTerm],
	CAST([WO#] AS NVARCHAR(MAX)) AS [Matched],
	(CASE WHEN (CAST([O].[WO#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
FROM 
	[BWSdb].[dbo].[Orders] [O]
LEFT JOIN
	[BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
ON
	(CAST([O].[WO#] AS NVARCHAR(MAX)) = [Splt].[splited_data])
	OR 
	(
		CASE
		WHEN 
			(@allowPartial = 1) 
			AND (LOWER(CAST([O].[WO#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
		THEN 1
		ELSE 0
		END
	) = 1
WHERE
	ISNULL([Splt].[splited_data], '') <> ''

UNION

SELECT
	'BWS' AS [Comp],
	CAST([Quote#] AS NVARCHAR(MAX)) AS [Quote],
	'Serial Number' AS [MatchColumn],
	[Splt].[splited_data] AS [SearchTerm],
	CAST([Serial Number] AS NVARCHAR(MAX)) AS [Matched],
	(CASE WHEN (CAST([O].[Serial Number] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
FROM 
	[BWSdb].[dbo].[Orders] [O]
LEFT JOIN
	[BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
ON
	(CAST([O].[Serial Number] AS NVARCHAR(MAX)) = [Splt].[splited_data])
	OR 
	(
		CASE
		WHEN 
			(@allowPartial = 1) 
			AND (LOWER(CAST([O].[Serial Number] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
		THEN 1
		ELSE 0
		END
	) = 1
WHERE
	ISNULL([Splt].[splited_data], '') <> ''

UNION

SELECT
	'BWS' AS [Comp],
	CAST([Quote#] AS NVARCHAR(MAX)) AS [Quote],
	'Model No' AS [MatchColumn],
	[Splt].[splited_data] AS [SearchTerm],
	CAST([Model No] AS NVARCHAR(MAX)) AS [Matched],
	(CASE WHEN (CAST([O].[Model No] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
FROM 
	[BWSdb].[dbo].[Orders] [O]
LEFT JOIN
	[BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
ON
	(CAST([O].[Model No] AS NVARCHAR(MAX)) = [Splt].[splited_data])
	OR 
	(
		CASE
		WHEN 
			(@allowPartial = 1) 
			AND (LOWER(CAST([O].[Model No] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
		THEN 1
		ELSE 0
		END
	) = 1
WHERE
	ISNULL([Splt].[splited_data], '') <> ''

UNION

SELECT
	'BWS' AS [Comp],
	CAST([Quote#] AS NVARCHAR(MAX)) AS [Quote],
	'Special Instructions' AS [MatchColumn],
	[Splt].[splited_data] AS [SearchTerm],
	CAST([Special Instructions] AS NVARCHAR(MAX)) AS [Matched],
	(CASE WHEN (CAST([O].[Special Instructions] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
FROM 
	[BWSdb].[dbo].[Orders] [O]
LEFT JOIN
	[BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
ON
	(CAST([O].[Special Instructions] AS NVARCHAR(MAX)) = [Splt].[splited_data])
	OR 
	(
		CASE
		WHEN 
			(@allowPartial = 1) 
			AND (LOWER(CAST([O].[Special Instructions] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
		THEN 1
		ELSE 0
		END
	) = 1
WHERE
	ISNULL([Splt].[splited_data], '') <> ''

UNION

SELECT
	'BWS' AS [Comp],
	CAST([Quote#] AS NVARCHAR(MAX)) AS [Quote],
	'Notes' AS [MatchColumn],
	[Splt].[splited_data] AS [SearchTerm],
	CAST([Notes] AS NVARCHAR(MAX)) AS [Matched],
	(CASE WHEN (CAST([O].[Notes] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
FROM 
	[BWSdb].[dbo].[Orders] [O]
LEFT JOIN
	[BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
ON
	(CAST([O].[Notes] AS NVARCHAR(MAX)) = [Splt].[splited_data])
	OR 
	(
		CASE
		WHEN 
			(@allowPartial = 1) 
			AND (LOWER(CAST([O].[Notes] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
		THEN 1
		ELSE 0
		END
	) = 1
WHERE
	ISNULL([Splt].[splited_data], '') <> ''

UNION

SELECT
	'BWS' AS [Comp],
	CAST([Quote#] AS NVARCHAR(MAX)) AS [Quote],
	'EngNotes' AS [MatchColumn],
	[Splt].[splited_data] AS [SearchTerm],
	CAST([EngNotes] AS NVARCHAR(MAX)) AS [Matched],
	(CASE WHEN (CAST([O].[EngNotes] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
FROM 
	[BWSdb].[dbo].[Orders] [O]
LEFT JOIN
	[BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
ON
	(CAST([O].[EngNotes] AS NVARCHAR(MAX)) = [Splt].[splited_data])
	OR 
	(
		CASE
		WHEN 
			(@allowPartial = 1) 
			AND (LOWER(CAST([O].[EngNotes] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
		THEN 1
		ELSE 0
		END
	) = 1
WHERE
	ISNULL([Splt].[splited_data], '') <> ''

UNION

SELECT
	'BWS' AS [Comp],
	CAST([Quote#] AS NVARCHAR(MAX)) AS [Quote],
	'Customer WO#' AS [MatchColumn],
	[Splt].[splited_data] AS [SearchTerm],
	CAST([Customer WO#] AS NVARCHAR(MAX)) AS [Matched],
	(CASE WHEN (CAST([O].[Customer WO#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
FROM 
	[BWSdb].[dbo].[Orders] [O]
LEFT JOIN
	[BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
ON
	(CAST([O].[Customer WO#] AS NVARCHAR(MAX)) = [Splt].[splited_data])
	OR 
	(
		CASE
		WHEN 
			(@allowPartial = 1) 
			AND (LOWER(CAST([O].[Customer WO#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
		THEN 1
		ELSE 0
		END
	) = 1
WHERE
	ISNULL([Splt].[splited_data], '') <> ''

UNION

SELECT
	'BWS' AS [Comp],
	CAST([Quote#] AS NVARCHAR(MAX)) AS [Quote],
	'Sales Order#' AS [MatchColumn],
	[Splt].[splited_data] AS [SearchTerm],
	CAST([Sales Order#] AS NVARCHAR(MAX)) AS [Matched],
	(CASE WHEN (CAST([O].[Sales Order#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
FROM 
	[BWSdb].[dbo].[Orders] [O]
LEFT JOIN
	[BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
ON
	(CAST([O].[Sales Order#] AS NVARCHAR(MAX)) = [Splt].[splited_data])
	OR 
	(
		CASE
		WHEN 
			(@allowPartial = 1) 
			AND (LOWER(CAST([O].[Sales Order#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
		THEN 1
		ELSE 0
		END
	) = 1
WHERE
	ISNULL([Splt].[splited_data], '') <> ''

UNION

SELECT
	'BWS' AS [Comp],
	CAST([Quote#] AS NVARCHAR(MAX)) AS [Quote],
	'Invoice #' AS [MatchColumn],
	[Splt].[splited_data] AS [SearchTerm],
	CAST([Invoice #] AS NVARCHAR(MAX)) AS [Matched],
	(CASE WHEN (CAST([O].[Invoice #] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
FROM 
	[BWSdb].[dbo].[Orders] [O]
LEFT JOIN
	[BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
ON
	(CAST([O].[Invoice #] AS NVARCHAR(MAX)) = [Splt].[splited_data])
	OR 
	(
		CASE
		WHEN 
			(@allowPartial = 1) 
			AND (LOWER(CAST([O].[Invoice #] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
		THEN 1
		ELSE 0
		END
	) = 1
WHERE
	ISNULL([Splt].[splited_data], '') <> ''

UNION

SELECT
	'STG' AS [Comp],
	CAST([SGQuote] AS NVARCHAR(MAX)) AS [Quote],
	'WO#' AS [MatchColumn],
	[Splt].[splited_data] AS [SearchTerm],
	CAST([WO#] AS NVARCHAR(MAX)) AS [Matched],
	(CASE WHEN (CAST([O].[WO#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
FROM 
	[BWSdb].[dbo].[OrdersV2] [O]
LEFT JOIN
	[BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
ON
	(CAST([O].[WO#] AS NVARCHAR(MAX)) = [Splt].[splited_data])
	OR 
	(
		CASE
		WHEN 
			(@allowPartial = 1) 
			AND (LOWER(CAST([O].[WO#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
		THEN 1
		ELSE 0
		END
	) = 1
WHERE
	ISNULL([Splt].[splited_data], '') <> ''

UNION

SELECT
	'STG' AS [Comp],
	CAST([SGQuote] AS NVARCHAR(MAX)) AS [Quote],
	'Serial Number' AS [MatchColumn],
	[Splt].[splited_data] AS [SearchTerm],
	CAST([Serial Number] AS NVARCHAR(MAX)) AS [Matched],
	(CASE WHEN (CAST([O].[Serial Number] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
FROM 
	[BWSdb].[dbo].[OrdersV2] [O]
LEFT JOIN
	[BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
ON
	(CAST([O].[Serial Number] AS NVARCHAR(MAX)) = [Splt].[splited_data])
	OR 
	(
		CASE
		WHEN 
			(@allowPartial = 1) 
			AND (LOWER(CAST([O].[Serial Number] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
		THEN 1
		ELSE 0
		END
	) = 1
WHERE
	ISNULL([Splt].[splited_data], '') <> ''

UNION

SELECT
	'STG' AS [Comp],
	CAST([SGQuote] AS NVARCHAR(MAX)) AS [Quote],
	'Model No' AS [MatchColumn],
	[Splt].[splited_data] AS [SearchTerm],
	CAST([Model No] AS NVARCHAR(MAX)) AS [Matched],
	(CASE WHEN (CAST([O].[Model No] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
FROM 
	[BWSdb].[dbo].[OrdersV2] [O]
LEFT JOIN
	[BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
ON
	(CAST([O].[Model No] AS NVARCHAR(MAX)) = [Splt].[splited_data])
	OR 
	(
		CASE
		WHEN 
			(@allowPartial = 1) 
			AND (LOWER(CAST([O].[Model No] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
		THEN 1
		ELSE 0
		END
	) = 1
WHERE
	ISNULL([Splt].[splited_data], '') <> ''

UNION

SELECT
	'STG' AS [Comp],
	CAST([SGQuote] AS NVARCHAR(MAX)) AS [Quote],
	'Special Instructions' AS [MatchColumn],
	[Splt].[splited_data] AS [SearchTerm],
	CAST([Special Instructions] AS NVARCHAR(MAX)) AS [Matched],
	(CASE WHEN (CAST([O].[Special Instructions] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
FROM 
	[BWSdb].[dbo].[OrdersV2] [O]
LEFT JOIN
	[BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
ON
	(CAST([O].[Special Instructions] AS NVARCHAR(MAX)) = [Splt].[splited_data])
	OR 
	(
		CASE
		WHEN 
			(@allowPartial = 1) 
			AND (LOWER(CAST([O].[Special Instructions] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
		THEN 1
		ELSE 0
		END
	) = 1
WHERE
	ISNULL([Splt].[splited_data], '') <> ''

UNION

SELECT
	'STG' AS [Comp],
	CAST([SGQuote] AS NVARCHAR(MAX)) AS [Quote],
	'Notes' AS [MatchColumn],
	[Splt].[splited_data] AS [SearchTerm],
	CAST([Notes] AS NVARCHAR(MAX)) AS [Matched],
	(CASE WHEN (CAST([O].[Notes] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
FROM 
	[BWSdb].[dbo].[OrdersV2] [O]
LEFT JOIN
	[BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
ON
	(CAST([O].[Notes] AS NVARCHAR(MAX)) = [Splt].[splited_data])
	OR 
	(
		CASE
		WHEN 
			(@allowPartial = 1) 
			AND (LOWER(CAST([O].[Notes] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
		THEN 1
		ELSE 0
		END
	) = 1
WHERE
	ISNULL([Splt].[splited_data], '') <> ''

UNION

SELECT
	'STG' AS [Comp],
	CAST([SGQuote] AS NVARCHAR(MAX)) AS [Quote],
	'EngNotes' AS [MatchColumn],
	[Splt].[splited_data] AS [SearchTerm],
	CAST([EngNotes] AS NVARCHAR(MAX)) AS [Matched],
	(CASE WHEN (CAST([O].[EngNotes] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
FROM 
	[BWSdb].[dbo].[OrdersV2] [O]
LEFT JOIN
	[BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
ON
	(CAST([O].[EngNotes] AS NVARCHAR(MAX)) = [Splt].[splited_data])
	OR 
	(
		CASE
		WHEN 
			(@allowPartial = 1) 
			AND (LOWER(CAST([O].[EngNotes] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
		THEN 1
		ELSE 0
		END
	) = 1
WHERE
	ISNULL([Splt].[splited_data], '') <> ''

UNION

SELECT
	'STG' AS [Comp],
	CAST([SGQuote] AS NVARCHAR(MAX)) AS [Quote],
	'Customer WO#' AS [MatchColumn],
	[Splt].[splited_data] AS [SearchTerm],
	CAST([Customer WO#] AS NVARCHAR(MAX)) AS [Matched],
	(CASE WHEN (CAST([O].[Customer WO#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
FROM 
	[BWSdb].[dbo].[OrdersV2] [O]
LEFT JOIN
	[BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
ON
	(CAST([O].[Customer WO#] AS NVARCHAR(MAX)) = [Splt].[splited_data])
	OR 
	(
		CASE
		WHEN 
			(@allowPartial = 1) 
			AND (LOWER(CAST([O].[Customer WO#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
		THEN 1
		ELSE 0
		END
	) = 1
WHERE
	ISNULL([Splt].[splited_data], '') <> ''

UNION

SELECT
	'STG' AS [Comp],
	CAST([SGQuote] AS NVARCHAR(MAX)) AS [Quote],
	'Sales Order#' AS [MatchColumn],
	[Splt].[splited_data] AS [SearchTerm],
	CAST([Sales Order#] AS NVARCHAR(MAX)) AS [Matched],
	(CASE WHEN (CAST([O].[Sales Order#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
FROM 
	[BWSdb].[dbo].[OrdersV2] [O]
LEFT JOIN
	[BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
ON
	(CAST([O].[Sales Order#] AS NVARCHAR(MAX)) = [Splt].[splited_data])
	OR 
	(
		CASE
		WHEN 
			(@allowPartial = 1) 
			AND (LOWER(CAST([O].[Sales Order#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
		THEN 1
		ELSE 0
		END
	) = 1
WHERE
	ISNULL([Splt].[splited_data], '') <> ''

UNION

SELECT
	'STG' AS [Comp],
	CAST([SGQuote] AS NVARCHAR(MAX)) AS [Quote],
	'Invoice #' AS [MatchColumn],
	[Splt].[splited_data] AS [SearchTerm],
	CAST([Invoice #] AS NVARCHAR(MAX)) AS [Matched],
	(CASE WHEN (CAST([O].[Invoice #] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
FROM 
	[BWSdb].[dbo].[OrdersV2] [O]
LEFT JOIN
	[BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
ON
	(CAST([O].[Invoice #] AS NVARCHAR(MAX)) = [Splt].[splited_data])
	OR 
	(
		CASE
		WHEN 
			(@allowPartial = 1) 
			AND (LOWER(CAST([O].[Invoice #] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
		THEN 1
		ELSE 0
		END
	) = 1
WHERE
	ISNULL([Splt].[splited_data], '') <> ''

































/*
SELECT
	'BWS' AS [Comp],
	[Quote#] AS [Quote],
	'Quote#' AS [MatchColumn],
	[Splt].[splited_data] AS [SearchTerm],
	CAST([Quote#] AS NVARCHAR(MAX)) AS [Matched],
	(CASE WHEN (CAST([O].[Quote#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
FROM 
	[BWSdb].[dbo].[Orders] [O]
LEFT JOIN
	[BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
ON
	(CAST([O].[Quote#] AS NVARCHAR(MAX)) = [Splt].[splited_data])
	OR 
	(
		CASE
		WHEN 
			(@allowPartial = 1) 
			AND (LOWER(CAST([O].[Quote#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
		THEN 1
		ELSE 0
		END
	) = 1
WHERE
	ISNULL([Splt].[splited_data], '') <> ''
ORDER BY
	[Quote#]
;
*/

























SELECT
	[Comp],
	[Quote],
	[MatchCode],
	[Matched],
	[ExactMatch]
FROM (
	SELECT
		[Comp],
		[Quote],
		REPLACE([MatchCode], @newDelim, '') AS [MatchCode],
		REPLACE([Matched], @newDelim, '') AS [Matched],
		(CASE WHEN LOWER([Matched]) LIKE '%exact%' THEN 1 ELSE 0 END) AS [ExactMatch]
	FROM (
		SELECT
			'BWS' AS [Comp],
			CAST([O].[Quote#] AS NVARCHAR(MAX)) AS [Quote],
			(CASE 
				WHEN @checkQuote = 1 THEN (
					CASE
						WHEN (CAST([O].[Quote#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 'Exact Quote'
						WHEN @allowPartial = 1 THEN (
							CASE
								WHEN LOWER(CAST([O].[Quote#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 'Partial Quote'
								ELSE (CASE WHEN @doTest = 1 THEN '-AA' ELSE '' END)
							END)
						ELSE (CASE WHEN @doTest = 1 THEN '-AB' ELSE '' END)
					END)
			END) + @newDelim + (CASE
				WHEN @checkWO = 1 THEN (
						CASE
							WHEN (CAST([O].[WO#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 'Exact WO'
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([O].[WO#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 'Partial WO'
									ELSE (CASE WHEN @doTest = 1 THEN '-AC' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-AD' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkSerial = 1 THEN (
						CASE
							WHEN ([O].[Serial Number] = [Splt].[splited_data]) THEN 'Exact Serial'
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER([O].[Serial Number]) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 'Partial Serial'
									ELSE (CASE WHEN @doTest = 1 THEN '-AE' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-AF' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkModelNo = 1 THEN (
						CASE
							WHEN ([O].[Model No] = [Splt].[splited_data]) THEN 'Exact Model'
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER([O].[Model No]) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 'Partial Model'
									ELSE (CASE WHEN @doTest = 1 THEN '-AG' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-AH' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkNotes = 1 THEN (
						CASE
							WHEN ([O].[Notes] = [Splt].[splited_data]) THEN 'Exact Notes'
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER([O].[Notes]) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 'Partial Notes'
									ELSE (CASE WHEN @doTest = 1 THEN '-AI' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-AJ' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkSpecialInstructions = 1 THEN (
						CASE
							WHEN ([O].[Special Instructions] = [Splt].[splited_data]) THEN 'Exact Special Instructions'
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER([O].[Special Instructions]) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 'Partial Special Instructions'
									ELSE (CASE WHEN @doTest = 1 THEN '-AK' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-AL' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkEngNotes = 1 THEN (
						CASE
							WHEN (CAST([O].[EngNotes] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 'Exact EngNotes'
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([O].[EngNotes] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 'Partial Notes'
									ELSE (CASE WHEN @doTest = 1 THEN '-AM' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-AN' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkCustomerWO = 1 THEN (
						CASE
							WHEN (CAST([O].[Customer WO#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 'Exact Customer WO'
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([O].[Customer WO#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 'Partial Customer WO'
									ELSE (CASE WHEN @doTest = 1 THEN '-AO' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-AP' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkSO = 1 THEN (
						CASE
							WHEN (CAST([O].[Sales Order#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 'Exact Sales Order'
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([O].[Sales Order#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 'Partial Sales Order'
									ELSE (CASE WHEN @doTest = 1 THEN '-AQ' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-AR' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkInvoice = 1 THEN (
						CASE
							WHEN (CAST([O].[Invoice #] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 'Exact Invoice'
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([O].[Invoice #] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 'Partial Invoice'
									ELSE (CASE WHEN @doTest = 1 THEN '-AS' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-AT' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkOS = 1 THEN (
						CASE
							WHEN (CAST([OS].[Description] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 'Exact Standards'
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([OS].[Description] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 'Partial Standards'
									ELSE (CASE WHEN @doTest = 1 THEN '-AU' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-AV' ELSE '' END)
						END)
				ELSE (CASE WHEN @doTest = 1 THEN '-AW' ELSE '' END)
			END) AS [MatchCode],
		
			(CASE 
				WHEN @checkQuote = 1 THEN (
					CASE
						WHEN (CAST([O].[Quote#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN CAST([O].[Quote#] AS NVARCHAR(MAX))
						WHEN @allowPartial = 1 THEN (
							CASE
								WHEN LOWER(CAST([O].[Quote#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN CAST([O].[Quote#] AS NVARCHAR(MAX))
								ELSE (CASE WHEN @doTest = 1 THEN '-CA' ELSE '' END)
							END)
						ELSE (CASE WHEN @doTest = 1 THEN '-CB' ELSE '' END)
					END)
			END) + @newDelim  + (CASE
				WHEN @checkWO = 1 THEN (
						CASE
							WHEN (CAST([O].[WO#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN CAST([O].[WO#] AS NVARCHAR(MAX))
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([O].[WO#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN CAST([O].[WO#] AS NVARCHAR(MAX))
									ELSE (CASE WHEN @doTest = 1 THEN '-CC' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-CD' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkSerial = 1 THEN (
						CASE
							WHEN ([O].[Serial Number] = [Splt].[splited_data]) THEN [O].[Serial Number]
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER([O].[Serial Number]) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN [O].[Serial Number]
									ELSE (CASE WHEN @doTest = 1 THEN '-CE' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-CF' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkModelNo = 1 THEN (
						CASE
							WHEN ([O].[Model No] = [Splt].[splited_data]) THEN [O].[Model No]
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER([O].[Model No]) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN [O].[Model No]
									ELSE (CASE WHEN @doTest = 1 THEN '-CG' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-CH' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkNotes = 1 THEN (
						CASE
							WHEN ([O].[Notes] = [Splt].[splited_data]) THEN [O].[Notes]
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER([O].[Notes]) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN [O].[Notes]
									ELSE (CASE WHEN @doTest = 1 THEN '-CI' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-CJ' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkSpecialInstructions = 1 THEN (
						CASE
							WHEN ([O].[Special Instructions] = [Splt].[splited_data]) THEN [O].[Special Instructions]
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER([O].[Special Instructions]) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN [O].[Special Instructions]
									ELSE (CASE WHEN @doTest = 1 THEN '-CK' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-CL' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkEngNotes = 1 THEN (
						CASE
							WHEN (CAST([O].[EngNotes] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN CAST([O].[EngNotes] AS NVARCHAR(MAX))
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([O].[EngNotes] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN CAST([O].[EngNotes] AS NVARCHAR(MAX))
									ELSE (CASE WHEN @doTest = 1 THEN '-CM' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-CN' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkCustomerWO = 1 THEN (
						CASE
							WHEN (CAST([O].[Customer WO#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN CAST([O].[Customer WO#] AS NVARCHAR(MAX))
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([O].[Customer WO#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN CAST([O].[Customer WO#] AS NVARCHAR(MAX))
									ELSE (CASE WHEN @doTest = 1 THEN '-CO' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-CP' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkSO = 1 THEN (
						CASE
							WHEN (CAST([O].[Sales Order#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN CAST([O].[Sales Order#] AS NVARCHAR(MAX))
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([O].[Sales Order#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN CAST([O].[Sales Order#] AS NVARCHAR(MAX))
									ELSE (CASE WHEN @doTest = 1 THEN '-CQ' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-CR' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkInvoice = 1 THEN (
						CASE
							WHEN (CAST([O].[Invoice #] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN [O].[Invoice #]
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([O].[Invoice #] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN [O].[Invoice #]
									ELSE (CASE WHEN @doTest = 1 THEN '-CS' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-CT' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkOS = 1 THEN (
						CASE
							WHEN (CAST([OS].[Description] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN [OS].[Description]
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([OS].[Description] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN [OS].[Description]
									ELSE (CASE WHEN @doTest = 1 THEN '-CU' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-CV' ELSE '' END)
						END)
				ELSE (CASE WHEN @doTest = 1 THEN '-CW' ELSE '' END)
			END) AS [Matched]
		FROM
			[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
		LEFT JOIN
			[BWSdb].[dbo].[Order Standards] [OS] WITH (NOLOCK)
		ON
			[O].[Quote#] = [OS].[Quote#]
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
									WHEN LOWER(CAST([O].[Customer WO#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 1
									ELSE 0
								END)
							ELSE 0 
						END)
					ELSE 0
				END) = 1
			)
			OR (
				(CASE 
					WHEN @checkSO = 1 THEN (
						CASE
							WHEN (CAST([O].[Sales Order#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([O].[Sales Order#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 1
									ELSE 0
								END)
							ELSE 0 
						END)
					ELSE 0
				END) = 1
			)
			OR (
				(CASE 
					WHEN @checkInvoice = 1 THEN (
						CASE
							WHEN (CAST([O].[Invoice #] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([O].[Invoice #] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 1
									ELSE 0
								END)
							ELSE 0 
						END)
					ELSE 0
				END) = 1
			)
			OR (
				(CASE 
					WHEN @checkOS = 1 THEN (
						CASE
							WHEN (CAST([OS].[Description] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([OS].[Description] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 1
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
			CAST([O].[SGQuote] AS NVARCHAR(MAX)) AS [Quote],
			(CASE 
				WHEN @checkQuote = 1 THEN (
					CASE
						WHEN (CAST([O].[SGQuote] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 'Exact Quote'
						WHEN @allowPartial = 1 THEN (
							CASE
								WHEN LOWER(CAST([O].[SGQuote] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 'Partial Quote'
								ELSE (CASE WHEN @doTest = 1 THEN '-BA' ELSE '' END)
							END)
						ELSE (CASE WHEN @doTest = 1 THEN '-BB' ELSE '' END)
					END)
			END) + @newDelim + (CASE
				WHEN @checkWO = 1 THEN (
						CASE
							WHEN (CAST([O].[WO#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 'Exact WO'
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([O].[WO#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 'Partial WO'
									ELSE (CASE WHEN @doTest = 1 THEN '-BC' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-BD' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkSerial = 1 THEN (
						CASE
							WHEN ([O].[Serial Number] = [Splt].[splited_data]) THEN 'Exact Serial'
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER([O].[Serial Number]) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 'Partial Serial'
									ELSE (CASE WHEN @doTest = 1 THEN '-BE' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-BF' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkModelNo = 1 THEN (
						CASE
							WHEN ([O].[Model No] = [Splt].[splited_data]) THEN 'Exact Model'
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER([O].[Model No]) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 'Partial Model'
									ELSE (CASE WHEN @doTest = 1 THEN '-BG' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-BH' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkNotes = 1 THEN (
						CASE
							WHEN ([O].[Notes] = [Splt].[splited_data]) THEN 'Exact Notes'
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER([O].[Notes]) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 'Partial Notes'
									ELSE (CASE WHEN @doTest = 1 THEN '-BI' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-BJ' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkSpecialInstructions = 1 THEN (
						CASE
							WHEN ([O].[Special Instructions] = [Splt].[splited_data]) THEN 'Exact Special Instructions'
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER([O].[Special Instructions]) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 'Partial Special Instructions'
									ELSE (CASE WHEN @doTest = 1 THEN '-BK' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-BL' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkEngNotes = 1 THEN (
						CASE
							WHEN (CAST([O].[EngNotes] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 'Exact EngNotes'
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([O].[EngNotes] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 'Partial Notes'
									ELSE (CASE WHEN @doTest = 1 THEN '-BM' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-BN' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkCustomerWO = 1 THEN (
						CASE
							WHEN (CAST([O].[Customer WO#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 'Exact Customer WO'
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([O].[Customer WO#] AS NVARCHAR(MAX))) LIKE LOWER('%' + RIGHT([Splt].[splited_data], 4) + '%') THEN 'Partial Customer WO'
									ELSE (CASE WHEN @doTest = 1 THEN '-BO' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-BP' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkSO = 1 THEN (
						CASE
							WHEN (CAST([O].[Sales Order#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 'Exact Sales Order'
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([O].[Sales Order#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 'Partial Sales Order'
									ELSE (CASE WHEN @doTest = 1 THEN '-BQ' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-BR' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkInvoice = 1 THEN (
						CASE
							WHEN (CAST([O].[Invoice #] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 'Exact Invoice'
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([O].[Invoice #] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 'Partial Invoice'
									ELSE (CASE WHEN @doTest = 1 THEN '-BS' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-BT' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkOS = 1 THEN (
						CASE
							WHEN (CAST([OS].[Description] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 'Exact Standards'
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([OS].[Description] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 'Partial Standards'
									ELSE (CASE WHEN @doTest = 1 THEN '-BU' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-BV' ELSE '' END)
						END)
				ELSE (CASE WHEN @doTest = 1 THEN '-BW' ELSE '' END)
			END) AS [MatchCode],
			(CASE 
				WHEN @checkQuote = 1 THEN (
					CASE
						WHEN (CAST([O].[SGQuote] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN [O].[SGQuote]
						WHEN @allowPartial = 1 THEN (
							CASE
								WHEN LOWER(CAST([O].[SGQuote] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN [O].[SGQuote]
								ELSE (CASE WHEN @doTest = 1 THEN '-DA' ELSE '' END)
							END)
						ELSE (CASE WHEN @doTest = 1 THEN '-DB' ELSE '' END)
					END)
			END) + @newDelim + (CASE
				WHEN @checkWO = 1 THEN (
						CASE
							WHEN (CAST([O].[WO#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN CAST([O].[WO#] AS NVARCHAR(MAX))
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([O].[WO#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN CAST([O].[WO#] AS NVARCHAR(MAX))
									ELSE (CASE WHEN @doTest = 1 THEN '-DC' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-DD' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkSerial = 1 THEN (
						CASE
							WHEN ([O].[Serial Number] = [Splt].[splited_data]) THEN [O].[Serial Number]
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER([O].[Serial Number]) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN [O].[Serial Number]
									ELSE (CASE WHEN @doTest = 1 THEN '-DE' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-DF' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkModelNo = 1 THEN (
						CASE
							WHEN ([O].[Model No] = [Splt].[splited_data]) THEN [O].[Model No]
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER([O].[Model No]) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN [O].[Model No]
									ELSE (CASE WHEN @doTest = 1 THEN '-DG' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-DH' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkNotes = 1 THEN (
						CASE
							WHEN ([O].[Notes] = [Splt].[splited_data]) THEN [O].[Notes]
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER([O].[Notes]) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN [O].[Notes]
									ELSE (CASE WHEN @doTest = 1 THEN '-DI' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-DJ' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkSpecialInstructions = 1 THEN (
						CASE
							WHEN ([O].[Special Instructions] = [Splt].[splited_data]) THEN [O].[Special Instructions]
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER([O].[Special Instructions]) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN [O].[Special Instructions]
									ELSE (CASE WHEN @doTest = 1 THEN '-DK' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-DL' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkEngNotes = 1 THEN (
						CASE
							WHEN (CAST([O].[EngNotes] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN CAST([O].[EngNotes] AS NVARCHAR(MAX))
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([O].[EngNotes] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN CAST([O].[EngNotes] AS NVARCHAR(MAX))
									ELSE (CASE WHEN @doTest = 1 THEN '-DM' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-DN' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkCustomerWO = 1 THEN (
						CASE
							WHEN (CAST([O].[Customer WO#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN CAST([O].[Customer WO#] AS NVARCHAR(MAX))
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([O].[Customer WO#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN CAST([O].[Customer WO#] AS NVARCHAR(MAX))
									ELSE (CASE WHEN @doTest = 1 THEN '-DO' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-DP' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkSO = 1 THEN (
						CASE
							WHEN (CAST([O].[Sales Order#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN CAST([O].[Sales Order#] AS NVARCHAR(MAX))
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([O].[Sales Order#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN CAST([O].[Sales Order#] AS NVARCHAR(MAX))
									ELSE (CASE WHEN @doTest = 1 THEN '-DQ' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-DR' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkInvoice = 1 THEN (
						CASE
							WHEN (CAST([O].[Invoice #] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN [O].[Invoice #]
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([O].[Invoice #] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN [O].[Invoice #]
									ELSE (CASE WHEN @doTest = 1 THEN '-DS' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-DT' ELSE '' END)
						END)
			END) + @newDelim + (CASE
				WHEN @checkOS = 1 THEN (
						CASE
							WHEN (CAST([OS].[Description] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN [OS].[Description]
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([OS].[Description] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN [OS].[Description]
									ELSE (CASE WHEN @doTest = 1 THEN '-DU' ELSE '' END)
								END)
							ELSE (CASE WHEN @doTest = 1 THEN '-DV' ELSE '' END)
						END)
				ELSE (CASE WHEN @doTest = 1 THEN '-DW' ELSE '' END)
			END) AS [Matched]
		FROM
			[BWSdb].[dbo].[OrdersV2] [O] WITH (NOLOCK)
		LEFT JOIN
			[BWSdb].[dbo].[Order StandardsV2] [OS] WITH (NOLOCK)
		ON
			[O].[SGQuote] = [OS].[SGQuote]
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
									WHEN LOWER(CAST([O].[Customer WO#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 1
									ELSE 0
								END)
							ELSE 0 
						END)
					ELSE 0
				END) = 1
			)
			OR (
				(CASE 
					WHEN @checkSO = 1 THEN (
						CASE
							WHEN (CAST([O].[Sales Order#] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([O].[Sales Order#] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 1
									ELSE 0
								END)
							ELSE 0 
						END)
					ELSE 0
				END) = 1
			)
			OR (
				(CASE 
					WHEN @checkInvoice = 1 THEN (
						CASE
							WHEN (CAST([O].[Invoice #] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([O].[Invoice #] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 1
									ELSE 0
								END)
							ELSE 0 
						END)
					ELSE 0
				END) = 1
			)
			OR (
				(CASE 
					WHEN @checkOS = 1 THEN (
						CASE
							WHEN (CAST([OS].[Description] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 
							WHEN @allowPartial = 1 THEN (
								CASE
									WHEN LOWER(CAST([OS].[Description] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%') THEN 1
									ELSE 0
								END)
							ELSE 0 
						END)
					ELSE 0
				END) = 1
			)
	) AS [Src1]
) AS [Src2]
GROUP BY
	[Comp],
	[Quote],
	[MatchCode],
	[Matched],
	[ExactMatch]
ORDER BY
	[Comp],
	[Quote]