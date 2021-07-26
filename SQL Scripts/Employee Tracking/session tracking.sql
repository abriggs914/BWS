use SysproCompanyA
go
select cast(Timestamp as bigint), * from ClkTransaction with (nolock)
where EmployeeNumber = 200100
order by TransactionID desc
select * from ClkLogClientServerEvent with (nolock)
where RequestInfo like '%4842863192%'
select distinct ClientID, SessionID from ClkLogClientServerEvent with (nolock)
where RequestInfo like '%4842863192%'
select * from ClkClients with (nolock)
where ClientID in (383, 401, 411)
select * from ClkClientSessions with (nolock)
where ClientID in (383, 401, 411)
and SessionID in (46080, 46079, 46087)