CREATE OR REPLACE TRIGGER ma_apps."REC_DAILY_OPERATIONS_UPD_EMAIL"
after update on ma_apps.rec_daily_operations
for each row
declare

  v_loader_old              rec_issue_owner.loader%type;
  v_loader_new              rec_issue_owner.loader%type;

begin

  if :old.owner_id != :new.owner_id then
    select
      nvl(loader,'N')
    into
      v_loader_old
    from
      rec_issue_owner
    where
      owner_id = :old.owner_id;
      
    select
      nvl(loader,'N')
    into
      v_loader_new
    from
      rec_issue_owner
    where
      owner_id = :new.owner_id;
    
    if v_loader_old = 'Y' and v_loader_new != 'Y' then
      -- New assignment.                             
      daily_updates.send_alert( 'I',
                                :new.daily_operations_id,
                                :new.issue_status_id,
                                :new.owner_id,
                                :new.issue_type_id,
                                :new.job_name,
                                :new.reported_date);
    elsif v_loader_old != 'Y' and :old.owner_id != :new.owner_id then
      -- Reassigned.                            
      daily_updates.send_alert( 'R',
                                :new.daily_operations_id,
                                :new.issue_status_id,
                                :new.owner_id,
                                :new.issue_type_id,
                                :new.job_name,
                                :new.reported_date);
    end if;
  end if;
  
  if :new.target_date != :old.target_date then
    insert into rec_target_history (
      target_history_id,
      daily_operations_id,
      owner_id,
      target_date,
      update_user_id,
      update_date )
    values (
      rec_target_history_seq.nextval,
      :new.daily_operations_id,
      :new.owner_id,
      :new.target_date,
      v('APP_USER'),
      sysdate);
  end if;
  
exception
  when others then
    raise_application_error(-20201, 'Failed on insert trigger.');
end;
/