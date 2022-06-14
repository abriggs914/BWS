

DECLARE @wos AS TABLE ([WO] NVARCHAR(MAX));

INSERT INTO @wos ([WO]) VALUES
('10000605'),
 ('10000476'),
 ('10000468'),
 ('10000543'),
 ('10000596'),
 ('10000597'),
 ('10000573'),
 ('10000572'),
 ('10000531'),
 ('10000530'),
 ('10000598'),
 ('10000627'),
 ('10000589'),
 ('10000628'),
 ('10000491'),
 ('10000490'),
 ('10000487'),
 ('10000542'),
 ('10000671')
 ;

 SELECT * FROM @wos;

 SELECT [WO], [SGQuote] FROM [OrdersV2] INNER JOIN @wos ON [@wos].[WO] = [OrdersV2].[WO#];

 DECLARE @sns AS TABLE ([SN] NVARCHAR(MAX));
 INSERT INTO @sns ([SN]) VALUES
 ('2S9DA6466NM119060'),
 ('2S9DA5358NM119130'),
 ('2S9DA646XNM119076'),
 ('2S9DA6466NM119060'),
 ('2S9DA6468NM119061'),
 ('2S9WA7469NM118080')
 ;

 SELECT 
	[SN],
	[SGQuote],
	RIGHT([@sns].[SN], 4) AS [X],
	RIGHT([OrdersV2].[Serial Number], 4) AS [Y],
	[@sns].[SN],
	[OrdersV2].[Serial Number]
FROM
	@sns
LEFT JOIN
	[OrdersV2] 
ON 
	LOWER(RIGHT([OrdersV2].[Serial Number], 4))
	= LOWER(RIGHT([@sns].[SN], 4));
