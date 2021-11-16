USE [BWSdb]
GO
/****** Object:  UserDefinedFunction [dbo].[split_string]    Script Date: 2021-11-16 12:28:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--DECLARE @CompanyString VARCHAR(MAX)
--SET @CompanyString = ''


--SELECT * FROM string_split(@CompanyString, ',')

ALTER FUNCTION [dbo].[split_string_idx]
(
    @string_value NVARCHAR(MAX),
    @delimiter_character CHAR(1)
)
RETURNS @result_set TABLE([Idx] INT, [splited_data] NVARCHAR(MAX)
)
BEGIN
    DECLARE @start_position INT,
            @ending_position INT
	DECLARE @count INT;
	SET @count = 0
    SELECT @start_position = 1,
            @ending_position = CHARINDEX(@delimiter_character, @string_value)
    WHILE @start_position < LEN(@string_value) + 1
            BEGIN
        IF @ending_position = 0 
           SET @ending_position = LEN(@string_value) + 1
        INSERT INTO @result_set ([Idx], [splited_data]) 
        VALUES(@count, SUBSTRING(@string_value, @start_position, @ending_position - @start_position))
        SET @start_position = @ending_position + 1
        SET @ending_position = CHARINDEX(@delimiter_character, @string_value, @start_position)
		SET @count = @count + 1
    END
    RETURN
END
GO