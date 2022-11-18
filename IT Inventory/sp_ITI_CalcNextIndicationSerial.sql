-- calc next ITI serial

USE BWSdb
GO

CREATE PROCEDURE [dbo].[sp_ITI_CalcNextIndicationSerial]
AS
BEGIN

	SELECT
		MAX([SerialNum]) + 1 AS [Next Serial]
	FROM (
		SELECT
			CAST(LEFT(RIGHT([Serial], LEN([Serial]) - 1), LEN([Serial]) - 2) AS BIGINT) AS [SerialNum]
		FROM
			[ITI Serial Indication]
	) AS [Src]
END