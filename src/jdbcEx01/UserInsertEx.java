package jdbcEx01;

import java.sql.Connection;
import java.sql.DriverManager;

public class UserInsertEx {
    public static void main(String[] args) {
        Connection connection = null;
        try {
            // 1. DB의 드라이버를 찾아서 로드해야 한다. MySQL JDBC 드라이버 등록
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Driver loaded successfully!");

            // 2. 드라이버로드가 OK 라면, 연결 Connection 객체 생성
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/bookmarketdb?serverTimezone=Asia/Seoul", "root", "mysql1234");
            System.out.println("Connection established!" + connection);

            // 3. Connection 객체가 생성 되었다면, 쿼리문을 Statement 객체에 담아 DB 에게 전송한다.
            String sql = " insert into users(userid, username, userpassword, userage, useremail)" +
                    " values('10', 'Geuni', '1234', 20, 'geuni@gmail.com')";

            // 4. 전송한 결과를 받아서 처리한다.
            int result = connection.createStatement().executeUpdate(sql);
            if (result == 1) {
                System.out.println("Insert successful!");
            } else {
                System.out.println("Insert failed!");
            }
        } catch (Exception e) {
            System.out.println("Driver loaded failed!");
        } finally {
            // 5. 다 사용한 Statements 와 Connection 객체를 닫는다.
            if (connection != null) {
                try {
                    connection.close();
                    System.out.println("Connection closed!");
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
            }
        }


    }

}
