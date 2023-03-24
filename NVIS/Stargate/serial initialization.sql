USE BWSdb
GO

--SELECT * FROM [Orders] WHERE [Model No] LIKE '%2313%'
SELECT * FROM [OrdersV2] WHERE [SGQuote] = 'SG101099';
SELECT * FROM [OrdersV2] INNER JOIN [SN Type V2] ON [OrdersV2].[Model No] = [SN Type V2].[Model No] WHERE [SGQuote] = 'SG101099';

SELECT DISTINCT [YEAR] FROM [SNC Year] GROUP BY [Year] HAVING  COUNT(*) > 1
SELECT [Model No] FROM [ProductsV2] GROUP BY [Model No] HAVING  COUNT(*) > 1
SELECT * FROM [ProductsV2] WHERE [Model No] = 'Pony Dump 3X17'

BEGIN TRAN;

--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D334RM000001', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 03, 2023
--Jan 11, 2023 - SDH - Fixed wording on Calcium Tank, Red paint and spelling error on capacity
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4424'' to ''2SVS6D334RM000001''' WHERE [SGQuote] = 'SG100942';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D336RM000002', [Notes] = 'March 15, 2023 - JAAM - As per Change Order, Add Reverse Lights to Rear Middle Plate (Inside Lights), Add 2nd Set of Reverse Lights on Side below Side Rail, between Front & Middle Axle, Add Grain Sock, and Add Compression Locks to Side of Tailgate, Change Box Length to 38 ft.
--March 16, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 03, 2023
--March 24, 2023 - JAAM - As per Change Order, Remove Front D/S Steps.
--March 24, 2023 - JAAM - As per Change Order, Change Man Door location to Driver''s Side.
--March 24, 2023 - JAAM - As per Change Order, Change Lift Axle from Middle to Front Axle
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4494'' to ''2SVS6D336RM000002''' WHERE [SGQuote] = 'SG101118';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D338RM000003', [Notes] = 'March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 04, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4484'' to ''2SVS6D338RM000003''' WHERE [SGQuote] = 'SG101102';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D33XRM000004', [Notes] = 'December 08, 2022 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 04, 2023
--March 10, 2023 - JAAM - As per Change Order, Add Compression Locks to Bottom of Tailgate.
--March 24th, 2023 - ABRIGGS - Serial Number change: ''9982'' to ''2SVS6D33XRM000004''' WHERE [SGQuote] = 'SG100904';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P437RM000005', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 04, 2023
--March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4446'' to ''2SVS6P437RM000005''' WHERE [SGQuote] = 'SG100936';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D333RM000006', [Notes] = 'January 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 05, 2023
--February 02, 2023 - JAAM - As per Sales Meeting, Updated Steer Axle (Dexter), Added Light Shield Dimension
--Feb. 22, 2023 – JAAM – As per Signed Change Order, Added Aluminum Round Rod to Tailgate.
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4405'' to ''2SVS6D333RM000006''' WHERE [SGQuote] = 'SG101005';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D335RM000007', [Notes] = 'March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 05, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4485'' to ''2SVS6D335RM000007''' WHERE [SGQuote] = 'SG101103';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D337RM000008', [Notes] = 'December 08, 2022 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 06, 2023
--March 10, 2023 - JAAM - As per Change Order, Add Compression Locks to Bottom of Tailgate.
--March 24th, 2023 - ABRIGGS - Serial Number change: ''9983'' to ''2SVS6D337RM000008''' WHERE [SGQuote] = 'SG100905';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P431RM000009', [Notes] = 'March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 07, 2023
--March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
--March 23, 2023 - JAAM - As per Change Order, Change Board & Tarp Color to Red. Add 6 - 36" Mudflaps in the Rear of the Box (Ship Loose)
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4496'' to ''2SVS6P431RM000009''' WHERE [SGQuote] = 'SG101096';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D335RM000010', [Notes] = 'February 03, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to July 03, 2023
--Feb. 23, 2023 – JAAM – As per Signed Change Order, Added Aluminum Round Rod to Tailgate.
--March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 10, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4486'' to ''2SVS6D335RM000010''' WHERE [SGQuote] = 'SG101104';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS61532RM000011', [Notes] = 'March 09, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 10, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''8108'' to ''2SVS61532RM000011''' WHERE [SGQuote] = 'SG101088';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D44XRM000012', [Notes] = 'December 05, 2022 - SDH - Changed Est. Delivery Date from May 20, 2021 to March 10, 2023
--December 15, 2022 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 11, 2023
--January 16, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 13, 2023
--March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 10, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''9858'' to ''2SVS6D44XRM000012''' WHERE [SGQuote] = 'SG100888';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P435RM000013', [Notes] = 'December 15, 2022 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 11, 2023
--March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4422'' to ''2SVS6P435RM000013''' WHERE [SGQuote] = 'SG100922';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D332RM000014', [Notes] = 'January 16, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 11, 2023
--Feb. 22, 2023 – JAAM – As per Signed Change Order, Added Aluminum Round Rod to Tailgate.
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4463'' to ''2SVS6D332RM000014''' WHERE [SGQuote] = 'SG101028';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D334RM000015', [Notes] = 'March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 11, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4487'' to ''2SVS6D334RM000015''' WHERE [SGQuote] = 'SG101105';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D336RM000016', [Notes] = 'March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 12, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4488'' to ''2SVS6D336RM000016''' WHERE [SGQuote] = 'SG101106';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D338RM000017', [Notes] = 'March 09, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 12, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4480'' to ''2SVS6D338RM000017''' WHERE [SGQuote] = 'SG101086';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D33XRM000018', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 19, 2023
--March 22, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 13, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''9863'' to ''2SVS6D33XRM000018''' WHERE [SGQuote] = 'SG100918';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS61435RM000019', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to February 14, 2023
--January 25, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to March 03, 2023
--March 01, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to March 14, 2023
--March 20, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 14, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''8106'' to ''2SVS61435RM000019''' WHERE [SGQuote] = 'SG100978';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6B443RM000020', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to January 27, 2023
--Jan 11, 2023 - SDH - Fixed wording on tailgate operation as spelling error.
--January 25, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to February 21, 2023
--March 01, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to March 31, 2023
--March 20, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 14, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''3217'' to ''2SVS6B443RM000020''' WHERE [SGQuote] = 'SG100966';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D440RM000021', [Notes] = 'December 05, 2022 - SDH - Changed Est. Delivery Date from May 20, 2021 to March 07, 2023
--December 15, 2022 - SDH - Changed Est. Delivery Date from May 20, 2021 to March 10, 2023
--December 15, 2022 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 10, 2023
--Feb 16, 2023 - SDH - Add 2 way gate, 15 clear lights top and bottom rail, all rear lights to be clear, 6 pairs of ground effect lights
--March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 07, 2023
--March 21, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 14, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''9857'' to ''2SVS6D440RM000021''' WHERE [SGQuote] = 'SG100886';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D331RM000022', [Notes] = 'December 08, 2022 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 07, 2023
--March 10, 2023 - JAAM - As per Change Order, Add Compression Locks to Bottom of Tailgate.
--March 21, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 14, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''9984'' to ''2SVS6D331RM000022''' WHERE [SGQuote] = 'SG100906';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D333RM000023', [Notes] = 'March 15, 2023 - JAAM - As per Change Order, Add Reverse Lights to Rear Middle Plate (Inside Lights), Add 2nd Set of Reverse Lights on Side below Side Rail, between Front & Middle Axle, Add Grain Sock, and Add Compression Locks to Side of Tailgate, Change Box Length to 38 ft.
--March 16, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 03, 2023
--March 24, 2023 - JAAM - As per Change Order, Remove Front D/S Steps.
--March 24, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 17, 2023
--March 24, 2023 - JAAM - As per Change Order, Change Man Door location to Driver''s Side.
--March 24, 2023 - JAAM - As per Change Order, Change Lift Axle from Middle to Front Axle to match 4494.
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4503'' to ''2SVS6D333RM000023''' WHERE [SGQuote] = 'SG101137';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D335RM000024', [Notes] = 'February 02, 2023 - JAAM - As per Sales Meeting, Fixed Wheels wording, Added Mandoor Location, Fixed Wording for Jug Holder, Removed Hydraulic Hoses
--February 03, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 18, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4466'' to ''2SVS6D335RM000024''' WHERE [SGQuote] = 'SG101037';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS61532RM000025', [Notes] = 'March 09, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 18, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''8109'' to ''2SVS61532RM000025''' WHERE [SGQuote] = 'SG101091';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P431RM000026', [Notes] = 'December 15, 2022 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 18, 2023
--March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4423'' to ''2SVS6P431RM000026''' WHERE [SGQuote] = 'SG100923';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D441RM000027', [Notes] = 'March 09, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 19, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''9333'' to ''2SVS6D441RM000027''' WHERE [SGQuote] = 'SG101070';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D332RM000028', [Notes] = 'March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 19, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4501'' to ''2SVS6D332RM000028''' WHERE [SGQuote] = 'SG101101';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D334RM000029', [Notes] = 'February 23, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 20, 2023
--Feb 15, change to all colored lights and rear to be 3 per side in lieu of 13 as per change roder.
--Feb 28, 2023 - SDH - Add Compression locks on bottom of gate as per Change order
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4476'' to ''2SVS6D334RM000029''' WHERE [SGQuote] = 'SG101064';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D330RM000030', [Notes] = 'January 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 28, 2023
--February 02, 2023 - JAAM - As per Sales Meeting, Updated Steer Axle (Dexter), Added Light Shield Dimension
--Feb. 23, 2023 – JAAM – As per Signed Change Order, Added Aluminum Round Rod to Tailgate.
--March 22, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 20, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4410'' to ''2SVS6D330RM000030''' WHERE [SGQuote] = 'SG101010';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D332RM000031', [Notes] = 'March 09, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 21, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4483'' to ''2SVS6D332RM000031''' WHERE [SGQuote] = 'SG101090';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D445RM000032', [Notes] = 'March 09, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 05, 2023
--March 22, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 21, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''9334'' to ''2SVS6D445RM000032''' WHERE [SGQuote] = 'SG101078';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P436RM000033', [Notes] = 'March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 21, 2023
--March 13, 2023 - SDH - Updated standard specificatoon from Enginering/production to  front fenders to have two brackets
--March 15, 2023 - added paint code for green
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4500'' to ''2SVS6P436RM000033''' WHERE [SGQuote] = 'SG101094';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D338RM000034', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 24, 2023
--Jan 11, 2023 - SDH - Fixed wording on Calcium Tank, Red paint and spelling error on capacity
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4425'' to ''2SVS6D338RM000034''' WHERE [SGQuote] = 'SG100943';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P433RM000035', [Notes] = 'December 15, 2022 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 25, 2023
--March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
--March 24th, 2023 - ABRIGGS - Serial Number change: ''9998'' to ''2SVS6P433RM000035''' WHERE [SGQuote] = 'SG100925';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D331RM000036', [Notes] = 'January 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 25, 2023
--February 02, 2023 - JAAM - As per Sales Meeting, Updated Steer Axle (Dexter), Added Light Shield Dimension
--Feb. 22, 2023 – JAAM – As per Signed Change Order, Added Aluminum Round Rod to Tailgate.
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4406'' to ''2SVS6D331RM000036''' WHERE [SGQuote] = 'SG101006';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D333RM000037', [Notes] = 'January 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 26, 2023
--February 02, 2023 - JAAM - As per Sales Meeting, Updated Steer Axle (Dexter), Added Light Shield Dimension
--Feb. 22, 2023 – JAAM – As per Signed Change Order, Added Aluminum Round Rod to Tailgate.
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4407'' to ''2SVS6D333RM000037''' WHERE [SGQuote] = 'SG101007';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D335RM000038', [Notes] = 'January 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 27, 2023
--February 02, 2023 - JAAM - As per Sales Meeting, Updated Steer Axle (Dexter), 
--Feb. 23, 2023 – JAAM – As per Signed Change Order, Added Aluminum Round Rod to Tailgate.
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4408'' to ''2SVS6D335RM000038''' WHERE [SGQuote] = 'SG101008';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D423RM000039', [Notes] = 'March 03, 2023 - hclark - THIS QUOTE WAS DONE WITH SG101047 THEN CHANGED TO A STARGATE UNIT
--March 09, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 28, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''9506'' to ''2SVS6D423RM000039''' WHERE [SGQuote] = 'SG100761';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P430RM000040', [Notes] = 'March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 28, 2023
--March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4497'' to ''2SVS6P430RM000040''' WHERE [SGQuote] = 'SG101097';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D335RM000041', [Notes] = 'January 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 01, 2023
--February 02, 2023 - JAAM - As per Sales Meeting, Updated Steer Axle (Dexter), Added Light Shield Dimension
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4411'' to ''2SVS6D335RM000041''' WHERE [SGQuote] = 'SG101011';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D337RM000042', [Notes] = 'January 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 02, 2023
--February 02, 2023 - JAAM - As per Sales Meeting, Updated Steer Axle (Dexter), Added Light Shield Dimension
--Feb. 23, 2023 – JAAM – As per Signed Change Order, Added Aluminum Round Rod to Tailgate.
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4413'' to ''2SVS6D337RM000042''' WHERE [SGQuote] = 'SG101013';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P431RM000043', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 02, 2023
--March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4447'' to ''2SVS6P431RM000043''' WHERE [SGQuote] = 'SG100937';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D128RM000044', [Notes] = 'March 23, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 02, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4609'' to ''2SVS6D128RM000044''' WHERE [SGQuote] = 'SG101114';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D332RM000045', [Notes] = 'January 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 03, 2023
--February 02, 2023 - JAAM - As per Sales Meeting, Updated Steer Axle (Dexter), Added Light Shield Dimension
--Feb. 23, 2023 – JAAM – As per Signed Change Order, Added Aluminum Round Rod to Tailgate.
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4414'' to ''2SVS6D332RM000045''' WHERE [SGQuote] = 'SG101014';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D334RM000046', [Notes] = 'January 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 04, 2023
--February 02, 2023 - JAAM - As per Sales Meeting, Updated Steer Axle (Dexter), Added Light Shield Dimension
--Feb. 23, 2023 – JAAM – As per Signed Change Order, Added Aluminum Round Rod to Tailgate.
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4416'' to ''2SVS6D334RM000046''' WHERE [SGQuote] = 'SG101016';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D336RM000047', [Notes] = 'January 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 12, 2023
--February 02, 2023 - JAAM - As per Sales Meeting, Updated Steer Axle (Dexter), Added Light Shield Dimension
--Feb. 23, 2023 – JAAM – As per Signed Change Order, Added Aluminum Round Rod to Tailgate.
--March 22, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 05, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4412'' to ''2SVS6D336RM000047''' WHERE [SGQuote] = 'SG101012';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P43XRM000048', [Notes] = 'March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 05, 2023
--March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4498'' to ''2SVS6P43XRM000048''' WHERE [SGQuote] = 'SG101098';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D33XRM000049', [Notes] = 'March 09, 2023 - JAAM - As per Sales Meeting, Updated W/O
--March 09, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 08, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4607'' to ''2SVS6D33XRM000049''' WHERE [SGQuote] = 'SG101079';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D429RM000050', [Notes] = 'February 23, 2023 - hclark - 
--March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to March 23, 2023
--March 21, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 13, 2023
--March 22, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 09, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4606'' to ''2SVS6D429RM000050''' WHERE [SGQuote] = 'SG101075';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D338RM000051', [Notes] = 'March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 09, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4502'' to ''2SVS6D338RM000051''' WHERE [SGQuote] = 'SG101100';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P433RM000052', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 09, 2023
--March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4448'' to ''2SVS6P433RM000052''' WHERE [SGQuote] = 'SG100938';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D331RM000053', [Notes] = 'March 09, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 10, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4608'' to ''2SVS6D331RM000053''' WHERE [SGQuote] = 'SG101080';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D444RM000054', [Notes] = 'January 18, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 11, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4464'' to ''2SVS6D444RM000054''' WHERE [SGQuote] = 'SG101029';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D446RM000055', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 12, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''9862'' to ''2SVS6D446RM000055''' WHERE [SGQuote] = 'SG100917';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D346RM000056', [Notes] = 'December 06, 2022 - SDH - Changed Est. Delivery Date from May 20, 2021 to February 27, 2023
--January 18, 2023 - JAAM - Due to Inventory Shortage, Replace Continental Tires with General RA Tires
--February 03, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 20, 2023
--February 08, 2023 - JAAM - As per Substitution Form, Change Axle/Susp Configuration to Dexter Brand
--Feb 10, 2023 - SDH - Fixd spread to reflect 49 in.
--March 22, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 12, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''9689'' to ''2SVS6D346RM000056''' WHERE [SGQuote] = 'SG100880';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P431RM000057', [Notes] = 'March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 12, 2023
--March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4499'' to ''2SVS6P431RM000057''' WHERE [SGQuote] = 'SG101099';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D330RM000058', [Notes] = 'January 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 15, 2023
--February 02, 2023 - JAAM - As per Sales Meeting, Updated Steer Axle (Dexter), Added Light Shield Dimension
--Feb. 23, 2023 – JAAM – As per Signed Change Order, Added Aluminum Round Rod to Tailgate.
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4415'' to ''2SVS6D330RM000058''' WHERE [SGQuote] = 'SG101015';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D332RM000059', [Notes] = 'January 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 16, 2023
--February 02, 2023 - JAAM - As per Sales Meeting, Updated Steer Axle (Dexter), Added Light Shield Dimension
--Feb. 23, 2023 – JAAM – As per Signed Change Order, Added Aluminum Round Rod to Tailgate.
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4417'' to ''2SVS6D332RM000059''' WHERE [SGQuote] = 'SG101017';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D44XRM000060', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 26, 2023
--February 02, 2023 - JAAM - As per Sales Meeting, Updated Qty. of Compression Locks
--March 22, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 16, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''9864'' to ''2SVS6D44XRM000060''' WHERE [SGQuote] = 'SG100963';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P435RM000061', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 16, 2023
--March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4449'' to ''2SVS6P435RM000061''' WHERE [SGQuote] = 'SG100939';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D332RM000062', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 17, 2023
--Jan 11, 2023 - SDH - Fixed wording on Calcium Tank, Red paint and spelling error on capacity
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4426'' to ''2SVS6D332RM000062''' WHERE [SGQuote] = 'SG100944';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D334RM000063', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 18, 2023
--Jan 11, 2023 - SDH - Fixed wording on Calcium Tank, Red paint and spelling error on capacity
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4427'' to ''2SVS6D334RM000063''' WHERE [SGQuote] = 'SG100945';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D336RM000064', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 19, 2023
--Jan 11, 2023 - SDH - Fixed wording on Calcium Tank, Red paint and spelling error on capacity
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4428'' to ''2SVS6D336RM000064''' WHERE [SGQuote] = 'SG100946';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D449RM000065', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 05, 2023
--March 22, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 19, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''9861'' to ''2SVS6D449RM000065''' WHERE [SGQuote] = 'SG100916';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P433RM000066', [Notes] = 'March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 19, 2023
--March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4495'' to ''2SVS6P433RM000066''' WHERE [SGQuote] = 'SG101095';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D442RM000067', [Notes] = 'March 09, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 07, 2023
--March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 20, 2023
--March 22, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 19, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''9870'' to ''2SVS6D442RM000067''' WHERE [SGQuote] = 'SG101082';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D333RM000068', [Notes] = 'March 09, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 23, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''9200'' to ''2SVS6D333RM000068''' WHERE [SGQuote] = 'SG101068';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D335RM000069', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 23, 2023
--Jan 11, 2023 - SDH - Fixed wording on Calcium Tank, Red paint and spelling error on capacity
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4429'' to ''2SVS6D335RM000069''' WHERE [SGQuote] = 'SG100947';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P437RM000070', [Notes] = 'January 16, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 23, 2023
--Feb 10, 2023 - SDH - Add reverse lights and both plugs to be standard plugs, no ISO
--March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4458'' to ''2SVS6P437RM000070''' WHERE [SGQuote] = 'SG101022';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D029RM000071', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to March 20, 2023
--February 14, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to March 24, 2023
--February 23, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to March 29, 2023
--March 20, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 24, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''9694'' to ''2SVS6D029RM000071''' WHERE [SGQuote] = 'SG100976';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D428RM000072', [Notes] = 'March 09, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 25, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''9699'' to ''2SVS6D428RM000072''' WHERE [SGQuote] = 'SG101083';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P438RM000073', [Notes] = 'March 06, 2023 - JAAM - Pair w/ Truck Box 1331
--March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 25, 2023
--March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4479'' to ''2SVS6P438RM000073''' WHERE [SGQuote] = 'SG101084';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D44XRM000074', [Notes] = '
--March 24th, 2023 - ABRIGGS - Serial Number change: ''9871'' to ''2SVS6D44XRM000074''' WHERE [SGQuote] = 'SG101093';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D035RM000075', [Notes] = 'January 09, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to March 20, 2023
--February 23, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to March 28, 2023
--March 09, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 21, 2023
--March 22, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 26, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''9695'' to ''2SVS6D035RM000075''' WHERE [SGQuote] = 'SG100979';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D332RM000076', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 29, 2023
--Jan 11, 2023 - SDH - Fixed wording on Calcium Tank, Red paint and spelling error on capacity
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4430'' to ''2SVS6D332RM000076''' WHERE [SGQuote] = 'SG100948';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D334RM000077', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 30, 2023
--Jan 11, 2023 - SDH - Fixed wording on Calcium Tank, Red paint and spelling error on capacity
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4431'' to ''2SVS6D334RM000077''' WHERE [SGQuote] = 'SG100949';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P436RM000078', [Notes] = 'January 16, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 30, 2023
--Feb 10, 2023 - SDH - Add reverse lights and both plugs to be standard plugs, no ISO
--March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4459'' to ''2SVS6P436RM000078''' WHERE [SGQuote] = 'SG101023';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D338RM000079', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 31, 2023
--Jan 11, 2023 - SDH - Fixed wording on Calcium Tank, Red paint and spelling error on capacity
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4432'' to ''2SVS6D338RM000079''' WHERE [SGQuote] = 'SG100950';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D334RM000080', [Notes] = 'February 03, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 02, 2023
--February 14, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 20, 2023
--Feb. 22, 2023 – JAAM – As per Signed Change Order, Added Aluminum Round Rod to Tailgate.
--March 20, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 02, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4470'' to ''2SVS6D334RM000080''' WHERE [SGQuote] = 'SG101041';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D336RM000081', [Notes] = 'March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 05, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4489'' to ''2SVS6D336RM000081''' WHERE [SGQuote] = 'SG101107';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D338RM000082', [Notes] = 'March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 06, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4490'' to ''2SVS6D338RM000082''' WHERE [SGQuote] = 'SG101108';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P433RM000083', [Notes] = 'Unit should be identical to 4458 and 4459
--February 03, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 06, 2023
--Feb 10, 2023 - SDH - Add reverse lights and both plugs to be standard plugs, no ISO
--February 10, 2023 - JAAM - As per SO Meeting, Added New Style Design to the Quote.
--March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4468'' to ''2SVS6P433RM000083''' WHERE [SGQuote] = 'SG101040';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS61426RM000084', [Notes] = 'February 14, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to March 21, 2023
--March 01, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 06, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''8107'' to ''2SVS61426RM000084''' WHERE [SGQuote] = 'SG101061';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D333RM000085', [Notes] = 'February 03, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 07, 2023
--Feb. 23, 2023 – JAAM – As per Signed Change Order, Added Aluminum Round Rod to Tailgate.
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4471'' to ''2SVS6D333RM000085''' WHERE [SGQuote] = 'SG101042';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D335RM000086', [Notes] = 'March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 08, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4491'' to ''2SVS6D335RM000086''' WHERE [SGQuote] = 'SG101109';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D448RM000087', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 09, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''9865'' to ''2SVS6D448RM000087''' WHERE [SGQuote] = 'SG100962';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P431RM000088', [Notes] = 'February 23, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 13, 2023
--March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4477'' to ''2SVS6P431RM000088''' WHERE [SGQuote] = 'SG101072';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P435RM000089', [Notes] = 'February 23, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 13, 2023
--March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4478'' to ''2SVS6P435RM000089''' WHERE [SGQuote] = 'SG101074';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D337RM000090', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 14, 2023
--Jan 11, 2023 - SDH - Fixed wording on Steer Suspension to reflect IMT (Dexter), added ball valve on Calcium Tank
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4433'' to ''2SVS6D337RM000090''' WHERE [SGQuote] = 'SG100940';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D339RM000091', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 15, 2023
--Jan 11, 2023 - SDH - Fixed wording on steer axle to say Dexter and Calcium tank to have ball valve
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4434'' to ''2SVS6D339RM000091''' WHERE [SGQuote] = 'SG100941';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D441RM000092', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 16, 2023
--February 02, 2023 - JAAM - As per Sales Meeting, Updated Qty. of Compression Locks
--March 24th, 2023 - ABRIGGS - Serial Number change: ''9866'' to ''2SVS6D441RM000092''' WHERE [SGQuote] = 'SG100964';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D332RM000093', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 19, 2023
--Jan 11, 2023 - SDH - Fixed wording on Calcium Tank, Red paint and spelling error on capacity
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4435'' to ''2SVS6D332RM000093''' WHERE [SGQuote] = 'SG100951';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P432RM000094', [Notes] = 'NEW DESIGN BOX
--January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 20, 2023
--March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4450'' to ''2SVS6P432RM000094''' WHERE [SGQuote] = 'SG100986';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D447RM000095', [Notes] = 'December 15, 2022 - SDH - Changed Est. Delivery Date from May 20, 2021 to March 10, 2023
--January 13, 2023 - JAAM - As per Signed Change Order, Added Switch for Lift Axle in Control Box
--January 13, 2023 - JAAM - As per Signed Change Order, Added Yellow Plug (Added Photo in folder for configuration layout)
--February 14, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 23, 2023
--Feb 14, 2023 - SDH -  Fixed wording oin tires as should be Continental HDW-2 11R22.5 as per Order.  Sales missed adding the wording
--March 24th, 2023 - ABRIGGS - Serial Number change: ''9860'' to ''2SVS6D447RM000095''' WHERE [SGQuote] = 'SG100915';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D338RM000096', [Notes] = 'February 03, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 26, 2023
--Feb. 23, 2023 – JAAM – As per Signed Change Order, Added Aluminum Round Rod to Tailgate.
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4472'' to ''2SVS6D338RM000096''' WHERE [SGQuote] = 'SG101043';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P433RM000097', [Notes] = 'NEW DESIGN BOX
--January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 27, 2023
--February 02, 2023 - JAAM - As per Sales Meeting, Updated ABS to 4S/3M
--Added Line for 3/8 Pick Up Plate
--March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4451'' to ''2SVS6P433RM000097''' WHERE [SGQuote] = 'SG100987';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D340RM000098', [Notes] = 'February 10, 2023 - JAAM - As per S/O Meeting, Change Hoist to 8-5-265.
--February 14, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 30, 2023
--February 24, 2023 - JAAM - As per Signed COR, Mount Air Gauge Flush to Front Frame, Change to 39 ft. Frame, 38 ft. Box, 68 in. Wall Height, Drum Brakes instead of Disc Brakes, Remove Vibrator, Tailgate to be hinged on D/S.
--March 24th, 2023 - ABRIGGS - Serial Number change: ''9698'' to ''2SVS6D340RM000098''' WHERE [SGQuote] = 'SG101052';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D333RM000099', [Notes] = 'February 03, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to July 03, 2023
--Feb. 23, 2023 – JAAM – As per Signed Change Order, Added Aluminum Round Rod to Tailgate.
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4473'' to ''2SVS6D333RM000099''' WHERE [SGQuote] = 'SG101044';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D336RM000100', [Notes] = 'February 03, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to July 04, 2023
--Feb. 23, 2023 – JAAM – As per Signed Change Order, Added Aluminum Round Rod to Tailgate.
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4474'' to ''2SVS6D336RM000100''' WHERE [SGQuote] = 'SG101045';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P43XRM000101', [Notes] = 'NEW DESIGN BOX
--January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to July 04, 2023
--March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4452'' to ''2SVS6P43XRM000101''' WHERE [SGQuote] = 'SG100988';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D33XRM000102', [Notes] = 'Feb. 23, 2023 – JAAM – As per Signed Change Order, Added Aluminum Round Rod to Tailgate.
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4475'' to ''2SVS6D33XRM000102''' WHERE [SGQuote] = 'SG101046';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D331RM000103', [Notes] = 'March 20, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to July 06, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4492'' to ''2SVS6D331RM000103''' WHERE [SGQuote] = 'SG101110';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D333RM000104', [Notes] = 'March 20, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to July 06, 2023
--March 20, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to July 10, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4493'' to ''2SVS6D333RM000104''' WHERE [SGQuote] = 'SG101111';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P434RM000105', [Notes] = 'NEW DESIGN BOX
--January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to July 11, 2023
--March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4453'' to ''2SVS6P434RM000105''' WHERE [SGQuote] = 'SG100989';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P438RM000106', [Notes] = 'NEW DESIGN BOX
--January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to July 18, 2023
--March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4454'' to ''2SVS6P438RM000106''' WHERE [SGQuote] = 'SG100990';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P431RM000107', [Notes] = 'NEW DESIGN BOX
--January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to July 25, 2023
--March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4455'' to ''2SVS6P431RM000107''' WHERE [SGQuote] = 'SG100991';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D330RM000108', [Notes] = 'Jan 11, 2023 - SDH - Fixed wording on Calcium Tank, Red paint and spelling error on capacity
--March 20, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to August 15, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4436'' to ''2SVS6D330RM000108''' WHERE [SGQuote] = 'SG100952';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D332RM000109', [Notes] = 'Jan 11, 2023 - SDH - Fixed wording on Calcium Tank, Red paint and spelling error on capacity
--March 20, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to August 15, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4437'' to ''2SVS6D332RM000109''' WHERE [SGQuote] = 'SG100953';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D339RM000110', [Notes] = 'Jan 11, 2023 - SDH - Fixed wording on Calcium Tank, Red paint and spelling error on capacity
--March 20, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to August 15, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4438'' to ''2SVS6D339RM000110''' WHERE [SGQuote] = 'SG100954';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D330RM000111', [Notes] = 'Jan 11, 2023 - SDH - Fixed wording on Calcium Tank, Red paint and spelling error on capacity
--March 20, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to August 15, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4439'' to ''2SVS6D330RM000111''' WHERE [SGQuote] = 'SG100955';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D332RM000112', [Notes] = 'Jan 11, 2023 - SDH - Fixed wording on Calcium Tank, Red paint and spelling error on capacity
--March 20, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to August 15, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4440'' to ''2SVS6D332RM000112''' WHERE [SGQuote] = 'SG100956';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D334RM000113', [Notes] = 'Jan 11, 2023 - SDH - Fixed wording on Calcium Tank, Red paint and spelling error on capacity
--March 20, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to October 01, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4441'' to ''2SVS6D334RM000113''' WHERE [SGQuote] = 'SG100957';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D336RM000114', [Notes] = 'Jan 11, 2023 - SDH - Fixed wording on Calcium Tank, Red paint and spelling error on capacity
--March 20, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to October 01, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4442'' to ''2SVS6D336RM000114''' WHERE [SGQuote] = 'SG100958';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D338RM000115', [Notes] = 'Jan 11, 2023 - SDH - Fixed wording on Calcium Tank, Red paint and spelling error on capacity
--March 20, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to October 01, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4443'' to ''2SVS6D338RM000115''' WHERE [SGQuote] = 'SG100959';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D33XRM000116', [Notes] = 'Jan 11, 2023 - SDH - Fixed wording on Calcium Tank, Red paint and spelling error on capacity
--March 20, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to November 01, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4444'' to ''2SVS6D33XRM000116''' WHERE [SGQuote] = 'SG100960';
--UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D331RM000117', [Notes] = 'Jan 11, 2023 - SDH - Fixed wording on Calcium Tank, Red paint and spelling error on capacity
--March 20, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to November 01, 2023
--March 24th, 2023 - ABRIGGS - Serial Number change: ''4445'' to ''2SVS6D331RM000117''' WHERE [SGQuote] = 'SG100961';




-- Fixing units that had 2 records in [ProductsV2]

UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P431RM000005', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 04, 2023
March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
March 24th, 2023 - ABRIGGS - Serial Number change: ''4446'' to ''2SVS6P431RM000005''' WHERE [SGQuote] = 'SG100936';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P439RM000009', [Notes] = 'March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 07, 2023
March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
March 23, 2023 - JAAM - As per Change Order, Change Board & Tarp Color to Red. Add 6 - 36" Mudflaps in the Rear of the Box (Ship Loose)
March 24th, 2023 - ABRIGGS - Serial Number change: ''4496'' to ''2SVS6P439RM000009''' WHERE [SGQuote] = 'SG101096';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P430RM000013', [Notes] = 'December 15, 2022 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 11, 2023
March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
March 24th, 2023 - ABRIGGS - Serial Number change: ''4422'' to ''2SVS6P430RM000013''' WHERE [SGQuote] = 'SG100922';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P439RM000026', [Notes] = 'December 15, 2022 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 18, 2023
March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
March 24th, 2023 - ABRIGGS - Serial Number change: ''4423'' to ''2SVS6P439RM000026''' WHERE [SGQuote] = 'SG100923';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P436RM000033', [Notes] = 'March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 21, 2023
March 13, 2023 - SDH - Updated standard specificatoon from Enginering/production to  front fenders to have two brackets
March 15, 2023 - added paint code for green
March 24th, 2023 - ABRIGGS - Serial Number change: ''4500'' to ''2SVS6P436RM000033''' WHERE [SGQuote] = 'SG101094';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P43XRM000035', [Notes] = 'December 15, 2022 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 25, 2023
March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
March 24th, 2023 - ABRIGGS - Serial Number change: ''9998'' to ''2SVS6P43XRM000035''' WHERE [SGQuote] = 'SG100925';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6D42XRM000039', [Notes] = 'March 03, 2023 - hclark - THIS QUOTE WAS DONE WITH SG101047 THEN CHANGED TO A STARGATE UNIT
March 09, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 28, 2023
March 24th, 2023 - ABRIGGS - Serial Number change: ''9506'' to ''2SVS6D42XRM000039''' WHERE [SGQuote] = 'SG100761';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P433RM000040', [Notes] = 'March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to April 28, 2023
March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
March 24th, 2023 - ABRIGGS - Serial Number change: ''4497'' to ''2SVS6P433RM000040''' WHERE [SGQuote] = 'SG101097';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P439RM000043', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 02, 2023
March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
March 24th, 2023 - ABRIGGS - Serial Number change: ''4447'' to ''2SVS6P439RM000043''' WHERE [SGQuote] = 'SG100937';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P438RM000048', [Notes] = 'March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 05, 2023
March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
March 24th, 2023 - ABRIGGS - Serial Number change: ''4498'' to ''2SVS6P438RM000048''' WHERE [SGQuote] = 'SG101098';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P43XRM000052', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 09, 2023
March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
March 24th, 2023 - ABRIGGS - Serial Number change: ''4448'' to ''2SVS6P43XRM000052''' WHERE [SGQuote] = 'SG100938';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P439RM000057', [Notes] = 'March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 12, 2023
March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
March 24th, 2023 - ABRIGGS - Serial Number change: ''4499'' to ''2SVS6P439RM000057''' WHERE [SGQuote] = 'SG101099';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P430RM000061', [Notes] = 'January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 16, 2023
March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
March 24th, 2023 - ABRIGGS - Serial Number change: ''4449'' to ''2SVS6P430RM000061''' WHERE [SGQuote] = 'SG100939';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P43XRM000066', [Notes] = 'March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 19, 2023
March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
March 24th, 2023 - ABRIGGS - Serial Number change: ''4495'' to ''2SVS6P43XRM000066''' WHERE [SGQuote] = 'SG101095';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P431RM000070', [Notes] = 'January 16, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 23, 2023
Feb 10, 2023 - SDH - Add reverse lights and both plugs to be standard plugs, no ISO
March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
March 24th, 2023 - ABRIGGS - Serial Number change: ''4458'' to ''2SVS6P431RM000070''' WHERE [SGQuote] = 'SG101022';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P437RM000073', [Notes] = 'March 06, 2023 - JAAM - Pair w/ Truck Box 1331
March 13, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 25, 2023
March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
March 24th, 2023 - ABRIGGS - Serial Number change: ''4479'' to ''2SVS6P437RM000073''' WHERE [SGQuote] = 'SG101084';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P436RM000078', [Notes] = 'January 16, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to May 30, 2023
Feb 10, 2023 - SDH - Add reverse lights and both plugs to be standard plugs, no ISO
March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
March 24th, 2023 - ABRIGGS - Serial Number change: ''4459'' to ''2SVS6P436RM000078''' WHERE [SGQuote] = 'SG101023';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P43XRM000083', [Notes] = 'Unit should be identical to 4458 and 4459
February 03, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 06, 2023
Feb 10, 2023 - SDH - Add reverse lights and both plugs to be standard plugs, no ISO
February 10, 2023 - JAAM - As per SO Meeting, Added New Style Design to the Quote.
March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
March 24th, 2023 - ABRIGGS - Serial Number change: ''4468'' to ''2SVS6P43XRM000083''' WHERE [SGQuote] = 'SG101040';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P439RM000088', [Notes] = 'February 23, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 13, 2023
March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
March 24th, 2023 - ABRIGGS - Serial Number change: ''4477'' to ''2SVS6P439RM000088''' WHERE [SGQuote] = 'SG101072';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P430RM000089', [Notes] = 'February 23, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 13, 2023
March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
March 24th, 2023 - ABRIGGS - Serial Number change: ''4478'' to ''2SVS6P430RM000089''' WHERE [SGQuote] = 'SG101074';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P434RM000094', [Notes] = 'NEW DESIGN BOX
January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 20, 2023
March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
March 24th, 2023 - ABRIGGS - Serial Number change: ''4450'' to ''2SVS6P434RM000094''' WHERE [SGQuote] = 'SG100986';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P43XRM000097', [Notes] = 'NEW DESIGN BOX
January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to June 27, 2023
February 02, 2023 - JAAM - As per Sales Meeting, Updated ABS to 4S/3M
Added Line for 3/8 Pick Up Plate
March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
March 24th, 2023 - ABRIGGS - Serial Number change: ''4451'' to ''2SVS6P43XRM000097''' WHERE [SGQuote] = 'SG100987';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P438RM000101', [Notes] = 'NEW DESIGN BOX
January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to July 04, 2023
March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
March 24th, 2023 - ABRIGGS - Serial Number change: ''4452'' to ''2SVS6P438RM000101''' WHERE [SGQuote] = 'SG100988';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P435RM000105', [Notes] = 'NEW DESIGN BOX
January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to July 11, 2023
March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
March 24th, 2023 - ABRIGGS - Serial Number change: ''4453'' to ''2SVS6P435RM000105''' WHERE [SGQuote] = 'SG100989';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P437RM000106', [Notes] = 'NEW DESIGN BOX
January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to July 18, 2023
March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
March 24th, 2023 - ABRIGGS - Serial Number change: ''4454'' to ''2SVS6P437RM000106''' WHERE [SGQuote] = 'SG100990';
UPDATE [OrdersV2] SET [Serial Number] = '2SVS6P439RM000107', [Notes] = 'NEW DESIGN BOX
January 02, 2023 - SDH - Changed Est. Delivery Date from May 20, 2021 to July 25, 2023
March 13, 2023 - SDH - Updated standard specificaiton form Enginering/production to  front fenders to have two brackets
March 24th, 2023 - ABRIGGS - Serial Number change: ''4455'' to ''2SVS6P439RM000107''' WHERE [SGQuote] = 'SG100991';


ROLLBACK;
COMMIT;
