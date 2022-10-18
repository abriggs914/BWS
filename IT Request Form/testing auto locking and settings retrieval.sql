USE BWSdb
GO

DECLARE @requestedBy AS NVARCHAR(MAX);
DECLARE @newLockedOG BIT;
DECLARE @newLocked BIT;
SELECT @requestedBy = 'James Crawford';
SELECT @newLockedOG = 1;

DECLARE @it_p_id AS INTEGER;
	DECLARE @it_s_id AS INTEGER;

	SELECT @it_p_id = [ITPersonID#] FROM [IT Personnel] WHERE LOWER([Name]) LIKE '%' + @requestedBy + '%';
	IF @newLockedOG <> 0 BEGIN
		IF @it_p_id IS NOT NULL BEGIN
			SELECT @it_s_id = [ID] FROM [ITR Settings] WHERE [ITRCustomerID] = @it_p_id;
			IF @it_s_id IS NOT NULL BEGIN
				SELECT @newLocked = [AutoLockOwnRequests] FROM [ITR Settings];
			END
		END
	END

SELECT
	@it_p_id AS [itpd]
	,@it_s_id AS [itsd]
	,@newLocked AS [nl]
	,@newLockedOG AS [nlo]