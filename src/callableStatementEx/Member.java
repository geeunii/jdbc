package callableStatementEx;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
public class Member {
    private int m_seq;
    private String m_userid;
    private String m_pwd;
    private String m_email;
    private String m_hp;
    private LocalDateTime m_registdate;
    private int m_point;

    public Member() {

    }
}
