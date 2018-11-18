SET ENABLE_SEQSCAN = OFF;
SELECT * FROM doc_b WHERE doc LIKE (SELECT md5(random()::text));