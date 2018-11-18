WITH docs AS (
  SELECT * FROM document_1 UNION ALL
  SELECT * FROM document_2 UNION ALL
  SELECT * FROM document_3 UNION ALL
  SELECT * FROM document_4 UNION ALL
  SELECT * FROM document_5),
     num_docs AS (
  SELECT MAX(doc_num) FROM docs),
     num_quantity AS (
  SELECT d.doc_num, d.quantity
  FROM docs d WHERE d.word = 'must' AND d.word NOT IN (SELECT word FROM stop_words)),
     n AS (
  SELECT COUNT(*) AS number FROM num_quantity),
     max AS (
  SELECT MAX(quantity) FROM num_quantity),
     idf AS (
  SELECT LOG(2, (SELECT max FROM num_docs))::FLOAT -
         LOG(2, (SELECT number FROM n))::FLOAT
)
SELECT doc_num, (quantity /
  (SELECT max::FLOAT FROM max) * (SELECT * FROM idf)) AS tf_idf
FROM num_quantity UNION ALL
(SELECT doc_num, 0 AS tf_idf FROM docs EXCEPT SELECT doc_num, 0 AS tf_idf FROM num_quantity)
ORDER BY (doc_num);