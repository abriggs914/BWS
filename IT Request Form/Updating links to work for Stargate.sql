SELECT
	[Directory],

	LEFT([Directory], 6) + '.bwsdomain.local' + RIGHT([Directory], LEN([Directory]) - 6)

	[ITRequestID#]
      ,[StartDate]
      ,[RequestDate]
      ,[DueDate]
      ,[Request]
      ,[Priority]
      ,[SubPriority]
      ,[RequestedBy]
      ,[Department]
      ,[RequestFollowUpPersonnel]
      ,[RequestType]
      ,[RequestSubType]
      ,[Comments]
      ,[Company]
      ,[Status]
      ,[Directory]
      ,[ITPersonAssignedID]
      ,[CompletionDate]
      ,[LastStatusUpdate]
      ,[LabourEstimate]
      ,[LabourActual]
      ,[TimerStart]
      ,[TimerStop]
      ,[Timer]
      ,[OpenCounter]
      ,[IsOpened]
      ,[RequestDateOriginal]
      ,[LinkNext]
      ,[LinkPrev]
      ,[RequesterLocked]
      ,[RequesterLockedDate]
      ,[AssignmentEmailDate]
	FROM 
		[IT Requests]

BEGIN TRAN;

UPDATE
	[IT Requests]
SET
	[Directory] = LEFT([Directory], 6) + '.bwsdomain.local' + RIGHT([Directory], LEN([Directory]) - 6)

SELECT
	[Directory],

	LEFT([Directory], 6) + '.bwsdomain.local' + RIGHT([Directory], LEN([Directory]) - 6)

	[ITRequestID#]
      ,[StartDate]
      ,[RequestDate]
      ,[DueDate]
      ,[Request]
      ,[Priority]
      ,[SubPriority]
      ,[RequestedBy]
      ,[Department]
      ,[RequestFollowUpPersonnel]
      ,[RequestType]
      ,[RequestSubType]
      ,[Comments]
      ,[Company]
      ,[Status]
      ,[Directory]
      ,[ITPersonAssignedID]
      ,[CompletionDate]
      ,[LastStatusUpdate]
      ,[LabourEstimate]
      ,[LabourActual]
      ,[TimerStart]
      ,[TimerStop]
      ,[Timer]
      ,[OpenCounter]
      ,[IsOpened]
      ,[RequestDateOriginal]
      ,[LinkNext]
      ,[LinkPrev]
      ,[RequesterLocked]
      ,[RequesterLockedDate]
      ,[AssignmentEmailDate]
	FROM 
		[IT Requests]


ROLLBACK;
COMMIT;