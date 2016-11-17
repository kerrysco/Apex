CREATE TABLE ma_apps.rec_issue_type (
  issue_type_id NUMBER NOT NULL,
  issue_type_name VARCHAR2(500 BYTE),
  report_order NUMBER,
  PRIMARY KEY (issue_type_id)
);