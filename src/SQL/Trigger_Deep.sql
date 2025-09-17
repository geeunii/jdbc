use sqldb;

# 중첩 트리거 작동 실습
-- 연습용 DB 생성

DROP DATABASE IF EXISTS triggerDB;
CREATE DATABASE IF NOT EXISTS triggerDB;

-- 테이블 생성
USE triggerDB;
CREATE TABLE orderTBL -- 구매 테이블
(
    orderNO     INT AUTO_INCREMENT PRIMARY KEY, -- 구매 일렬번호
    userID      VARCHAR(5),                     -- 회원 아이디
    prodName    VARCHAR(5),                     -- 구매 물건
    orderAmount Int                             -- 구매 개수
);

CREATE TABLE prodTBL -- 물품 테이블
(
    prodName VARCHAR(5), -- 물건 이름
    account  INT         -- 남은 물건 수량
);

CREATE TABLE deliverTBL -- 배송 테이블
(
    deliverNo INT AUTO_INCREMENT PRIMARY KEY, -- 배송 일렬번호
    prodName  VARCHAR(5),                     -- 배송할 물건
    account   INT UNIQUE                      -- 배송할 물건개수
);
ALTER TABLE deliverTBL DROP INDEX account; -- 유니크 제약조건 제거
-- 왜 제거 하는지 ? -> account 컬럼의 UNIQUE 제약조건 제거 (같은 수량의 배송이 여러 번 발생할 수 있으므로)



-- 데이터 입력
INSERT INTO prodTBL
VALUES ('사과', 100);
INSERT INTO prodTBL
VALUES ('배', 100);
INSERT INTO prodTBL
VALUES ('귤', 100);

# 구매 테이블과 물품 테이블에 트리거 부착
-- 물품 테이블에서 개수를 감소시키는 트리거
DROP TRIGGER IF EXISTS orderTrg;
DELIMITER $$
CREATE TRIGGER orderTrg -- 트리거 이름
    AFTER INSERT
    ON orderTBL -- 트리거를 부착할 테이블
    FOR EACH ROW
BEGIN
    UPDATE prodTBL
    SET account = account - NEW.orderAmount
    WHERE prodName = NEW.prodName;
end $$
DELIMITER ;

-- 배송 테이블에서 새 배송 건을 입력하는 트리거
DROP TRIGGER prodTrg;
DELIMITER $$
CREATE TRIGGER prodTrg
    AFTER UPDATE
    ON prodTBL
    FOR EACH ROW
BEGIN
    DECLARE orderAmount Int;
    -- 주문 개수 = (변경 전의 개수 - 변경 후의 개수);
    SET orderAmount = OLD.account - NEW.account;
    INSERT INTO deliverTBL(prodName, account) VALUES (NEW.prodName, orderAmount);
end $$
DELIMITER ;

-- 고객이 구매한 데이터 입력
INSERT INTO orderTBL VALUES (NULL, 'Elice', '배', 5);

SELECT * FROM orderTBL;
SELECT * FROM prodTBL;
SELECT * FROM deliverTBL;

-- 배송 테이블의 열 이름을 변경해서 (3)번의 INSERT가 실패하도록 실습
ALTER TABLE deliverTBL
    CHANGE prodName productName VARCHAR(5);

-- 데이터 입력
INSERT INTO orderTBL
VALUES (NUll, 'DANG', '사과', 9);

SELECT * FROM orderTBL;
SELECT * FROM prodTBL;
SELECT * FROM deliverTBL;

-- 데이터가 변경되지 않았음
-- (3)번의 INSERT 가 실패하면 (1)번 INSERT, (2)번 UPDATE 모두 롤백됨


