package jdbc_boards.model;

import jdbc_boards.vo.Board;
import lombok.Data;
import util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Data
public class BoardDAO {

    // 굳이 클래스의 변수를 안만들어도 됨.
    // 메소드 안에서 만들고 쓰고 버리기.
    private List<Board> boardList = new ArrayList<>();
    private Connection connection;

    public boolean createBoard(Board board) {
        connection = DBUtil.getConnection(); // 연결

        String sql = "insert into boardTable(btitle, bcontent, bwriter, bdate) values (? ,? , ?, now())";

        try (PreparedStatement preparedStatement = connection.prepareStatement(sql, PreparedStatement.NO_GENERATED_KEYS)) {

            preparedStatement.setString(1, board.getBtitle());
            preparedStatement.setString(2, board.getBcontent());
            preparedStatement.setString(3, board.getBwriter());

            int affected = preparedStatement.executeUpdate();
            boolean flag = affected > 0;

            if (flag) {
                try (ResultSet resultSet = preparedStatement.getGeneratedKeys()) {

                    if (resultSet.next()) {
                        int newBno = resultSet.getInt(1);
                        board.setBno(newBno);
                        boardList.add(board);
                    }
                }
            }
            return flag;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;

        }
    }

    public boolean updateBoard(Board board) {
        connection = DBUtil.getConnection(); // 1. 단 연결

        String sql = "UPDATE boardTable SET btitle = ?, bcontent = ? WHERE bno = ?";

        try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                preparedStatement.setString(1, board.getBtitle());
                preparedStatement.setString(2, board.getBcontent());
                preparedStatement.setInt(3, board.getBno());

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteBoard(int bno) {
        connection = DBUtil.getConnection();

        String sql = "DELETE FROM boardTable WHERE bno = ?";

        try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, bno);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Board> selectAll() {
        // ArrayList<Board> boardList = new ArrayList<>();
        connection = DBUtil.getConnection(); // 연결

        String sql = "select * from boardTable ORDER BY bno DESC ";

        try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                Board board = new Board();
                board.setBno(resultSet.getInt("bno"));
                board.setBtitle(resultSet.getString("btitle"));
                board.setBcontent(resultSet.getString("bcontent"));
                board.setBwriter(resultSet.getString("bwriter"));
                board.setBdate(resultSet.getDate("bdate"));

                boardList.add(board);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return boardList;
    }

    // bno 를 인자값 넣어서 Board 반환. -> selectOne
    public Board selectOne(int bno) {
        connection = DBUtil.getConnection(); // 연결

        String sql = "select * from BoardTable where bno = ?";

        try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, bno);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    Board board = new Board();
                    board.setBno(resultSet.getInt("bno"));
                    board.setBtitle(resultSet.getString("btitle"));
                    board.setBcontent(resultSet.getString("bcontent"));
                    board.setBwriter(resultSet.getString("bwriter"));
                    board.setBdate(resultSet.getDate("bdate"));
                    return board;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
}