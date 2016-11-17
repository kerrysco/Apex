CREATE OR REPLACE TRIGGER ma_apps.rec_daily_operations_closed
before update on ma_apps.rec_daily_operations
for each row
begin
  if (:new.issue_status_id = 3 or :new.issue_status_id = 23) then
    if (:old.issue_status_id != 3 or :old.issue_status_id != 23) then
      :new.closed_date := sysdate;
    end if;
  else
    :new.closed_date := null;
  end if;
end;
/