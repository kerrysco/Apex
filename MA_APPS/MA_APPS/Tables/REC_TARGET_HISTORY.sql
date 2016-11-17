CREATE TABLE ma_apps.rec_target_history (
  target_history_id NUMBER NOT NULL,
  daily_operations_id NUMBER NOT NULL,
  owner_id NUMBER,
  target_date DATE,
  update_user_id VARCHAR2(30 BYTE),
  update_date DATE,
  CONSTRAINT rec_target_history_pk PRIMARY KEY (target_history_id)
);