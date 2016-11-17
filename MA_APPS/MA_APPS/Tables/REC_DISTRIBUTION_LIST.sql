CREATE TABLE ma_apps.rec_distribution_list (
  distribution_id NUMBER NOT NULL,
  email VARCHAR2(500 BYTE),
  exec_list VARCHAR2(1 BYTE),
  PRIMARY KEY (distribution_id)
);