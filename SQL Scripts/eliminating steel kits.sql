-- List of WOs from kyle
-- Need to view what MRP thinks for Victor
-- He wants to eliminate the steel kits.

DECLARE @wos AS TABLE ([ID] INT IDENTITY(1, 1), [WO] NVARCHAR(MAX));

INSERT INTO @wos ([WO]) VALUES
('20052179'),
('20052207'),
('20052315'),
('20052535'),
('20052521'),
('20052522'),
('20052487'),
('20052529'),
('20052422'),
('20052107'),
('20052113'),
('20052110'),
('20052323'),
('20052285'),
('20052502'),
('20052270')

SELECT * FROM @wos ORDER BY [WO]