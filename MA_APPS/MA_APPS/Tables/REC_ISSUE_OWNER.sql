CREATE TABLE ma_apps.rec_issue_owner (
  owner_id NUMBER NOT NULL,
  owner_name VARCHAR2(100 BYTE),
  owner_deleted VARCHAR2(30 BYTE),
  owner_email VARCHAR2(100 BYTE),
  owner_type_id NUMBER,
  attended VARCHAR2(1 BYTE),
  loader VARCHAR2(1 BYTE) CONSTRAINT rec_issue_owner_ck1 CHECK (LOADER in ('Y','N')),
  PRIMARY KEY (owner_id),
  FOREIGN KEY (owner_type_id) REFERENCES ma_apps.rec_owner_type (owner_id)
);