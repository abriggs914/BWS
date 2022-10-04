
SELECT * FROM
	dbo.Orders WITH (nolock)
	 WHERE [Quote#] IN (26491, 26492, 26941, 26942)
ORDER BY [Quote#];

SELECT * FROM
	[v_Order Book Detail_All] WITH (nolock)
	 WHERE [Quote#] IN (26491, 26492, 26941, 26942)
ORDER BY [Quote#];

--SELECT * FROM
--	Dealers WITH (nolock)
--	 WHERE [Quote#] IN (26491, 26492, 26941, 26942)
--ORDER BY [Quote#];

--SELECT * FROM
--	Products WITH (nolock)
--	 WHERE [Quote#] IN (26491, 26492, 26941, 26942)
--ORDER BY [Quote#];

SELECT * FROM
	Production WITH (nolock)
	 WHERE [Quote#] IN (26491, 26492, 26941, 26942)
ORDER BY [Quote#];

SELECT * FROM
	SysproCompanyA.dbo.v_CompletedJobInfo WITH (nolock)
INNER JOIN
	[Orders]
ON
	CAST(dbo.Orders.WO# AS varchar(20)) = SysproCompanyA.dbo.v_CompletedJobInfo.Job
	 --WHERE [Quote#] IN (26491, 26492, 26941, 26942)
	 WHERE [Quote#] IN (26491)
ORDER BY [Quote#];
	
	--INNER JOIN
 --                        dbo.[v_Order Book Detail_All] ON dbo.Orders.Quote# = dbo.[v_Order Book Detail_All].Quote# INNER JOIN
 --                        dbo.Dealers WITH (nolock) ON dbo.Orders.DealerID = dbo.Dealers.ID INNER JOIN
 --                        dbo.Products WITH (nolock) ON dbo.Orders.[Model No] = dbo.Products.[Model No] LEFT OUTER JOIN
 --                        dbo.Production WITH (nolock) ON dbo.Orders.Quote# = dbo.Production.Quote# LEFT OUTER JOIN
 --                        SysproCompanyA.dbo.v_CompletedJobInfo ON CAST(dbo.Orders.WO# AS varchar(20)) = SysproCompanyA.dbo.v_CompletedJobInfo.Job