SET ENABLE_SEQSCAN = OFF;

EXPLAIN ANALYZE VERBOSE SELECT *
                        FROM doc_gist
                        WHERE doc LIKE '%cold%';

EXPLAIN ANALYZE VERBOSE SELECT *
                        FROM doc_gin
                        WHERE doc LIKE '%cold%';

EXPLAIN ANALYZE VERBOSE SELECT *
                        FROM doc_b
                        WHERE doc LIKE '%cold%';

SELECT
  blkno                                    AS "Page Number",
  pg_size_pretty(avail :: BIGINT)          AS "Available space",
  pg_size_pretty((8192 - avail) :: BIGINT) AS "Used space"
FROM pg_freespace('gist_idx');

SELECT
  blkno                                    AS "Page Number",
  pg_size_pretty(avail :: BIGINT)          AS "Available space",
  pg_size_pretty((8192 - avail) :: BIGINT) AS "Used space"
FROM pg_freespace('gin_idx');

SELECT
  blkno                                    AS "Page Number",
  pg_size_pretty(avail :: BIGINT)          AS "Available space",
  pg_size_pretty((8192 - avail) :: BIGINT) AS "Used space"
FROM pg_freespace('b_idx');

SELECT
  pg_relation_filenode(oid),
  pg_relation_filepath(oid),
  pg_size_pretty(pg_total_relation_size(oid)),
  relfilenode,
  relpages,
  relname
FROM pg_class
WHERE relname = 'gist_idx';

SELECT
  pg_relation_filenode(oid),
  pg_relation_filepath(oid),
  pg_size_pretty(pg_total_relation_size(oid)),
  relfilenode,
  relpages,
  relname
FROM pg_class
WHERE relname = 'gin_idx';

SELECT
  pg_relation_filenode(oid),
  pg_relation_filepath(oid),
  pg_size_pretty(pg_total_relation_size(oid)),
  relfilenode,
  relpages,
  relname
FROM pg_class
WHERE relname = 'b_idx';