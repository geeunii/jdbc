CREATE DATABASE WMS_TEST_01;

USE WMS_TEST_01;

-- 창고 정보
-- 'warehouseStatus' -> ENUM 타입을 사용해 정해진 값만 받도록 수정
CREATE TABLE Warehouse
(
    warehouseId      INTEGER                   NOT NULL AUTO_INCREMENT,            -- 창고 번호 (PK)
    managerId        VARCHAR(50)               NOT NULL,                           -- FK 관리자 아이디
    warehouseName    VARCHAR(50)               NOT NULL,                           -- 창고 이름
    warehouseAddress VARCHAR(255)              NOT NULL,                           -- 창고 주소
    area_sqm         DECIMAL(10, 2)            NOT NULL,                           -- 창고 면적 (m²)
    maxCapacityCBM   INTEGER                   NOT NULL,                           -- 창고의 총 최대 CBM 용량
    warehouseStatus  ENUM ('운영중', '점검중', '폐쇄') NOT NULL,                           -- 창고 상태
    whCityName       VARCHAR(50)               NOT NULL,                           -- 창고 도시명
    regDate          DATETIME                  NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 등록 일시
    PRIMARY KEY (warehouseId)
);

-- 창고 구역 정보
CREATE TABLE Warehouse_Section
(
    sectionId        INTEGER        NOT NULL AUTO_INCREMENT,                       -- 구역 번호 (PK)
    warehouseId      INTEGER        NOT NULL,                                      -- FK 창고 번호
    sectionName      VARCHAR(50)    NOT NULL,                                      -- 구역 이름 (예: A구역, 반품구역)
    maxVolumeCBM     DECIMAL(10, 2) NOT NULL,                                      -- 최대 허용 부피 (CBM)
    currentVolumeCBM DECIMAL(10, 2) NOT NULL DEFAULT 0,                            -- 현재 적재 부피 (CBM)
    PRIMARY KEY (sectionId),
    FOREIGN KEY (warehouseId) REFERENCES Warehouse (warehouseId) ON DELETE CASCADE -- 창고 삭제 시 구역도 함께 삭제
);

-- 창고 요금
CREATE TABLE WarehouseFee
(
    warehouseFeeId INTEGER NOT NULL AUTO_INCREMENT, -- 창고 요금 번호 (PK)
    warehouseId    INTEGER NOT NULL,                -- FK 창고 번호
    Id             INTEGER NOT NULL,                -- FK 유저번호
    ratePerCBM     INTEGER NOT NULL,                -- CBM당 보관료 단가
    startDate      DATE    NOT NULL,                -- 계약 시작일
    endDate        DATE    NOT NULL,                -- 계약 종료일
    PRIMARY KEY (warehouseFeeId),
    FOREIGN KEY (warehouseId) REFERENCES Warehouse (warehouseId)
);

##################################################################

-- 창고 데이터 INSERT
-- 서울(소형), 천안(중형), 인천(대형) 창고 등록 및 창고 관리자 배치
INSERT INTO Warehouse (managerId, warehouseName, warehouseAddress, area_sqm, maxCapacityCBM, warehouseStatus,
                       whCityName)
VALUES ('manager01', '서울 도심 MFC', '서울특별시 강남구 역삼동 123-1', 1500.00, 12000, '운영중', '서울'),
       ('manager02', '천안 중부권 거점센터', '충청남도 천안시 서북구 직산읍 456-2', 4000.00, 40000, '운영중', '천안'),
       ('manager03', '인천 국제 허브', '인천광역시 중구 공항동 789-3', 10000.00, 70000, '점검중', '인천');

-- 창고 구역 데이터 INSERT
-- 서울 창고 (ID:1) 섹션 2개 등록
INSERT INTO Warehouse_Section (warehouseId, sectionName, maxVolumeCBM, currentVolumeCBM)
VALUES (1, 'A섹션-주력상품', 10000.00, 8500.00),
       (1, 'B섹션-반품/기타', 2000.00, 500.00);

-- 천안 창고 (ID:2) 섹션 4개 등록
INSERT INTO Warehouse_Section (warehouseId, sectionName, maxVolumeCBM, currentVolumeCBM)
VALUES (2, 'A섹션-고객사A전용', 10000.00, 9990.00), -- '포화' 상태 테스트용
       (2, 'B섹션-고객사B전용', 10000.00, 6000.00),
       (2, 'C섹션-장기보관', 15000.00, 11000.00),
       (2, 'D섹션-부가작업공간', 5000.00, 100.00);

-- 인천 창고 (ID:3) 섹션 6개 등록
INSERT INTO Warehouse_Section (warehouseId, sectionName, maxVolumeCBM, currentVolumeCBM)
VALUES (3, '1F-A 입고/하역', 10000.00, 2000.00),
       (3, '1F-B 대형화물', 15000.00, 12000.00),
       (3, '1F-C 출고대기', 15000.00, 14500.00),
       (3, '2F-D e-커머스', 15000.00, 13000.00),
       (3, '2F-E 장기보관', 10000.00, 0.00),
       (3, '2F-F 반품/검수', 5000.00, 120.00);

-- 3. 창고 요금(WarehouseFee) 데이터 INSERT
-- 여러 창고, 여러 사업자에 대한 요금 정책 등록
INSERT INTO WarehouseFee (warehouseId, Id, ratePerCBM, startDate, endDate)
VALUES (1, 101, 4000, '2024-01-01', '2025-12-31'), -- 서울창고, 101번 사업자
       (2, 101, 3000, '2024-01-01', '2025-12-31'), -- 천안창고, 101번 사업자
       (2, 202, 3100, '2024-03-01', '2024-12-31'), -- 천안창고, 202번 사업자
       (3, 301, 2500, '2025-01-01', '2026-12-31');
-- 인천창고, 301번 사업자

#################### 창고 관리 테스트 #####################
-- 창고 조회
SELECT *
FROM Warehouse;

-- 소재지별 창고 조회
SELECT *
FROM Warehouse
WHERE warehouseAddress LIKE '%천안%';

-- 창고명별 창고 조회
SELECT *
FROM Warehouse
WHERE warehouseName LIKE '%허브%';

-- 창고 사이즈별 창고 조회
-- 소형 창고 (3000m² 미만) 조회
SELECT *
FROM Warehouse
WHERE area_sqm < 3000;

-- 창고 최대 수용 용량 조회
SELECT warehouseName, maxCapacityCBM
FROM Warehouse
WHERE warehouseId = 2;
-- 천안 창고 ID

-- 창고 상태
-- 1. 저장된 상태(운영중, 점검중 등) 확인
SELECT warehouseName, warehouseStatus
FROM Warehouse;

-- 2. 포화 상태인 섹션 확인 - 95% 이상 사용중인 섹션
SELECT w.warehouseName,
       ws.sectionName,
       ws.maxVolumeCBM,
       ws.currentVolumeCBM,
       (ws.currentVolumeCBM / ws.maxVolumeCBM) * 100 AS '섹션 사용 퍼센트'
FROM Warehouse_Section ws
         JOIN Warehouse w ON ws.warehouseId = w.warehouseId
WHERE (ws.currentVolumeCBM / ws.maxVolumeCBM) >= 0.95;

-- 요금 정책 등록
INSERT INTO WarehouseFee (warehouseId, Id, ratePerCBM, startDate, endDate)
VALUES (3, 202, 2600, '2025-02-01', '2026-01-31');

-- 창고별 요금 조회
SELECT Id, ratePerCBM, startDate, endDate
FROM WarehouseFee
WHERE warehouseId = 3;
-- 요금 정책 등록까지 확인 후 조회

-- 요금 정책 수정 - 서울 창고 101번 사업자'의 CBM 당 단가(ratePerCBM)를 4000에서 4200으로 수정
UPDATE WarehouseFee
SET ratePerCBM = 4200
WHERE warehouseId = 1
  AND Id = 101;

SELECT *
FROM WarehouseFee
WHERE warehouseId = 1
  AND Id = 101;

-- 창고 구역 관리 테스트 - 서울 도심 MFC(ID:1)에 C섹션-특별보관 구역을 신규 등록
INSERT INTO Warehouse_Section (warehouseId, sectionName, maxVolumeCBM)
VALUES (1, 'C섹션-특별보관', 1500.00);

-- 구역 조회 - 인천 국제 허브'(ID:3)에 속한 모든 구역(6개)의 목록과 상태(용량)
SELECT sectionName, maxVolumeCBM, currentVolumeCBM
FROM Warehouse_Section
WHERE warehouseId = 3;

-- 구역 수정 - 천안 창고(ID:2)의 D섹션-부가작업공간의 이름을 D섹션-포장/라벨링으로 수정
UPDATE Warehouse_Section
SET sectionName = 'D섹션-포장/라벨링'
WHERE warehouseId = 2
  AND sectionName = 'D섹션-부가작업공간';




