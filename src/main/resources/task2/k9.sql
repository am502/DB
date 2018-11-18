WITH g1_k9 AS (
  SELECT word
  FROM genome_1_k9 UNION
  SELECT word
  FROM genome_1_k9),
    g2_k9 AS (
  SELECT word
  FROM genome_2_k9 UNION
  SELECT word
  FROM genome_2_k9),
    one AS (
  SELECT word
  FROM g1_k9 INTERSECT
  SELECT word
  FROM g2_k9),
    two AS (
  SELECT word
  FROM g1_k9 UNION
  SELECT word
  FROM g2_k9
)
SELECT (SELECT CAST(COUNT(*) AS FLOAT)
        FROM one) /
       (SELECT CAST(COUNT(*) AS FLOAT)
        FROM two);