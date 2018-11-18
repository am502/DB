package ru.itis.task4;

import org.springframework.jdbc.core.JdbcTemplate;
import ru.itis.config.DataConfig;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;

public class App {
    private static final String DOCUMENT_1 = "src/main/resources/task4/Document_1.txt";
    private static final String DOCUMENT_2 = "src/main/resources/task4/Document_2.txt";
    private static final String DOCUMENT_3 = "src/main/resources/task4/Document_3.txt";
    private static final String DOCUMENT_4 = "src/main/resources/task4/Document_4.txt";
    private static final String DOCUMENT_5 = "src/main/resources/task4/Document_5.txt";

    private static final String STOP_WORDS = "src/main/resources/task4/stop_words.txt";

    private final static String SQL_INSERT_DOCUMENT_1 = "INSERT INTO document_1 VALUES ";
    private final static String SQL_INSERT_DOCUMENT_2 = "INSERT INTO document_2 VALUES ";
    private final static String SQL_INSERT_DOCUMENT_3 = "INSERT INTO document_3 VALUES ";
    private final static String SQL_INSERT_DOCUMENT_4 = "INSERT INTO document_4 VALUES ";
    private final static String SQL_INSERT_DOCUMENT_5 = "INSERT INTO document_5 VALUES ";

    public static void main(String[] args) {
        HashMap<String, Integer> map1 = read(DOCUMENT_1);
        HashMap<String, Integer> map2 = read(DOCUMENT_2);
        HashMap<String, Integer> map3 = read(DOCUMENT_3);
        HashMap<String, Integer> map4 = read(DOCUMENT_4);
        HashMap<String, Integer> map5 = read(DOCUMENT_5);

        DataConfig dataConfig = new DataConfig();
        JdbcTemplate jdbcTemplate = dataConfig.jdbcTemplate();

        jdbcTemplate.update(SQL_INSERT_DOCUMENT_1 + getInsert(map1, 1));
        jdbcTemplate.update(SQL_INSERT_DOCUMENT_2 + getInsert(map2, 2));
        jdbcTemplate.update(SQL_INSERT_DOCUMENT_3 + getInsert(map3, 3));
        jdbcTemplate.update(SQL_INSERT_DOCUMENT_4 + getInsert(map4, 4));
        jdbcTemplate.update(SQL_INSERT_DOCUMENT_5 + getInsert(map5, 5));
    }

    public static String getInsert(HashMap<String, Integer> map, int num) {
        StringBuilder stringBuilder = new StringBuilder();
        for(Map.Entry<String, Integer> entry : map.entrySet()) {
            stringBuilder.append("(");
            stringBuilder.append(num);
            stringBuilder.append(", ");
            stringBuilder.append("'");
            stringBuilder.append(entry.getKey());
            stringBuilder.append("', ");
            stringBuilder.append(entry.getValue());
            stringBuilder.append("), ");
        }
        return stringBuilder.toString().substring(0, stringBuilder.length() - 2);
    }

    public static HashMap<String, Integer> read(String path) {
        HashSet<String> stopWordSet = new HashSet<>();
        try {
            BufferedReader br = new BufferedReader(
                    new InputStreamReader(
                            new FileInputStream(STOP_WORDS)));
            int c;
            StringBuilder stopWord = new StringBuilder();
            while ((c = br.read()) != -1) {
                char cur = (char) c;
                if ((cur >= 'a' && cur <= 'z') || (cur >= 'A' && cur <= 'Z')) {
                    stopWord.append(cur);
                } else if (stopWord.length() > 0) {
                    stopWordSet.add(stopWord.toString());
                    stopWord = new StringBuilder();
                }
            }
            stopWordSet.add(stopWord.toString());
        } catch (IOException e) {
            e.printStackTrace();
        }

        HashMap<String, Integer> map = new HashMap<>();
        try {
            BufferedReader br = new BufferedReader(
                    new InputStreamReader(
                            new FileInputStream(path)));
            int c;
            StringBuilder word = new StringBuilder();
            while ((c = br.read()) != -1) {
                char cur = (char) c;
                if ((cur >= 'a' && cur <= 'z') || (cur >= 'A' && cur <= 'Z')) {
                    word.append(cur);
                } else if (word.length() > 0) {
                    String curWord = word.toString().toLowerCase();
                    if (!stopWordSet.contains(curWord)) {
                        if (map.containsKey(curWord)) {
                            map.put(curWord, map.get(curWord) + 1);
                        } else {
                            map.put(curWord, 1);
                        }
                    }
                    word = new StringBuilder();
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return map;
    }
}
