USE [SysproCompanyS]
GO
/****** Object:  UserDefinedFunction [dbo].[GetNthBusinessDay]    Script Date: 2024-07-05 1:31:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[GetNthBusinessDay](
    @dateIn DATETIME,
    @nBusinessDays INT
)
RETURNS DATETIME
AS
BEGIN


	/*
	--------------------------------------------------
	DECLARE
		@dateIn DATETIME,
		@nBusinessDays INT
	
	SET @dateIn = '2024-07-03'
	SET @dateIn = GETDATE()
	SET @nBusinessDays = 3
	--------------------------------------------------
	*/


    DECLARE @currentDate DATETIME = @dateIn;
    DECLARE @daysCount INT = 0;

    -- Determine the direction of iteration based on the sign of nBusinessDays
    DECLARE @direction INT = CASE WHEN @nBusinessDays >= 0 THEN 1 ELSE -1 END;
    
    -- Loop until we reach the nth business day
    WHILE @daysCount <> ABS(@nBusinessDays)
    BEGIN
        -- Move to the next/previous day
        SET @currentDate = DATEADD(DAY, @direction, @currentDate);
        
        -- Check if the new date is a business day
        IF EXISTS (
            SELECT 
				1
            FROM
				[SysproCompanyS].[dbo].[v_CalendarWorkDays]
            WHERE
				YEAR([CalendarDate]) = YEAR(@currentDate)
				AND MONTH([CalendarDate]) = MONTH(@currentDate)
				AND DAY([CalendarDate]) = DAY(@currentDate)
				AND [WorkDay] = 1
        )
        BEGIN
            -- Increment the business day counter
            SET @daysCount = @daysCount + 1;
        END
    END

	
	/*
	------------------------------------------------------
	-- TESTING
	SELECT
		@dateIn AS [dateIn]
		, @currentDate AS [currentDate]
		, @nBusinessDays AS [nBusinessDays]
		, @daysCount AS [daysCount]
		, @direction AS [direction]

	SELECT
		*
	FROM
		[SysproCompanyA].[dbo].[v_CalendarWorkDays]
	WHERE
		([CalendarDate] BETWEEN @dateIn AND @currentDate)
		OR ([CalendarDate] BETWEEN @currentDate AND @dateIn)
	------------------------------------------------------
	*/

	
    RETURN @currentDate;
END;
