USE BWSdb
GO

-- Get all non-complete requests that deal with phones.
-- Use the results to prepare a list of items for a service call to Bob.
-- Designed to save from calling for each individual task.

SELECT * FROM [IT Requests] WHERE ([RequestSubType] LIKE '%phone%' OR [Comments] LIKE '%phone%' OR [Request] LIKE '%phone%') AND [Status] <> 'Complete'