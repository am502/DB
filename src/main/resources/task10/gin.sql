SET ENABLE_SEQSCAN = OFF;
SELECT * FROM doc_gin WHERE doc LIKE (SELECT md5(random()::text));