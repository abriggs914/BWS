USE BWSdb
GO

-- Updates 2024-02-08

DECLARE @vinceTables20240205 TABLE (
	[ID] INT IDENTITY(0, 1)
	,[Quote] NVARCHAR(MAX)
	,[WO] NVARCHAR(MAX)
	,[Date] DATETIME
	,[Line] NVARCHAR(MAX)
	,[Rev] NVARCHAR(MAX)
	,[SchedPath] NVARCHAR(MAX)
);

INSERT INTO @vinceTables20240205 ([Quote], [WO], [Date], [Line], [Rev], [SchedPath]) VALUES
('SG101297', NULL, '2024-02-01', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_End Dump-Rev10.pdf'),
('SG101431', NULL, '2024-02-05', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_End Dump-Rev10.pdf'),
('SG101434', NULL, '2024-02-06', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_End Dump-Rev10.pdf'),
('SG101403', NULL, '2024-02-07', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_End Dump-Rev10.pdf'),
('SG101437', NULL, '2024-02-08', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_End Dump-Rev10.pdf'),
('SG101397', NULL, '2024-02-09', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_End Dump-Rev10.pdf'),
('SG101432', NULL, '2024-02-12', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_End Dump-Rev10.pdf'),
('SG101438', NULL, '2024-02-13', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_End Dump-Rev10.pdf'),
('SG101407', NULL, '2024-02-14', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_End Dump-Rev10.pdf'),
('SG101440', NULL, '2024-02-15', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_End Dump-Rev10.pdf'),
('SG101433', NULL, '2024-02-16', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_End Dump-Rev10.pdf'),
('SG101462', NULL, '2024-02-20', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_End Dump-Rev10.pdf'),
('SG101411', NULL, '2024-02-21', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-02\PRODUCTION CALENDAR 2024_(02)February_End Dump-Rev09.pdf'),
('SG101304', NULL, '2024-02-22', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-02\PRODUCTION CALENDAR 2024_(02)February_End Dump-Rev09.pdf'),
('SG101436', NULL, '2024-02-23', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-02\PRODUCTION CALENDAR 2024_(02)February_End Dump-Rev09.pdf'),
('SG101513', NULL, '2024-02-26', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-02\PRODUCTION CALENDAR 2024_(02)February_End Dump-Rev09.pdf'),
('SG101515', NULL, '2024-02-27', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-02\PRODUCTION CALENDAR 2024_(02)February_End Dump-Rev09.pdf'),
('SG101412', NULL, '2024-02-28', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-02\PRODUCTION CALENDAR 2024_(02)February_End Dump-Rev09.pdf'),
('SG101204', NULL, '2024-02-29', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-02\PRODUCTION CALENDAR 2024_(02)February_End Dump-Rev09.pdf'),

('SG101497', NULL, '2024-02-06', 'WF', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_Walking floor-Rev08.pdf'),
('SG101498', NULL, '2024-02-13', 'WF', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_Walking floor-Rev08.pdf'),
('SG101426', NULL, '2024-02-15', 'WF', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_Walking floor-Rev08.pdf'),
('SG101427', NULL, '2024-02-15', 'WF', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_Walking floor-Rev08.pdf'),
(NULL, '10001372', '2024-02-16', 'WF', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_Walking floor-Rev08.pdf'),
(NULL, '10001373', '2024-02-16', 'WF', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_Walking floor-Rev08.pdf'),
('SG101499', NULL, '2024-02-20', 'WF', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_Walking floor-Rev08.pdf'),
('SG101428', NULL, '2024-02-22', 'WF', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_Walking floor-Rev08.pdf'),
('SG101421', NULL, '2024-02-22', 'WF', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_Walking floor-Rev08.pdf'),
(NULL, '10001374', '2024-02-23', 'WF', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_Walking floor-Rev08.pdf'),
(NULL, '10001375', '2024-02-23', 'WF', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_Walking floor-Rev08.pdf'),
('SG101500', NULL, '2024-02-27', 'WF', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_Walking floor-Rev08.pdf'),
('SG101422', NULL, '2024-02-28', 'WF', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_Walking floor-Rev08.pdf'),
('SG101423', NULL, '2024-02-28', 'WF', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_Walking floor-Rev08.pdf'),
(NULL, '10001376', '2024-02-29', 'WF', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_Walking floor-Rev08.pdf'),
(NULL, '10001377', '2024-02-29', 'WF', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(02)February_Walking floor-Rev08.pdf'),

('SG101492', NULL, '2024-03-01', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev07.pdf'),
('SG101480', NULL, '2024-03-04', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev07.pdf'),
('SG101456', NULL, '2024-03-05', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev07.pdf'),
('SG101457', NULL, '2024-03-06', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev07.pdf'),
('SG101493', NULL, '2024-03-07', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev07.pdf'),
('SG101548', NULL, '2024-03-08', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev07.pdf'),
('SG101505', NULL, '2024-03-11', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev07.pdf'),
('SG101402', NULL, '2024-03-12', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev07.pdf'),
('SG101305', NULL, '2024-03-13', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev07.pdf'),
('SG101547', NULL, '2024-03-14', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev07.pdf'),
('SG101494', NULL, '2024-03-15', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev07.pdf'),
('SG101506', NULL, '2024-03-18', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev07.pdf'),
('SG101458', NULL, '2024-03-19', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev07.pdf'),
('SG101530', NULL, '2024-03-20', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev07.pdf'),
('SG101459', NULL, '2024-03-21', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev07.pdf'),
('SG101539', NULL, '2024-03-22', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev07.pdf'),
('SG101507', NULL, '2024-03-25', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev07.pdf'),
('SG101414', NULL, '2024-03-26', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev07.pdf'),
('SG101460', NULL, '2024-03-27', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev07.pdf'),
('SG101508', NULL, '2024-03-28', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev07.pdf'),
('SG101495', NULL, '2024-03-29', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev07.pdf'),

('SG101501', NULL, '2024-03-05', 'WF', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_Walking floor-Rev07.pdf'),
('SG101424', NULL, '2024-03-07', 'WF', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_Walking floor-Rev07.pdf'),
('SG101425', NULL, '2024-03-07', 'WF', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_Walking floor-Rev07.pdf'),
(NULL, '10001378', '2024-03-08', 'WF', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_Walking floor-Rev07.pdf'),
(NULL, '10001379', '2024-03-08', 'WF', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_Walking floor-Rev07.pdf'),
('SG101502', NULL, '2024-03-12', 'WF', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_Walking floor-Rev07.pdf'),
('SG101503', NULL, '2024-03-26', 'WF', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(03)March_Walking floor-Rev07.pdf'),

('SG101430', NULL, '2024-04-01', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev10.pdf'),
('SG101443', NULL, '2024-04-02', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev10.pdf'),
('SG101534', NULL, '2024-04-03', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev10.pdf'),
('SG101453', NULL, '2024-04-04', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev10.pdf'),
('SG101306', NULL, '2024-04-05', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev10.pdf'),
('SG101509', NULL, '2024-04-08', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev10.pdf'),
('SG101454', NULL, '2024-04-09', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev10.pdf'),
('SG101415', NULL, '2024-04-10', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev10.pdf'),
('SG101510', NULL, '2024-04-15', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev10.pdf'),
('SG101523', NULL, '2024-04-16', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev10.pdf'),
('SG101511', NULL, '2024-04-17', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev10.pdf'),
('SG101496', NULL, '2024-04-18', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev10.pdf'),
('SG101512', NULL, '2024-04-22', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev10.pdf'),
('SG101525', NULL, '2024-04-24', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev10.pdf'),
('SG101455', NULL, '2024-04-25', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev10.pdf'),
('SG101551', NULL, '2024-04-26', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev10.pdf'),
('SG101450', NULL, '2024-04-29', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev10.pdf'),
('SG101526', NULL, '2024-04-30', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev10.pdf'),

('SG101504', NULL, '2024-04-09', 'WF', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_Walking floor-Rev09.pdf'),
('SG101370', NULL, '2024-04-11', 'WF', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_Walking floor-Rev09.pdf'),
('SG101521', NULL, '2024-04-16', 'WF', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_Walking floor-Rev09.pdf'),

('SG101442', NULL, '2024-05-01', 'ED', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev08.pdf'),
('SG101476', NULL, '2024-05-02', 'ED', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev08.pdf'),
('SG101435', NULL, '2024-05-03', 'ED', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev08.pdf'),
('SG101369', NULL, '2024-05-06', 'ED', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev08.pdf'),
('SG101477', NULL, '2024-05-07', 'ED', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev08.pdf'),
('SG101552', NULL, '2024-05-10', 'ED', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev08.pdf'),
('SG101522', NULL, '2024-05-15', 'ED', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev08.pdf'),
('SG101527', NULL, '2024-05-21', 'ED', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev08.pdf'),
('SG101451', NULL, '2024-05-22', 'ED', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev08.pdf'),
('SG101468', NULL, '2024-05-23', 'ED', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev08.pdf'),
('SG101452', NULL, '2024-05-24', 'ED', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev08.pdf'),
('SG101528', NULL, '2024-05-27', 'ED', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev08.pdf'),
('SG101541', NULL, '2024-05-28', 'ED', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev08.pdf'),
('SG101529', NULL, '2024-05-30', 'ED', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev08.pdf'),

('SG101444', NULL, '2024-06-03', 'ED', 'Rev05', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(06)June_End Dump-Rev05.pdf'),
('SG101531', NULL, '2024-06-05', 'ED', 'Rev05', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(06)June_End Dump-Rev05.pdf'),
('SG101549', NULL, '2024-06-07', 'ED', 'Rev05', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(06)June_End Dump-Rev05.pdf'),
('SG101461', NULL, '2024-06-10', 'ED', 'Rev05', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(06)June_End Dump-Rev05.pdf'),
('SG101532', NULL, '2024-06-11', 'ED', 'Rev05', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(06)June_End Dump-Rev05.pdf'),
('SG101542', NULL, '2024-06-18', 'ED', 'Rev05', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(06)June_End Dump-Rev05.pdf'),
('SG101441', NULL, '2024-06-24', 'ED', 'Rev05', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(06)June_End Dump-Rev05.pdf')
;

SELECT
	'These Quote''s are in duplicate on Vince''s schedule.'
	,[Quote]
FROM
	@vinceTables20240205
WHERE
	[Quote] IS NOT NULL
GROUP BY
	[Quote]
HAVING
	COUNT(*) > 1
;

SELECT
	'These WO''s are in duplicate on Vince''s schedule.'
	[WO]
FROM
	@vinceTables20240205
WHERE
	[WO] IS NOT NULL
GROUP BY
	[WO]
HAVING
	COUNT(*) > 1
;

SELECT
	'These Date''s and Lines have more than 1 entry on Vince''s schedule.',
	[Date],
	[Line],
	COUNT(*) AS [C]
FROM
	@vinceTables20240205
GROUP BY
	[Date],
	[Line]
HAVING
	COUNT(*) > 1
;

SELECT
	ROW_NUMBER() OVER(
		PARTITION BY
			[Line]
			,[Date]
		ORDER BY
			[ID]
	) AS [Rn]
	,*
FROM
	@vinceTables20240205
;

SELECT
	'Active STG Prod Lines'
	,*
FROM
	[Stargatedb].[dbo].[Prod Lines]
WHERE
	[Active] = 1
;

UPDATE
	@vinceTables20240205
SET
	[Line] = [Src].[Line] + CAST([Src].[Rn] AS NVARCHAR(MAX))
FROM (
	SELECT
		ROW_NUMBER() OVER(
			PARTITION BY
				[Line]
				,[Date]
			ORDER BY
				[ID]
		) AS [Rn]
		,*
	FROM
		@vinceTables20240205
) AS [Src]
INNER JOIN
	@vinceTables20240205 [V]
ON
	ISNULL([V].[Quote], '') = ISNULL([Src].[Quote], '')
	AND ISNULL([V].[WO], '') = ISNULL([Src].[WO], '')
;

SELECT
	'Pre-Orders and dtProductionSchedule Update'
	,*
FROM
	@vinceTables20240205
;

BEGIN TRAN;

	SELECT
		'Before'
		,*
	FROM
		[Stargatedb].[dbo].[dtProductionScheduleV2] [P]
	INNER JOIN
		@vinceTables20240205 [V]
	ON
		ISNULL([V].[Quote], '') = ISNULL([P].[SGQuote], '')
	;

	SELECT
		'Before'
		,*
	FROM
		[BWSdb].[dbo].[OrdersV2] [O]
	INNER JOIN
		@vinceTables20240205 [V]
	ON
		ISNULL([V].[Quote], '') = ISNULL([O].[SGQuote], '')
	;

	UPDATE
		[BWSdb].[dbo].[OrdersV2]
	SET
		[JobAvailableLine] = [Line]
		,[Available Date] = [Date]
		,[JobAvailableScheduled] = GETDATE()
		,[JobAvailableScheduledBy] = 'vincef via abriggs'
	FROM
		@vinceTables20240205 [V]
	INNER JOIN
		[BWSdb].[dbo].[OrdersV2] [O]
	ON
		ISNULL([V].[Quote], '') = ISNULL([O].[SGQuote], '')
	;

	UPDATE
		[Stargatedb].[dbo].[dtProductionScheduleV2]
	SET
		[JobStartLine] = [Line]
		,[JobFinishDate] = [Date]
	FROM
		@vinceTables20240205 [V]
	INNER JOIN
		[Stargatedb].[dbo].[dtProductionScheduleV2] [P]
	ON
		ISNULL([V].[Quote], '') = ISNULL([P].[SGQuote], '')
	;

	SELECT
		'After'
		,*
	FROM
		[Stargatedb].[dbo].[dtProductionScheduleV2] [P]
	INNER JOIN
		@vinceTables20240205 [V]
	ON
		ISNULL([V].[Quote], '') = ISNULL([P].[SGQuote], '')
	;

	SELECT
		'After'
		,*
	FROM
		[BWSdb].[dbo].[OrdersV2] [O]
	INNER JOIN
		@vinceTables20240205 [V]
	ON
		ISNULL([V].[Quote], '') = ISNULL([O].[SGQuote], '')
	;

ROLLBACK;
COMMIT;


SELECT
	*
FROM
	[OrdersV2] [O]
WHERE
	[O].[JobAvailableLine] = 'WF2'


SELECT
	*
FROM
	[Stargatedb].[dbo].[dtProductionScheduleV2] [D]
WHERE
	[D].[JobStartLine] = 'WF2'

BEGIN TRAN;

	UPDATE
		[BWSdb].[dbo].[OrdersV2]
	SET
		[JobAvailableLine] = 'WFL'
	WHERE
		[JobAvailableLine] = 'WF1'

	UPDATE
		[Stargatedb].[dbo].[dtProductionScheduleV2]
	SET
		[JobStartLine] = 'WFL'
	WHERE
		[JobStartLine] = 'WF1'

	UPDATE
		[BWSdb].[dbo].[OrdersV2]
	SET
		[JobAvailableLine] = 'TPL'
	WHERE
		[JobAvailableLine] = 'WF2'

	UPDATE
		[Stargatedb].[dbo].[dtProductionScheduleV2]
	SET
		[JobStartLine] = 'TPL'
	WHERE
		[JobStartLine] = 'WF2'

ROLLBACK;
COMMIT;