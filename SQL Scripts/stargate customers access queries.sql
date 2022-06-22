DECLARE @tblCustomerFormSNParam AS TABLE ([PartofSN] NVARCHAR(MAX));
INSERT INTO @tblCustomerFormSNParam ([PartofSN]) VALUES ('8779');


SELECT 
	OrdersV2.[WO#],
	OrdersV2.[Model No],
	OrdersV2.Width,
	OrdersV2.Spread,
	OrdersV2.[Serial Number],
	DealersV2.[COMPANY NAME],
	OrdersV2.[Shipped Date],
	OrdersV2.[Date In Service],
	OrdersV2.DealerSalesPersonID,
	DealersV2.ID 
FROM
	@tblCustomerFormSNParam, DealersV2
INNER JOIN
	OrdersV2 ON DealersV2.ID = OrdersV2.DealerID
WHERE (((OrdersV2.[WO#]) Is Not Null) AND ((OrdersV2.[Serial Number]) Like '%' + [@tblCustomerFormSNParam].[PartofSN] + '%'));



SELECT CustomersV2.[ID#], CustomersV2.[WO#], CustomersV2.Customer, CustomersV2.Address, CustomersV2.City, CustomersV2.[Province/State], CustomersV2.[Postal Code/ZIP], CustomersV2.Phone, CustomersV2.Cell, CustomersV2.Email, CustomersV2.Contact
FROM @tblCustomerFormSNParam, CustomersV2 INNER JOIN OrdersV2 ON CustomersV2.SGQuote = OrdersV2.SGQuote
WHERE (((OrdersV2.[Serial Number]) Like '%' + [@tblCustomerFormSNParam].[PartofSN] + '%'));