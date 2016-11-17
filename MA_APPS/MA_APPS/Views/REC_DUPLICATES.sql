CREATE OR REPLACE FORCE VIEW ma_apps.rec_duplicates (daily_operations_id,daily_update_id,issue_status_id,owner_id,reported_date,job_name,update_desc) AS
select
  rdo.daily_operations_id,
  c.daily_update_id,
  rdo.issue_status_id,
  rdo.owner_id,
  rdo.reported_date,
  rdo.job_name,
  c.update_desc
from
  rec_daily_operations rdo,
  ( select
      job_name,
      count(*)
    from
      rec_daily_operations
    where
      issue_type_id = 3 and
      closed_date is null
    group by
      job_name
    having
      count(*) > 1 ) dup,
  ( select
      rdu.daily_operations_id,
      rdu.daily_update_id,
      fup.first_update,
      rdu.update_desc
    from
      rec_daily_update rdu,
      ( select
          daily_operations_id,
          min(daily_update_id) first_update
        from
          rec_daily_update
        group by
          daily_operations_id ) fup
    where
      rdu.daily_operations_id = fup.daily_operations_id and
      rdu.daily_update_id = fup.first_update ) c
where
  rdo.job_name = dup.job_name and
  rdo.daily_operations_id = c.daily_operations_id and
  rdo.issue_type_id = 3 and
  rdo.closed_date is null;