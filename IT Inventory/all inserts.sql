BEGIN TRAN;


	SELECT 'A v_ITI Item' AS [Table], * FROM [dbo].[v_ITI_Items] 
	SELECT 'A ITI Item' AS [Table], * FROM [ITI Item];
	SELECT 'A ITI InvMaster' AS [Table], * FROM [ITI InvMaster];
	SELECT 'A ITI InvMaster Snap' AS [Table], * FROM [ITI InvMaster Snap];

	DECLARE @table AS TABLE ([ID] [int] IDENTITY(1,1),
		[Name] [nvarchar](max),
		[Description] [nvarchar](max),
		[IsActive] [bit],
		[Condition] [int],
		[Status] [int],
		[Type] [int],
		[SubType] [int],
		[DateCreated] [datetime])

	INSERT INTO @table ([Name], [Description], [IsActive], [Condition], [Status], [Type], [SubType], [DateCreated]) VALUES
	('UNKNOWN', 'UNKNOWN', 1, 1, 1, 1, 1, GETDATE()),
	('17" Monitor', '17" Monitor', 1, 2, 1, 3, 10, GETDATE()),
	('19" Monitor', '19" Monitor', 1, 2, 1, 3, 10, GETDATE()),
	('19" Monitor', '19" Monitor', 1, 3, 1, 3, 10, GETDATE()),
	('20" Monitor', '20" Monitor', 1, 3, 1, 3, 10, GETDATE()),
	('22" Monitor', '22" Monitor', 1, 3, 1, 3, 10, GETDATE()),
	('23" Monitor', '23" Monitor Both are Dim', 1, 3, 1, 3, 10, GETDATE()),
	('24" Monitor', '24" Monitor', 1, 3, 1, 3, 10, GETDATE()),
	('27" Monitor', '27" Monitor', 1, 2, 1, 3, 10, GETDATE()),
	('27" Monitor', '27" Monitor Dim', 1, 3, 1, 3, 10, GETDATE()),
	('Office Spare', 'Office Spare (2 are mini PCs)', 1, 3, 1, 2, 5, GETDATE()),
	('Shopclock Spare', 'Shopclock Spare', 1, 3, 1, 2, 3, GETDATE()),
	('Laptops', 'Laptops', 1, 3, 1, 2, 2, GETDATE()),
	('Wired keyboard', 'Wired keyboard', 1, 3, 1, 3, 6, GETDATE()),
	('Wired Mouse', 'Wired Mouse', 1, 3, 1, 3, 4, GETDATE()),
	('Wireless Keyboard', 'Wireless Keyboard', 1, 3, 1, 3, 7, GETDATE()),
	('Wireless Mouse', 'Wireless Mouse', 1, 2, 1, 3, 3, GETDATE()),
	('Wireless Mouse', 'Wireless Mouse', 1, 3, 1, 3, 3, GETDATE()),
	('Wired Keyboard Mouse set', 'Wired Keyboard Mouse set', 1, 2, 1, 3, 12, GETDATE()),
	('Wireless Keyboard Mouse set', 'Wireless Keyboard Mouse set', 1, 2, 1, 3, 13, GETDATE()),
	('Wireless Keyboard Mouse set', 'Wireless Keyboard Mouse set', 1, 3, 1, 3, 13, GETDATE()),
	('C270 Webcam', 'C270 Webcam', 1, 2, 1, 3, 8, GETDATE()),
	('C270 Webcam', 'C270 Webcam', 1, 3, 1, 3, 8, GETDATE()),
	('Headset', 'Headset', 1, 2, 1, 3, 14, GETDATE()),
	('Headset', 'Headset', 1, 3, 1, 3, 14, GETDATE()),
	('3 ft. Ethernet Cables', '3 ft. Ethernet Cables', 1, 2, 1, 5, 3, GETDATE()),
	('10 ft. Ethernet Cables', '10 ft. Ethernet Cables', 1, 2, 1, 5, 3, GETDATE()),
	('15 ft. Ethernet Cables', '15 ft. Ethernet Cables', 1, 2, 1, 5, 3, GETDATE()),
	('25 ft. Ethernet Cables', '25 ft. Ethernet Cables', 1, 2, 1, 5, 3, GETDATE()),
	('Cat-5 Ethernet For Printers', 'Cat-5 Ethernet For Printers', 1, 2, 1, 5, 3, GETDATE()),
	('Random Ethernet', 'Random Ethernet', 1, 3, 1, 5, 3, GETDATE()),
	('Serial Cable', 'Serial Cable', 1, 2, 1, 5, 2, GETDATE()),
	('Serial Cable', 'Serial Cable', 1, 3, 1, 5, 2, GETDATE()),
	('VGA Cable', 'VGA Cable', 1, 2, 1, 5, 2, GETDATE()),
	('VGA Cable', 'VGA Cable', 1, 3, 1, 5, 2, GETDATE()),
	('DVI Cable', 'DVI Cable', 1, 3, 1, 5, 2, GETDATE()),
	('HDMI Cable', 'HDMI Cable', 1, 2, 1, 5, 2, GETDATE()),
	('HDMI Cable', 'HDMI Cable', 1, 3, 1, 5, 2, GETDATE()),
	('Display Port Cable', 'Display Port Cable', 1, 2, 1, 5, 2, GETDATE()),
	('Display Port Cable', 'Display Port Cable', 1, 3, 1, 5, 2, GETDATE()),
	('(M)USB to  (F)Ethernet Adapter', '(M)USB to  (F)Ethernet Adapter', 1, 2, 1, 5, 3, GETDATE()),
	('(M)USB to  (F)Ethernet Adapter', '(M)USB to  (F)Ethernet Adapter', 1, 3, 1, 5, 3, GETDATE()),
	('(M)HDMI to  (F)VGA Adapter', '(M)HDMI to  (F)VGA Adapter', 1, 2, 1, 5, 2, GETDATE()),
	('(M)HDMI to  (F)VGA Adapter', '(M)HDMI to  (F)VGA Adapter', 1, 3, 1, 5, 2, GETDATE()),
	('(M)HDMI to (M)DVI cable', '(M)HDMI to (M)DVI cable', 1, 3, 1, 5, 2, GETDATE()),
	('(M) Display to (F) HDMI Adapter', '(M) Display to (F) HDMI Adapter', 1, 2, 1, 5, 2, GETDATE()),
	('(M) Display to (F) HDMI Adapter', '(M) Display to (F) HDMI Adapter', 1, 3, 1, 5, 2, GETDATE()),
	('(M)Display to  (F)VGA Adapter', '(M)Display to  (F)VGA Adapter', 1, 2, 1, 5, 2, GETDATE()),
	('(M)Display to  (F)VGA Adapter', '(M)Display to  (F)VGA Adapter', 1, 3, 1, 5, 2, GETDATE()),
	('(M)Display to  (F)DVI Adapter', '(M)Display to  (F)DVI Adapter', 1, 2, 1, 5, 2, GETDATE()),
	('(M)Display to  (F)DVI Adapter', '(M)Display to  (F)DVI Adapter', 1, 3, 1, 5, 2, GETDATE()),
	('(M)HDMI to (M)Micro HDMI', '(M)HDMI to (M)Micro HDMI', 1, 3, 1, 5, 2, GETDATE()),
	('(M) USB-C to (F) USB', '(M) USB-C to (F) USB', 1, 3, 1, 5, 4, GETDATE()),
	('(M) USB-C to  (F) HDMI', '(M) USB-C to  (F) HDMI', 1, 3, 1, 5, 2, GETDATE()),
	('(M)VGA to  (F)HDMI Converter', '(M)VGA to  (F)HDMI Converter', 1, 2, 1, 5, 2, GETDATE()),
	('usb-c to usb-c  charging cable', 'usb-c to usb-c  charging cable', 1, 2, 1, 5, 4, GETDATE()),
	('usb-c 3.1 ', 'usb-c 3.1 ', 1, 2, 1, 5, 4, GETDATE()),
	('usb-c 3.1 ', 'usb-c 3.1 ', 1, 3, 1, 5, 4, GETDATE()),
	('usb to lightning  iPhone charger', 'usb to lightning  iPhone charger 2 @ 3 ft. 2 @ 6 ft.', 1, 2, 1, 5, 7, GETDATE()),
	('3-Outlet  Extension Cords', '3-Outlet  Extension Cords', 1, 2, 1, 5, 5, GETDATE()),
	('3-slot Universal  Power Cord', '3-slot Universal  Power Cord', 1, 2, 1, 5, 5, GETDATE()),
	('3-slot Universal  Power Cord', '3-slot Universal  Power Cord', 1, 3, 1, 5, 5, GETDATE()),
	(' Power Cord Three-pin  ', ' Power Cord Three-pin  ', 1, 3, 1, 5, 5, GETDATE()),
	('Thunderbolt3 dock', 'Thunderbolt3 dock', 1, 2, 1, 3, 16, GETDATE()),
	('USB-C HUB', 'USB-C HUB', 1, 2, 1, 3, 17, GETDATE()),
	('Power bar', 'Power bar', 1, 3, 1, 5, 5, GETDATE()),
	('Power Banks -  BackUps', 'Power Banks -  BackUps', 1, 2, 1, 5, 6, GETDATE()),
	('Power Banks -  BackUps', 'Power Banks -  BackUps', 1, 3, 1, 5, 6, GETDATE()),
	('USB to Square Printer Cables', 'USB to Square Printer Cables', 1, 2, 1, 5, 4, GETDATE()),
	('USB to Square Printer Cables', 'USB to Square Printer Cables', 1, 3, 1, 5, 4, GETDATE()),
	('DVI Splitter', 'DVI Splitter', 1, 3, 1, 5, 2, GETDATE()),
	('Audio Splitter', 'Audio Splitter', 1, 3, 1, 5, 2, GETDATE()),
	('3.5mm Audio Jack', '3.5mm Audio Jack', 1, 3, 1, 5, 2, GETDATE()),
	('Wall Phone Cord', 'Wall Phone Cord', 1, 2, 1, 5, 7, GETDATE()),
	('Wall Phone Cord', 'Wall Phone Cord', 1, 3, 1, 5, 7, GETDATE()),
	('Curley Phone Cord', 'Curley Phone Cord', 1, 2, 1, 5, 7, GETDATE()),
	('Monitor Arms', 'Monitor Arms', 1, 2, 1, 3, 19, GETDATE()),
	('Computer Speakers', 'Computer Speakers', 1, 3, 1, 3, 20, GETDATE()),
	('USB Keypad', 'USB Keypad', 1, 2, 1, 3, 22, GETDATE()),
	('Engineer  SpaceMouse', 'Engineer  SpaceMouse', 1, 3, 1, 3, 23, GETDATE()),
	('Phone with display', 'Phone with display', 1, 3, 1, 2, 7, GETDATE()),
	('Phone - No display', 'Phone - No display Just base', 1, 3, 1, 2, 7, GETDATE()),
	('AA Batteries', 'AA Batteries', 1, 2, 1, 3, 24, GETDATE()),
	('AA Batteries', 'AA Batteries', 1, 3, 1, 3, 24, GETDATE()),
	('AAA Batteries', 'AAA Batteries', 1, 2, 1, 3, 25, GETDATE()),
	('AAA Batteries', 'AAA Batteries', 1, 3, 1, 3, 25, GETDATE())

	SELECT * FROM @table

	DECLARE @i AS INTEGER;
	DECLARE @c AS INTEGER;
	SET @i = 0;
	SELECT @c = COUNT(*) FROM @table;

	WHILE @i <= @c BEGIN

		INSERT INTO [ITI Item] ([Name], [Description], [IsActive], [Condition], [Status], [Type], [SubType])
		SELECT [Name], [Description], [IsActive], [Condition], [Status], [Type], [SubType] FROM @table WHERE [ID] = @i;
		SET @i = @i + 1;

	END


	SELECT 'B v_ITI Item' AS [Table], * FROM [dbo].[v_ITI_Items] 
	SELECT 'B ITI Item' AS [Table], * FROM [ITI Item];
	SELECT 'B ITI InvMaster' AS [Table], * FROM [ITI InvMaster];
	SELECT 'B ITI InvMaster Snap' AS [Table], * FROM [ITI InvMaster Snap];


ROLLBACK;
COMMIT;