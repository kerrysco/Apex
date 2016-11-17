CREATE OR REPLACE FORCE VIEW ma_apps.rec_jams_count_by_date ("LINK",reported_date,jams) AS
select 
  null link,
  op.reported_date,
  count(*) jams
from
  rec_daily_operations op,
  rec_issue_type it
where
  op.issue_type_id = it.issue_type_id and
  it.issue_type_name = 'JAMS Issues' and
  op.reported_date >= sysdate - 90
group by
  op.reported_date
order by
  op.reported_date;