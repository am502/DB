SET ENABLE_SEQSCAN = OFF;
SELECT * FROM doc_gist WHERE doc LIKE (SELECT md5(random()::text));