USE BWSdb
GO

DECLARE @t1 AS NVARCHAR(MAX);
DECLARE @t2 AS NVARCHAR(MAX);
DECLARE @t3 AS NVARCHAR(MAX);
DECLARE @t4 AS NVARCHAR(MAX);
DECLARE @t5 AS NVARCHAR(MAX);
DECLARE @t6 AS NVARCHAR(MAX);
DECLARE @t7 AS NVARCHAR(MAX);
DECLARE @t8 AS NVARCHAR(MAX);
DECLARE @t9 AS NVARCHAR(MAX);
DECLARE @t10 AS NVARCHAR(MAX);
DECLARE @t11 AS NVARCHAR(MAX);
DECLARE @t12 AS NVARCHAR(MAX);
DECLARE @t13 AS NVARCHAR(MAX);
DECLARE @t14 AS NVARCHAR(MAX);
DECLARE @t15 AS NVARCHAR(MAX);
DECLARE @t16 AS NVARCHAR(MAX);
DECLARE @t17 AS NVARCHAR(MAX);
DECLARE @t18 AS NVARCHAR(MAX);
DECLARE @t19 AS NVARCHAR(MAX);
DECLARE @t20 AS NVARCHAR(MAX);
DECLARE @t21 AS NVARCHAR(MAX);
DECLARE @t22 AS NVARCHAR(MAX);
DECLARE @t23 AS NVARCHAR(MAX);
DECLARE @t24 AS NVARCHAR(MAX);
DECLARE @t25 AS NVARCHAR(MAX);

SET @t1 = '15063238472';
SET @t2 = '16478901060';
SET @t3 = '5062785454';
SET @t4 = '2785454';
SET @t5 = '1 506 323 8472';
SET @t6 = '1-506-323-8472';
SET @t7 = '+1 506 323 8472';
SET @t8 = '+1-506-323-8472';
SET @t9 = '+ 1 506 323 8472';
SET @t10 = '+-1-506-323-8472';
SET @t11 = '506-323-8472';
SET @t12 = '506 323 8472';
SET @t13 = '323-8472';
SET @t14 = '6478901060';
SET @t15 = '8901060';
SET @t16 = '1 647 890 1060';
SET @t17 = '1-647-890-1060';
SET @t18 = '+1 647 890 1060';
SET @t19 = '+1-647-890-1060';
SET @t20 = '+ 1 647 890 1060';
SET @t21 = '+-1-647-890-1060';
SET @t22 = '647-890-1060';
SET @t23 = '647 890 1060';
SET @t24 = '890-1060';
SET @t25 = '15062761157  ';

SELECT
	@t1 AS [@t1],
	@t2 AS [@t2],
	@t3 AS [@t3],
	@t4 AS [@t4],
	@t5 AS [@t5],
	@t6 AS [@t6],
	@t7 AS [@t7],
	@t8 AS [@t8],
	@t9 AS [@t9],
	@t10 AS [@t10],
	@t11 AS [@t11],
	@t12 AS [@t12],
	@t13 AS [@t13],
	@t14 AS [@t14],
	@t15 AS [@t15],
	@t16 AS [@t16],
	@t17 AS [@t17],
	@t18 AS [@t18],
	@t19 AS [@t19],
	@t20 AS [@t20],
	@t21 AS [@t21],
	@t22 AS [@t22],
	@t23 AS [@t23],
	@t24 AS [@t24],
	@t25 AS [@t25]

DECLARE @tests AS TABLE ([ID] INT IDENTITY(1, 1), [Og] NVARCHAR(MAX), [In] NVARCHAR(MAX), [Out] NVARCHAR(MAX), [Ans] NVARCHAR(MAX), [Right] NVARCHAR(MAX), [Calc] NVARCHAR(MAX))
INSERT INTO @tests ([Og], [In], [Ans]) VALUES 
	(@t1, @t1,'323-8472'), (@t2, @t2, '647-890-1060'), (@t3, @t3, '278-5454'),
	(@t4, @t4, '278-5454'), (@t5, @t5, '323-8472'), (@t6, @t6, '323-8472'),
	(@t7, @t7, '323-8472'), (@t8, @t8, '323-8472'), (@t9, @t9, '323-8472'),
	(@t10, @t10, '323-8472'), (@t11, @t11, '323-8472'), (@t12, @t12, '323-8472'),
	(@t13, @t13, '323-8472')
	,
	(@t14, @t14, '647-890-1060'),
	(@t15, @t15, '890-1060'),
	(@t16, @t16, '647-890-1060'),
	(@t17, @t17, '647-890-1060'),
	(@t18, @t18, '647-890-1060'),
	(@t19, @t19, '647-890-1060'),
	(@t20, @t20, '647-890-1060'),
	(@t21, @t21, '647-890-1060'),
	(@t22, @t22, '647-890-1060'),
	(@t23, @t23, '647-890-1060'),
	(@t24, @t24, '890-1060'),
	(@t25, @t25, '276-1157')

UPDATE
	@tests
SET
	[In] = LTRIM(RTRIM(REPLACE(REPLACE(REPLACE([In], ' ', ''), '+', ''), '-', '')))

UPDATE
	@tests
SET
	[Out] = (CASE
		WHEN
			(LEN([In]) > 16 OR LEN([In]) < 7) OR (LEFT([In], 4) NOT LIKE '1506' AND LEFT([In], 3) NOT LIKE '506')
		THEN
			--'A_' +
			(CASE
				WHEN
					LEN([In]) = 7
				THEN
					--'a_' +
					LEFT([In], 3) + '-' + RIGHT([In], LEN([In]) - 3)
				WHEN
					LEN([In]) = 10
				THEN
					--'b_' +
					LEFT([In], 3) + '-' + LEFT(RIGHT([In], 7), 3) + '-' + RIGHT([In], 4)
				WHEN
					LEN([In]) = 11
				THEN
					--'c_' +
					LEFT(RIGHT([In], 10), 3) + '-' + LEFT(RIGHT(RIGHT([In], 10), 7), 3) + '-' + RIGHT([In], 4)
				WHEN
					LEN([In]) = 12
				THEN
					--'d_' +
					LEFT(RIGHT([In], 11), 3) + '-' + LEFT(RIGHT(RIGHT([In], 11), 7), 3) + '-' + RIGHT([In], 4)
				ELSE
					--'e_' +
					[In]
				END)
		WHEN LEFT([In], 4) = '1506' THEN
			--'B_' +
			LEFT(RIGHT([In], LEN([IN]) - 4), 3) + '-' + RIGHT([In], 4)
		WHEN LEFT([In], 3) = '506' THEN
			--'C_' +
			LEFT(RIGHT([In], LEN([IN]) - 3), 3) + '-' + RIGHT([In], 4)
		ELSE
			--'D_' +
			LEFT([In], 3) + '-' + RIGHT([In], LEN([In]) - 3)
		END)

UPDATE
	@tests
SET
	[Right] = (CASE WHEN REPLACE(
							REPLACE(
								REPLACE(
									REPLACE(
										REPLACE(
											REPLACE(
												REPLACE(
													REPLACE(
														REPLACE(
															REPLACE(
																[Out], '_', ''),
															'A', ''),
														'B', ''),
													'C', ''), 
												'D', ''),
											'a', ''),
										'b', ''),
									'c', ''),
								'd', ''),
							'e', '')
						= [Ans] THEN
							'Y'
						ELSE
							''
						END
				)

UPDATE
	@tests
SET
	[Calc] = [dbo].[NBPhonify]([Og], 1)

--SET
--	[Out] = (CASE
--		WHEN
--			LEN([In]) < 7 OR (LEFT([In], 4) NOT LIKE '1506' AND LEFT([In], 3) NOT LIKE '506')
--		THEN
--			[In]
--		ELSE
--			REPLACE(
--				REPLACE(
--					LEFT([In], 4), '1506', '')
--				, '506', '')
--			+ RIGHT(LEFT([In], LEN([In]) - (CASE
--												WHEN
--													LEFT([In], 4) = '1506'
--												THEN
--													4
--												ELSE
--													3
--												END)), 3)
--			+ '-' + RIGHT([In], 4)
--		END)

SELECT * FROM @tests;

--SELECT
	--LEFT(REPLACE(REPLACE(@t1, '1506', '')), 3) + '-' + RIGHT(@t1, 4) AS [X]

--	REPLACE(REPLACE(LEFT(@t1, 4), '1506', ''), '506', '') + RIGHT(LEFT(@t1, LEN(@t1) - 4), 3) + '-' + RIGHT(@t1, 4) AS [X]
