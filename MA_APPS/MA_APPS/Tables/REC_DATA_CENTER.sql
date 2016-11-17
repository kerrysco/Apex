CREATE TABLE ma_apps.rec_data_center (
  data_center_id NUMBER NOT NULL,
  data_center_status_id NUMBER NOT NULL,
  data_center_area VARCHAR2(200 BYTE),
  data_center_desc VARCHAR2(4000 BYTE),
  PRIMARY KEY (data_center_id),
  FOREIGN KEY (data_center_status_id) REFERENCES ma_apps.rec_data_center_status (data_center_status_id)
);