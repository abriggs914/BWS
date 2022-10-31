USE [BWSdb]
GO
/****** Object:  UserDefinedFunction [dbo].[PercentOfDay]    Script Date: 2022-10-31 9:04:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	-- Use this function to determine the percentage complete this time of day is relative to midnight that day.
	-- i.e 3AM ==> 12.5% (1 / 8)
	
--ALTER FUNCTION [dbo].[PercentOfDay](@timeIn DATETIME, @startTime DATETIME=NULL, @endTime DATETIME=NULL) RETURNS DECIMAL(14, 5)
ALTER FUNCTION [dbo].[Datify](@Y INT, @M INT, @D INT, @H INT = 0, @N INT = 0, @S INT = 0) RETURNS DATETIME
AS
BEGIN
		
	RETURN 
		CAST(
			CAST(@Y AS NVARCHAR(4))
			+ '-' +
			CAST(@M AS NVARCHAR(2))
			+ '-' +
			CAST(@D AS NVARCHAR(2))
			+ ' ' +
			CAST(@H AS NVARCHAR(2))
			+ ':' +
			CAST(@N AS NVARCHAR(2))
			+ ':' +
			CAST(@S AS NVARCHAR(3))
		AS DATETIME)

END