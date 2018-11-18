DROP TABLE IF EXISTS m_table;

CREATE TABLE m_table (
  id BIGSERIAL,
  type_info INT,
  name VARCHAR,
  PRIMARY KEY (id)
);

ALTER TABLE m_table ADD CONSTRAINT type_info_check
  CHECK (type_info >= 1 AND  type_info <= 15);

CREATE OR REPLACE FUNCTION fnc_child()
  RETURNS TRIGGER AS
$BODY$
DECLARE
  master_table VARCHAR := 'm_table';
  child_table VARCHAR;
BEGIN
  child_table := master_table || '_child_' || NEW.type_info;
  IF NOT EXISTS(SELECT 1 FROM pg_class WHERE relname = child_table) THEN
    EXECUTE 'CREATE TABLE ' || child_table || ' (LIKE ' || master_table || ' INCLUDING ALL) INHERITS ('
      || master_table || ')';
  END IF;
  EXECUTE 'INSERT INTO ' || child_table || ' (type_info, name) VALUES (' ||
    NEW.type_info || ', ''' || NEW.name || ''');';
  RETURN NULL;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER trg_child
  BEFORE INSERT
  ON m_table
  FOR EACH ROW
  EXECUTE PROCEDURE fnc_child();