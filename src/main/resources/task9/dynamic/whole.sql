DO $$
BEGIN
  FOR i IN 1..200 LOOP
    EXECUTE 'SELECT SUM(value) FROM part_table';
  END LOOP;
END;
$$;