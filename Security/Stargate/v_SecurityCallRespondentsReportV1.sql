USE [Stargatedb]
GO

/****** Object:  View [dbo].[v_SecurityCallRespondentsReportV1]    Script Date: 2022-04-12 3:57:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[v_SecurityCallRespondentsReportV1] AS


	--ROW_NUMBER() OVER(
	--	ORDER BY
	--		[Building],
	--		[Place]
	--) AS [Row#],


SELECT
	[Date],
	[Place],
	[Main],
	[Dome],
	[Tire],
	[Finish]
FROM (
	SELECT
		[Date],
		[Building]
		,[Place],
		[Name]
	FROM (
		SELECT TOP 1 
			[Date]
			,'Main' AS [Building]
			,(SELECT [Employee] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Main1]) AS [1]
			,(SELECT [PhoneNumber] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Main1]) AS [1#]
			,(SELECT [Employee] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Main2]) AS [2]
			,(SELECT [PhoneNumber] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Main2]) AS [2#]
			,(SELECT [Employee] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Main3]) AS [3]
			,(SELECT [PhoneNumber] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Main3]) AS [3#]
			,(SELECT [Employee] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Main4]) AS [4]
			,(SELECT [PhoneNumber] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Main4]) AS [4#]
			,(SELECT [Employee] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Main5]) AS [5]
			,(SELECT [PhoneNumber] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Main5]) AS [5#]
			,(SELECT [Employee] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Main6]) AS [6]
			,(SELECT [PhoneNumber] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Main6]) AS [6#]
		FROM
			[SecurityCallersV1]
		UNION ALL
			SELECT TOP 1 
				[Date]
				,'Dome' AS [Building]
				,(SELECT [Employee] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Dome1]) AS [1]
				,(SELECT [PhoneNumber] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Dome1]) AS [1#]
				,(SELECT [Employee] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Dome2]) AS [2]
				,(SELECT [PhoneNumber] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Dome2]) AS [2#]
				,(SELECT [Employee] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Dome3]) AS [3]
				,(SELECT [PhoneNumber] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Dome3]) AS [3#]
				,(SELECT [Employee] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Dome4]) AS [4]
				,(SELECT [PhoneNumber] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Dome4]) AS [4#]
				,(SELECT [Employee] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Dome5]) AS [5]
				,(SELECT [PhoneNumber] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Dome5]) AS [5#]
				,(SELECT [Employee] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Dome6]) AS [6]
				,(SELECT [PhoneNumber] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Dome6]) AS [6#]
			FROM
				[SecurityCallersV1]
		UNION ALL
			SELECT TOP 1 
				[Date]
				,'Tire' AS [Building]
				,(SELECT [Employee] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Tire1]) AS [1]
				,(SELECT [PhoneNumber] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Tire1]) AS [1#]
				,(SELECT [Employee] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Tire2]) AS [2]
				,(SELECT [PhoneNumber] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Tire2]) AS [2#]
				,(SELECT [Employee] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Tire3]) AS [3]
				,(SELECT [PhoneNumber] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Tire3]) AS [3#]
				,(SELECT [Employee] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Tire4]) AS [4]
				,(SELECT [PhoneNumber] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Tire4]) AS [4#]
				,(SELECT [Employee] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Tire5]) AS [5]
				,(SELECT [PhoneNumber] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Tire5]) AS [5#]
				,(SELECT [Employee] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Tire6]) AS [6]
				,(SELECT [PhoneNumber] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Tire6]) AS [6#]
			FROM
				[SecurityCallersV1]
		UNION ALL
			SELECT TOP 1 
				[Date]
				,'Finish' AS [Building]
				,(SELECT [Employee] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Finish1]) AS [1]
				,(SELECT [PhoneNumber] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Finish1]) AS [1#]
				,(SELECT [Employee] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Finish2]) AS [2]
				,(SELECT [PhoneNumber] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Finish2]) AS [2#]
				,(SELECT [Employee] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Finish3]) AS [3]
				,(SELECT [PhoneNumber] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Finish3]) AS [3#]
				,(SELECT [Employee] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Finish4]) AS [4]
				,(SELECT [PhoneNumber] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Finish4]) AS [4#]
				,(SELECT [Employee] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Finish5]) AS [5]
				,(SELECT [PhoneNumber] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Finish5]) AS [5#]
				,(SELECT [Employee] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Finish6]) AS [6]
				,(SELECT [PhoneNumber] FROM [SecurityEmpV1] WHERE [SecurityEmpID] = [Finish6]) AS [6#]
			FROM
				[SecurityCallersV1]
	) AS [SrcA]
	UNPIVOT (
		[Name]
		FOR [Place] IN ([1], [2], [3], [4], [5], [6])
	) UNPIV
) AS [SrcB]
PIVOT (
	MAX([Name])
	FOR [Building] IN ([Main], [Dome], [Tire], [Finish])
) AS [PivotTableA]
;
GO


