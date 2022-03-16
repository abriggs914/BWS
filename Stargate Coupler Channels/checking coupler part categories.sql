USE SysproCompanyA
GO

DECLARE @Src AS TABLE ([Channel] NVARCHAR(255), [StockCode] NVARCHAR(255));

INSERT INTO @Src ([Channel], [StockCode]) VALUES
	('Front Channels', 'TR-UC-P043'),
	('Front Channels', 'TR-UC-P047'),
	('Front Channels', 'TR-UC-P048'),
	('Front Channels', 'TR-UC-P049'),
	('Front Channels', 'TR-UC-P050'),
	('Front Channels', 'TR-UC-P104'),
	('Front Channels', 'TR-UC-P118'),
	('Front Channels', 'TR-UC-P122'),
	('Front Channels', 'TR-UC-P127'),
	('Front Channels', 'TR-UC-P135'),
	('Front Channels', 'TR-UC-P140'),
	('Front Channels', 'TR-UC-P143'),
	('Front Channels', 'TR-UC-P148'),
	('Front Channels', 'TR-SUC-P005'),
	('Front Channels', 'TR-SUC-P006'),
	('Front Channels', 'TR-SUC-P016'),
	('Front Channels', 'TR-SUC-P035'),
	('Front Channels', 'TR-SUC-P038'),
	('Front Channels', 'TR-SUC-P042'),
	('Front Channels', 'TR-SUC-P048'),
	('Front Channels', 'STL-UC-P001'),
	('Front Channels', 'STL-UC-P005'),
	('Front Channels', 'STP-UC-P002'),
	('Front Channels', 'STP-UC-P011'),
	
	('Second Channels', 'TR-UC-P004'),
	('Second Channels', 'TR-UC-P030'),
	('Second Channels', 'TR-UC-P080'),
	('Second Channels', 'TR-UC-P116'),
	('Second Channels', 'TR-UC-P121'),
	('Second Channels', 'TR-UC-P136'),
	('Second Channels', 'TR-UC-P144'),
	('Second Channels', 'TR-SUC-P007'),
	('Second Channels', 'TR-SUC-P017'),
	('Second Channels', 'TR-SUC-P039'),
	('Second Channels', 'TR-SUC-P043'),
	('Second Channels', 'TR-SUC-P046'),
	('Second Channels', 'TR-SUC-P049'),
	('Second Channels', 'STL-UC-P002'),
	('Second Channels', 'STL-UC-P006'),
		
	('Rear Channels', 'TR-UC-P003'),
	('Rear Channels', 'TR-UC-P031'),
	('Rear Channels', 'TR-UC-P115'),
	('Rear Channels', 'TR-UC-P145'),
	('Rear Channels', 'TR-SUC-P008'),
	('Rear Channels', 'TR-SUC-P018'),
	('Rear Channels', 'TR-SUC-P040'),
	('Rear Channels', 'TR-SUC-P044'),
	('Rear Channels', 'STL-UC-P003'),
	('Rear Channels', 'STL-UC-P007'),
	('Rear Channels', 'STP-UC-P016'),
	('Rear Channels', 'STP-UC-P017'),

	('Hoist Channels', 'TR-UC-P006'),
	('Hoist Channels', 'TR-UC-P018L'),
	('Hoist Channels', 'TR-UC-P018R'),
	('Hoist Channels', 'TR-UC-P035L'),
	('Hoist Channels', 'TR-UC-P035R'),
	('Hoist Channels', 'TR-UC-P040L'),
	('Hoist Channels', 'TR-UC-P040R'),
	('Hoist Channels', 'TR-UC-P117L'),
	('Hoist Channels', 'TR-UC-P117R'),
	('Hoist Channels', 'TR-UC-P119'),
	('Hoist Channels', 'TR-UC-P120'),
	('Hoist Channels', 'TR-UC-P123L'),
	('Hoist Channels', 'TR-UC-P123R'),
	('Hoist Channels', 'TR-UC-P125L'),
	('Hoist Channels', 'TR-UC-P125R'),
	('Hoist Channels', 'TR-UC-P147'),
	('Hoist Channels', 'TR-UC-P149L'),
	('Hoist Channels', 'TR-UC-P149R'),
	('Hoist Channels', 'STP-UC-P003L'),
	('Hoist Channels', 'STP-UC-P003R'),
	('Hoist Channels', 'STP-UC-P012L'),
	('Hoist Channels', 'STP-UC-P012R'),
	('Hoist Channels', 'STP-UC-P023L'),
	('Hoist Channels', 'STP-UC-P023R')

SELECT
	[Channel]
	,[@Src].[StockCode]
	,[Description]
	,(CASE	WHEN [PartCategory] = 'B' THEN 'Bought-Out'
			WHEN [PartCategory] = 'M' THEN 'Made-In'
			ELSE [PartCategory] 
		END) AS [PartCategory]		
FROM
	@Src
LEFT JOIN
	[InvMaster]
ON
	[@Src].[StockCode] = [InvMaster].[StockCode]