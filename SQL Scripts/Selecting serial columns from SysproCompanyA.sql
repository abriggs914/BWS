USE uniPoint_Live
GO


DECLARE @searchTerm NVARCHAR(MAX) = 'contact';
SELECT @searchTerm = LOWER(@searchTerm);


SELECT
	*
FROM
	INFORMATION_SCHEMA.COLUMNS
WHERE
	LOWER([COLUMN_NAME]) LIKE '%' + @searchTerm + '%'
	--[COLUMN_NAME] LIKE '%serial%'
ORDER BY
	[TABLE_NAME],
	[COLUMN_NAME]
;

/*
SELECT * FROM [InvSerialHead] WHERE [Serial] = '2XBB6GW2XRA001106';
SELECT * FROM [InvSerialCrossRef] WHERE	[Serial] = '2XBB6GW2XRA001106';
SELECT * FROM [InvSerialTrn] WHERE [Serial] = '2XBB6GW2XRA001106';
SELECT * FROM [InvSerialTrack] WHERE [Serial] = '2XBB6GW2XRA001106';
*/