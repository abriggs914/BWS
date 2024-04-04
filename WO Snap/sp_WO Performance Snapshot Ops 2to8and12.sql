USE [SysproCompanyS]
GO
/****** Object:  StoredProcedure [dbo].[sp_WO Performance Snapshot Ops 5to8]    Script Date: 2024-04-04 6:25:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
CREATE PROCEDURE [dbo].[sp_WO Performance Snapshot Ops 2to8and12]
	@WO NVARCHAR(MAX) --[Forms]![WO Performance Snapshot Input]![Combo5].Value
AS BEGIN
*/

-----------------------------------------------------------------------------------------------------------------------------
DECLARE @WO NVARCHAR(MAX);
SELECT @WO = '10001444';
-----------------------------------------------------------------------------------------------------------------------------


DECLARE @t AS TABLE(
	[WO#] NVARCHAR(MAX),

	[Total Budgeted Hours OP2] DECIMAL(10, 2),
	[Total Hours Issued OP2] DECIMAL(10, 2),
	[Hours Over Budget OP2] DECIMAL(10, 2),

	[Total Budgeted Hours OP3] DECIMAL(10, 2),
	[Total Hours Issued OP3] DECIMAL(10, 2),
	[Hours Over Budget OP3] DECIMAL(10, 2),

	[Total Budgeted Hours OP4] DECIMAL(10, 2),
	[Total Hours Issued OP4] DECIMAL(10, 2),
	[Hours Over Budget OP4] DECIMAL(10, 2),

	[Total Budgeted Hours OP5] DECIMAL(10, 2),
	[Total Hours Issued OP5] DECIMAL(10, 2),
	[Hours Over Budget OP5] DECIMAL(10, 2),
	
	[Total Budgeted Hours OP6] DECIMAL(10, 2),
	[Total Hours Issued OP6] DECIMAL(10, 2),
	[Hours Over Budget OP6] DECIMAL(10, 2),
	
	[Total Budgeted Hours OP7] DECIMAL(10, 2),
	[Total Hours Issued OP7] DECIMAL(10, 2),
	[Hours Over Budget OP7] DECIMAL(10, 2),

	[Total Budgeted Hours OP8] DECIMAL(10, 2),
	[Total Hours Issued OP8] DECIMAL(10, 2),
	[Hours Over Budget OP8] DECIMAL(10, 2),

	[Total Budgeted Hours OP12] DECIMAL(10, 2),
	[Total Hours Issued OP12] DECIMAL(10, 2),
	[Hours Over Budget OP12] DECIMAL(10, 2),

	[Total Budgeted Hours] DECIMAL(10, 2),
	[Total Hours Issued] DECIMAL(10, 2),
	[Hours Over Budget] DECIMAL(10, 2),

	[Total Defects] INT
);

INSERT INTO @t
SELECT 
	[WO#],

	CAST(ROUND([Total Budgeted Hours OP2], 2, 1) AS DECIMAL(10, 2)) AS [Total Budgeted Hours OP2],
	CAST(ROUND([Total Hours Issued OP2], 2, 1) AS DECIMAL(10, 2)) AS [Total Hours Issued OP2],
	CAST(ROUND([Hours Over Budget OP2], 2, 1) AS DECIMAL(10, 2)) AS [Hours Over Budget OP2],

	CAST(ROUND([Total Budgeted Hours OP3], 2, 1) AS DECIMAL(10, 2)) AS [Total Budgeted Hours OP3],
	CAST(ROUND([Total Hours Issued OP3], 2, 1) AS DECIMAL(10, 2)) AS [Total Hours Issued OP3],
	CAST(ROUND([Hours Over Budget OP3], 2, 1) AS DECIMAL(10, 2)) AS [Hours Over Budget OP3],

	CAST(ROUND([Total Budgeted Hours OP4], 2, 1) AS DECIMAL(10, 2)) AS [Total Budgeted Hours OP4],
	CAST(ROUND([Total Hours Issued OP4], 2, 1) AS DECIMAL(10, 2)) AS [Total Hours Issued OP4],
	CAST(ROUND([Hours Over Budget OP4], 2, 1) AS DECIMAL(10, 2)) AS [Hours Over Budget OP4],

	CAST(ROUND([Total Budgeted Hours OP5], 2, 1) AS DECIMAL(10, 2)) AS [Total Budgeted Hours OP5],
	CAST(ROUND([Total Hours Issued OP5], 2, 1) AS DECIMAL(10, 2)) AS [Total Hours Issued OP5],
	CAST(ROUND([Hours Over Budget OP5], 2, 1) AS DECIMAL(10, 2)) AS [Hours Over Budget OP5],
	
	CAST(ROUND([Total Budgeted Hours OP6], 2, 1) AS DECIMAL(10, 2)) AS [Total Budgeted Hours OP6],
	CAST(ROUND([Total Hours Issued OP6], 2, 1) AS DECIMAL(10, 2)) AS [Total Hours Issued OP6],
	CAST(ROUND([Hours Over Budget OP6], 2, 1) AS DECIMAL(10, 2)) AS [Hours Over Budget OP6],
	
	CAST(ROUND([Total Budgeted Hours OP7], 2, 1) AS DECIMAL(10, 2)) AS [Total Budgeted Hours OP7],
	CAST(ROUND([Total Hours Issued OP7], 2, 1) AS DECIMAL(10, 2)) AS [Total Hours Issued OP7],
	CAST(ROUND([Hours Over Budget OP7], 2, 1) AS DECIMAL(10, 2)) AS [Hours Over Budget OP7],
	
	CAST(ROUND([Total Budgeted Hours OP8], 2, 1) AS DECIMAL(10, 2)) AS [Total Budgeted Hours OP8],
	CAST(ROUND([Total Hours Issued OP8], 2, 1) AS DECIMAL(10, 2)) AS [Total Hours Issued OP8],
	CAST(ROUND([Hours Over Budget OP8], 2, 1) AS DECIMAL(10, 2)) AS [Hours Over Budget OP8],

	CAST(ROUND([Total Budgeted Hours OP12], 2, 1) AS DECIMAL(10, 2)) AS [Total Budgeted Hours OP12],
	CAST(ROUND([Total Hours Issued OP12], 2, 1) AS DECIMAL(10, 2)) AS [Total Hours Issued OP12],
	CAST(ROUND([Hours Over Budget OP12], 2, 1) AS DECIMAL(10, 2)) AS [Hours Over Budget OP12],
	
	CAST(ROUND([Total Budgeted Hours], 2, 1) AS DECIMAL(10, 2)) AS [Total Budgeted Hours],
	CAST(ROUND([Total Hours Issued], 2, 1) AS DECIMAL(10, 2)) AS [Total Hours Issued],
	CAST(ROUND([Hours Over Budget], 2, 1) AS DECIMAL(10, 2)) AS [Hours Over Budget],
	[Total Defects]
FROM (
	SELECT
		[WO#],

		SUM([2 Total Budgeted Hours]) AS [Total Budgeted Hours OP2],
		SUM([2 Total Hours Issued]) AS [Total Hours Issued OP2],
		SUM([2 Hours Over Budget]) AS [Hours Over Budget OP2],

		SUM([3 Total Budgeted Hours]) AS [Total Budgeted Hours OP3],
		SUM([3 Total Hours Issued]) AS [Total Hours Issued OP3],
		SUM([3 Hours Over Budget]) AS [Hours Over Budget OP3],

		SUM([4 Total Budgeted Hours]) AS [Total Budgeted Hours OP4],
		SUM([4 Total Hours Issued]) AS [Total Hours Issued OP4],
		SUM([4 Hours Over Budget]) AS [Hours Over Budget OP4],

		SUM([5 Total Budgeted Hours]) AS [Total Budgeted Hours OP5],
		SUM([5 Total Hours Issued]) AS [Total Hours Issued OP5],
		SUM([5 Hours Over Budget]) AS [Hours Over Budget OP5],
		
		SUM([6 Total Budgeted Hours]) AS [Total Budgeted Hours OP6],
		SUM([6 Total Hours Issued]) AS [Total Hours Issued OP6],
		SUM([6 Hours Over Budget]) AS [Hours Over Budget OP6],
		
		SUM([7 Total Budgeted Hours]) AS [Total Budgeted Hours OP7],
		SUM([7 Total Hours Issued]) AS [Total Hours Issued OP7],
		SUM([7 Hours Over Budget]) AS [Hours Over Budget OP7],
		
		SUM([8 Total Budgeted Hours]) AS [Total Budgeted Hours OP8],
		SUM([8 Total Hours Issued]) AS [Total Hours Issued OP8],
		SUM([8 Hours Over Budget]) AS [Hours Over Budget OP8],

		SUM([12 Total Budgeted Hours]) AS [Total Budgeted Hours OP12],
		SUM([12 Total Hours Issued]) AS [Total Hours Issued OP12],
		SUM([12 Hours Over Budget]) AS [Hours Over Budget OP12],
		
		SUM([2 Total Budgeted Hours]) + SUM([3 Total Budgeted Hours]) + SUM([4 Total Budgeted Hours]) + SUM([5 Total Budgeted Hours]) + SUM([6 Total Budgeted Hours]) + SUM([7 Total Budgeted Hours]) + SUM([8 Total Budgeted Hours]) + SUM([12 Total Budgeted Hours]) AS [Total Budgeted Hours],
		SUM([2 Total Hours Issued]) + SUM([3 Total Hours Issued]) + SUM([4 Total Hours Issued]) + SUM([5 Total Hours Issued]) + SUM([6 Total Hours Issued]) + SUM([7 Total Hours Issued]) + SUM([8 Total Hours Issued]) + SUM([12 Total Hours Issued]) AS [Total Hours Issued],
		SUM([2 Hours Over Budget]) + SUM([3 Hours Over Budget]) + SUM([4 Hours Over Budget]) + SUM([5 Hours Over Budget]) + SUM([6 Hours Over Budget]) + SUM([7 Hours Over Budget]) + SUM([8 Hours Over Budget]) + SUM([12 Hours Over Budget]) AS [Hours Over Budget],
		[Total Defects]
	FROM (
		SELECT
			@WO AS [WO#],

			[2 Total Budgeted Hours],
			[2 Total Hours Issued],
			[2 Hours Over Budget],

			[3 Total Budgeted Hours],
			[3 Total Hours Issued],
			[3 Hours Over Budget],

			[4 Total Budgeted Hours],
			[4 Total Hours Issued],
			[4 Hours Over Budget],

			[5 Total Budgeted Hours],
			[5 Total Hours Issued],
			[5 Hours Over Budget],
			
			[6 Total Budgeted Hours],
			[6 Total Hours Issued],
			[6 Hours Over Budget],
			
			[7 Total Budgeted Hours],
			[7 Total Hours Issued],
			[7 Hours Over Budget],
			
			[8 Total Budgeted Hours],
			[8 Total Hours Issued],
			[8 Hours Over Budget],

			[12 Total Budgeted Hours],
			[12 Total Hours Issued],
			[12 Hours Over Budget],
			(
				SELECT
					ISNULL(SUM([#Defects]), 0)
				FROM
					[BWSdb].[dbo].[Defects]
				WHERE
					CAST([WO#] AS NVARCHAR(MAX)) LIKE @WO
			) AS [Total Defects]
		FROM (
			SELECT
				@WO AS [Job],
				SUM(IExpUnitRunTim) AS [2 Total Budgeted Hours],
				SUM([RunTimeIssued]) AS [2 Total Hours Issued],
				SUM([RunTimeIssued]) - SUM(IExpUnitRunTim) AS [2 Hours Over Budget],
				
				0 AS [3 Total Budgeted Hours],
				0 AS [3 Total Hours Issued],
				0 AS [3 Hours Over Budget],
				
				0 AS [4 Total Budgeted Hours],
				0 AS [4 Total Hours Issued],
				0 AS [4 Hours Over Budget],
				
				0 AS [5 Total Budgeted Hours],
				0 AS [5 Total Hours Issued],
				0 AS [5 Hours Over Budget],
				
				0 AS [6 Total Budgeted Hours],
				0 AS [6 Total Hours Issued],
				0 AS [6 Hours Over Budget],
				
				0 AS [7 Total Budgeted Hours],
				0 AS [7 Total Hours Issued],
				0 AS [7 Hours Over Budget],
				
				0 AS [8 Total Budgeted Hours],
				0 AS [8 Total Hours Issued],
				0 AS [8 Hours Over Budget],
				
				0 AS [12 Total Budgeted Hours],
				0 AS [12 Total Hours Issued],
				0 AS [12 Hours Over Budget]
			FROM
				[WipJobAllLab]
			WHERE
				[Job] LIKE @WO
				AND [Operation] = 2
				--AND (
				--	[IMachine] = 41
				--	OR [IMachine] = 42
				--)
			GROUP BY
				[Job]

			UNION

				SELECT
					@WO AS [Job],
				
					0 AS [2 Total Budgeted Hours],
					0 AS [2 Total Hours Issued],
					0 AS [2 Hours Over Budget],

					SUM(IExpUnitRunTim) AS [3 Total Budgeted Hours],
					SUM([RunTimeIssued]) AS [3 Total Hours Issued],
					SUM([RunTimeIssued]) - SUM(IExpUnitRunTim) AS [3 Hours Over Budget],
				
					0 AS [4 Total Budgeted Hours],
					0 AS [4 Total Hours Issued],
					0 AS [4 Hours Over Budget],
				
					0 AS [5 Total Budgeted Hours],
					0 AS [5 Total Hours Issued],
					0 AS [5 Hours Over Budget],
				
					0 AS [6 Total Budgeted Hours],
					0 AS [6 Total Hours Issued],
					0 AS [6 Hours Over Budget],
				
					0 AS [7 Total Budgeted Hours],
					0 AS [7 Total Hours Issued],
					0 AS [7 Hours Over Budget],
				
					0 AS [8 Total Budgeted Hours],
					0 AS [8 Total Hours Issued],
					0 AS [8 Hours Over Budget],
				
					0 AS [12 Total Budgeted Hours],
					0 AS [12 Total Hours Issued],
					0 AS [12 Hours Over Budget]
				FROM
					[WipJobAllLab]
				WHERE
					[Job] LIKE @WO
					AND [Operation] = 3
					--AND (
					--	[IMachine] = 41
					--	OR [IMachine] = 42
					--)
				GROUP BY
					[Job]

			UNION

				SELECT
					@WO AS [Job],
				
					0 AS [2 Total Budgeted Hours],
					0 AS [2 Total Hours Issued],
					0 AS [2 Hours Over Budget],
				
					0 AS [3 Total Budgeted Hours],
					0 AS [3 Total Hours Issued],
					0 AS [3 Hours Over Budget],

					SUM(IExpUnitRunTim) AS [4 Total Budgeted Hours],
					SUM([RunTimeIssued]) AS [4 Total Hours Issued],
					SUM([RunTimeIssued]) - SUM(IExpUnitRunTim) AS [4 Hours Over Budget],
				
					0 AS [5 Total Budgeted Hours],
					0 AS [5 Total Hours Issued],
					0 AS [5 Hours Over Budget],
				
					0 AS [6 Total Budgeted Hours],
					0 AS [6 Total Hours Issued],
					0 AS [6 Hours Over Budget],
				
					0 AS [7 Total Budgeted Hours],
					0 AS [7 Total Hours Issued],
					0 AS [7 Hours Over Budget],
				
					0 AS [8 Total Budgeted Hours],
					0 AS [8 Total Hours Issued],
					0 AS [8 Hours Over Budget],
				
					0 AS [12 Total Budgeted Hours],
					0 AS [12 Total Hours Issued],
					0 AS [12 Hours Over Budget]
				FROM
					[WipJobAllLab]
				WHERE
					[Job] LIKE @WO
					AND [Operation] = 4
					--AND (
					--	[IMachine] = 41
					--	OR [IMachine] = 42
					--)
				GROUP BY
					[Job]

			UNION

				SELECT
					@WO AS [Job],
				
					0 AS [2 Total Budgeted Hours],
					0 AS [2 Total Hours Issued],
					0 AS [2 Hours Over Budget],
				
					0 AS [3 Total Budgeted Hours],
					0 AS [3 Total Hours Issued],
					0 AS [3 Hours Over Budget],
				
					0 AS [4 Total Budgeted Hours],
					0 AS [4 Total Hours Issued],
					0 AS [4 Hours Over Budget],

					SUM(IExpUnitRunTim) AS [5 Total Budgeted Hours],
					SUM([RunTimeIssued]) AS [5 Total Hours Issued],
					SUM([RunTimeIssued]) - SUM(IExpUnitRunTim) AS [5 Hours Over Budget],
				
					0 AS [6 Total Budgeted Hours],
					0 AS [6 Total Hours Issued],
					0 AS [6 Hours Over Budget],
				
					0 AS [7 Total Budgeted Hours],
					0 AS [7 Total Hours Issued],
					0 AS [7 Hours Over Budget],
				
					0 AS [8 Total Budgeted Hours],
					0 AS [8 Total Hours Issued],
					0 AS [8 Hours Over Budget],
				
					0 AS [12 Total Budgeted Hours],
					0 AS [12 Total Hours Issued],
					0 AS [12 Hours Over Budget]
				FROM
					[WipJobAllLab]
				WHERE
					[Job] LIKE @WO
					AND [Operation] = 5
					--AND (
					--	[IMachine] = 41
					--	OR [IMachine] = 42
					--)
				GROUP BY
					[Job]

			UNION

				SELECT
					@WO AS [Job],
				
					0 AS [2 Total Budgeted Hours],
					0 AS [2 Total Hours Issued],
					0 AS [2 Hours Over Budget],
				
					0 AS [3 Total Budgeted Hours],
					0 AS [3 Total Hours Issued],
					0 AS [3 Hours Over Budget],
				
					0 AS [4 Total Budgeted Hours],
					0 AS [4 Total Hours Issued],
					0 AS [4 Hours Over Budget],
				
					0 AS [5 Total Budgeted Hours],
					0 AS [5 Total Hours Issued],
					0 AS [5 Hours Over Budget],

					SUM(IExpUnitRunTim) AS [6 Total Budgeted Hours],
					SUM([RunTimeIssued]) AS [6 Total Hours Issued],
					SUM([RunTimeIssued]) - SUM(IExpUnitRunTim) AS [6 Hours Over Budget],
				
					0 AS [7 Total Budgeted Hours],
					0 AS [7 Total Hours Issued],
					0 AS [7 Hours Over Budget],
				
					0 AS [8 Total Budgeted Hours],
					0 AS [8 Total Hours Issued],
					0 AS [8 Hours Over Budget],
				
					0 AS [12 Total Budgeted Hours],
					0 AS [12 Total Hours Issued],
					0 AS [12 Hours Over Budget]
				FROM
					[WipJobAllLab]
				WHERE
					[Job] LIKE @WO
					AND [Operation] = 6
					--AND (
					--	[IMachine] = 41
					--	OR [IMachine] = 42
					--)
				GROUP BY
					[Job]

			UNION

				SELECT
					@WO AS [Job],
				
					0 AS [2 Total Budgeted Hours],
					0 AS [2 Total Hours Issued],
					0 AS [2 Hours Over Budget],
				
					0 AS [3 Total Budgeted Hours],
					0 AS [3 Total Hours Issued],
					0 AS [3 Hours Over Budget],
				
					0 AS [4 Total Budgeted Hours],
					0 AS [4 Total Hours Issued],
					0 AS [4 Hours Over Budget],
				
					0 AS [5 Total Budgeted Hours],
					0 AS [5 Total Hours Issued],
					0 AS [5 Hours Over Budget],
				
					0 AS [6 Total Budgeted Hours],
					0 AS [6 Total Hours Issued],
					0 AS [6 Hours Over Budget],

					SUM(IExpUnitRunTim) AS [7 Total Budgeted Hours],
					SUM([RunTimeIssued]) AS [7 Total Hours Issued],
					SUM([RunTimeIssued]) - SUM(IExpUnitRunTim) AS [7 Hours Over Budget],
				
					0 AS [8 Total Budgeted Hours],
					0 AS [8 Total Hours Issued],
					0 AS [8 Hours Over Budget],
				
					0 AS [12 Total Budgeted Hours],
					0 AS [12 Total Hours Issued],
					0 AS [12 Hours Over Budget]
				FROM
					[WipJobAllLab]
				WHERE
					[Job] LIKE @WO
					AND [Operation] = 7
					--AND (
					--	[IMachine] = 41
					--	OR [IMachine] = 42
					--)
				GROUP BY
					[Job]

			UNION

				SELECT
					@WO AS [Job],
				
					0 AS [2 Total Budgeted Hours],
					0 AS [2 Total Hours Issued],
					0 AS [2 Hours Over Budget],
				
					0 AS [3 Total Budgeted Hours],
					0 AS [3 Total Hours Issued],
					0 AS [3 Hours Over Budget],
				
					0 AS [4 Total Budgeted Hours],
					0 AS [4 Total Hours Issued],
					0 AS [4 Hours Over Budget],
				
					0 AS [5 Total Budgeted Hours],
					0 AS [5 Total Hours Issued],
					0 AS [5 Hours Over Budget],
				
					0 AS [6 Total Budgeted Hours],
					0 AS [6 Total Hours Issued],
					0 AS [6 Hours Over Budget],
				
					0 AS [7 Total Budgeted Hours],
					0 AS [7 Total Hours Issued],
					0 AS [7 Hours Over Budget],

					SUM(IExpUnitRunTim) AS [8 Total Budgeted Hours],
					SUM([RunTimeIssued]) AS [8 Total Hours Issued],
					SUM([RunTimeIssued]) - SUM(IExpUnitRunTim) AS [8 Hours Over Budget],
				
					0 AS [12 Total Budgeted Hours],
					0 AS [12 Total Hours Issued],
					0 AS [12 Hours Over Budget]
				FROM
					[WipJobAllLab]
				WHERE
					[Job] LIKE @WO
					AND [Operation] = 8
					--AND (
					--	[IMachine] = 41
					--	OR [IMachine] = 42
					--)
				GROUP BY
					[Job]

			UNION

				SELECT
					@WO AS [Job],
				
					0 AS [2 Total Budgeted Hours],
					0 AS [2 Total Hours Issued],
					0 AS [2 Hours Over Budget],
				
					0 AS [3 Total Budgeted Hours],
					0 AS [3 Total Hours Issued],
					0 AS [3 Hours Over Budget],
				
					0 AS [4 Total Budgeted Hours],
					0 AS [4 Total Hours Issued],
					0 AS [4 Hours Over Budget],
				
					0 AS [5 Total Budgeted Hours],
					0 AS [5 Total Hours Issued],
					0 AS [5 Hours Over Budget],
				
					0 AS [6 Total Budgeted Hours],
					0 AS [6 Total Hours Issued],
					0 AS [6 Hours Over Budget],
				
					0 AS [7 Total Budgeted Hours],
					0 AS [7 Total Hours Issued],
					0 AS [7 Hours Over Budget],
				
					0 AS [8 Total Budgeted Hours],
					0 AS [8 Total Hours Issued],
					0 AS [8 Hours Over Budget],

					SUM(IExpUnitRunTim) AS [12 Total Budgeted Hours],
					SUM([RunTimeIssued]) AS [12 Total Hours Issued],
					SUM([RunTimeIssued]) - SUM(IExpUnitRunTim) AS [12 Hours Over Budget]
				FROM
					[WipJobAllLab]
				WHERE
					[Job] LIKE @WO
					AND [Operation] = 12
					--AND (
					--	[IMachine] = 41
					--	OR [IMachine] = 42
					--)
				GROUP BY
					[Job]
				
			
		) AS [SrcTable1]
	) AS [SrcTable2]

	GROUP BY
		[WO#],
		[Total Defects]
) AS [SrcTable4]

;

--DECLARE @a AS NVARCHAR(MAX)
--DECLARE @b AS NVARCHAR(MAX)
--DECLARE @c AS NVARCHAR(MAX)
--DECLARE @d AS NVARCHAR(MAX)
--DECLARE @e AS NVARCHAR(MAX)
--DECLARE @f AS NVARCHAR(MAX)
--DECLARE @g AS NVARCHAR(MAX)
--DECLARE @h AS NVARCHAR(MAX)
--DECLARE @z AS NVARCHAR(MAX)

--SELECT TOP 1
--	@a = ISNULL([WO#], ''),
--	@b = ISNULL(CAST([Total Budgeted Hours OP4] AS NVARCHAR(MAX)), ''),
--	@c = ISNULL(CAST([Total Hours Issued OP4] AS NVARCHAR(MAX)), ''),
--	@d = ISNULL(CAST([Hours Over Budget OP4] AS NVARCHAR(MAX)), ''),
--	@e = ISNULL(CAST([Total Budgeted Hours OP5] AS NVARCHAR(MAX)), ''),
--	@f = ISNULL(CAST([Total Hours Issued OP5] AS NVARCHAR(MAX)), ''),
--	@g = ISNULL(CAST([Hours Over Budget OP5] AS NVARCHAR(MAX)), ''),
--	@h = ISNULL(CAST([Total Defects] AS NVARCHAR(MAX)), ''),
--	@z = GETDATE()
--FROM @t


--DECLARE @persons AS NVARCHAR(MAX);
--DECLARE @subject AS NVARCHAR(255);
--DECLARE @body AS NVARCHAR(MAX);

--SELECT @persons = 'avery.briggs@bwstrailers.com';
--SELECT @subject = 'New WO Snapshot Query';

--SELECT @body = '<!DOCTYPE html><html><body><div class="ITR Body" id="ITR Body ID 001" ><Table class="ITR Table" border="1" cellpadding = "5" cellspacing = "5"><thead><th colspan="2"><b>WO#: '
--SELECT @body = @body + @a + '</b></th></thead><tbody><tr><td><b>When:</b></td><td>';
--SELECT @body = @body + @z + '</b></th></thead><tbody><tr><td><b>Total Budgeted Hours OP4:</b></td><td>';
--SELECT @body = @body + @b + '</td></tr><tr><td><b>Total Hours Issued OP4:</b></td><td>';
--SELECT @body = @body + @c + '</td></tr><tr><td><b>Hours Over Budget OP4:</b></td><td>';
--SELECT @body = @body + @d + '</td></tr><tr><td><b>Total Budgeted Hours OP5:</b></td><td>';
--SELECT @body = @body + @e + '</td></tr><tr><td><b>Total Hours Issued OP5:</b></td><td>';
--SELECT @body = @body + @f + '</td></tr><tr><td><b>Hours Over Budget OP5:</b></td><td>';
--SELECT @body = @body + @g + '</td></tr><tr><td><b>Total Defects:</b></td><td>';
--SELECT @body = @body + @h + '</td></tr></tbody></Table></div></body><footer>'
--SET @body = @body + '</footer></html>'

----SELECT @body AS [Body]

--EXEC msdb.dbo.sp_send_dbmail
--	@recipients = @persons,
--	@profile_name = 'SQL Agent',
--	@subject = @subject, 
--	@body = @body,
--	@body_format='HTML';

SELECT * FROM @t

--END
