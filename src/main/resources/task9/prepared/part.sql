DO $$
BEGIN
  PREPARE test_sql(INT) AS SELECT SUM(value) FROM part_table WHERE part_no = $1;
  FOR i IN 1..200 LOOP
    EXECUTE 'EXECUTE test_sql(1)';
  END LOOP;
  DEALLOCATE test_sql;
END;
$$;