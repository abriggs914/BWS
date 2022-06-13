USE BWSdb
GO

EXEC [dbo].[sp_ITRTopNTimeIssued] @topN=5
EXEC [dbo].[sp_ITRTopNRequests] @topN=5
EXEC [dbo].[sp_ITRTopNTimePerRequest] @topN=5