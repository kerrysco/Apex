CREATE TABLE ma_apps.rec_daily_update (
  daily_update_id NUMBER NOT NULL,
  daily_operations_id NUMBER NOT NULL,
  update_user VARCHAR2(100 BYTE),
  update_date DATE,
  update_desc VARCHAR2(4000 BYTE),
  PRIMARY KEY (daily_update_id),
  CONSTRAINT fk_daily_operations FOREIGN KEY (daily_operations_id) REFERENCES ma_apps.rec_daily_operations (daily_operations_id)
);