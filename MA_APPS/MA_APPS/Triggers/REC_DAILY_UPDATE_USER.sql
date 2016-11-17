CREATE OR REPLACE TRIGGER ma_apps.rec_daily_update_user
BEFORE UPDATE
   ON ma_apps.rec_daily_update
   FOR EACH ROW
   
DISABLE DECLARE
   v_username varchar2(10);
   
BEGIN

   -- Find username of person performing UPDATE on the table
   SELECT user INTO v_username
   FROM dual;
   
   -- Update updated_by field to the username of the person performing the UPDATE
   :new.update_user := v('APP_USER');
   
   -- Update updated_date field to current system date
   :new.update_date := sysdate;
   
END;
/