
--2025-09-02 10:20
-- Initial data population
INSERT INTO [SysproCompanyA].[dbo].[SorStatusCodes] ([StatusCode], [Description])
VALUES
('1', 'Open Order'),
('2', 'Open Backorder'),
('3', 'Released backorder'),
('4', 'In Warehouse'),
('9', 'Ready to Invoice'),
('S', 'Suspended'),
('*', 'Cancelled during entry'),
('\', 'Cancelled');
;