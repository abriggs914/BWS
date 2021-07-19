USE BWSdb
GO

-- Production
SELECT * FROM [Defects]
SELECT * FROM [Defects_Causes]
SELECT * FROM [Defects_Location]

-- Finish Off
SELECT * FROM [Defects_BPF]
SELECT * FROM [Defects_BPF_Location]
SELECT * FROM [Defects_BPF_NoWOsInspected]

SELECT * FROM [Defects_NoWOsInspected]

-- Engineering
SELECT * FROM [Defects_Print]
SELECT * FROM [Defects_Print_Problems]

-- Receiving
SELECT * FROM [Defects_Receiving]
SELECT * FROM [Defects_Receiving_Problems]


-- Mostly unused...
SELECT * FROM [Defects_Snags]
SELECT * FROM [Defects_Snags_Causes]
SELECT * FROM [Defects_Snags_Location]
SELECT * FROM [Defects_Snags_NoWOsInspected]