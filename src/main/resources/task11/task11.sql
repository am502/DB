DROP TABLE IF EXISTS stat_table;
CREATE TABLE stat_table (
  A INT,
  B INT,
  C INT
);

INSERT INTO stat_table(A, B, C)
    SELECT random() * 100, random() * 100, random() * 100 FROM generate_series(1, 100000);

EXPLAIN (ANALYZE)
  SELECT * FROM stat_table WHERE A < 30 AND B > 70
    AND C < 10;

EXPLAIN (ANALYZE)
  SELECT * FROM stat_table GROUP BY (A, B, C);

ALTER TABLE stat_table ALTER COLUMN A SET STATISTICS 500;
ALTER TABLE stat_table ALTER COLUMN B SET STATISTICS 500;
ALTER TABLE stat_table ALTER COLUMN C SET STATISTICS 500;

ANALYZE stat_table;

SELECT * FROM pg_stats WHERE tablename = 'stat_table' AND attname = 'a';
SELECT * FROM pg_stats WHERE tablename = 'stat_table' AND attname = 'b';
SELECT * FROM pg_stats WHERE tablename = 'stat_table' AND attname = 'c';

EXPLAIN (ANALYZE)
  SELECT * FROM stat_table WHERE A < 30 AND B > 70
    AND C < 10;

EXPLAIN (ANALYZE)
  SELECT * FROM stat_table GROUP BY (A, B, C);

-- CREATE STATISTICS my_stat (dependencies) ON a, b, c FROM stat_table;
ANALYZE stat_table;
SELECT * FROM pg_statistic_ext WHERE stxname = 'my_stat';

EXPLAIN (ANALYZE)
  SELECT * FROM stat_table WHERE A < 30 AND B > 70
    AND C < 10;

EXPLAIN (ANALYZE)
  SELECT * FROM stat_table GROUP BY (A, B, C);