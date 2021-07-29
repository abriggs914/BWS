USE BWSdb
GO

SELECT * FROM [Orders] WHERE [WO#] = 10014800;

SELECT * FROM [Order Options] WHERE [WO#] = 10014800

SELECT * FROM [Custom Work] WHERE [Description] LIKE '%Hendrickson%' -- = A

SELECT * FROM [Master Options] WHERE [Stock Code (SYSPRO)] LIKE '%99000135%' -- = B

-- Problem was that the NPO (A) was overwriting the Axle hours for the option (B) in SP: [dbo].[sp_NewWOReport]
-- The result was a mixed option spec line with 0 hours.
-- Solution: re-code the spec lines for both options. 
--				NPO goes from 0 to -95, ensure valid find though.
--				Option goes from 0 to -97 to only include the desired text.
--			- NO CHANGE TO [dbo].[sp_NewWOReport]
--			- Change applied to WOs:
--									10014800
--									10014801