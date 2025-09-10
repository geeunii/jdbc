package jdbc_boards.Controller;

import jdbc_boards.model.BoardDAO;
import jdbc_boards.vo.Board;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;

public class BoardMenu {

    BoardDAO dao;
    BufferedReader input = new BufferedReader(new InputStreamReader(System.in));
    Board board = new Board();

    public BoardMenu() {
        dao = new BoardDAO();
    }

    public void boardMenu() throws IOException {
        System.out.println("""
                 메인 메뉴
                 1. 글 생성 | 2. 전체 글 읽어오기 | 3. 글 번호를 지정하여 읽어오기
                 4. 글 수정 | 5. 글 삭제 | 0. 종료 \s
                \s""");
        System.out.println("메뉴 선택: ");
        int choice = 0;
        try {
            choice = Integer.parseInt(input.readLine());
        } catch (IOException e) {
            System.out.println("입력도중 에러 발생");
        } catch (NumberFormatException e1) {
            System.out.println("숫자만 입력하라니까");
        } catch (Exception e2) {
            System.out.println("꿰엑 에라 모르겠다.");
        }
        switch (choice) {
            case 1:
                //사용자에게 title,content 를 입력받아서 Board 구성하여 createBoard()넘겨주자
                // 1. 글 생성
                Board row = boardDataInput();
                boolean ack = dao.createBoard(row);
                if (ack == true) System.out.println("글이 성공적으로 입력되었습니다.");
                else {
                    System.out.println("입력 실패, 다시 시도 부탁드립니다. ");
                    //원하는 위치로 이동
                }
                break;

            // 2. 전체 글 읽어오기
            case 2:
                boardDataRead();
                break;
            case 3:
                selectOne(board.getBno());
                break;
            case 4:
                updateBoard(board);
                break;
            case 5:
                deleteBoard(board.getBno());
                break;
            case 6:
                System.out.println("종료 합니다.");
                break;
        }

    }

    public Board boardDataInput() throws IOException {
        System.out.println("새로운 글 입력");
        System.out.println("제목 입력");
        String title = input.readLine();
        board.setBtitle(title);
        System.out.println("내용 입력");
        String content = input.readLine();
        board.setBcontent(content);
        return board;
    }

    public List<Board> boardDataRead() {
        System.out.println("전체 글을 읽어옵니다.");

        return dao.selectAll();
    }

    public Board selectOne(int bno) {
        System.out.println(" 해당글을 읽어옵니다.");

        return dao.selectOne(bno);
    }

    public boolean updateBoard(Board board) {
        System.out.println("해당 글을 수정합니다.");

        return dao.updateBoard(board);
    }

    public boolean deleteBoard(int bno) {
        System.out.println("해당 글을 삭제합니다");

        return dao.deleteBoard(bno);
    }
}
