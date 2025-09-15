create table CODE1
(
    CID   int,
    cName VARCHAR(50)
);
DESC CODE1;

INSERT INTO CODE1(cid, cname)
SELECT IFNULL(MAX(CID), 0) + 1 AS CLD2, 'TEST' AS CNAME2
FROM CODE1;

select *
from CODE1;

truncate code1; -- 입력한 데이터만 삭제

DELIMITER $$
CREATE PROCEDURE P_INSERTCODES(IN cData VARCHAR(255),
                               IN cTname VARCHAR(255),
                               OUT resultMsg VARCHAR(255))
BEGIN
    SET @strsql = CONCAT(
            'INSERT INTO ', 'cTname', '(cid,cname)',
            'SELECT COALESCE(MAX(cid),0)+1,? FROM ', cTname
                  );
    -- 바인딩할 변수 설정
    SET @cData = cData;
    SET resultMsg = 'Insert Sucess!';

    prepare stmt FROM @strSql;
    EXECUTE stmt USING @cData;

    DEALLOCATE PREPARE stmt;
    COMMIT;
END $$
DELIMITER ;
use bookmarketdb;
drop procedure P_INSERTCODES;
SET @result = '';
CALL P_INSERTCODES('프론트디자이너', 'CODE1', @result);
CALL P_INSERTCODES('백엔드개발자', 'CODE1', @result);
select @result;
select *
from code1;

CREATE TABLE TB_MEMBER
(
    m_seq        INT AUTO_INCREMENT PRIMARY KEY, -- 자동 증가 시퀀스
    m_userid     VARCHAR(20) NOT NULL,
    m_pwd        VARCHAR(20) NOT NULL,
    m_email      VARCHAR(50) NULL,
    m_hp         VARCHAR(20) NULL,
    m_registdate DATETIME DEFAULT NOW(),         -- 기본값: 현재 날짜와 시간
    m_point      INT      DEFAULT 0
);

drop procedure if exists SP_MEMBER_INSERT;
delimiter $$
-- 반드시  중복 사용자 예외 처리  (이미 존재하는 사용자 검사 시행)
-- 만약 성공적이면  숫자 200 리턴 , 이미 가입된 회원이라면 숫자 100 리턴
CREATE PROCEDURE SP_MEMBER_INSERT(
    IN V_USERID VARCHAR(20),
    IN V_PWD VARCHAR(20),
    IN V_EMAIL VARCHAR(50),
    IN V_HP VARCHAR(20),
    OUT RTN_CODE INT
)
BEGIN
    DECLARE v_count int;

    SELECT COUNT(m_seq) into v_count FROM TB_MEMBER WHERE M_USERID = V_USERID;

    IF v_count > 0 THEN
        SET RTN_CODE = 100;
    ELSE
        INSERT INTO TB_MEMBER (M_USERID, M_pwd, M_EMAIL, M_HP)
        VALUES (V_USERID, V_PWD, V_EMAIL, V_HP);
        SET RTN_CODE = 200;
    END IF;
    COMMIT;
end $$
delimiter ;

CALL SP_MEMBER_INSERT('apple', '1111', 'apple@sample.com', '010-9898-9999', @result);
SELECT @result;

SELECT *
FROM TB_MEMBER;
show create procedure SP_MEMBER_INSERT;

# 1. SP_MEMBER_LIST() 프로시저 생성 : 전체 회원들의 정보를 출력하는 기능
# 2. MemberList 클래스에서 callableStatement 방식으로 회원들의 리스트를 출력하는 기능 구현하시오.
DROP PROCEDURE IF EXISTS SP_NUMBER_LIST;
DELIMITER $$
CREATE PROCEDURE SP_NUMBER_LIST(
)
BEGIN

    SELECT * FROM TB_MEMBER;

end $$
DELIMITER ;
CALL SP_NUMBER_LIST();

DELIMITER $$
CREATE PROCEDURE SP_SELECT_NUMBER
    (
        IN V_SEQ INT
    )
begin
    SET V_SEQ = @V_SEQ;




end $$
