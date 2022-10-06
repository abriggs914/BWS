
USE BWSdb
GO

CREATE VIEW [dbo].[v_ITP DistinctPhoneListNames] AS
SELECT DISTINCT [v_ITP PhoneListData].NAME_
FROM [v_ITP PhoneListData]
LEFT JOIN
	[ITP FormSections]
ON
	RIGHT([NAME_], 255) = RIGHT([Name], 255)
WHERE [Name] IS NULL AND ((([v_ITP PhoneListData].NAME_) IS NOT NULL));

GO