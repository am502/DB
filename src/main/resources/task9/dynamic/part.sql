DO $$
BEGIN
  FOR i IN 1..200 LOOP
    EXECUTE 'SELECT SUM(value) FROM part_table WHERE part_no = $1' USING 1;
  END LOOP;
END;
$$;