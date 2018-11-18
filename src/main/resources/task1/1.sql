DROP TABLE IF EXISTS a;
DROP TABLE IF EXISTS b;

CREATE TABLE a (
  letter CHAR
);
CREATE TABLE b (
  letter CHAR
);

INSERT INTO a VALUES ('a'), ('b'), ('c'), ('d'), ('e');
INSERT INTO b VALUES ('c'), ('d'), ('e'), ('f'), ('g'), ('h');

SELECT (SELECT CAST(COUNT(*) AS FLOAT)
        FROM (SELECT letter
              FROM a INTERSECT SELECT letter
                               FROM b) AS one) /
       (SELECT CAST(COUNT(*) AS FLOAT)
        FROM (SELECT letter
              FROM a
              UNION SELECT letter
                    FROM b) AS two) AS res;