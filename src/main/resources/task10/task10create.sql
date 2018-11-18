CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS pg_freespacemap;

-- //

DROP TABLE IF EXISTS doc_gist;

CREATE TABLE doc_gist (
  doc     TEXT
);

DROP INDEX IF EXISTS gist_idx;

CREATE INDEX gist_idx ON doc_gist USING GIST (doc gist_trgm_ops);

-- //

DROP TABLE IF EXISTS doc_gin;

CREATE TABLE doc_gin (
  doc     TEXT
);

DROP INDEX IF EXISTS gin_idx;

CREATE INDEX gin_idx ON doc_gin USING GIN (doc gin_trgm_ops);

-- //

DROP TABLE IF EXISTS doc_b;

CREATE TABLE doc_b (
  doc TEXT
);

DROP INDEX IF EXISTS b_idx;

CREATE INDEX b_idx ON doc_b USING BTREE(doc text_pattern_ops);

-- pgbench -l --log-prefix= -f C:\Users\aaa\IdeaProjects\db\src\main\resources\task10\.sql -n -c 1 -T 60 -U postgres db