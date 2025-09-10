package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ResourceBundle;

public class DBUtil {
    private static ResourceBundle bundle;

    static {
        bundle = ResourceBundle.getBundle("util.dbinfo");

        try {
            Class.forName(bundle.getString("driver"));
            System.out.println("드라이버 로딩 성공");
        } catch (ClassNotFoundException e) {
            System.out.println("드라이버 로딩 실패");
            e.printStackTrace();
        }
    }

    public static Connection getConnection() {

        try {
            return DriverManager.getConnection(
                    bundle.getString("url"),
                    bundle.getString("username"),
                    bundle.getString("password"));

        } catch (SQLException e) {
            System.out.println("연결 실패");
            e.printStackTrace();
        }
           return null;
    }
}
