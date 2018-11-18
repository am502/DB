DROP TABLE IF EXISTS a;
DROP TABLE IF EXISTS b;

CREATE TABLE a (
  letter CHAR
);
CREATE TABLE b (
  letter CHAR
);

INSERT INTO a VALUES ('a'), ('a'), ('a'), ('b');
INSERT INTO b VALUES ('a'), ('a'), ('b'), ('b'), ('c');

WITH one AS (
  SELECT letter
  FROM a INTERSECT ALL SELECT letter
                       FROM b),
    two AS (
    SELECT letter
    FROM a
    UNION ALL SELECT letter
              FROM b
  )
SELECT (SELECT CAST(COUNT(*) AS FLOAT)
        FROM one) /
       (SELECT CAST(COUNT(*) AS FLOAT)
        FROM two);