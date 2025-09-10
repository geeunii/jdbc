package jdbcEx01;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class UserInsertTest {
    public static void main(String[] args) {
      String DriverName ="com.mysql.cj.jdbc.Driver";
      String url = "jdbc:mysql://localhost:3306/bookmarketdb?serverTimezone=Asia/Seoul";
      String username = "root";
      String password = "mysql1234";



      try{
          Class.forName(DriverName);
          System.out.println("Driver loaded OK!");
      } catch (Exception e) {
          System.out.println("Driver loaded failed!");
      }
      try(Connection con = DriverManager.getConnection(url, username, password)){  //도로연결
          System.out.println("AutoCommit 상태: " + con.getAutoCommit());
          con.setAutoCommit(true);

          // 매개변수화된 SQL문
          String sql = "INSERT INTO users(userid,username,userpassword,userage,useremail) values(?,?,?,?,?)";

          //PreparedStatement 얻기
          PreparedStatement pstmt = con.prepareStatement(sql);

          //값 지정
          pstmt.setString(1, "test01");
          pstmt.setString(2,"신호동");
          pstmt.setString(3,"123456");
          pstmt.setInt(4,20);
          pstmt.setString(5,"test@gmail.com");

          //SQL문 실행
          int result = pstmt.executeUpdate();
          System.out.println("저장된 행의 수" + result);



          if (result == 1) {
              System.out.println("Insert successful!");
          }


      } catch (Exception e) {
          System.out.println("Connection established!" + e);
      }

    }
}
