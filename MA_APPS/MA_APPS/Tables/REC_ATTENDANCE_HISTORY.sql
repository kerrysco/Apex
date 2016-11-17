CREATE TABLE ma_apps.rec_attendance_history (
  owner_id NUMBER NOT NULL,
  attendance_date DATE NOT NULL,
  attended VARCHAR2(1 BYTE),
  CONSTRAINT rec_attendance_history_pk PRIMARY KEY (owner_id,attendance_date)
);