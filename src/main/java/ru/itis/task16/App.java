package ru.itis.task16;

import org.springframework.jdbc.core.JdbcTemplate;
import ru.itis.config.DataConfig;

public class App {
    private final static String SQL_INSERT = "INSERT INTO gather_log_table " +
            "SELECT * FROM log_table";
    private final static String SQL_TRUNCATE = "TRUNCATE log_table";

    public static void main(String[] args) {
        // Sync every 5 mins
        while (true) {
            try {
                Thread.sleep(5 * 60 * 1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            DataConfig dataConfig = new DataConfig();
            JdbcTemplate jdbcTemplate = dataConfig.jdbcTemplate();

            jdbcTemplate.update(SQL_INSERT);

            jdbcTemplate.update(SQL_TRUNCATE);

            System.out.println("Sync");
        }
    }
}
