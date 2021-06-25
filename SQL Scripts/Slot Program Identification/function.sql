-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Avery, Briggs>
-- Create date: <2021-06-25>
-- Description:	<Return the month name from a number 1-12>
-- =============================================
CREATE FUNCTION getmonth (@num int)
RETURNS varchar(9) --since 'September' is the longest string, length 9
AS
BEGIN

DECLARE @intMonth Table (num int PRIMARY KEY IDENTITY(1,1), month varchar(9))

INSERT INTO @intMonth VALUES ('January'), ('February'), ('March'), ('April'), ('May')
                           , ('June'), ('July'), ('August') ,('September'), ('October')
                           , ('November'), ('December')

RETURN (SELECT I.month
        FROM @intMonth I
        WHERE I.num = @num)
END
GO

--Use the function for various months
SELECT dbo.getmonth(4) AS [Month]
