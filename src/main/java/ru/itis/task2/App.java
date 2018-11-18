package ru.itis.task2;

import org.springframework.jdbc.core.JdbcTemplate;
import ru.itis.config.DataConfig;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;

public class App {
    private static final String GENOME_1 = "src/main/resources/task2/Genome_1.txt";
    private static final String GENOME_2 = "src/main/resources/task2/Genome_2.txt";

    private final static String SQL_INSERT_GENOME_1_K2 = "INSERT INTO genome_1_k2 VALUES ";
    private final static String SQL_INSERT_GENOME_2_K2 = "INSERT INTO genome_2_k2 VALUES ";

    private final static String SQL_INSERT_GENOME_1_K5 = "INSERT INTO genome_1_k5 VALUES ";
    private final static String SQL_INSERT_GENOME_2_K5 = "INSERT INTO genome_2_k5 VALUES ";

    private final static String SQL_INSERT_GENOME_1_K9 = "INSERT INTO genome_1_k9 VALUES ";
    private final static String SQL_INSERT_GENOME_2_K9 = "INSERT INTO genome_2_k9 VALUES ";

    public static void main(String[] args) {
        String genome1 = read(GENOME_1);
        String genome2 = read(GENOME_2);

        DataConfig dataConfig = new DataConfig();
        JdbcTemplate jdbcTemplate = dataConfig.jdbcTemplate();

        jdbcTemplate.update(SQL_INSERT_GENOME_1_K2 + getInsert(2, genome1));
        jdbcTemplate.update(SQL_INSERT_GENOME_2_K2 + getInsert(2, genome2));

        jdbcTemplate.update(SQL_INSERT_GENOME_1_K5 + getInsert(5, genome1));
        jdbcTemplate.update(SQL_INSERT_GENOME_2_K5 + getInsert(5, genome2));

        jdbcTemplate.update(SQL_INSERT_GENOME_1_K9 + getInsert(9, genome1));
        jdbcTemplate.update(SQL_INSERT_GENOME_2_K9 + getInsert(9, genome2));
    }

    public static String getInsert(int k, String genome) {
        StringBuilder stringBuilder = new StringBuilder();
        for (int i = 0; i < genome.length() - k + 1; i++) {
            stringBuilder.append("('");
            stringBuilder.append(genome.substring(i, i + k));
            stringBuilder.append("'), ");
        }
        return stringBuilder.toString().substring(0, stringBuilder.length() - 2);
    }

    public static String read(String path) {
        StringBuilder stringBuilder = new StringBuilder();
        try {
            BufferedReader br = new BufferedReader(
                    new InputStreamReader(
                            new FileInputStream(path), "Cp1251"));
            int c;
            while ((c = br.read()) != -1) {
                if ((char) c != '\n') {
                    stringBuilder.append((char) c);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return stringBuilder.toString();
    }
}
