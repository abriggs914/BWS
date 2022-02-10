USE Stargatedb
GO

ALTER VIEW [dbo].[v_Dealer Listing] AS

SELECT        [COMPANY NAME], Initials, [Eastern Canada], American, [Central Canada], [Western Canada], [Proprietary/Direct/Other], CASE WHEN American = 1 AND 
                         [Proprietary/Direct/Other] = 0 THEN '1' WHEN [central canada] = 1 THEN '3' WHEN [eastern canada] = 1 THEN '2' WHEN [western canada] = 1 THEN '3' WHEN [Proprietary/Direct/Other] = 1 THEN 5 ELSE NULL 
                         END AS GROUPING, 
                         CASE WHEN American = 1 THEN 'American' WHEN [central canada] = 1 THEN 'Canadian' WHEN [eastern canada] = 1 THEN 'Canadian' WHEN [western canada] = 1 THEN 'Canadian' ELSE 'Canadian' END AS [CDN/US]
FROM            [BWSdb].dbo.DealersV2 WITH (nolock)
WHERE        (CAST([CURRENT DEALER] AS int) + CAST([CURRENT DEALER CDN] AS int) + CAST([CURRENT DEALER US] AS int) > 0)
GROUP BY [COMPANY NAME], Initials, [Eastern Canada], American, [Central Canada], [Western Canada], [Proprietary/Direct/Other]

;