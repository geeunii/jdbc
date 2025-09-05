package jdbcEx01;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class UserInsertTest {
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
            String sql = "INSERT INTO users(userid, username, userpassword, userage, useremail) values (?, ?, ?, ?, ?)";

            // PreparedStatement 얻기
            PreparedStatement preparedStatement = connection.prepareStatement(sql);

            // 값 지정
            preparedStatement.setInt(1, 999);
            preparedStatement.setString(2, "김형근");
            preparedStatement.setString(3, "qwer1234");
            preparedStatement.setInt(4, 66);
            preparedStatement.setString(5, "koo4934@gmail.com");

            // SQL 문 실행
            int result = preparedStatement.executeUpdate();
            System.out.println("저장된 행의 수 " + result);

            if (result == 1) {
                System.out.println("INSERT Success!");
            }
        } catch (Exception e) {
            System.out.println("Connection established!" + e);
        }
    }
}
