SELECT
  relid :: REGCLASS                                        AS table,
  indexrelid :: REGCLASS                                   AS index,
  pg_size_pretty(pg_relation_size(indexrelid :: REGCLASS)) AS index_size,
  idx_tup_read,
  idx_tup_fetch,
  idx_scan
FROM pg_stat_user_indexes
  JOIN pg_index USING (indexrelid)
WHERE indisunique IS FALSE;