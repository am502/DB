DROP TABLE IF EXISTS s_table;

CREATE TABLE s_table (
  A INT,
  B INT,
  C INT
);

INSERT INTO s_table(A, B, C)
  SELECT random() * 500, random() * 500, random() * 500 FROM generate_series(1, 10000);

DROP INDEX IF EXISTS a_idx;
CREATE INDEX a_idx ON s_table USING BTREE(A);

DROP INDEX IF EXISTS b_idx;
CREATE INDEX b_idx ON s_table USING BTREE(B);

DROP INDEX IF EXISTS c_idx;
CREATE INDEX c_idx ON s_table USING BTREE(C);

DROP INDEX IF EXISTS a_b_idx;
CREATE INDEX a_b_idx ON s_table USING BTREE(A, B);
DROP INDEX IF EXISTS b_a_idx;
CREATE INDEX b_a_idx ON s_table USING BTREE(B, A);

DROP INDEX IF EXISTS a_c_idx;
CREATE INDEX a_c_idx ON s_table USING BTREE(A, C);
DROP INDEX IF EXISTS c_a_idx;
CREATE INDEX c_a_idx ON s_table USING BTREE(C, A);

DROP INDEX IF EXISTS b_c_idx;
CREATE INDEX b_c_idx ON s_table USING BTREE(B, C);
DROP INDEX IF EXISTS c_b_idx;
CREATE INDEX c_b_idx ON s_table USING BTREE(C, B);

DROP INDEX IF EXISTS a_b_c_idx;
CREATE INDEX a_b_c_idx ON s_table USING BTREE(A, B, C);

DROP INDEX IF EXISTS a_c_b_idx;
CREATE INDEX a_c_b_idx ON s_table USING BTREE(A, C, B);

DROP INDEX IF EXISTS b_a_c_idx;
CREATE INDEX b_a_c_idx ON s_table USING BTREE(B, A, C);

DROP INDEX IF EXISTS b_c_a_idx;
CREATE INDEX b_c_a_idx ON s_table USING BTREE(B, C, A);

DROP INDEX IF EXISTS c_a_b_idx;
CREATE INDEX c_a_b_idx ON s_table USING BTREE(C, A, B);

DROP INDEX IF EXISTS c_b_a_idx;
CREATE INDEX c_b_a_idx ON s_table USING BTREE(C, B, A);

-- pgbench -l --log-prefix=bench14 -f C:\Users\aaa\IdeaProjects\db\src\main\resources\task14\bench.sql -n -T 60 -U postgres db