DROP TABLE IF EXISTS table15;

CREATE TABLE table15 (
  A INT,
  B INT
);

INSERT INTO table15(A, B)
  SELECT random() * 100, random() * 100 FROM generate_series(1, 1000);

DROP FUNCTION IF EXISTS get1;

CREATE FUNCTION get1()
  RETURNS TABLE (_A INT, _B INT)
AS $$
  SELECT A, B FROM table15;
$$ LANGUAGE SQL;

DROP FUNCTION IF EXISTS get2;

CREATE FUNCTION get2()
  RETURNS TABLE (_A INT, _B INT)
AS $$
BEGIN
  RETURN QUERY
    SELECT A, B FROM table15;
END;
$$ LANGUAGE plpgsql;

-- pgbench -l --log-prefix=benchoriginal -f C:\Users\aaa\IdeaProjects\db\src\main\resources\task15\benchoriginal.sql -n -T 30 -U postgres db

-- pgbench -l --log-prefix=benchplpgsql -f C:\Users\aaa\IdeaProjects\db\src\main\resources\task15\benchplpgsql.sql -n -T 30 -U postgres db

-- pgbench -l --log-prefix=benchsql -f C:\Users\aaa\IdeaProjects\db\src\main\resources\task15\benchsql.sql -n -T 30 -U postgres db