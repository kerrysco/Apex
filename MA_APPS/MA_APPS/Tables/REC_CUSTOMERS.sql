CREATE TABLE ma_apps.rec_customers (
  customer_id NUMBER NOT NULL,
  customer_name VARCHAR2(128 BYTE) NOT NULL,
  hem_id NUMBER,
  CONSTRAINT rec_customers_pk PRIMARY KEY (customer_id),
  CONSTRAINT rec_customers_uk UNIQUE (customer_name),
  CONSTRAINT rec_customers_fk1 FOREIGN KEY (hem_id) REFERENCES ma_apps.rec_hems (hem_id)
);