DO $$
BEGIN
  PREPARE test_sql AS SELECT SUM(value) FROM part_table;
  FOR i IN 1..200 LOOP
    EXECUTE 'EXECUTE test_sql';
  END LOOP;
  DEALLOCATE test_sql;
END;
$$;