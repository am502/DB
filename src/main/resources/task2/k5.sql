WITH g1_k5 AS (
  SELECT word
  FROM genome_1_k5 UNION
  SELECT word
  FROM genome_1_k5),
    g2_k5 AS (
  SELECT word
  FROM genome_2_k5 UNION
  SELECT word
  FROM genome_2_k5),
    one AS (
  SELECT word
  FROM g1_k5 INTERSECT
  SELECT word
  FROM g2_k5),
    two AS (
  SELECT word
  FROM g1_k5 UNION
  SELECT word
  FROM g2_k5
)
SELECT (SELECT CAST(COUNT(*) AS FLOAT)
        FROM one) /
       (SELECT CAST(COUNT(*) AS FLOAT)
        FROM two);