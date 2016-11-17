CREATE OR REPLACE FORCE VIEW ma_apps.rec_outage_count_by_date ("LINK",reported_date,outages) AS
select 
  null link,
  op.reported_date,
  count(*) outages
from
  rec_daily_operations op,
  rec_issue_type it
where
  op.issue_type_id = it.issue_type_id and
  it.issue_type_name = 'Outages' and
  op.reported_date >= sysdate - 90
group by
  op.reported_date
order by
  op.reported_date;