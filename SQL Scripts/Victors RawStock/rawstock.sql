
USE SysproCompanyA
GO

DECLARE @knownProductClasses AS TABLE ([ID] INT IDENTITY(1, 1), [PC] NVARCHAR(10), [Description] NVARCHAR(MAX));
INSERT INTO @knownProductClasses ([PC], [Description]) VALUES
('03', 'Threaded Rod'),
('22', 'Cutting Edge'),
('27', 'Mild Plate'),
('28', 'Corten Plate'),
('31', 'Deck Plate'),
('33', 'T1 Plate'),
('34', 'Aluminum Plate'),
('35', 'Aluminum Deck Plate'),
('36', 'Channel 44W'),
('37', 'Angle 44W'),
('38', 'WF Beam'),
('39', 'I Beam'),
('41', 'Junior I Beam'),
('42', 'Aluminum H Beam'),
('43', 'Scandia'),
('45', 'Aluminum Flatbar'),
('46', 'Mild Round Bar HR'),
('48', 'Stressproof Shaft'),
('49', 'Chrome Shaft'),
('50', 'Aluminum Shift'),
('51', 'Mild Square Bar HR'),
('52', 'Keystock'),
('53', 'Flatbar'),
('54', 'Hss Tubing'),
('55', 'Schedule 40 Pipe'),
('56', 'Schedule 50 Pipe'),
('58', 'Seamless Mechanical Tubing'),
('59', 'Mechanical Tubing'),
('60', 'Cylinder Tubing'),
('61', 'Expanded Metal Aluminum'),
('64', 'Aluminum Channel'),
('66', 'Stainless Shaft'),
('67', 'Galvanized Plate'),
('68', 'CHT100 Plate'),
('69', 'Re-bar'),
('71', '100ksi Plate'),
('72', '50W Plate'),
('73', 'Aluminum HSS'),
('74', 'Aluminum Angel'),
('75', 'Stainless Plate 304L'),
('76', 'Hardox Plate'),
('78', 'Stainless Steel Angel'),
('79', 'Stainless Steel Flatbar'),
('70', 'Stainless Steel Sch 40 Pipe'),
('81', 'Stainless Steel Squarebar'),
('82', 'Stainless Steel HSS')
;

SELECT
	[InvMaster].*
FROM
	[InvMaster]
LEFT JOIN
	[BomStructure]
ON
	[BomStructure].[ParentPart] = [InvMaster].[StockCode]
WHERE
	[PartCategory] = 'B'
	AND [ProductClass] IN (SELECT [PC] FROM @knownProductClasses)

SELECT DISTINCT [ProductClass] FROM [InvMaster] INNER JOIN @knownProductClasses ON [ProductClass] = [@knownProductClasses].[PC]