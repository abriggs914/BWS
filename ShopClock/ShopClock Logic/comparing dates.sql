DECLARE @sd AS DATETIME = '2021-11-01 8:00';
DECLARE @ed AS DATETIME = '2021-11-01 13:15';
DECLARE @s AS DATETIME = '1900-01-01';

SELECT
	@sd AS [SD],
	@ed AS [ED],
	@ed - @sd AS [X],
	@sd - @ed AS [-X],
	@s - (@ed - @sd) AS [XY],
	(@ed - @sd) - @s AS [-XY],
	@s - (@sd - @ed) AS [YX],
	(@sd - @ed) - @s AS [-YX]