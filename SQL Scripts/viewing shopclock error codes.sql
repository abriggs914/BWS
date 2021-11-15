USE SysproCompanyS
GO

select * from ClkLogClientServerEvent with (nolock)
where cast(DateTimeStartedUTC as date) = 'nov 12 2021'