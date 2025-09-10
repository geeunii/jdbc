package jdbcEx01;

import jdbcEx01.vo.Person;
import util.DBUtil;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class ConnectionDBUtilTest {
    public static void main(String[] args) {
        try {
            Connection con = DBUtil.getConnection();  //도로연결

            Statement stmt = con.createStatement();   //자동차
            int result = stmt.executeUpdate("INSERT INTO person(id,name) values(1000000,'홍길동11')");
            if (result == 1) {
                System.out.println("Insert successful!");
            }


            String selectSql = "select id, name from person";
            ResultSet rs = stmt.executeQuery(selectSql);
            while(rs.next()) {
                Person person = new Person();
                person.setId(rs.getInt(1));
                person.setName(rs.getString(2));
                System.out.println(person.toString());
            }

        } catch (Exception e) {
            System.out.println("Connection established!" + e);
        }

    }
}
