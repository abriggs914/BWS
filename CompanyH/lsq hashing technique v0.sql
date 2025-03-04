DECLARE @QuoteSignature TABLE (
    [Quote#] INT PRIMARY KEY,
    --Signature VARBINARY(20)  -- e.g. using SHA-256 or MD5 (if acceptable)
    [Signature] NVARCHAR(MAX)  -- e.g. using SHA-256 or MD5 (if acceptable)
);


WITH AggregatedData AS (
    SELECT 
        O.[Quote#],
        -- Concatenate all the standard details, for example.
        (
          SELECT OS.[Group] + '|' + OS.[Section] + '|' + ISNULL(OS.[Description], '')
          FROM [BWSdb].[dbo].[Order Standards] OS WITH (NOLOCK)
          WHERE OS.[Quote#] = O.[Quote#]
          ORDER BY OS.[Group], OS.[Section]
          FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)') AS StandardsConcat,
        -- Concatenate the Order Options (and their spec-lines) similarly.
        (
          SELECT OO.[Description] + '|' + CAST(OO.[Qty] AS NVARCHAR(20))
          FROM [BWSdb].[dbo].[Order Options] OO WITH (NOLOCK)
          WHERE OO.[Quote#] = O.[Quote#]
          ORDER BY OO.[ID]
          FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)') AS OptionsConcat,
        -- And similarly for Custom Work.
        (
          SELECT CW.[Description] + '|' + CAST(CW.[Qty] AS NVARCHAR(20))
          FROM [BWSdb].[dbo].[Custom Work] CW WITH (NOLOCK)
          WHERE CW.[Quote#] = O.[Quote#]
          ORDER BY CW.[ID]
          FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)') AS CustomWorkConcat
    FROM [BWSdb].[dbo].[Orders] O WITH (NOLOCK)
    WHERE O.[Date Declined] IS NULL
)
INSERT INTO @QuoteSignature ([Quote#], Signature)
SELECT 
    [Quote#],
    /*HASHBYTES('SHA1', ISNULL(StandardsConcat, '') + '||' +
                        ISNULL(OptionsConcat, '') + '||' +
                        ISNULL(CustomWorkConcat, ''))*/
    ISNULL(StandardsConcat, '') + '||' +
                        ISNULL(OptionsConcat, '') + '||' +
                        ISNULL(CustomWorkConcat, '')
FROM AggregatedData;


/*
SELECT 
    [Quote#],
    CAST(HASHBYTES('SHA1', ISNULL(StandardsConcat, '')) AS VARBINARY(20)) AS StandardHash,
    CAST(HASHBYTES('SHA1', ISNULL(OptionsConcat, '')) AS VARBINARY(20)) AS OptionsHash,
    CAST(HASHBYTES('SHA1', ISNULL(CustomWorkConcat, '')) AS VARBINARY(20)) AS CustomWorkHash
FROM AggregatedData;
*/
/*
SELECT 
    LEN(ISNULL(StandardsConcat,'')) AS StandardsLen,
    LEN(ISNULL(OptionsConcat,'')) AS OptionsLen,
    LEN(ISNULL(CustomWorkConcat,'')) AS CustomWorkLen
FROM AggregatedData;
*/
/*
INSERT INTO @QuoteSignature ([Quote#], Signature)
SELECT 
    [Quote#],
    CAST(HASHBYTES('SHA1', ISNULL(StandardsConcat,'') + '||' +
                          ISNULL(OptionsConcat,'') + '||' +
                          ISNULL(CustomWorkConcat,'')) AS VARBINARY(20))
FROM AggregatedData;
*/


--SELECT * FROM AggregatedData

--INSERT INTO @QuoteSignature ([Quote#], Signature)
--SELECT 
--    [Quote#],
--    HASHBYTES('SHA1', ISNULL(StandardsConcat,'') + '||' +
--                    ISNULL(OptionsConcat,'') + '||' +
--                    ISNULL(CustomWorkConcat,''))
--FROM AggregatedData;

SELECT * FROM @QuoteSignature
SELECT
	[A].[Quote#]
	,[B].[Quote#]
FROM
	@QuoteSignature [A]
LEFT JOIN
	@QuoteSignature [B]
ON
	[A].[Signature] = [B].[Signature]
WHERE
	[A].[Quote#] <> [B].[Quote#]
/*ORDER BY
	[A].[Quote#]*/




/*
DECLARE @Qiq INT = 31206

SELECT 'Orders' AS [T], [O].[Quote#], [O].[ProductID] FROM [BWSdb].[dbo].[Orders] [O] WHERE [O].[Quote#] = @Qiq
SELECT 'Order Standards' AS [T], [OS].[Quote#], [OS].[Description], [OS].[Group], [OS].[Section] FROM [BWSdb].[dbo].[Order Standards] [OS] WHERE [OS].[Quote#] = @Qiq
SELECT 'Order Options' AS [T], [OO].[Quote#], [OO].[Description], [OO].[ID], [OO].[Qty] FROM [BWSdb].[dbo].[Order Options] [OO] WHERE [OO].[Quote#] = @Qiq
SELECT 'Order Options_FactoryLines' AS [T], [OF].[Quote#], [OF].[Description], [OF].[OrderOptionID], [OF].[SpecDescription], [OF].[SpecGroup], [OF].[SpecSection] FROM [BWSdb].[dbo].[Order Options_FactoryLines] [OF] WHERE [OF].[Quote#] = @Qiq
SELECT 'Order Options_SpecLines' AS [T], [OL].[Quote#], [OL].[ID], [OL].[OrderOptionID], [OL].[Description], [OL].[SpecDescription], [OL].[SpecGroup], [OL].[SpecSection] FROM [BWSdb].[dbo].[Order Options_SpecLines] [OL] WHERE [OL].[Quote#] = @Qiq
SELECT 'Custom Work' AS [T], [CW].[Quote#], [CW].[Description], [CW].[ID], [CW].[Qty] FROM [BWSdb].[dbo].[Custom Work] [CW] WHERE [CW].[Quote#] = @Qiq
SELECT 'Custom Work_FactoryLines' AS [T], [CF].[Quote#], [CF].[ID], [CF].[NPOID], [CF].[SpecDescription], [CF].[SpecGroup], [CF].[SpecSection] FROM [BWSdb].[dbo].[Custom Work_FactoryLines] [CF] WHERE [CF].[Quote#] = @Qiq
SELECT 'Custom Work_SpecLines' AS [T], [CL].[Quote#], [CL].[NPOID], [CL].[ID], [CL].[SpecDescription], [CL].[SpecGroup], [CL].[SpecGroup] FROM [BWSdb].[dbo].[Custom Work_SpecLines] [CL] WHERE [CL].[Quote#] = @Qiq
*/