package ru.itis.task10;

import org.springframework.jdbc.core.JdbcTemplate;
import ru.itis.config.DataConfig;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;

public class App {
    private static final String DOC_GIST = "src/main/resources/task4/Document_1.txt";
    private static final String DOC_GIN = "src/main/resources/task4/Document_2.txt";
    private static final String DOC_B = "src/main/resources/task4/Document_3.txt";

    private final static String SQL_INSERT_DOC_GIST = "INSERT INTO doc_gist VALUES ";
    private final static String SQL_INSERT_DOC_GIN = "INSERT INTO doc_gin VALUES ";
    private final static String SQL_INSERT_DOC_B = "INSERT INTO doc_b VALUES ";

    public static void main(String[] args) {
        ArrayList<String> list1 = read(DOC_GIST);
        ArrayList<String> list2 = read(DOC_GIN);
        ArrayList<String> list3 = read(DOC_B);

        DataConfig dataConfig = new DataConfig();
        JdbcTemplate jdbcTemplate = dataConfig.jdbcTemplate();

        jdbcTemplate.update(SQL_INSERT_DOC_GIST + getInsert(list1));
        jdbcTemplate.update(SQL_INSERT_DOC_GIN + getInsert(list2));
        jdbcTemplate.update(SQL_INSERT_DOC_B + getInsert(list3));
    }

    public static ArrayList<String> read(String path) {
        ArrayList<String> list = new ArrayList<>();
        try {
            BufferedReader br = new BufferedReader(
                    new InputStreamReader(
                            new FileInputStream(path)));
            int c;
            StringBuilder str = new StringBuilder();
            while ((c = br.read()) != -1) {
                char cur = (char) c;
                str.append(cur);
                if (cur == '\n') {
                    if (str.length() > 1) {
                        list.add(str.toString());
                    }
                    str = new StringBuilder();
                }
            }
            if (str.length() > 1) {
                list.add(str.toString());
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return list;
    }

    public static String getInsert(ArrayList<String> list) {
        StringBuilder stringBuilder = new StringBuilder();
        for (int i = 0; i < list.size(); i++) {
            stringBuilder.append("('");
            stringBuilder.append(list.get(i));
            stringBuilder.append("'), ");
        }
        return stringBuilder.toString().substring(0, stringBuilder.length() - 2);
    }
}
