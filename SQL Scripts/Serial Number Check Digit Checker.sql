-- Serial Number Check Digit Checker

DECLARE @snWeights TABLE ([ID] INT IDENTITY(0, 1), [Weight] INT);
INSERT @snWeights ([Weight]) VALUES
(8),
(7),
(6),
(5),
(4),
(3),
(2),
(10),
(NULL),
(9),
(8),
(7),
(6),
(5),
(4),
(3),
(2)
;

DECLARE @yearCodes TABLE ([ID] INT IDENTITY(0, 1), [Year] INT, [Code] NVARCHAR(1));
INSERT @yearCodes ([Year], [Code]) VALUES
(2014, 'E'),
(2015, 'F'),
(2016, 'G'),
(2017, 'H'),
(2018, 'J'),
(2019, 'K'),
(2020, 'L'),
(2021, 'M'),
(2022, 'N'),
(2023, 'P'),
(2024, 'R'),
(2025, 'S'),
(2026, 'T'),
(2027, 'V'),
(2028, 'W'),
(2029, 'X'),
(2030, 'Y'),
(2031, '1'),
(2032, '2'),
(2033, '3'),
(2034, '4'),
(2035, '5'),
(2036, '6'),
(2037, '7'),
(2038, '8'),
(2039, '9')
;

DECLARE @charValues TABLE ([ID] INT IDENTITY(0, 1), [Char] NVARCHAR(1), [Value] INT);
INSERT @charValues ([Char], [Value]) VALUES
('A', 1),
('B', 2),
('C', 3),
('D', 4),
('E', 5),
('F', 6),
('G', 7),
('H', 8),
('J', 1),
('K', 2),
('L', 3),
('M', 4),
('N', 5),
('P', 7),
('R', 9),
('S', 2),
('T', 3),
('U', 4),
('V', 5),
('W', 6),
('X', 7),
('Y', 8),
('Z', 9)
;


SELECT
	*
FROM
	@snWeights
;

SELECT
	*
FROM
	@yearCodes
;

SELECT
	*
FROM
	@charValues
;

SELECT
	*
FROM
	[BWSdb].[dbo].[split_string_idx]('string', '')
