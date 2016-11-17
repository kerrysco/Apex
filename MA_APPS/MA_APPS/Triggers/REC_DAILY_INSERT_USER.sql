CREATE OR REPLACE TRIGGER ma_apps.rec_daily_insert_user
BEFORE INSERT
   ON ma_apps.rec_daily_update
   FOR EACH ROW
   
DISABLE DECLARE
   v_username varchar2(10);
   
BEGIN
   
   -- Update updated_by field to the username of the person performing the UPDATE
   :new.update_user := v('APP_USER');
   
END;
/