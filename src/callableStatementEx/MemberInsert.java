package callableStatementEx;

import util.DBUtil;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;

public class MemberInsert {

    static Connection connection = DBUtil.getConnection(); // static main 에서는 호출 불가능.

    public static void main(String[] args) {

        String m_userid = "Ronaldo7777";
        String m_pwd = "siu";
        String m_email = "siu1234@gmail.com";
        String m_hp = "010-7777-7777";
        String resultString = null;

        String sql = "{CALL SP_MEMBER_INSERT(?, ?, ?, ?, ?)}";

        try (CallableStatement callableStatement = connection.prepareCall(sql)) {
            // IN PARAMETER 세팅
            callableStatement.setString(1, m_userid);
            callableStatement.setString(2, m_pwd);
            callableStatement.setString(3, m_email);
            callableStatement.setString(4, m_hp);

            // OUT PARAMETER 세팅
            callableStatement.registerOutParameter(5, Types.INTEGER);

            // 실행
            callableStatement.execute();

            // 받아내기
            int rtn = callableStatement.getInt(5);

            if (rtn == 100) {
                // connection.rollback();
                System.out.println("이미 가입된 사용자입니다.");
            } else {
                // connection.commit();
                System.out.println("회원 가입이 되었습니다.");
            }
        } catch (SQLException e) {
//            try{
//                connection.rollback();
//            } catch (SQLException ex) {
//                ex.printStackTrace();
//            }
        }
    }
}
