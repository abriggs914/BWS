USE BWSdb

GO


DECLARE @quotes TABLE ([SGQuote] NVARCHAR(8));
INSERT INTO @quotes ([SGQuote]) VALUES 
('SG100509'),
('SG100510'),
('SG100511'),
('SG100512'),
('SG100513'),
('SG100514'),
('SG100515'),
('SG100516'),
('SG100517'),
('SG100518'),
('SG100519'),
('SG100520'),
('SG100521')
;

BEGIN TRAN;


SELECT * FROM [OrdersV2] WHERE [CompanyID] = 1 ORDER BY [Quote Date] DESC

UPDATE 
	[OrdersV2]
SET
	[Model No] = 'Frameless End Dump 2X'
WHERE
	[SGQuote] IN (SELECT [SGQuote] FROM @quotes);

SELECT * FROM [OrdersV2] WHERE [CompanyID] = 1 ORDER BY [Quote Date] DESC

ROLLBACK:
COMMIT;