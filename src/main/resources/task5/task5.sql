WITH toast_1 AS (
  SELECT relname, relpages
  FROM pg_class,
  (SELECT reltoastrelid
  FROM pg_class
  WHERE relname = 'test_1') AS ss
  WHERE oid = ss.reltoastrelid OR
  oid = (SELECT indexrelid
    FROM pg_index
    WHERE indrelid = ss.reltoastrelid)
  ORDER BY relname LIMIT 1),
    toast_2 AS (
  SELECT relname, relpages
  FROM pg_class,
  (SELECT reltoastrelid
  FROM pg_class
  WHERE relname = 'test_2') AS ss
  WHERE oid = ss.reltoastrelid OR
  oid = (SELECT indexrelid
    FROM pg_index
    WHERE indrelid = ss.reltoastrelid)
  ORDER BY relname LIMIT 1),
    uni AS(
  SELECT * FROM toast_1 UNION ALL
  SELECT * FROM toast_2),
    toast_infos AS (
  SELECT pg_relation_filenode(oid),
    pg_relation_filepath(oid),
    pg_size_pretty(pg_total_relation_size(oid)),
    relfilenode,
    pg_class.relpages,
    pg_class.relname
  FROM pg_class, uni
  WHERE pg_class.relname IN (uni.relname)),
    test_1_header AS (
  SELECT 'test_1' AS table, *
  FROM page_header(get_raw_page('public.test_1', 0))),
    test_2_header AS (
  SELECT 'test_2' AS table, *
  FROM page_header(get_raw_page('public.test_2', 0))),
    uni_header AS (
  SELECT * FROM test_1_header UNION ALL
  SELECT * FROM test_2_header),
    test_1_item_page_header AS (
  SELECT *
  FROM heap_page_items(get_raw_page('public.test_1', 0))),
    test_2_item_page_header AS (
  SELECT *
  FROM heap_page_items(get_raw_page('public.test_2', 0))),
    uni_item_page_header AS (
  SELECT 'test_1' AS table, * FROM test_1_item_page_header UNION ALL
  SELECT 'test_2' AS table, * FROM test_2_item_page_header),
    test_1_size AS (
  SELECT 'test_1' AS table, blkno AS "Page Number",
    pg_size_pretty(avail::BIGINT) AS "Available space",
    pg_size_pretty((8192 - avail)::BIGINT) AS "Used space"
  FROM pg_freespace('test_1')),
    test_2_size AS (
  SELECT 'test_2' AS table, blkno AS "Page Number",
    pg_size_pretty(avail::BIGINT) AS "Available space",
    pg_size_pretty((8192 - avail)::BIGINT) AS "Used space"
  FROM pg_freespace('test_2')),
    uni_test_size AS (
  SELECT * FROM test_1_size UNION ALL
  SELECT * FROM test_2_size
)
SELECT * FROM uni_test_size;



