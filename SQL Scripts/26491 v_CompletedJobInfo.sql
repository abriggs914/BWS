SET ARITHABORT OFF;

SELECT * FROM [v_Order Book Detail_All] WHERE [Quote#] IN (26491, 26492, 26941, 26942)
ORDER BY [Quote#]

SELECT * FROM [Orders] LEFT OUTER JOIN SysproCompanyA.dbo.v_CompletedJobInfo ON CAST(dbo.Orders.WO# AS varchar(20)) = SysproCompanyA.dbo.v_CompletedJobInfo.Job WHERE [Quote#] IN (26491, 26492, 26941, 26942)
ORDER BY [Quote#]