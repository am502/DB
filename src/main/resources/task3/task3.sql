DROP TABLE IF EXISTS graph;

CREATE TABLE graph (
  node_from VARCHAR,
  node_to   VARCHAR,
  cost      INT
);

INSERT INTO graph VALUES ('s', 'x', 5), ('s', 'u', 3), ('u', 'v', 6), ('u', 'x', 2), ('v', 'y', 2),
  ('y', 's', 3), ('y', 'v', 7), ('x', 'u', 1), ('x', 'v', 4), ('x', 'y', 6);

WITH RECURSIVE p (node_from, node_to, path_cost, path) AS
(
  SELECT
    node_from,
    node_to,
    cost                       AS path_cost,
    ARRAY [node_from, node_to] AS path
  FROM graph
  WHERE node_from = 's'
  UNION ALL
  SELECT
    graph.node_from,
    graph.node_to,
    graph.cost + p.path_cost AS path_cost,
    p.path || graph.node_to  AS path
  FROM graph
    INNER JOIN p ON graph.node_from = p.node_to AND graph.node_to <> ALL (p.path)
)
SELECT
  path_cost,
  path
FROM p
WHERE p.node_to = 'y';