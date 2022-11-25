use SysproCompanyA
go

select *
FROM
    WipMaster with (nolock)
WHERE
    lower(JobDescription) like '%filter%'
    or lower(StockDescription) like '%filter%'


select *
FROM
    WipJobAllLab with (nolock)
WHERE
    Job in (
                select Job
                FROM
                    WipMaster with (nolock)
                WHERE
                    lower(JobDescription) like '%filter%'
                    or lower(StockDescription) like '%filter%'
            )

select *
FROM
    BomMachine with (nolock)
WHERE
    Machine = '56'