DROP TABLE IF EXISTS simple_table;

CREATE TABLE simple_table (
  id BIGINT,
  name VARCHAR
) WITH (AUTOVACUUM_ENABLED=false);