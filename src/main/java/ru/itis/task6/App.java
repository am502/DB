package ru.itis.task6;

import org.springframework.jdbc.core.JdbcTemplate;
import ru.itis.config.DataConfig;

public class App {
    private final static String SQL_INSERT = "INSERT INTO simple_table VALUES ";
    private final static String SQL_UPDATE = "UPDATE simple_table SET name = 'b' WHERE id = 1";
    private final static String SQL_DELETE = "DELETE FROM simple_table WHERE id = 2";
    private final static String SQL_SIZE = "SELECT pg_size_pretty(pg_total_relation_size(oid)) " +
            "FROM pg_class WHERE relname = 'simple_table'";
    private final static String SQL_VACUUM = "VACUUM simple_table";
    private final static String SQL_VACUUM_FULL = "VACUUM FULL simple_table";

    public static void main(String[] args) {
        DataConfig dataConfig = new DataConfig();
        JdbcTemplate jdbcTemplate = dataConfig.jdbcTemplate();

        System.out.println("2) " + jdbcTemplate.queryForObject(SQL_SIZE, String.class));

        jdbcTemplate.update(SQL_INSERT + getInsert(1, 1000000));
        jdbcTemplate.update(SQL_INSERT + getInsert(1, 1000000));
        jdbcTemplate.update(SQL_INSERT + getInsert(1, 1000000));
        jdbcTemplate.update(SQL_INSERT + getInsert(1, 1000000));
        jdbcTemplate.update(SQL_INSERT + getInsert(2, 1000000));

        System.out.println("4) " + jdbcTemplate.queryForObject(SQL_SIZE, String.class));

        jdbcTemplate.update(SQL_UPDATE);

        System.out.println("6) " + jdbcTemplate.queryForObject(SQL_SIZE, String.class));

        jdbcTemplate.update(SQL_DELETE);

        System.out.println("8) " + jdbcTemplate.queryForObject(SQL_SIZE, String.class));

        jdbcTemplate.update(SQL_VACUUM);

        System.out.println("10) " + jdbcTemplate.queryForObject(SQL_SIZE, String.class));

        jdbcTemplate.update(SQL_VACUUM_FULL);

        System.out.println("12) " + jdbcTemplate.queryForObject(SQL_SIZE, String.class));
    }

    public static String getInsert(int id, long count) {
        StringBuilder stringBuilder = new StringBuilder();
        for (int i = 0; i < count; i++) {
            stringBuilder.append("(");
            stringBuilder.append(id);
            stringBuilder.append(", '");
            stringBuilder.append('a');
            stringBuilder.append("'), ");
        }
        return stringBuilder.toString().substring(0, stringBuilder.length() - 2);
    }
}
