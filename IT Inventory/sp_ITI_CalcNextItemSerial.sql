-- calc next ITI serial

USE BWSdb
GO

ALTER PROCEDURE [dbo].[sp_ITI_CalcNextItemSerial]
AS
BEGIN

	SELECT
		RIGHT('0000000000' + CAST(MAX([SerialNum]) + 1 AS NVARCHAR(10)), 10) AS [Next Serial]
	FROM (
		SELECT
			--CAST(LEFT(RIGHT([Serial], LEN([Serial]) - 1), LEN([Serial]) - 2) AS BIGINT) AS [SerialNum]
			CAST([Serial] AS BIGINT) AS [SerialNum]
		FROM
			[ITI Item]
	) AS [Src]
END