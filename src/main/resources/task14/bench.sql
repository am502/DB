SET ENABLE_SEQSCAN = FALSE;

SELECT A, B, C FROM s_table
GROUP BY CUBE (A, B, C)
ORDER BY A, B, C;