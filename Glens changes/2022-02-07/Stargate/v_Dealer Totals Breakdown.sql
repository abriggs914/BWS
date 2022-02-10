USE Stargatedb
GO

CREATE VIEW [dbo].[v_Dealer Totals Breakdown] AS

SELECT        Initials, 
                         CASE [v_Dealer Listing].Grouping WHEN '5' THEN 'Proprietary, Direct & Other' WHEN '4' THEN 'American Dealers' WHEN '2' THEN 'Eastern Canadian Dealers' WHEN '1' THEN 'American Dealers' WHEN '3' THEN 'Western Canadian Dealers'
                          ELSE '' END AS Label, CASE [v_Dealer Listing].Grouping WHEN '5' THEN 'Ttl Dir/Other' WHEN '4' THEN 'Ttl US' WHEN '2' THEN 'Ttl East Cdn.' WHEN '1' THEN 'Ttl US' WHEN '3' THEN 'Ttl West Cdn.' ELSE '' END AS LabelTtl, 
                         CASE [v_Dealer Listing].Grouping WHEN '5' THEN 'Other' WHEN '3' THEN 'Western' WHEN '1' THEN 'American' WHEN '2' THEN 'Eastern' END AS Section, 
                         CASE [v_Dealer Listing].Grouping WHEN '5' THEN 'Total Other' WHEN '3' THEN 'Total Western' WHEN '1' THEN 'Total American' WHEN '2' THEN 'Total Eastern' END AS LabelSection, [CDN/US] AS US, 
                         CASE [v_Dealer Listing].[CDN/US] WHEN 'Canadian' THEN 'Total CDN' WHEN 'American' THEN 'Total US' END AS LabelUS, GROUPING
FROM            dbo.[v_Dealer Listing]
WHERE        (Initials IS NOT NULL)
GROUP BY Initials, 
                         CASE [v_Dealer Listing].Grouping WHEN '5' THEN 'Proprietary, Direct & Other' WHEN '4' THEN 'American Dealers' WHEN '2' THEN 'Eastern Canadian Dealers' WHEN '1' THEN 'American Dealers' WHEN '3' THEN 'Western Canadian Dealers'
                          ELSE '' END, CASE [v_Dealer Listing].Grouping WHEN '5' THEN 'Ttl Dir/Other' WHEN '4' THEN 'Ttl US' WHEN '2' THEN 'Ttl East Cdn.' WHEN '1' THEN 'Ttl US' WHEN '3' THEN 'Ttl West Cdn.' ELSE '' END, 
                         CASE [v_Dealer Listing].Grouping WHEN '5' THEN 'Other' WHEN '3' THEN 'Western' WHEN '1' THEN 'American' WHEN '2' THEN 'Eastern' END, 
                         CASE [v_Dealer Listing].Grouping WHEN '5' THEN 'Total Other' WHEN '3' THEN 'Total Western' WHEN '1' THEN 'Total American' WHEN '2' THEN 'Total Eastern' END, [CDN/US], 
                         CASE [v_Dealer Listing].[CDN/US] WHEN 'Canadian' THEN 'Total CDN' WHEN 'American' THEN 'Total US' END, GROUPING

;