package ru.itis.task9;

import org.springframework.jdbc.core.JdbcTemplate;
import ru.itis.config.DataConfig;

public class App {
    private final static String SQL_INSERT = "INSERT INTO part_table VALUES ";
    private final static int PART = 100000;
    private final static int SIZE = 1000000;


    public static void main(String[] args) {
        int partCount = 1;
        StringBuilder sb = new StringBuilder();
        for (int i = 1; i <= SIZE; i++) {
            if (i > partCount * PART) {
                partCount++;
            }
            sb.append("(");
            sb.append(i);
            sb.append(", ");
            sb.append(partCount);
            sb.append(", ");
            sb.append(i + PART);
            sb.append("), ");
        }
        String insert = sb.toString().substring(0, sb.length() - 2);

        DataConfig dataConfig = new DataConfig();
        JdbcTemplate jdbcTemplate = dataConfig.jdbcTemplate();

        jdbcTemplate.update(SQL_INSERT + insert);
    }
}
