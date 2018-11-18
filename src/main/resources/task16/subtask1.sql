DROP TABLE IF EXISTS origin_table;

CREATE TABLE origin_table (
  A INT,
  B INT,
  C INT
);

DROP TABLE IF EXISTS log_table;

CREATE TABLE log_table (
  time TIMESTAMP,
  operation VARCHAR,
  username VARCHAR,
  old_data VARCHAR,
  new_data VARCHAR
);

DROP TABLE IF EXISTS gather_log_table;

CREATE TABLE gather_log_table (
  time TIMESTAMP,
  operation VARCHAR,
  username VARCHAR,
  old_data VARCHAR,
  new_data VARCHAR
);

CREATE OR REPLACE FUNCTION log_table_fnc()
  RETURNS TRIGGER AS
$BODY$
BEGIN
  IF (TG_OP = 'DELETE') THEN
    INSERT INTO log_table VALUES (NOW(), TG_OP, SESSION_USER, ROW(OLD.*), NULL);
    RETURN OLD;
  ELSEIF (TG_OP = 'UPDATE') THEN
    INSERT INTO log_table VALUES (NOW(), TG_OP, SESSION_USER, ROW(OLD.*), ROW(NEW.*));
    RETURN NEW;
  ELSEIF (TG_OP = 'INSERT') THEN
    INSERT INTO log_table VALUES (NOW(), TG_OP, SESSION_USER, NULL, ROW(NEW.*));
    RETURN NEW;
  END IF;
  RETURN NULL;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER log_trg
  BEFORE INSERT OR UPDATE OR DELETE
  ON origin_table
  FOR EACH ROW
  EXECUTE PROCEDURE log_table_fnc();