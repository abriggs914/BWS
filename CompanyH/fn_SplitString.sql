USE [CompanyH]
GO

CREATE FUNCTION [dbo].[fn_SplitString]
(
    @String NVARCHAR(MAX),        -- The delimited string to split
    @Delimiter CHAR(1)            -- The delimiter (e.g., ';')
)
RETURNS @Result TABLE 
(
    ID NVARCHAR(MAX)              -- The split values
)
AS
BEGIN

	-- Supports only single length delimiters

    DECLARE @Start INT = 1, 
            @End INT;

    -- Loop through the string, splitting based on the delimiter
    WHILE CHARINDEX(@Delimiter, @String, @Start) > 0
    BEGIN
        SET @End = CHARINDEX(@Delimiter, @String, @Start);

        INSERT INTO @Result (ID)
        VALUES (SUBSTRING(@String, @Start, @End - @Start));

        SET @Start = @End + 1;
    END

    -- Add the last element (or the entire string if no delimiters are found)
    IF @Start <= LEN(@String)
        INSERT INTO @Result (ID)
        VALUES (SUBSTRING(@String, @Start, LEN(@String) - @Start + 1));

    RETURN;
END;
GO
