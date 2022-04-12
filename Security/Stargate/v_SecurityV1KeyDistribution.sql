USE [Stargatedb]
GO

/****** Object:  View [dbo].[v_SecurityV1KeyDistribution]    Script Date: 2022-04-12 3:57:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[v_SecurityV1KeyDistribution]
AS
SELECT
	[Employee],
	[A],
	[A1],
	[A2],
	[A3]
FROM
	[Stargatedb].[dbo].[SecurityV1]
INNER JOIN
	[Stargatedb].[dbo].[SecurityEmpV1]
ON
	[Stargatedb].[dbo].[SecurityV1].[EmployeeID] = [Stargatedb].[dbo].[SecurityEmpV1].SecurityEmpID
GO


