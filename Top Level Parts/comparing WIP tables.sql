USE SysproCompanyA
GO

SELECT [QtyOnHand], [QtyIssued], [UnitQtyReqd], [RunTimeIssued], [Complete], * FROM [InvWarehouse]
SELECT [QtyOnHand], [QtyIssued], [UnitQtyReqd], [RunTimeIssued], [Complete], * FROM [WipJobAllMat]
SELECT [QtyOnHand], [QtyIssued], [UnitQtyReqd], [RunTimeIssued], [Complete], * FROM [WipJobAllLab]
SELECT [QtyOnHand], [QtyIssued], [UnitQtyReqd], [RunTimeIssued], [Complete], * FROM [WipMaster]