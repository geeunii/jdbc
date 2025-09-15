package callableStatementEx;

import util.DBUtil;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MemberDAO {

    static Connection connection = DBUtil.getConnection();
    static List<Member> members = new ArrayList<>();
    private static BufferedReader br = new BufferedReader(new InputStreamReader(System.in));

    public static void main(String[] args) {

        MemberInsert();
    }


    public static void MemberInsert() {

        try {
            String m_userid = br.readLine();
            String m_pwd = br.readLine();
            String m_email = br.readLine();
            String m_hp = br.readLine();

            String sql = "{CALL SP_MEMBER_INSERT(?, ?, ?, ?, ?)}";

            try (CallableStatement callableStatement = connection.prepareCall(sql)) {
                // IN PARAMETER SET
                callableStatement.setString(1, m_userid);
                callableStatement.setString(2, m_pwd);
                callableStatement.setString(3, m_email);
                callableStatement.setString(4, m_hp);

                // OUT PARAMETER SET
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
                e.printStackTrace();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static List<Member> memberList() {

        String sql = "CALL SP_NUMBER_LIST()";

        try (CallableStatement callableStatement = connection.prepareCall(sql)) {
            ResultSet resultSet =callableStatement.executeQuery();

            if (resultSet != null) {
                while (resultSet.next()) {
                    Member member = new Member();

                    int seq = resultSet.getInt("m_seq");
                    String userid = resultSet.getString("m_userid");
                    String pwd = resultSet.getString("m_pwd");
                    String email = resultSet.getString("m_email");
                    String hp = resultSet.getString("m_hp");


                    member.setM_seq(seq);
                    member.setM_userid(userid);
                    member.setM_pwd(pwd);
                    member.setM_email(email);
                    member.setM_hp(hp);

                    members.add(member);
                }
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return members;
    }

}
