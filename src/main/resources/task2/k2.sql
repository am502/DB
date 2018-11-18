WITH g1_k2 AS (
  SELECT word
  FROM genome_1_k2 UNION
  SELECT word
  FROM genome_1_k2),
    g2_k2 AS (
  SELECT word
  FROM genome_2_k2 UNION
  SELECT word
  FROM genome_2_k2),
    one AS (
  SELECT word
  FROM g1_k2 INTERSECT
  SELECT word
  FROM g2_k2),
    two AS (
  SELECT word
  FROM g1_k2 UNION
  SELECT word
  FROM g2_k2
)
SELECT (SELECT CAST(COUNT(*) AS FLOAT)
        FROM one) /
       (SELECT CAST(COUNT(*) AS FLOAT)
        FROM two);