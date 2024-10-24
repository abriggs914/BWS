SELECT * FROM [BWSdb].[dbo].[SecurityCallersV1];
SELECT * FROM [BWSdb].[dbo].[SecurityEmpV1];
SELECT * FROM [BWSdb].[dbo].[SecurityLogEventsV1];
SELECT * FROM [BWSdb].[dbo].[SecurityLogV1];
SELECT * FROM [BWSdb].[dbo].[SecurityStatusV1];
SELECT * FROM [BWSdb].[dbo].[SecurityV1];
SELECT * FROM [BWSdb].[dbo].[SecurityValidViewersV1];
SELECT * FROM [BWSdb].[dbo].[v_SecurityCallReportV1];
SELECT * FROM [BWSdb].[dbo].[v_SecurityCallRespondentsReportV1];
SELECT * FROM [BWSdb].[dbo].[v_SecurityDataDumpV1];
SELECT * FROM [BWSdb].[dbo].[v_SecurityEventsByYearByMonthAllV1];
SELECT * FROM [BWSdb].[dbo].[v_SecurityEventsByYearByMonthV1];
SELECT * FROM [BWSdb].[dbo].[v_SecurityEventsByYearV1];
SELECT * FROM [BWSdb].[dbo].[v_SecurityLogEvents];
SELECT * FROM [BWSdb].[dbo].[v_SecurityV1BuildingAccessibility];
SELECT * FROM [BWSdb].[dbo].[v_SecurityV1KeyDistribution];
SELECT * FROM [BWSdb].[dbo].[v_SecurityVerifiedCallers];




SELECT
	* 
FROM
	[BWSdb].[dbo].[SecurityEmpV1] [SE]
LEFT JOIN
	[BWSdb].[dbo].[SecurityV1] [S]
ON
	[S].[EmployeeID] = [SE].[SecurityEmpID]
ORDER BY
	[SE].[Employee]
;


/*
BEGIN TRAN;


SELECT
	* 
FROM
	[BWSdb].[dbo].[SecurityV1] [S]
INNER JOIN
	[BWSdb].[dbo].[SecurityEmpV1] [SE]
ON
	[S].[EmployeeID] = [SE].[SecurityEmpID]
;

UPDATE
	[SecurityV1]
SET
	[Active] = 0
FROM
	[BWSdb].[dbo].[SecurityV1] [S]
INNER JOIN
	[BWSdb].[dbo].[SecurityEmpV1] [SE]
ON
	[S].[EmployeeID] = [SE].[SecurityEmpID]
WHERE
	[SE].[Employee] IN (
		'ASHLIE BROWN',
		'BARRY BLANEY',
		'COLE CARLISLE',
		'FRANCIS CAMPBELL',
		'IVAN COWPERTHWAITE',
		'JACK JOHNSON',
		'JOANNA METHERELL',
		'JONATHAN SEWELL',
		'LARRY BERRY',
		'LLOYD ORSER',
		'OWEN DERRAH',
		'ROLAND HAWLING',
		'SHEILA PIPER',
		'STEPHEN SMITH',
		'VICTOR BOBARNAC',
		'SCOTT MESSERVEY'
	)
	

SELECT
	* 
FROM
	[BWSdb].[dbo].[SecurityV1] [S]
INNER JOIN
	[BWSdb].[dbo].[SecurityEmpV1] [SE]
ON
	[S].[EmployeeID] = [SE].[SecurityEmpID]
;

ROLLBACK;
COMMIT;
*/


/*
DECLARE @INPUTS_202410241812 TABLE(
	[ID] INT IDENTITY(0, 1),
	[User Label] NVARCHAR(255),
	[FN] NVARCHAR(255),
	[Code] NVARCHAR(4)
)
INSERT INTO @INPUTS_202410241812 ([User Label], [FN], [Code]) VALUES
('BOYD S.', 'STEVEN BOYD', '7384'),
('BRIGGS A.', 'AVERY BRIGGS', '5648'),
('BROAD D.', 'DUSTIN BROAD', '7326'),
('BROOKER L.', 'LESTER BROOKER', '2831'),
('CAMPBELL R.', 'RICHIE CAMPBELL', '1981'),
('CASS A.', 'ALFRED CASS', '2222'),
('CHARLIE GUEST', 'CHARLIE GUEST', '0808'),
('CRAWFORD J.', 'JAMES CRAWFORD', '1680'),
('CULLINS S.', 'SIDNEY CULLINS', '1961'),
('DAMIEN D.', 'DAMIEN DENNY', '5674'),
('DILL A.', 'ARNOLD DILL', '1970'),
('DOWNEY N.', 'NATHAN DOWNEY', '6553'),
('FAULKNER A.', 'AARON FAULKNER', '2838'),
('FINDLATER G.', 'GLEN FINDLATER', '5283'),
('GUEST M.', 'MIKE GUEST', '1581'),
('HAMILTON C.', 'CHELSEY HAMILTON', '9626'),
('HOLMES S.', 'SHELLEY HOLMES', '0294'),
('KINNEY K.', 'KENNETH KINNEY', '3352'),
('LANCE LUNN', 'LANCE LUNN', '1947'),
('LORD S.', 'SARAH LORD', '1002'),
('MACRAE S.', 'SCOTT MACRAE', '4556'),
('MCADAM J.', 'JOE MCADAM', '1212'),
('MERRITHEW J.', 'JAMIE MERRITHEW', '2272'),
('MORGAN J.', 'JASON MORGAN', '1295'),
('ORSER J.', 'JANET ORSER', '7829'),
('PIPER L.', 'LORI PIPER', '3241'),
('RIDEOUT M.', 'MARK RIDEOUT', '1226'),
('SAUNDERS T.', 'TODD SAUNDERS', '8993'),
('SKAARUP J.', 'JENNIFER SKAARUP', '3403'),
('SMITH G.', 'GAYLON SMITH', '8885'),
('SMITH J.', 'JAMIE SMITH', '3308'),
('SMITH K.', 'KYLE SMITH', '4132'),
('SOMERVILLE J.', 'JASON SOMERVILLE', '1906'),
('ST CYR H.', 'HUGO ST CYR', '1973'),
('THOMAS G.', 'GARY THOMAS', '3374'),
('UNDERHILL T.', 'TONY UNDERHILL', '3196');

BEGIN TRAN;


SELECT
	* 
FROM
	[BWSdb].[dbo].[SecurityEmpV1] [SE]
LEFT JOIN
	[BWSdb].[dbo].[SecurityV1] [S]
ON
	[S].[EmployeeID] = [SE].[SecurityEmpID]
ORDER BY
	[SE].[Employee]
;

INSERT INTO
	[BWSdb].[dbo].[SecurityV1]
([EmployeeID], [Code], [Main])
SELECT
	[SE].[SecurityEmpID],
	[I].[Code],
	1
FROM
	@INPUTS_202410241812 [I]
INNER JOIN
	[BWSdb].[dbo].[SecurityEmpV1] [SE]
ON
	[SE].[Employee] = [I].[FN]
LEFT JOIN
	[BWSdb].[dbo].[SecurityV1] [S]
ON
	[S].[EmployeeID] = [SE].[SecurityEmpID]
WHERE
	[S].[SecurityID] IS NULL


--UPDATE
--	[BWSdb].[dbo].[SecurityEmpV1]
--SET
--	[DisplayName] = [I].[User Label]
--FROM
--	[BWSdb].[dbo].[SecurityEmpV1] [SE]
--INNER JOIN
--	@INPUTS_202410241812 [I]
--ON
--	[SE].[Employee] = [I].[FN]



SELECT
	* 
FROM
	[BWSdb].[dbo].[SecurityEmpV1] [SE]
LEFT JOIN
	[BWSdb].[dbo].[SecurityV1] [S]
ON
	[S].[EmployeeID] = [SE].[SecurityEmpID]
WHERE
	[Active] IS NULL
ORDER BY
	[SE].[Employee]
;


ROLLBACK;
COMMIT;

*/
SELECT
	*
FROM
	[BWSdb].[dbo].[SecurityV1]


SELECT
	* 
FROM
	[BWSdb].[dbo].[SecurityEmpV1] [SE]
LEFT JOIN
	[BWSdb].[dbo].[SecurityV1] [S]
ON
	[S].[EmployeeID] = [SE].[SecurityEmpID]
WHERE
	[Active] IS NULL
ORDER BY
	[SE].[Employee]
;