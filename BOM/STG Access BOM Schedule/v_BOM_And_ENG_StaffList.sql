USE BWSdb
GO

CREATE VIEW [v_BOM_And_ENG_StaffList] AS

	SELECT
		[BOMStaffID] AS [ID]
		, 'BOM' AS [StaffSection]
		, [Initials]
		, [Staff]
	FROM
		[Design BOM Staff]
	UNION
	SELECT
		[ID-SaleStaff]
		, 'ENG'
		, [Initials]
		, [Staff]
	FROM
		[Design Staff]
	WHERE
		[Active?] = 1