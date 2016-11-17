CREATE TABLE ma_apps.rec_jobs (
  job_id NUMBER NOT NULL,
  job_name VARCHAR2(1000 BYTE) NOT NULL,
  customer_id NUMBER,
  owner_id NUMBER,
  description VARCHAR2(1000 BYTE),
  message VARCHAR2(256 BYTE),
  CONSTRAINT rec_jobs_pk PRIMARY KEY (job_id),
  CONSTRAINT rec_jobs_uk UNIQUE (job_name),
  CONSTRAINT rec_jobs_fk1 FOREIGN KEY (customer_id) REFERENCES ma_apps.rec_customers (customer_id),
  CONSTRAINT rec_jobs_fk2 FOREIGN KEY (owner_id) REFERENCES ma_apps.rec_issue_owner (owner_id)
);