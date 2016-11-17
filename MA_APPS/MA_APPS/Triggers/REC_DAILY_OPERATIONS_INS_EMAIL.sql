CREATE OR REPLACE TRIGGER ma_apps.rec_daily_operations_ins_email
after insert on ma_apps.rec_daily_operations
for each row
begin
  daily_updates.send_alert( 'I',
                            :new.daily_operations_id,
                            :new.issue_status_id,
                            :new.owner_id,
                            :new.issue_type_id,
                            :new.job_name,
                            :new.reported_date);
  if :new.issue_type_id = 6 then
    insert into rec_daily_update (
      daily_update_id,
      daily_operations_id,
      update_user,
      update_date,
      update_desc )
    values (
      rec_daily_update_seq.nextval,
      :new.daily_operations_id,
      :new.owner_id,
      trunc(sysdate),
      'Project: ');
    insert into rec_daily_update (
      daily_update_id,
      daily_operations_id,
      update_user,
      update_date,
      update_desc )
    values (
      rec_daily_update_seq.nextval,
      :new.daily_operations_id,
      :new.owner_id,
      trunc(sysdate),
      'Time: ');
    insert into rec_daily_update (
      daily_update_id,
      daily_operations_id,
      update_user,
      update_date,
      update_desc )
    values (
      rec_daily_update_seq.nextval,
      :new.daily_operations_id,
      :new.owner_id,
      trunc(sysdate),
      'DBA Resource: ');
    insert into rec_daily_update (
      daily_update_id,
      daily_operations_id,
      update_user,
      update_date,
      update_desc )
    values (
      rec_daily_update_seq.nextval,
      :new.daily_operations_id,
      :new.owner_id,
      trunc(sysdate),
      'SysAdmin Resource: ');
  end if;

exception
  when others then
    raise_application_error(-20201, 'Failed on insert trigger.');
end;
/