-- 트리거가 생성되었는지 확인 => show 트리거명;
-- 트리거 삭제 => Drop Trigger 트리거명;

-- 실습테이블: 제품로그 테이블 => 제품이 추가할 때 마다 로그 테이블에 정보를 남기는 트리거 작성
DROP TABLE Product;
CREATE TABLE Product -- 제품
(
    ProductNumber INT AUTO_INCREMENT PRIMARY KEY, -- 제품 번호
    ProductName   VARCHAR(100),                   -- 제품명
    PackagingUnit INT DEFAULT 0,                  -- 포장단위
    Price         INT DEFAULT 0,                  -- 단가
    Inventory     INT DEFAULT 0                   -- 재고
);


CREATE TABLE ProductLog -- 제품로그
(
    LogNumber     INT AUTO_INCREMENT PRIMARY KEY,     -- 로그번호
    Treatment     VARCHAR(10),                        -- 처리
    Content       VARCHAR(100),                       -- 내용
    TreatmentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- 처리일
);

DELIMITER $$
CREATE TRIGGER trigger_Add_Product_Log -- 제품 추가 로그
    AFTER INSERT
    ON Product
    FOR EACH ROW
BEGIN
    INSERT INTO ProductLog(Treatment, Content)
    VALUES ('INSERT', CONCAT('ProductNumber : ', NEW.ProductNumber, 'ProductName : ', NEW.ProductName));

END $$
DELIMITER ;

INSERT INTO Product(ProductName, Price, Inventory)
VALUES ('AppleCandy', 2000, 10);
SELECT *
FROM Product
WHERE ProductNumber = 1;

SELECT *
FROM ProductLog;

-- 제품 테이블에서 단가난 재고가 변경되면 변경된 사항을 제품로그 테이블에 저장하는 트리거를 생성
DROP TRIGGER trigger_product_update_log;
DELIMITER $$
CREATE TRIGGER trigger_product_update_log -- 제품 수정 로그
    AFTER UPDATE -- [수정] INSERT가 아닌 UPDATE로 변경
    ON Product
    FOR EACH ROW
BEGIN
    -- OLD.Price와 NEW.Price가 다를 경우 (가격이 변경된 경우)
    IF NOT (NEW.Price <=> OLD.Price) THEN
        INSERT INTO ProductLog(Treatment, Content)
        VALUES ('UPDATE', CONCAT('ProductNumber: ', OLD.ProductNumber, ', Price: ', OLD.Price, ' -> ', NEW.Price));
    END IF;

    -- OLD.Inventory와 NEW.Inventory가 다를 경우 (재고가 변경된 경우)
    IF NOT (NEW.Inventory <=> OLD.Inventory) THEN
        INSERT INTO ProductLog(Treatment, Content)
        VALUES ('UPDATE',
                CONCAT('ProductNumber: ', OLD.ProductNumber, ', Inventory: ', OLD.Inventory, ' -> ', NEW.Inventory));
    END IF;
END $$
DELIMITER ;

UPDATE Product
SET Price = 2500
WHERE ProductNumber = 1;
select *
FROM ProductLog;

-- 제품 테이블에서 제품 정보를 삭제하면 삭제된 레코드의 정보를 제품 로그 테이블에 저장하는 트리거 작성하세요.
DELIMITER $$
CREATE TRIGGER trigger_Product_Delete_log
    AFTER DELETE
    ON Product
    FOR EACH ROW
BEGIN
    INSERT INTO ProductLog(Treatment, Content)
    VALUES ('DELETE',
            CONCAT('ProductNumber: ', OLD.ProductNumber, ', ProductName: ', OLD.ProductName, 'Inventory: ',
                   OLD.Inventory));
END $$
DELIMITER ;

DELETE
FROM Product
WHERE ProductNumber = 1;

SELECT *
FROM Product;
SELECT *
FROM ProductLog;

-- SIU