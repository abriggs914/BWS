USE BWSdb
GO

BEGIN TRAN;

DECLARE @SID AS INTEGER;
SET @SID = 10;
DECLARE @SN AS VARCHAR(25);
SET @SN = 'All seasons';

SELECT * FROM [Production Slot Types] -- WHERE [ProdSlotTypeIDNo] = @SID;

UPDATE
	[Production Slot Types]
SET
	[SlotTypeName] = @SN
WHERE
	[ProdSlotTypeIDNo] = @SID;
;

SELECT * FROM [Production Slot Types] -- WHERE [ProdSlotTypeIDNo] = @SID;

ROLLBACK;
COMMIT;