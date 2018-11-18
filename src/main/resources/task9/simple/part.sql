DO $$
DECLARE
  sum FLOAT;
BEGIN
  FOR i IN 1..200 LOOP
    SELECT SUM(value) FROM part_table WHERE part_no = 1 INTO sum;
  END LOOP;
END;
$$;