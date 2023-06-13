USE SysproCompanyA
GO

SELECT TOP 5000 PorMasterDetail.PurchaseOrder, PorMasterDetail.MStockCode, PorMasterDetail.MStockDes
FROM PorMasterDetail
ORDER BY PorMasterDetail.[PurchaseOrder] DESC;


SELECT * FROM [BWSdb].[dbo].[Design StaffV2]
SELECT * FROM [BWSdb].[dbo].[v_DesignStaffV2]