package jdbc_boards.Controller;

import jdbc_boards.model.BoardDAO;
import jdbc_boards.vo.Board;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Objects;

/**
 * Board 메뉴
 * - 1. 글쓰기
 * - 2. 전체목록
 * - 3. 상세조회
 * - 4. 수정
 * - 5. 삭제
 * - 0. 종료
 * *
 * * BoardMain 에서 new BoardMenu() 만 호출해도 전체 기능이 동작하도록
 * * 생성자에서 run() 을 바로 실행합니다.
 */
public class BoardMenu {

    private final BoardDAO dao;
    private final BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
    private final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    public BoardMenu() {
        this.dao = new BoardDAO();
        run();
    }

    private void run() {
        println("\n==== 게시판 ====");
        while (true) {
            try {
                showMenu();
                String sel = read("메뉴 선택: ");
                switch (sel) {
                    case "1" -> write();
                    case "2" -> list();
                    case "3" -> view();
                    case "4" -> edit();
                    case "5" -> remove();
                    case "0" -> {
                        println("종료합니다.");
                        return;
                    }
                    default -> println("메뉴를 다시 선택하세요.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                println("오류가 발생했습니다: " + e.getMessage());
            }
        }
    }

    private void showMenu() {
        println("");
        println("1. 글쓰기");
        println("2. 전체목록");
        println("3. 상세조회");
        println("4. 수정");
        println("5. 삭제");
        println("0. 종료");
    }

    private void write() throws IOException {
        println("\n[글쓰기]");
        Board board = new Board();
        board.setBtitle(readRequired("제목: "));
        board.setBcontent(readRequired("내용: "));
        board.setBwriter(readRequired("작성자: "));

        boolean rows = dao.createBoard(board);
        if (rows == true) {
            println("등록 성공! 글번호=" + board.getBno());
        } else {
            println("등록 실패");
        }
    }

    private void list() {
        println("\n[전체목록]");
        List<Board> all = dao.selectAll();
        if (all == null || all.isEmpty()) {
            println("(게시물이 없습니다)");
            return;
        }
        println("--------------------------------------------------------------------");
        println(String.format("%-5s %-20s %-10s %-19s", "번호", "제목", "작성자", "작성일"));
        println("--------------------------------------------------------------------");
        for (Board b : all) {
            String dateStr = b.getBdate() != null ? sdf.format(b.getBdate()) : "";
            println(String.format("%-5d %-20s %-10s %-19s",
                    b.getBno(),
                    trimToLen(b.getBtitle(), 20),
                    trimToLen(b.getBwriter(), 10),
                    dateStr));
        }
        println("--------------------------------------------------------------------");
    }

    private void view() throws IOException {
        println("\n[상세조회]");
        int bno = readInt("글번호: ");
        Board board = dao.selectOne(bno);
        if (board == null) {
            println("해당 글이 없습니다.");
            return;
        }
        println("번호    : " + board.getBno());
        println("제목    : " + nullSafe(board.getBtitle()));
        println("작성자  : " + nullSafe(board.getBwriter()));
        println("작성일  : " + (board.getBdate() != null ? sdf.format(board.getBdate()) : ""));
        println("내용    : \n" + nullSafe(board.getBcontent()));
    }

    private void edit() throws IOException {
        println("\n[수정]");
        int bno = readInt("수정할 글번호: ");
        Board board = dao.selectOne(bno);
        if (board == null) {
            println("해당 글이 없습니다.");
            return;
        }
        println("현재 제목: " + nullSafe(board.getBtitle()));
        String newTitle = read("새 제목(엔터=유지): ");
        if (!isBlank(newTitle)) board.setBtitle(newTitle);

        println("현재 내용: \n" + nullSafe(board.getBcontent()));
        String newContent = read("새 내용(엔터=유지): ");
        if (!isBlank(newContent)) board.setBcontent(newContent);

        boolean rows = dao.updateBoard(board);
        println(rows == true ? "수정 성공" : "수정 실패");
    }

    private void remove() throws IOException {
        println("\n[삭제]");
        int bno = readInt("삭제할 글번호: ");
        Board board = dao.selectOne(bno);
        if (board == null) {
            println("해당 글이 없습니다.");
            return;
        }
        String yn = read("정말 삭제하시겠습니까? (y/N): ");
        if ("y".equalsIgnoreCase(yn)) {
            boolean rows = dao.deleteBoard(bno);
            println(rows == true ? "삭제 성공" : "삭제 실패");
        } else {
            println("삭제 취소");
        }
    }

    // -------------------- Util function --------------------

    private String read(String prompt) throws IOException {
        System.out.print(prompt);
        return in.readLine();
    }

    private String readRequired(String prompt) throws IOException {
        while (true) {
            String s = read(prompt);
            if (!isBlank(s)) return s.trim();
            println("값을 입력하세요.");
        }
    }

    private int readInt(String prompt) throws IOException {
        while (true) {
            try {
                String s = read(prompt);
                return Integer.parseInt(s.trim());
            } catch (NumberFormatException e) {
                println("숫자를 입력하세요.");
            }
        }
    }

    private void println(String s) {
        System.out.println(s);
    }

    private String nullSafe(String s) {
        return Objects.toString(s, "");
    }

    private String trimToLen(String s, int len) {
        if (s == null) return "";
        if (s.length() <= len) return s;
        return s.substring(0, len - 1) + "…";
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}