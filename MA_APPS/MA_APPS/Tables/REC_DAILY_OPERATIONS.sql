CREATE TABLE ma_apps.rec_daily_operations (
  daily_operations_id NUMBER NOT NULL,
  issue_status_id NUMBER NOT NULL,
  owner_id NUMBER,
  issue_type_id NUMBER,
  job_name VARCHAR2(1000 BYTE),
  reported_date DATE,
  target_date DATE,
  next_update DATE,
  closed_date DATE,
  request_close VARCHAR2(1 BYTE),
  PRIMARY KEY (daily_operations_id),
  CONSTRAINT fk_issue_status FOREIGN KEY (issue_status_id) REFERENCES ma_apps.rec_issue_status (issue_status_id),
  CONSTRAINT fk_issue_type FOREIGN KEY (issue_type_id) REFERENCES ma_apps.rec_issue_type (issue_type_id),
  CONSTRAINT fk_owner FOREIGN KEY (owner_id) REFERENCES ma_apps.rec_issue_owner (owner_id)
);