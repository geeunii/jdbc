package jdbcEx01;

import java.io.FileInputStream;
import java.sql.*;

public class BoardInsertTest {
    public static void main(String[] args) {
        String DriverName = "com.mysql.cj.jdbc.Driver";
        String url = "jdbc:mysql://localhost:3306/bookmarketdb?serverTimezone=Asia/Seoul";
        String username = "root";
        String password = "mysql1234";

        try {
            Class.forName(DriverName);
            System.out.println("Driver loaded Success!");
        } catch (Exception e) {
            System.out.println("Driver loaded failed!");
        }

        try (Connection connection = DriverManager.getConnection(url, username, password)) { // 도로 연결
            System.out.println("AutoCommit 상태 : " + connection.getAutoCommit());
            connection.setAutoCommit(true);

            // 매개변수화 된 SQL 문
            String sql = "INSERT INTO boards(btitle, bcontent, bwriter, bdate, bfilename, bfiledata) values (?, ?, ?, now(), ?, ?)";

            // PreparedStatement 얻기
            PreparedStatement preparedStatement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            // 값 지정
            preparedStatement.setString(1, "봄");
            preparedStatement.setString(2, "봄 사진 입니다.");
            preparedStatement.setString(3, "아카자");
            preparedStatement.setString(4, "spring.jpg");
            preparedStatement.setBlob(5, new FileInputStream("Temp/spring.jpg")); // 대용량 첨부 데이터 타입

            // SQL 문 실행
            int result = preparedStatement.executeUpdate();
            System.out.println("저장된 행의 수 " + result);

            // bno 값 얻기
            if (result == 1) {
                ResultSet resultSet = preparedStatement.getGeneratedKeys();
                if (resultSet.next()) {
                    int bno = resultSet.getInt(1);
                    System.out.println("bno = " + bno);
                }
                resultSet.close();
            }

            if (result == 1) {
                System.out.println("INSERT Success!");
            }
        } catch (Exception e) {
            System.out.println("Connection established!" + e);
        }
    }
}
